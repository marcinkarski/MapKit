import UIKit

class BottomView: UIView {
    let view: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 3
        view.layer.masksToBounds = true
        return view
    }()
}
