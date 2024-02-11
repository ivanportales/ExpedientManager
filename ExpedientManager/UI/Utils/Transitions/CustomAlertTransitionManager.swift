//
//  CustomAlertTransitionManager.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 10/02/24.
//

import UIKit

final class CustomAlertTransitionManager: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval
    private var operation = UINavigationController.Operation.push
    
    init(duration: TimeInterval) {
        self.duration = duration
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
              let toViewController = transitionContext.viewController(forKey: .to)
        else {
            transitionContext.completeTransition(false)
            return
        }
        animateTransition(from: fromViewController, to: toViewController, with: transitionContext)
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension CustomAlertTransitionManager: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        operation = .pop
        return self
    }
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        operation = .push
        return self
    }
}

// MARK: - Animations

private extension CustomAlertTransitionManager {
    func animateTransition(from fromViewController: UIViewController,
                           to toViewController: UIViewController,
                           with context: UIViewControllerContextTransitioning) {
        switch operation {
        case .push:
            presentViewController(toViewController, from: fromViewController, with: context)
        case .pop:
            dismissViewController(fromViewController, with: context)
        default:
            break
        }
    }
    
    func presentViewController(_ toViewController: UIViewController,
                               from fromViewController: UIViewController,
                               with context: UIViewControllerContextTransitioning) {
        
        guard let toView = toViewController.view,
              let fromView = fromViewController.view else { return }
        //toView.layoutIfNeeded()
        let contextContainerView = context.containerView
        
        // Any presented views must be part of the container view's hierarchy
        contextContainerView.addSubview(toView)
        
        let drawerSize = CGSize(width: fromView.frame.width,
                                height: fromView.frame.height)
        
        // Determine the drawer frame for both on and off screen positions.
        let offScreenDrawerFrame = CGRect(origin: CGPoint(x: 0, y: drawerSize.height), size: drawerSize)
        let onScreenDrawerFrame = CGRect(origin: .zero, size: drawerSize)
        toView.frame = offScreenDrawerFrame
    
        // let newDuration = transitionDuration(using: context)
        let animator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
            toView.frame = onScreenDrawerFrame
        }

        animator.addCompletion { position in
            context.completeTransition(position == .end)
        }

        animator.startAnimation()
    }
    
    func dismissViewController(_ fromViewController: UIViewController,
                               with context: UIViewControllerContextTransitioning) {
        
        guard let fromView = fromViewController.view else { return }
        
        let drawerSize = CGSize(width: fromView.frame.width,
                                height: fromView.frame.height)
        
        // Determine the drawer frame for both on and off screen positions.
        let offScreenDrawerFrame = CGRect(origin: CGPoint(x: 0, y: drawerSize.height), size: drawerSize)
        let onScreenDrawerFrame = CGRect(origin: .zero, size: drawerSize)
        fromView.frame = onScreenDrawerFrame
    
        // let newDuration = transitionDuration(using: context)
        let animator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
            fromView.frame = offScreenDrawerFrame
        }

        animator.addCompletion { position in
            fromView.removeFromSuperview()
            context.completeTransition(position == .end)
        }

        animator.startAnimation()
    }
}
