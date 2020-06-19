import UIKit

class QuizViewModel {
    
    private let quiz: Quiz?
    
    init(quiz: Quiz?) {
        self.quiz = quiz
    }
    
    public var id: Int {
        return quiz?.id ?? -1
    }
    
    public var title: String {
        return quiz?.title ?? ""
    }
    
    public var description: String? {
        return quiz?.desc
    }
    
    public var imageUrl: URL? {
        guard let urlString = quiz?.imageUrl else {
            return nil
        }
        return URL(string: urlString)
    }
    
    public var questions: [Question] {
        return quiz?.questions ?? []
    }
    
    public var numberOfQuestions: Int {
        return self.questions.count
    }
    
    public func question(forIndex index: Int) -> Question? {
        guard let questions = self.quiz?.questions else {
            return nil
        }
        return questions[index]
    }
    
}
