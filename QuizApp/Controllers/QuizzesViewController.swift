import Foundation
import UIKit

class QuizzesViewController: UIViewController {
    
    internal var viewModel: QuizzesViewModel!
    internal let cellReuseIdentifier = "cellReuseIdentifier"
    
}

extension QuizzesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 104.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let category = Category.allCases[section]
        return QuizzesTableSectionHeader(title: category.rawValue, color: category.color)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let quizViewModel = self.viewModel!.quizViewModel(forIndexPath: indexPath) {
            let quizViewController = QuizViewController(viewModel: quizViewModel)
            navigationController?.pushViewController(quizViewController, animated: true)
        }
    }
    
}

extension QuizzesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = Category.allCases[section]
        return self.viewModel!.numberOfQuizzes(category: category)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Category.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! QuizTableViewCell
        
        if let quiz = self.viewModel!.quiz(forIndexPath: indexPath) {
            cell.setup(withQuiz: quiz)
            cell.delegate = self
        }
        return cell
    }
}

extension QuizzesViewController: QuestionTableViewCellDelegate {
    
    func leaderboardClicked(forQuiz id: Int) {
        let lvc = LeaderboardViewController(viewModel: ScoresViewModel(quizId: id))
        self.present(lvc, animated: true, completion: nil)
    }
    
}
