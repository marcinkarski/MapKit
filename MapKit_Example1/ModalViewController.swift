import UIKit

class ModalViewController: UIViewController {
    
    let heartButton: UIButton = {
        let button = UIButton()
        let heartNormal = UIImage(named: "heart1")
        let heartSelected = UIImage(named: "heart2")
        button.setImage(heartNormal?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        button.setImage(heartSelected?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), for: .selected)
        button.tintColor = .white
        button.layer.shadowOffset = CGSize(width: 0.2, height: 0.2)
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 0.5
        button.addTarget(self, action: #selector(handleHeart), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleHeart(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "close")
        button.setImage(image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.layer.shadowOffset = CGSize(width: 0.2, height: 0.2)
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 0.5
        button.addTarget(self, action: #selector(onCloseButtonClicked), for: .touchUpInside)
        return button
    }()
    
    @objc func onCloseButtonClicked(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
        view.addSubview(closeButton)
        view.addSubview(heartButton)
        closeButton.anchor(view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 25, heightConstant: 25)
        heartButton.anchor(nil, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 20, rightConstant: 20, widthConstant: 30, heightConstant: 30)
    }
}
