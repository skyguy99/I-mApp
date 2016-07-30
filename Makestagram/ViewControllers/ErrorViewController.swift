//
//  ErrorViewController.swift
//  I'm..
//
//  Created by Skylar Thomas on 7/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import QuartzCore

class ErrorViewController: UIViewController {
    
    var gradient = CAGradientLayer()
    var toColors : AnyObject?
    var fromColors : AnyObject?
    
    let errorMessage = UILabel()
    public var errorNum = Int()
    
    let acceptImg = UIImageView()
    let acceptLabel = UILabel()
    var circleView = CircleView()
    
    let exclamationView = UIImageView()
    let exclamationView2 = UIImageView()
    
    let exclamationLine = RectangleLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        exclamationView.frame = CGRectMake(0, 0, screenSize.width * (12/330), screenSize.width * (12/330))
       exclamationView.backgroundColor = UIColor.whiteColor()
        //exclamationView.layer.cornerRadius = exclamationView.bounds.width*0.5
        exclamationView.clipsToBounds = true
        exclamationView.center = CGPointMake(screenSize.width * 0.5, screenSize.height * -(0.1))
        view.addSubview(exclamationView)
        
        //exclamationView2.frame = CGRectMake(0, 0, screenSize.width * (12/330), screenSize.height * (1/568)) //61
        exclamationView2.frame = CGRect.zero
        exclamationView2.hidden = true
        exclamationView2.backgroundColor = UIColor.whiteColor()
        //exclamationView.layer.cornerRadius = exclamationView.bounds.width*0.5
        exclamationView2.clipsToBounds = true
        exclamationView2.center = CGPointMake(screenSize.width * 0.5, screenSize.height * (0.23))
        view.addSubview(exclamationView2)
        
        errorMessage.frame = CGRectMake(0, 0, screenSize.width*0.5, screenSize.height * (300/568))
        errorMessage.center = CGPointMake(screenSize.width * 0.5, screenSize.height * 1.1)
        errorMessage.font = UIFont(name: "Roboto-Light", size:screenSize.height * (23/568))
        errorMessage.textColor = UIColor.whiteColor()
        errorMessage.textAlignment = .Center
        errorMessage.numberOfLines = 0
        view.addSubview(errorMessage)
        
        acceptLabel.frame = CGRectMake(0, 0, screenSize.width*0.5, screenSize.height * (300/568))
         acceptLabel.center = CGPointMake(screenSize.width * 0.5, screenSize.height * 1.1)
         acceptLabel.font = UIFont(name: "Roboto", size: screenSize.height * (13/568))
         acceptLabel.textColor = UIColor.whiteColor()
        acceptLabel.textAlignment = .Center
        acceptLabel.numberOfLines = 0
        view.addSubview( acceptLabel)

        
        
        //Set based on error
        
