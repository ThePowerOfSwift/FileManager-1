//
//  AnimViewController.swift
//  FileManager
//
//  Created by JOSEPH KERR on 3/31/16.
//  Copyright © 2016 JOSEPH KERR. All rights reserved.
//

import UIKit

class AnimViewController: UIViewController {

    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var animLabel: UILabel!
    var animator: UIDynamicAnimator?
    var snapBehavior: UISnapBehavior?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let newAnimator = UIDynamicAnimator(referenceView: self.view)
        self.animator = newAnimator
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.55 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            //self.animDown()
            //self.animDownCompl()
            //self.animDownComplOptions()
            //self.animDownSprings()
            
            self.snapToBottomLeft()
        }
    }
    
    
    // MARK: Demonstrations animate autolayout constraint
    
    func animDown() {
        self.topLayoutConstraint.constant = 100
        self.view.setNeedsUpdateConstraints()
        UIView.animateWithDuration(3.0, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func animDownCompl() {
        self.topLayoutConstraint.constant = 100
        self.view.setNeedsUpdateConstraints()
        UIView.animateWithDuration(2, animations: {
            self.view.layoutIfNeeded()
            },completion: {(fini:Bool) in
                
                let backHeight = self.topLayoutConstraint.constant * 0.25
                self.topLayoutConstraint.constant -= backHeight
                self.view.setNeedsUpdateConstraints()
                UIView.animateWithDuration(1.0, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        )
    }
    
    func animDownComplOptions() {
        self.topLayoutConstraint.constant = 100
        self.view.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(2, delay:0, options: [.CurveEaseOut, .AllowAnimatedContent], animations: {
            self.view.layoutIfNeeded()
            
            }, completion: {(fini:Bool) in
                
                let backHeight = self.topLayoutConstraint.constant * 0.25
                self.topLayoutConstraint.constant -= backHeight
                self.view.setNeedsUpdateConstraints()
                UIView.animateWithDuration(1.0, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        )
    }
    
    
    func animDownSprings() {
        self.topLayoutConstraint.constant = 100
        self.view.setNeedsUpdateConstraints()
        UIView.animateWithDuration(6, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.8, options: .CurveLinear, animations:{
            self.view.layoutIfNeeded()
            } , completion: {(fini:Bool) in
                
            }
        )
    }

    
    // MARK: Demonstration UIDynamics
    
    func snapToBottomLeft() {
        
        topLayoutConstraint.active = false
        
        let point = CGPoint(x: animLabel.frame.midX/2, y: self.view.bounds.size.height - animLabel.frame.midY/2 -
            (self.tabBarController?.tabBar.frame.size.height)!)
        
        if let currentSnap = snapBehavior {
            self.animator!.removeBehavior(currentSnap)
        }
        
        
        let newSnapBehavior = UISnapBehavior(item: animLabel, snapToPoint: point)
        
        newSnapBehavior.damping = 0.75
        animator!.addBehavior(newSnapBehavior)
        self.snapBehavior = newSnapBehavior
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
