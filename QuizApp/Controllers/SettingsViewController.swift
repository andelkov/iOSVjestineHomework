import UIKit
import PureLayout

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBAction func logoutClicked(_ sender: Any) {
        AuthorizationUtils.logoutUser()
        UIUtils.switchToLoginController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        usernameLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        usernameLabel.text = AuthorizationUtils.getUsername()
        
        logoutButton.layer.cornerRadius = 5
        logoutButton.clipsToBounds = true
        logoutButton.backgroundColor = UIColor.lightGray
    }
    
}
