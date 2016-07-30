//
//  StarterViewController.swift
//  round
//
//  Created by Skylar Thomas on 7/2/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit

 public var externalViewUp = Bool(false)

class StarterViewController: UIViewController {

    let v1 : AskViewController = AskViewController (nibName: "AskViewController", bundle: nil)
    let v2 : PostViewController = PostViewController (nibName: "PostViewController", bundle: nil)
    let v3 : HistoryViewController = HistoryViewController (nibName: "HistoryViewController", bundle: nil)
    
    let menuBtn1 = UIButton(type: UIButtonType.Custom)
    let menuBtn2 = UIButton(type: UIButtonType.Custom)
    let menuBtn3 = UIButton(type: UIButtonType.Custom)
    
    let ico1 = UIImageView(image: UIImage(named: "history"))
    let ico2 = UIImageView(image: UIImage(named: "safari"))
    let ico3 = UIImageView(image: UIImage(named: "light"))
    
    var menuUp = Bool(false)
    var viewUp = Int(2)
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = colorWithHexString("#F4F3F7")
        
        self.addChildViewController(v1)
        self.view.addSubview(v1.view)
        v1.didMoveToParentViewController(self)
        
        v1.view.frame = self.view.bounds
        
        self.addChildViewController(v2)
        self.view.addSubview(v2.view)
        v2.didMoveToParentViewController(self)
        
        v2.view.frame = self.view.bounds
        v2.view.frame.origin.x = self.view.frame.width
        
        self.addChildViewController(v3)
        self.view.addSubview(v3.view)
        v3.didMoveToParentViewController(self)
        
        v3.view.frame = self.view.bounds
        v3.view.frame.origin.x = -self.view.frame.width
        
        //menu buttons
        menuBtn1.frame = CGRectMake(0, 0, screenSize.width * (58/330), screenSize.width * (58/330))
        menuBtn1.backgroundColor = colorWithHexString(chosenColor)
        menuBtn1.layer.cornerRadius = menuBtn1.bounds.width*0.5
        menuBtn1.clipsToBounds = true
        menuBtn1.center = CGPointMake(screenSize.width * 0.5, screenSize.height * (1.1))
        menuBtn1.addTarget(self, action: "goToAsk:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(menuBtn1)
        menuBtn2.frame = CGRectMake(0, 0, screenSize.width * (58/330), screenSize.width * (58/330))
        menuBtn2.backgroundColor = colorWithHexString(chosenColor)
        menuBtn2.layer.cornerRadius = menuBtn1.bounds.width*0.5
        menuBtn2.clipsToBounds = true
        menuBtn2.center = CGPointMake(screenSize.width * 0.26, screenSize.height * (1.1))
        menuBtn2.addTarget(self, action: "goToHistory:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(menuBtn2)
        menuBtn3.frame = CGRectMake(0, 0, screenSize.width * (58/330), screenSize.width * (58/330))
        menuBtn3.backgroundColor = colorWithHexString(chosenColor)
        menuBtn3.layer.cornerRadius = menuBtn1.bounds.width*0.5
        menuBtn3.clipsToBounds = true
        menuBtn3.center = CGPointMake(screenSize.width * 0.74, screenSize.height * (1.1))
        menuBtn3.addTarget(self, action: "goToPost:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(menuBtn3)
        
        
        ico1.frame = CGRectMake(0, 0, menuBtn1.layer.bounds.width*0.44, menuBtn1.layer.bounds.height*0.44)
      ico1.center = CGPointMake(menuBtn1.layer.bounds.width * 0.5, menuBtn1.layer.bounds.height * 0.5)
        //ico1.alpha = 0.7
        menuBtn1.addSubview(ico2)
        ico2.frame = CGRectMake(0, 0, menuBtn1.layer.bounds.width*0.48, menuBtn1.layer.bounds.height*0.48)
        ico2.center = CGPointMake(menuBtn1.layer.bounds.width * 0.5, menuBtn1.layer.bounds.height * 0.5)
        //ico2.alpha = 0.7
        menuBtn2.addSubview(ico1)
        ico3.frame = CGRectMake(0, 0, menuBtn1.layer.bounds.width*0.54, menuBtn1.layer.bounds.height*0.54)
        ico3.center = CGPointMake(menuBtn1.layer.bounds.width * 0.5, menuBtn1.layer.bounds.height * 0.49)
        //ico3.alpha = 0.7
        menuBtn3.addSubview(ico3)
        
        let menuSwipe = UISwipeGestureRecognizer(target: self, action: "moveMenuUp:")
        menuSwipe.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(menuSwipe)
        
        let menuSwipe2 = UISwipeGestureRecognizer(target: self, action: "moveMenuDown:")
        menuSwipe2.direction = UISwipeGestureRecognizerDirection.Up
        self.view.addGestureRecognizer(menuSwipe2)
        
        runAfterDelay(1)
        {
        self.moveMenuUp(self)
        }
        
        
    }
    
    
    func goToAsk(sender: UIButton!)
        
        
    {
        
        
        print(viewUp)
        if viewUp == 1
        {
            self.moveMenuRight()
            UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping:
                0.8, initialSpringVelocity: 1.4, options: [], animations: {
                    
                    self.v3.view.center.x -= self.v3.view.bounds.width
                    self.v1.view.center.x -= self.v1.view.bounds.width
                    self.v2.view.center.x -= self.v1.view.bounds.width
                    
                    //chnage frame however you want to here
                    
                }, completion: { finished in
                    //code that runs after the transition is complete here
                    
                    
            })
            self.viewUp = 2
        }
        else if viewUp == 3 {
            self.moveMenuLeft()
            UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping:
                0.8, initialSpringVelocity: 1.4, options: [], animations: {
                    
                    self.v2.view.center.x += self.v3.view.bounds.width
                    self.v3.view.center.x += self.v3.view.bounds.width
                    self.v1.view.center.x += self.v1.view.bounds.width
                    
                    //chnage frame however you want to here
                    
                }, completion: { finished in
                    //code that runs after the transition is complete here
                
                    
            })
            self.viewUp = 2
        }
    }
    
