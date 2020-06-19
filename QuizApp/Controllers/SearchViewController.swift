import UIKit

class SearchViewController: QuizzesViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
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
        refreshControl.addTarget(self, action: #selector(SearchViewController.refresh), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.register(UINib(nibName: "QuizTableViewCell", bundle: nil), forCellReuseIdentifier: super.cellReuseIdentifier)
    }
    
    @objc func refresh() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    @IBAction func searchClicked(_ sender: UIButton) {
        let filter = searchTextField.text ?? ""
        viewModel.fetchQuizzes(filter: filter) {
            self.refresh()
        }
    }
}
