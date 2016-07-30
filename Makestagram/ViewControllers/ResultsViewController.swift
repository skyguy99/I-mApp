//
//  ResultsViewController.swift
//  I'm..
//
//  Created by Skylar Thomas on 7/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Parse

class ResultsViewController: UIViewController {
    
    let moodDisplay = EGFloatingTextField()
    let ideaText = UILabel()
    let numberView = UIImageView()
    let numberLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = colorWithHexString(chosenColor)
        
        moodDisplay.frame = CGRectMake(0, 0, screenSize.width*0.72, screenSize.height * (50/568))
        moodDisplay.center = CGPointMake(screenSize.width * 0.5, screenSize.height * 0.45)
        moodDisplay.setPlaceHolder("When I'm..")
        moodDisplay.label.textColor = UIColor.whiteColor()
        //moodDisplay.label.center.y -= screenSize.height * (10/568)
        moodDisplay.kDefaultInactiveColor = UIColor.whiteColor()
        moodDisplay.validationType = .Search
        moodDisplay.keyboardType = .EmailAddress
        moodDisplay.font = UIFont(name: "Roboto-Light", size: screenSize.height * (30/568))
        moodDisplay.textAlignment = NSTextAlignment.Center
        //moodDisplay.label.text = "Testing"
        moodDisplay.kDefaultActiveColor = UIColor.whiteColor()
        moodDisplay.activeBorder.backgroundColor = UIColor.whiteColor()
        moodDisplay.kDefaultErrorColor = UIColor.clearColor()
        moodDisplay.hasError = true
    moodDisplay.activateWithout()
        //moodDisplay.floatLabelToTop()
        moodDisplay.text = ""
        moodDisplay.textColor = UIColor.whiteColor()
    
        moodDisplay.userInteractionEnabled = false
        view.addSubview(moodDisplay)
        
        ideaText.frame = CGRectMake(0, 0, screenSize.width*0.72, screenSize.height * (50/568))
        ideaText.center = CGPointMake(screenSize.width * 0.5, screenSize.height * 0.55)
        ideaText.font = UIFont(name: "Roboto", size: screenSize.height*(18/568))
        ideaText.textColor = UIColor.whiteColor()
        ideaText.textAlignment = .Center
        ideaText.text = ""
        ideaText.numberOfLines = 0
        view.addSubview(ideaText)

        //numebr view 
        
        numberView.frame = CGRectMake(0, 0, screenSize.width * (40/330), screenSize.width * (40/330))
        numberView.layer.cornerRadius = screenSize.width * (40/330) * 0.5
        numberView.center = CGPointMake(screenSize.width * 0.5, screenSize.height * 0.2)
        numberView.backgroundColor = UIColor.whiteColor()
        view.addSubview(numberView)
        
        numberLabel.frame = CGRectMake(0, 0, screenSize.width * (40/330), screenSize.width * (40/330))
        numberLabel.font = UIFont(name: "Roboto-Black", size: screenSize.height * (23/568))
        numberLabel.textColor = colorWithHexString(chosenColor)
        numberLabel.text = "1"
        numberLabel.textAlignment = .Center
        numberView.addSubview(numberLabel)
    }
    
    public func setIdeaLabels(mood: String, idea: String)
    {
        moodDisplay.text = mood
        ideaText.text = idea
        
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
