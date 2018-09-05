import UIKit

extension UIView {
    
    func slideInFromBottom(duration: TimeInterval = 0.1, completionDelegate: AnyObject? = nil) {
        let slideInFromBottomTransition = CATransition()
        
        if let delegate: AnyObject = completionDelegate {
            slideInFromBottomTransition.delegate = delegate as? CAAnimationDelegate
        }
        
        slideInFromBottomTransition.type = CATransitionType.push
        slideInFromBottomTransition.subtype = CATransitionSubtype.fromTop
        slideInFromBottomTransition.duration = duration
        slideInFromBottomTransition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        slideInFromBottomTransition.fillMode = CAMediaTimingFillMode.removed
        
        self.layer.add(slideInFromBottomTransition, forKey: "slideInFromBottomTransition")
    }
}
