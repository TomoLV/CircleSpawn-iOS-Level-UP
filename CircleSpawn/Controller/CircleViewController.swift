//
//  ViewController.swift
//  CircleSpawn
//
//  Created by Tomasz Bogusz on 20.03.2018.
//  Copyright © 2018 Tomasz Bogusz. All rights reserved.
//

import UIKit

class CircleViewController: UIViewController  {
    
    // Remember where circles were grabbed for smooth move animation
    private var grabOffset: [UIView : CGVector] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TapGestureRecognizer - add new circle
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.numberOfTapsRequired = 2
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func handleTap(_ tap: UITapGestureRecognizer) {
        // Create new circle
        let size: CGFloat = 100
        let circleView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: size, height: size)))
        circleView.center = tap.location(in: view)
        circleView.backgroundColor = UIColor.randomBrightColor()
        circleView.layer.cornerRadius = size * 0.5
        circleView.alpha = 0
        view.addSubview(circleView)
        
        // Animate the circle
        circleView.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        let animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: {
            circleView.alpha = 1
            circleView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
        animator.startAnimation()
        
        // LongPressGestureRecognizer - move the circle
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        circleView.addGestureRecognizer(longPress)
        
        // TapGestureRecognizer - remove the circle
        let deleteTap = UITapGestureRecognizer(target: self, action: #selector(handleDeleteTap(_:)))
        deleteTap.numberOfTapsRequired = 3
        circleView.addGestureRecognizer(deleteTap)
    }
    
    @objc func handleLongPress(_ longPress: UILongPressGestureRecognizer) {
        guard let circleView = longPress.view else { return }
        let touchPoint = longPress.location(in: view)
        switch longPress.state {
        case .began:
            // FadeOut and resize the view
            // Set grabOffset - so it does not 'blink' later
            grabOffset[circleView] = CGVector(dx: touchPoint.x - circleView.center.x, dy: touchPoint.y - circleView.center.y)
            let animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeIn, animations: { [weak self] in
                self?.view.bringSubview(toFront: circleView)
                circleView.alpha = 0.7
                circleView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            })
            animator.startAnimation()
        case .changed:
            // Move the view
            let grabOffset = self.grabOffset[circleView] ?? CGVector.zero
            circleView.center = CGPoint(x: touchPoint.x - grabOffset.dx, y: touchPoint.y - grabOffset.dy)
        case .cancelled, .ended, .failed:
            // FadeIn and resize the view back to original state
            let animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeIn, animations: {
                circleView.alpha = 1
                circleView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
            animator.startAnimation()
            grabOffset[circleView] = nil
        default:
            break
        }
    }
    
    @objc func handleDeleteTap(_ tap: UITapGestureRecognizer) {
        if let circleView = tap.view {
            let animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeIn, animations: {
                circleView.alpha = 0
                circleView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            })
            animator.addCompletion { position in
                if position == .end { circleView.removeFromSuperview() }
            }
            animator.startAnimation()
            grabOffset.removeValue(forKey: circleView)
        }
        
    }
    
}

// Extension - Implementation of UIGestureRecognizerDelegate
extension CircleViewController: UIGestureRecognizerDelegate {
    
    // Handle 2- and 3- tap recognizers behavior
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let otherRecognizer = otherGestureRecognizer as? UITapGestureRecognizer, otherRecognizer.numberOfTapsRequired == 3 {
            return true
        }
        return false
    }
}


