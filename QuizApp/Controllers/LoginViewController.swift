import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var contentView: UIStackView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        setupKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        prepareForAnimation()
        animateIn()
    }
    
    private func prepareForAnimation() {
        let viewWidth = view.bounds.width
        
        self.headingLabel.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        let views = [usernameTextField, passwordTextField, signInButton]
        views.forEach {
            $0?.center.x -= viewWidth
            $0?.alpha = 0.0
        }
    }
    
    private func animateIn() {
        let viewWidth = view.bounds.width
        
        UIView.animate(withDuration: 0.7, animations: {
            self.headingLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { _ in }
        
        let views = [usernameTextField, passwordTextField, signInButton]
        let delays = [0.0, 0.15, 0.3]
        
        for (view, delay) in zip(views, delays) {
            UIView.animate(withDuration: 0.5, delay: delay, animations: {
                view?.transform = CGAffineTransform(translationX: viewWidth, y: 0.0)
                view?.alpha = 1.0
            }) { _ in }
        }
    }
    
    public func animateOut() {
        self.errorLabel.isHidden = true
        
        let viewHeight = view.bounds.height
        let views = [headingLabel, usernameTextField, passwordTextField]
        let delays = [0.0, 0.1, 0.2]
        
        for (view, delay) in zip(views, delays) {
            UIView.animate(withDuration: 0.5, delay: delay, animations: {
                view?.center.y -= viewHeight
                view?.alpha = 0.0
            }) { _ in }
        }
    
        UIView.animate(withDuration: 0.5, delay: 0.3, animations: {
            self.signInButton.center.y -= viewHeight
            self.signInButton.alpha = 0.0
        }) { _ in
            UIUtils.switchToTabBarController()
        }
    }
    
    @IBAction func userLogin(_ sender: Any) {
        LoginService().login(
            username: usernameTextField.text ?? "",
            password: passwordTextField.text ?? "",
            completion: { (authorization) in
                DispatchQueue.main.async {
                    if let authorization = authorization {
                        AuthorizationUtils.loginUser(auth: authorization)
                        self.animateOut()
                    } else {
                        self.errorLabel.isHidden = false
                    }
                }
        })
    }
}
    
extension LoginViewController {
    
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardHeight = getKeyboardHeight(notification: notification) {
            let overlap = keyboardHeight - getContentViewBottomMargin()
            if overlap > 0 && view.frame.origin.y == 0 {
                self.view.frame.origin.y -= overlap
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    private func getKeyboardHeight(notification: NSNotification) -> CGFloat? {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            return keyboardHeight
        }
        return nil
    }
    
    private func getContentViewBottomMargin() -> CGFloat {
        return view.frame.size.height - (contentView.frame.size.height + contentView.frame.origin.y)
    }
}