    func goToPost(sender: AnyObject!)
    {
        print(viewUp)
        if viewUp == 1
        {
            self.moveMenuRight()
            //weird
            UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping:
                0.8, initialSpringVelocity: 1.4, options: [], animations: {
                
                    self.v2.view.center.x -= 2 * self.v1.view.bounds.width
                    self.v1.view.center.x -= 2 * self.v2.view.bounds.width
                    self.v3.view.center.x -= 2 * self.v2.view.bounds.width

                //chnage frame however you want to here
                
            }, completion: { finished in
                //code that runs after the transition is complete here
                
                
        })
            self.viewUp = 3
        }
            //this one
        else if viewUp == 2 {
            self.moveMenuRight()
            UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping:
                0.8, initialSpringVelocity: 1.4, options: [], animations: {
                    
                    self.v1.view.center.x -= self.v1.view.bounds.width
                    self.v2.view.center.x -= self.v2.view.bounds.width
                    self.v3.view.center.x -= self.v1.view.bounds.width
                    
                    //chnage frame however you want to here
                    
                }, completion: { finished in
                    //code that runs after the transition is complete here
                
                    
            })
            self.viewUp = 3

        }

    }
    
    func goToHistory(sender: AnyObject!)
    {
        
        print(viewUp)
        if viewUp == 2 {
            self.moveMenuLeft()
            UIView.animateWithDuration(0.8, delay: 0.0, usingSpringWithDamping:
                0.65, initialSpringVelocity: 1.2, options: [], animations: {
                    
                    self.v1.view.center.x += self.v1.view.bounds.width
                    self.v2.view.center.x += self.v1.view.bounds.width
                    self.v3.view.center.x += self.v2.view.bounds.width
                    
                    //chnage frame however you want to here
                    
                }, completion: { finished in
                    //code that runs after the transition is complete here
                    
            })
            self.viewUp = 1
        }
        else if viewUp == 3 {
            
            self.moveMenuLeft()
            //weird
            UIView.animateWithDuration(0.8, delay: 0.0, usingSpringWithDamping:
                0.65, initialSpringVelocity: 1.2, options: [], animations: {
                    
                    self.v2.view.center.x += 2 * self.v1.view.bounds.width
                    self.v1.view.center.x += 2 * self.v1.view.bounds.width
                    self.v3.view.center.x += 2 * self.v1.view.bounds.width
                    //chnage frame however you want to here
                    
                }, completion: { finished in
                    //code that runs after the transition is complete here
                    
            })
             self.viewUp = 1
        }
        
    }
    
    func moveMenuDown(sender: AnyObject!)
    {
        print(menuUp)
        if !externalViewUp { //maybe want to change this later
        if menuUp {
            UIView.animateWithDuration(0.8, delay: 0.0, usingSpringWithDamping:
                0.65, initialSpringVelocity: 1.2, options: [], animations: {
                    
                    //above change the duration to the time it will take,
                    //and fiddle with the springs between 0-1 until you are happy with the effect.
                    self.menuBtn1.center.y += screenSize.height * (122/568)
                    self.menuBtn2.center.y += screenSize.height * (122/568)
                    self.menuBtn3.center.y += screenSize.height * (122/568)
                    //chnage frame however you want to here
                    
                }, completion: { finished in
                    //code that runs after the transition is complete here
                    
            })
        menuUp = !menuUp
        }
        
        v1.goSearch(self)
        }

    }
    func moveMenuLeft()
    {
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping:
            0.7, initialSpringVelocity: 1.2, options: [], animations: {
                
                
                self.menuBtn1.center.x -= screenSize.width * (5/330)
                self.menuBtn2.center.x -= screenSize.width * (7/330)
                self.menuBtn3.center.x -= screenSize.width * (6/330) //0 for spring?
                //chnage frame however you want to here
                
            }, completion: { finished in
                //code that runs after the transition is complete here
                UIView.animateWithDuration(0.5, delay: -0.9, usingSpringWithDamping:
                    0.35, initialSpringVelocity: 1.2, options: [], animations: { //or .55 for faster or 0.8
                        
                        //above change the duration to the time it will take,
                        //and fiddle with the springs between 0-1 until you are happy with the effect.
                        self.menuBtn1.center.x += screenSize.width * (5/330)
                        self.menuBtn2.center.x += screenSize.width * (7/330)
                        self.menuBtn3.center.x += screenSize.width * (6/330)
                        //chnage frame however you want to here
                        
                    }, completion: { finished in
                        //code that runs after the transition is complete here
                        
                })
        })

        
    }
    func moveMenuRight()
    {
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping:
            0.7, initialSpringVelocity: 1.2, options: [], animations: {
                
                
                self.menuBtn1.center.x += screenSize.width * (5/330)
                self.menuBtn2.center.x += screenSize.width * (7/330)
                self.menuBtn3.center.x += screenSize.width * (6/330) //0 for spring?
                //chnage frame however you want to here
                
            }, completion: { finished in
                //code that runs after the transition is complete here
                UIView.animateWithDuration(0.5, delay: -0.9, usingSpringWithDamping:
                    0.35, initialSpringVelocity: 1.2, options: [], animations: { //or .55 for faster or 0.8
                        
                        //above change the duration to the time it will take,
                        //and fiddle with the springs between 0-1 until you are happy with the effect.
                        self.menuBtn1.center.x -= screenSize.width * (5/330)
                        self.menuBtn2.center.x -= screenSize.width * (7/330)
                        self.menuBtn3.center.x -= screenSize.width * (6/330)
                        //chnage frame however you want to here
                        
                    }, completion: { finished in
                        //code that runs after the transition is complete here
                        
                })
        })    }
    
    func moveMenuUp(sender: AnyObject!)
    {
        
        if !menuUp && !externalViewUp
        {
        UIView.animateWithDuration(0.8, delay: 0.0, usingSpringWithDamping:
            0.65, initialSpringVelocity: 1.2, options: [], animations: {
                
                //above change the duration to the time it will take,
                //and fiddle with the springs between 0-1 until you are happy with the effect.
                self.menuBtn1.center.y -= screenSize.height * (122/568)
                self.menuBtn2.center.y -= screenSize.height * (122/568)
                self.menuBtn3.center.y -= screenSize.height * (122/568)
                //chnage frame however you want to here
                
            }, completion: { finished in
                //code that runs after the transition is complete here  
                
        })
            menuUp = !menuUp
        }
      
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
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
func runAfterDelay(delay: NSTimeInterval, block: dispatch_block_t) {
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
    dispatch_after(time, dispatch_get_main_queue(), block)
}
