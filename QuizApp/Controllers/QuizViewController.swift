import Foundation
import UIKit

class QuizViewController: UIViewController {
    
    var viewModel: QuizViewModel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var quizImageView: UIImageView!
    @IBOutlet weak var startQuizButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var answers: [Bool] = []
    var startTime: Date?
    
    convenience init(viewModel: QuizViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupScrollView()
    }
    
    @IBAction func startQuiz(_ sender: Any) {
        self.navigationItem.setHidesBackButton(true, animated: true)
        scrollView.isHidden = false
        scrollView.isScrollEnabled = false
        startQuizButton.isEnabled = false
        startTime = Date()
    }
    
    private func setup() {
        self.navigationItem.title = viewModel.title
        self.titleLabel.text = self.viewModel.title
        self.quizImageView.kf.setImage(with: viewModel.imageUrl)
    }
    
    private func setupScrollView() {
        let questionViewWidth = self.scrollView.frame.width
        let totalWidth = questionViewWidth * CGFloat(viewModel.numberOfQuestions)
        scrollView.contentSize = CGSize(width: totalWidth, height: self.scrollView.frame.height)
        
        viewModel.questions.enumerated().forEach {
            let offset = questionViewWidth * CGFloat($0)
            let questionView = QuestionView(
                frame: CGRect(origin: CGPoint(x: offset, y: 0),
                              size: scrollView.frame.size))
            questionView.setup(question: $1)
            questionView.delegate = self
            scrollView.addSubview(questionView)
        }
    }
    
    private func postQuizResults() {
        let quizId = viewModel.id
        let numberOfCorrectAnswers = answers.filter{$0}.count
        var elapsedTime = Double(Date().timeIntervalSince(startTime!))
        elapsedTime = (elapsedTime * 10000).rounded() / 10000
        
        let quizResult = "\(numberOfCorrectAnswers)/\(viewModel.numberOfQuestions) in \(elapsedTime) s"
        
        QuizService().postQuizResult(
            quizId: quizId,
            time: elapsedTime,
            numberOfCorrect: numberOfCorrectAnswers,
            completion: { (httpStatusCode) in
                if let httpStatusCode = httpStatusCode {
                    self.showAlert(httpStatusCode: httpStatusCode, quizResult: quizResult)
                } else {
                    UIUtils.showError(message: "Internal server error", view: self.view)
                }
            }
        )
    }
    
    private func showAlert(httpStatusCode: HttpStatusCode, quizResult: String) {
        var title: String = quizResult
        var actions: [UIAlertAction] = []
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (_) in
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                self.navigationController?.popViewController(animated: true)
            }
        }
        actions.append(cancelAction)
        
        if httpStatusCode != HttpStatusCode.OK {
            let resendAction = UIAlertAction(title: "Resend", style: .default) { (_) in
                self.postQuizResults()
            }
            actions.append(resendAction)
            title = httpStatusCode.name
        }
        
        UIUtils.showAlert(
            title: title,
            message: httpStatusCode.message,
            actions: actions,
            viewController: self
        )
    }
}

extension QuizViewController: QuestionViewDelegate {
    
    func questionAnswered(isCorrectAnswer: Bool) {
        answers.append(isCorrectAnswer)
        
        if answers.count == viewModel.numberOfQuestions {
            postQuizResults()
        } else {
            let offset = scrollView.frame.width * CGFloat(answers.count)
            scrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        }
    }
}
