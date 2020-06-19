import UIKit

class ScoreTableViewCell: UITableViewCell {
    
    @IBOutlet weak var numerationLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableViewCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.numerationLabel.text = ""
        self.usernameLabel.text = ""
        self.scoreLabel.text = ""
    }
    
    private func setupTableViewCell() {
        numerationLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        usernameLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        scoreLabel.font = UIFont.systemFont(ofSize: 12.0)
    }
    
    func setup(withScore score: ScoreCellModel) {
        self.numerationLabel.text = score.number
        self.usernameLabel.text = score.username
        self.scoreLabel.text = score.score
    }
    
}

