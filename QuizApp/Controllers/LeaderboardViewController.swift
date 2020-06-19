import UIKit

class LeaderboardViewController: UIViewController {
    
    private var viewModel: ScoresViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    
    private let cellReuseIdentifier = "cellReuseIdentifier"
    
    convenience init(viewModel: ScoresViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupTableView()
    }
    
    @IBAction func closeLeaderboard(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func refresh() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    private func setup() {
        viewModel.fetchScores {
            self.refresh()
        }
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor.lightGray
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(LeaderboardViewController.refresh), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.register(UINib(nibName: "ScoreTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
    }
}

extension LeaderboardViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return ScoresTableSectionHeader()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32.0
    }
    
}

extension LeaderboardViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfScores
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! ScoreTableViewCell
        
        if let score = self.viewModel.score(forRow: indexPath.row) {
            cell.setup(withScore: score)
        }
        return cell
    }
}
