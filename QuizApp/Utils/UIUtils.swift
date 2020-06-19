import UIKit
import PureLayout

class UIUtils {
    
    static func showError(message: String, view: UIView) {
        let toastLabel = UILabel(
            frame: CGRect(x: view.frame.size.width / 2 - 75,
                          y: view.frame.size.height - 100,
                          width: 175, height: 35))
        
        toastLabel.text = message
        toastLabel.backgroundColor = UIColor.red.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 5;
        toastLabel.clipsToBounds = true
        view.addSubview(toastLabel)
        
        toastLabel.autoAlignAxis(.vertical, toSameAxisOf: view)
        toastLabel.autoPinEdge(.bottom, to: .bottom, of: view, withOffset: -20)
        
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    static func showAlert(title: String, message: String, actions: [UIAlertAction]?, viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions?.forEach{ alertController.addAction($0) }
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    static func switchToTabBarController() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.switchToTabBarController()
    }
    
    static func switchToLoginController() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.switchToLoginController()
    }
}
