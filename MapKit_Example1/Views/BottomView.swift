import UIKit

enum BottomViewState {
    case expanded, minimized
}

class BottomView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configure() {
        backgroundColor = .white
        layer.cornerRadius = 5
        layer.shadowOffset = CGSize(width: 0.2, height: 0.2)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 0.5
    }
}
