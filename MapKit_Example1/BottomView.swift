import UIKit

class BottomView: UIView {
    let view: UIView = {
        let view = UIView()
        let frame = CGRect(x: 0, y: 50, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 50)
        view.frame = frame
        view.backgroundColor = .red
        view.layer.cornerRadius = 3
        view.layer.masksToBounds = true
    
        return view
    }()
}
