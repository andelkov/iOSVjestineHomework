
import UIKit

protocol QuestionViewDelegate: class {
    func questionAnswered(isCorrectAnswer: Bool)
}

class QuestionView: UIView {
    
    private var question: Question?
    
    weak var delegate: QuestionViewDelegate?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var answerButtons: [UIButton]!
    
    @IBAction func questionAnswered(_ sender: Any) {
        if let button = sender as? UIButton, let question = self.question {
            let isCorrectAnswer = button.tag == question.correctAnswer
            button.backgroundColor = isCorrectAnswer ? .green : .red
            answerButtons.forEach{ $0.isEnabled = false }
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: {
                self.delegate?.questionAnswered(isCorrectAnswer: isCorrectAnswer)
            })
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("QuestionView", owner: self, options: nil)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
        
        answerButtons.forEach {
            $0.layer.borderColor = UIColor.gray.cgColor
            $0.layer.borderWidth = 1
        }
    }
    
    func setup(question: Question) {
        self.question = question
        self.questionLabel.text = question.question
        self.answerButtons.enumerated().forEach{
            $1.setTitle(question.answers[$0], for: .normal)
        }
    }
    
}
