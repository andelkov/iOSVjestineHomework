import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        let hvc = HomeViewController(viewModel: QuizzesViewModel())
        let nvc = UINavigationController(rootViewController: hvc)
        hvc.navigationItem.title = "Quizzes"
        nvc.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home"), tag: 0)
        
        let sqvc = SearchViewController(viewModel: QuizzesViewModel())
        let snvc = UINavigationController(rootViewController: sqvc)
        sqvc.navigationItem.title = "Search"
        snvc.tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "search"), tag: 1)
        
        let svc = SettingsViewController()
        svc.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "settings"), tag: 2)
        
        self.viewControllers = [nvc, snvc, svc]
    }
}
