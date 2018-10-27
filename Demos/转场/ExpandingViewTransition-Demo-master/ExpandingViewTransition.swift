import UIKit

class ExpandingViewTransition: NSObject, UIViewControllerTransitioningDelegate {
    
    fileprivate let expandableView: UIView
    fileprivate let expandViewAnimationDuration: TimeInterval
    fileprivate let presentVCAnimationDuration: TimeInterval
    
    init(expandingView: UIView,
         expandViewAnimationDuration: TimeInterval = 0.35,
         presentVCAnimationDuration: TimeInterval = 0.35) {
        self.expandableView = expandingView
        self.expandViewAnimationDuration = expandViewAnimationDuration
        self.presentVCAnimationDuration = presentVCAnimationDuration
    }
    
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return ExpandingViewTransitionAnimatorPresent(expandableView: self.expandableView,
                                                      expandViewAnimationDuration: self.expandViewAnimationDuration,
                                                      presentVCAnimationDuration: self.presentVCAnimationDuration)
    }
    
    func animationController(
        forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}
