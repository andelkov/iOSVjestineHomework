import Foundation
import CoreData
import UIKit

enum Category: String, CaseIterable {
    
    case sports = "SPORTS"
    case science = "SCIENCE"
    
    var color: UIColor {
        switch self {
        case .sports:
            return UIColor.red
        case .science:
            return UIColor.green
        }
    }
}

@objc(Quiz)
public class Quiz: NSManagedObject {
    
    static func getEntityName() -> String {
        return "Quiz"
    }
    
    static func firstOrCreate(withId id: Int) -> Quiz? {
        let context = DataController.shared.persistentContainer.viewContext
        
        let request: NSFetchRequest<Quiz> = Quiz.fetchRequest()
        request.predicate = NSPredicate(format: "nsmId = %i", id)
        request.returnsObjectsAsFaults = false
        
        do {
            let quizzes = try context.fetch(request)
            if let quiz = quizzes.first {
                return quiz
            } else {
                let newQuiz = Quiz(context: context)
                return newQuiz
            }
        } catch {
            return nil
        }
    }
    
    static func createFrom(json: Any) -> Quiz? {
        if let jsonDict = json as? [String: Any],
            let id = jsonDict["id"] as? Int,
            let title = jsonDict["title"] as? String,
            let category = jsonDict["category"] as? String,
            let level = jsonDict["level"] as? Int,
            let questionsJson = jsonDict["questions"] as? [Any] {
            
            if let quiz = Quiz.firstOrCreate(withId: id) {
                quiz.id = id
                quiz.title = title
                quiz.level = level
                quiz.category = Category(rawValue: category)!
                quiz.desc = jsonDict["description"] as? String
                quiz.imageUrl = jsonDict["image"] as? String
                quiz.questions = questionsJson.compactMap(Question.createFrom)
                
                DataController.shared.saveContext()
                return quiz
            }
        }
        return nil
    }
}

