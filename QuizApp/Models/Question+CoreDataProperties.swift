import Foundation
import CoreData


extension Question {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Question> {
        return NSFetchRequest<Question>(entityName: "Question")
    }

    @NSManaged public var nsmId: Int64
    @NSManaged public var nsmQuestion: String
    @NSManaged public var nsmAnswers: [String]
    @NSManaged public var nsmCorrectAnswer: Int16
    
    var id: Int {
        get { return Int(nsmId) }
        set { nsmId = Int64(newValue) }
    }
    
    var question: String {
        get { return nsmQuestion }
        set { nsmQuestion = newValue }
    }
    
    var answers: [String] {
        get { return nsmAnswers }
        set { nsmAnswers = newValue }
    }
    
    var correctAnswer: Int {
        get { return Int(nsmCorrectAnswer) }
        set { nsmCorrectAnswer = Int16(newValue) }
    }

}
