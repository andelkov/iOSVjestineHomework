import Foundation

class LoginService {
    
    private final let loginUrl = "https://iosquiz.herokuapp.com/api/session"
    
    func login(username: String, password: String, completion: @escaping ((Authorization?) -> Void)) {
        if let url = URL(string: loginUrl) {
            var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            let parameters = ["username": username, "password": password]
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
            
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        if let jsonDict = json as? [String: Any],
                            let accessToken = jsonDict["token"] as? String,
                            let userId = jsonDict["user_id"] as? Int {
                            completion(Authorization(accessToken: accessToken, userId: userId, username: username))
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
}
