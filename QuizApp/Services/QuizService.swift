import UIKit

enum HttpStatusCode: Int {
    case OK = 200
    case BAD_REQUEST = 400
    case UNAUTHORIZED = 401
    case FORBIDDEN = 403
    case NOT_FOUND = 404
    
    var name: String {
        return "\(self.rawValue) " + "\(self)".replacingOccurrences(of: "_", with: " ", options: .literal, range: nil)
    }
    
    var message: String {
        switch self {
        case .OK:
            return "Quiz results successfully sent to server."
        case .BAD_REQUEST:
            return "An error occurred."
        case .UNAUTHORIZED:
            return "User is not authorized."
        case .FORBIDDEN:
            return "Access token does not match user ID."
        case .NOT_FOUND:
            return "Quiz does not exist."
        }
    }
}

class QuizService {
    
    private final let quizzesUrlString = "https://iosquiz.herokuapp.com/api/quizzes"
    private final let resultUrlString = "https://iosquiz.herokuapp.com/api/result"
    private final let leaderboardUrlString = "https://iosquiz.herokuapp.com/api/score?quiz_id="
    
    func fetchQuizzes(completion: @escaping (([Quiz]?) -> Void)) {
        if let url = URL(string: quizzesUrlString) {
            var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        if let jsonDict = json as? [String: Any],
                            let quizzesList = jsonDict["quizzes"] as? [Any] {
                            let quizzes = quizzesList.compactMap(Quiz.createFrom)
                            completion(quizzes)
                        } else {
                            completion(nil)
                        }
                    } catch {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            }
            dataTask.resume()
        } else {
            completion(nil)
        }
    }
    
    func fetchScores(forQuiz id: Int, completion: @escaping (([Score]?) -> Void)) {
        if let url = URL(string: leaderboardUrlString + "\(id)") {
            var request = URLRequest(url: url)
            
            // Set header
            if let accessToken = AuthorizationUtils.getAccessToken() {
                request.addValue(accessToken, forHTTPHeaderField: "Authorization")
            }
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        if let jsonDict = json as? [Any] {
                            let scores = jsonDict.compactMap(Score.init)
                            completion(scores)
                        } else {
                            completion(nil)
                        }
                    } catch {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            }
            dataTask.resume()
        } else {
            completion(nil)
        }
    }
    
    func postQuizResult(quizId: Int, time: Double, numberOfCorrect: Int,
                        completion: @escaping ((HttpStatusCode?) -> Void)) {
        if let url = URL(string: resultUrlString) {
            var request = URLRequest(url: url)
            
            // Set header
            if let accessToken = AuthorizationUtils.getAccessToken() {
                request.addValue(accessToken, forHTTPHeaderField: "Authorization")
            }
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            // Set parameters
            let parameters: [String: Any] = [
                "quiz_id": quizId, "user_id": AuthorizationUtils.getUserId(),
                "time": time, "no_of_correct": numberOfCorrect
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
            
            // Check HTTP status code
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let httpResponse = response as? HTTPURLResponse {
                    print("statusCode: \(httpResponse.statusCode)")
                    completion(HttpStatusCode(rawValue: httpResponse.statusCode))
                }
            }
            dataTask.resume()
        } else {
            completion(nil)
        }
    }
    
}
