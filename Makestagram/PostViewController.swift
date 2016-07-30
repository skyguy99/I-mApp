//
//  PostViewController.swift
//  round
//
//  Created by Skylar Thomas on 7/2/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Parse
import Foundation

extension String {
    
    func contains(find: String) -> Bool{
        return self.rangeOfString(find) != nil
    }
    
    func containsIgnoringCase(find: String) -> Bool{
        return self.rangeOfString(find, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil
    }
}

class PostViewController: UIViewController {

    //this was fun
    let prohibitedWords = [
    
    "anal",
    "anus",
    "apeshit",
    "arsehole",
    "ass",
    "asshole",
    "ballsack",
    "bitch",
    "bitches",
    "black cock",
    "blowjob",
    "boner",
    "boob",
    "boobs",
    "bullshit",
    "butthole",
    "clit",
    "cock",
    "cocks",
    "cum",
    "cumming",
    "cunt",
    "daterape",
    "dick",
    "dildo",
        "ejaculation",
    "erotic",
    "faggot",
    "fisting",
    "fuck",
    "fuckin",
    "fucking",
    "fucktards",
    "fuggin",
    "fucktard",
    "genitals",
    "g-spot",
    "handjob",
    "intercourse",
    "jack off",
    "kinky",
    "masturbate",
    "motherfucker",
    "motherfuggin",
    "motherfucking",
"negro",
"nigga",
    "nigger",
    "orgasm",
    "orgy",
    "penis",
    "porn",
    "porno",
    "pussy",
    "rape",
    "raping",
"semen",
    "sex",
    "shit",
    "shitty",
    "slut",
    "slutty",
    "tit",
    "tits",
    "titties",
    "tranny",
    "twat",
    "vagina",
    "vulva",
    "wank",
    "🖕",
    "fucker"]
    
    @IBOutlet var ideaTextField: UITextView!
    
    @IBOutlet var postBtn: UIButton!
    let moodTextField = EGFloatingTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = colorWithHexString("#F4F3F7")
        
//mood textfield
        moodTextField.frame = CGRectMake(0, 0, screenSize.width*0.72, screenSize.height * (50/568))
         moodTextField.center = CGPointMake(screenSize.width * 0.5, screenSize.height * 0.45)
        moodTextField.floatingLabel = true
         moodTextField.setPlaceHolder("When I'm..")
         moodTextField.validationType = .Search
         moodTextField.keyboardType = .EmailAddress
       moodTextField.font = UIFont(name: "Roboto", size: screenSize.height * (27/568))
         moodTextField.textAlignment = NSTextAlignment.Center
        
        
       moodTextField.kDefaultActiveColor = UIColor.redColor()
        moodTextField.activeBorder.backgroundColor = UIColor.redColor()
        
        self.view.addSubview(moodTextField)
        
        //gesture
        let viewGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(PostViewController.deSelect(_:)))
        view.userInteractionEnabled = true
        view.addGestureRecognizer(viewGestureRecognizer)
    }
    //Swift 3:
//    func containsSwearWord(text: String, swearWords: [String]) -> Bool {
//        return swearWords.reduce(false) { $0 || text.contains($1) }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func deSelect(sender: AnyObject) { //issue with scroll - maybe disable scrollview scroll when textfield selected?
        
        dismissKeyboard()
        moodTextField.resignFirstResponder()
        moodTextField.endEditing(true)
        moodTextField.active = false //return to starting state
        moodTextField.floating = false
        
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func postIdea(sender: AnyObject) {
        var noSwears = true
        
        if ((!(moodTextField.text?.isEmpty)! && !(ideaTextField.text?.isEmpty)!))
        {
            for word in prohibitedWords
            {
                if ideaTextField.text.containsIgnoringCase(word) || moodTextField.text!.containsIgnoringCase(word)
                {
                    noSwears = false
                }
            }
            
            //no swears and not empty
            if noSwears == true {
                let ideaPost = PFObject(className: "ideaPosts")
                ideaPost["mood"] = moodTextField.text
                ideaPost["ideaText"] = ideaTextField.text
                ideaPost.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    print("Object has been saved.")
                }
            }
            else {
                print("Sorry kid, you swore")
            }
        }
        else {
            print("empty!")
        }
        
        
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
