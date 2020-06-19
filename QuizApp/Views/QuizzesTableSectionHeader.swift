import UIKit
import PureLayout

class QuizzesTableSectionHeader: UIView {
    
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(title: String, color: UIColor) {
        self.init(frame: CGRect.zero)
        
        backgroundColor = color
        titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor.darkGray
        self.addSubview(titleLabel)
        
        titleLabel.autoCenterInSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
