import Foundation
import CoreData


extension Quiz {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Quiz> {
        return NSFetchRequest<Quiz>(entityName: "Quiz")
    }

    @NSManaged public var nsmId: Int64
    @NSManaged public var nsmTitle: String
    @NSManaged public var nsmDescription: String?
    @NSManaged public var nsmCategory: String
    @NSManaged public var nsmLevel: Int16
    @NSManaged public var nsmImageUrl: String?
    @NSManaged public var nsmQuestions: Set<Question>?
    
    var id: Int {
        get { return Int(nsmId) }
        set { nsmId = Int64(newValue) }
    }
    
    var title: String {
        get { return nsmTitle }
        set { nsmTitle = newValue }
    }
    
    var desc: String? {
        get { return nsmDescription }
        set { nsmDescription = newValue }
    }
    
    var category: Category {
        get { return Category(rawValue: self.nsmCategory)! }
        set { self.nsmCategory = newValue.rawValue }
    }
    
    var level: Int {
        get { return Int(nsmLevel) }
        set { nsmLevel = Int16(newValue) }
    }
    
    var imageUrl: String? {
        get { return nsmImageUrl }
        set { nsmImageUrl = newValue }
    }
    
    var questions: [Question]? {
        get { return Array(nsmQuestions!)}
        set { self.addToNsmQuestions(Set(newValue ?? [])) }
    }

}

// MARK: Generated accessors for nsmQuestions
extension Quiz {

    @objc(addNsmQuestionsObject:)
    @NSManaged public func addToNsmQuestions(_ value: Question)

    @objc(removeNsmQuestionsObject:)
    @NSManaged public func removeFromNsmQuestions(_ value: Question)

    @objc(addNsmQuestions:)
    @NSManaged public func addToNsmQuestions(_ values: Set<Question>)

    @objc(removeNsmQuestions:)
    @NSManaged public func removeFromNsmQuestions(_ values: Set<Question>)

}
