import UIKit

class HomeViewController: QuizzesViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var refreshControl: UIRefreshControl!
    
    convenience init(viewModel: QuizzesViewModel) {
        self.init()
        super.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupTableView()
    }
    
    private func setup() {
        viewModel!.fetchQuizzes {
            self.refresh()
        }
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor.lightGray
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(HomeViewController.refresh), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.register(UINib(nibName: "QuizTableViewCell", bundle: nil), forCellReuseIdentifier: super.cellReuseIdentifier)
    }
    
    @objc func refresh() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
}
