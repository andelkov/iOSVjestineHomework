import Foundation
import CoreData

@objc(Question)
public class Question: NSManagedObject {
    
    static func getEntityName() -> String {
        return "Question"
    }
    
    static func firstOrCreate(withId id: Int) -> Question? {
        let context = DataController.shared.persistentContainer.viewContext
        
        let request: NSFetchRequest<Question> = Question.fetchRequest()
        request.predicate = NSPredicate(format: "nsmId = %i", id)
        request.returnsObjectsAsFaults = false
        
        do {
            let questions = try context.fetch(request)
            if let question = questions.first {
                return question
            } else {
                let newQuestion = Question(context: context)
                return newQuestion
            }
        } catch {
            return nil
        }
    }
    
    static func createFrom(json: Any) -> Question? {
        if let jsonDict = json as? [String: Any],
            let id = jsonDict["id"] as? Int,
            let question = jsonDict["question"] as? String,
            let answers = jsonDict["answers"] as? [String],
            let correctAnswer = jsonDict["correct_answer"] as? Int {
            
            if let ques = Question.firstOrCreate(withId: id) {
                ques.id = id
                ques.question = question
                ques.answers = answers
                ques.correctAnswer = correctAnswer
                return ques
            }
        }
        return nil
    }
}