        if errorNum == 1 {
        //No ideas (1)
            errorMessage.text = "Sorry, we're out of ideas!"
            acceptLabel.text = "Try again"
        }
        else if errorNum == 2 {
        
        //No network (2)
            errorMessage.text = "Sorry, looks like you aren't on Earth.."
            acceptLabel.text = "Try again"
        }
        else if errorNum == 3 {
        //No swears (3)
            errorMessage.text = "Sorry bud, no swearing!"
            acceptLabel.text = "Got it"
        }
        else if errorNum == 4 {
        //No more skips(4)
            errorMessage.text = "Looks like you're out of skips!"
            acceptLabel.text = "But I want more ideas.."
        }
        
        
        //Run stuff
        runAfterDelay(0.1) {
            self.animateExclamation()
            
            self.addCircleView()
        }
        runAfterDelay(0.3) {
            self.moveAcceptLabelUp()
        }
        runAfterDelay(0.7) {
            self.moveLabelUp()
        }
        

    }
    
    override func viewDidAppear(animated: Bool) {
        
        self.gradient = CAGradientLayer()
        self.gradient.frame = self.view.bounds
        
        self.toColors = [colorWithHexString("#14AEFF").CGColor, colorWithHexString("#4342F9").CGColor, colorWithHexString("#A442F9").CGColor, UIColor.magentaColor().CGColor] //start
        self.gradient.colors = [colorWithHexString("#FB22B5").CGColor, colorWithHexString("#FB258F").CGColor,colorWithHexString("#FD5E50").CGColor,colorWithHexString("#FD963C").CGColor] //end
        
        //self.gradient.colors = [colorWithHexString("#6442F9").CGColor, colorWithHexString("#6442F9").CGColor]
        //self.toColors = [colorWithHexString("#FB863F").CGColor, colorWithHexString("#FB863F").CGColor]
        self.view.layer.insertSublayer(self.gradient, atIndex: 0)
        
        animateLayer()
    }
    
    
    func animateExclamation()
    {
        UIView.animateWithDuration(0.6, delay: 0.0, usingSpringWithDamping:
            0.9, initialSpringVelocity: 1.2, options: [], animations: {
                
                //above change the duration to the time it will take,
                //and fiddle with the springs between 0-1 until you are happy with the effect.
                self.exclamationView.center.y += screenSize.height * (240/568)
                //chnage frame however you want to here
                
            }, completion: { finished in
                
                
                self.drawExclamation()
            
     })
        
        

    }
    
    func drawExclamation() {
        view.layer.addSublayer(exclamationLine)
        //exclamationLine.layer.center = CGPointMake(screenSize.width*0.5)
        
        exclamationLine.animateStrokeWithColor(UIColor.whiteColor())
    }
    
    func moveLabelUp()
    {
        UIView.animateWithDuration(1.1, delay: 0.0, usingSpringWithDamping:
            0.85, initialSpringVelocity: 1.2, options: [], animations: {
                
                //above change the duration to the time it will take,
                //and fiddle with the springs between 0-1 until you are happy with the effect.
                self.errorMessage.center.y -= screenSize.height * (340/568)
                //chnage frame however you want to here
                
            }, completion: { finished in
                //code that runs after the transition is complete here
                
        })

    }
    func moveAcceptLabelUp()
    {
        UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping:
            0.8, initialSpringVelocity: 1.2, options: [], animations: {
                
                //above change the duration to the time it will take,
                //and fiddle with the springs between 0-1 until you are happy with the effect.
                self.acceptLabel.center.y -= screenSize.height * (160/568)
                //chnage frame however you want to here
                
            }, completion: { finished in
                //code that runs after the transition is complete here
                
        })
    }
    
    //circle

    
    func animateLayer(){
        
        self.fromColors = self.gradient.colors
        self.gradient.colors = self.toColors! as! [AnyObject] // You missed this line
        var animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
        animation.delegate = self
        animation.fromValue = fromColors
        animation.toValue = toColors
        animation.duration = 20.00
        animation.removedOnCompletion = true
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.delegate = self
        
        self.gradient.addAnimation(animation, forKey:"animateGradient")
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        
        self.toColors = self.fromColors;
        self.fromColors = self.gradient.colors //maybe flip these?
        
        animateLayer()
    }
    
    func addCircleView() {
        let diceRoll = CGFloat(Int(arc4random_uniform(7))*50)
        var circleWidth = screenSize.width*(85/330)
        var circleHeight = circleWidth
        
        // Create a new CircleView
        circleView = CircleView(frame: CGRectMake(diceRoll, 0, circleWidth, circleHeight))
        circleView.center = CGPointMake(screenSize.width*0.5, screenSize.height*0.71)
        
        view.addSubview(circleView)
        //circleView.addSubview(acceptBtn)
        
        // Animate the drawing of the circle over the course of 1 second
        
        acceptImg.image = UIImage(named: "check")
        acceptImg.frame = CGRectMake(0, 0, circleView.layer.bounds.width*0.45, circleView.layer.bounds.height*0.45)
        acceptImg.alpha = 0.0
        acceptImg.center = CGPointMake(circleView.layer.bounds.width * 0.5, circleView.layer.bounds.height * 0.5)
        circleView.addSubview(acceptImg)
        
        
        circleView.animateCircle(1.0)
        runAfterDelay(1) {
            self.scaleAcceptImg()
        }
        
        circleView.userInteractionEnabled = true
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ErrorViewController.acceptPressed(_:)))
        gesture.numberOfTapsRequired = 1
        circleView.addGestureRecognizer(gesture)
        
    }
    
    func scaleAcceptImg()
    {
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            
            self.acceptImg.alpha = 1.0
            self.acceptImg.transform = CGAffineTransformMakeScale(1.2, 1.2)
            
            }, completion: { finished in
                
                UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                    
                    self.acceptImg.transform = CGAffineTransformMakeScale(1, 1)
                    
                }, completion: nil)
        })
    }
    
    func acceptPressed(sender:UITapGestureRecognizer)
    {
        print("woohoo!")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
