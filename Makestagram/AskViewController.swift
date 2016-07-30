//
//  AskViewController.swift
//  round
//
//  Created by Skylar Thomas on 7/2/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Parse
import StoreKit

extension Array {
    func contains<T where T : Equatable>(obj: T) -> Bool {
        return self.filter({$0 as? T == obj}).count > 0
    }
}

let screenSize: CGRect = UIScreen.mainScreen().bounds
public var chosenColor = String()

class AskViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver,  UITextFieldDelegate {
    
    //UI stuff
    
    var timer = NSTimer()
    var ellipseCount = Int(0)
    
    let searchBar = EGFloatingTextField()
    let arrowUp = UIImageView(image: UIImage(named: "arrow"))
    var arrowIsIn = Bool(false)
    let searchLabel = UILabel()
    var ideaDisplayView = UIView()
    let moodDisplayLabel = UILabel()
    let ideaDisplayLabel = UILabel()
    
    var usedIdeasArray = [String]()
    var timesThru = Int()
    
    let ellipse1 = UIImageView()
    let ellipse2 = UIImageView()
    let ellipse3 = UIImageView()
    
    let prefs = NSUserDefaults.standardUserDefaults()
    
    let colors = ["#00D8FF","#F96964", "#FEA924", "#5EC739"]
    
    let v : ResultsViewController = ResultsViewController (nibName: "ResultsViewController", bundle: nil)
    let e : ErrorViewController = ErrorViewController (nibName: "ErrorViewController", bundle: nil)
    var viewGestureRecognizer = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Tried for ellipse
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target:self, selector: Selector("updateLabel"), userInfo: nil, repeats: true)
        arrowIsIn = false
        
        //Search bar
        chosenColor = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        print(chosenColor)
        
        searchBar.frame = CGRectMake(0, 0, screenSize.width*0.72, screenSize.height * (50/568))
        searchBar.center = CGPointMake(screenSize.width * 0.5, screenSize.height * 0.45)
        searchBar.floatingLabel = true
        searchBar.setPlaceHolder("Right now, I'm..")
        searchBar.validationType = .Search
        searchBar.keyboardType = .EmailAddress
        searchBar.font = UIFont(name: "Roboto-Light", size: screenSize.height * (27/568))
        searchBar.textAlignment = NSTextAlignment.Center
        searchBar.originalPlaceholder = "Right now, I'm.."
        
        searchBar.delegate = self
        searchBar.addTarget(self, action: "startedEntering:", forControlEvents: UIControlEvents.TouchDown)

        searchBar.kDefaultActiveColor = colorWithHexString(chosenColor)
        searchBar.activeBorder.backgroundColor = colorWithHexString(chosenColor)
        
        self.view.addSubview(searchBar)
        
        self.view.backgroundColor = colorWithHexString("#F4F3F7")
        
        //Gesture
        viewGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(AskViewController.deSelect(_:)))
        view.userInteractionEnabled = true
        view.addGestureRecognizer(viewGestureRecognizer)
    
    
        //arrow
         
        arrowUp.frame = CGRectMake(0, 0, screenSize.width*(31/330), screenSize.height * (12/568))
        arrowUp.center = CGPointMake(screenSize.width * 0.5, screenSize.height * 1.1)
        self.view.addSubview(arrowUp)
        
//        //ellipse
        ellipse1.frame = CGRectMake(100, 100, screenSize.width*(4/330), screenSize.width*(4/330))
        //ellipse1.center = CGPointMake(searchBar.label.bounds.width*1.7, searchBar.label.bounds.height*0.2)
        ellipse1.center = CGPointMake(screenSize.width*0.5, screenSize.height*0.5)
        ellipse1.layer.cornerRadius = ellipse1.bounds.width * 0.5
        //ellipse1.backgroundColor = searchBar.kDefaultLabelTextColor
        ellipse1.backgroundColor = UIColor.redColor()
        //searchBar.label.addSubview(ellipse1)
//        ellipse2.frame = CGRectMake(0, 0, screenSize.width*(3/330), screenSize.width*(3/330))
//        ellipse2.center = CGPoint(x: screenSize.width*0.76, y: screenSize.height * 0.45)
//        ellipse2.layer.cornerRadius = ellipse1.bounds.width * 0.5
//        ellipse2.backgroundColor = searchBar.kDefaultLabelTextColor
//        view.addSubview(ellipse2)
//        ellipse3.frame = CGRectMake(0, 0, screenSize.width*(3/330), screenSize.width*(3/330))
//        ellipse3.center = CGPoint(x: screenSize.width*0.77, y: screenSize.height * 0.45)
//        ellipse3.layer.cornerRadius = ellipse1.bounds.width * 0.5
//        ellipse3.backgroundColor = searchBar.kDefaultLabelTextColor
//        view.addSubview(ellipse3)
        
        // Set IAPS
        if(SKPaymentQueue.canMakePayments()) {
            print("IAP is enabled, loading")
            let productID:NSSet = NSSet(objects: "imapp.skips1")
            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            request.delegate = self
            request.start()
        } else {
            print("please enable IAPS")
        }

        
//view for idea
        ideaDisplayView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height)
        ideaDisplayView.backgroundColor = colorWithHexString(colors[1])
        view.addSubview(ideaDisplayView)
        
        moodDisplayLabel.text = "Mood"
        moodDisplayLabel.font = UIFont(name: "Roboto", size: screenSize.height * (18/568))
        moodDisplayLabel.frame = CGRectMake(0, 0, screenSize.width * 0.5, screenSize.height * (100/568))
        moodDisplayLabel.center = CGPointMake(screenSize.width * 0.5, screenSize.height * (0.4))
        moodDisplayLabel.textColor = UIColor.whiteColor()
        moodDisplayLabel.textAlignment = NSTextAlignment.Center
        ideaDisplayView.addSubview(moodDisplayLabel)
        
        ideaDisplayLabel.text = "This is my idea..."
       ideaDisplayLabel.font = UIFont(name: "Roboto", size: screenSize.height * (14/568))
        ideaDisplayLabel.textColor = UIColor.whiteColor()
        ideaDisplayLabel.frame = CGRectMake(0, 0, screenSize.width * 0.5, screenSize.height * (100/568))
        ideaDisplayLabel.center = CGPointMake(screenSize.width * 0.5, screenSize.height * (0.5))
        ideaDisplayLabel.textAlignment = NSTextAlignment.Center
        ideaDisplayView.addSubview(ideaDisplayLabel)
        
        
        ideaDisplayView.hidden = true
        
        //Set up prefs
        if prefs.objectForKey("seenIdeas") == nil
        {
            prefs.setValue(usedIdeasArray, forKey: "seenIdeas")
        }
       
    }
    
    //In app purchase =============================================================================
    
    // 1
    var list = [SKProduct]()
    var p = SKProduct()
    
    // 2
    func buyProduct() {
        print("buy " + p.productIdentifier)
        let pay = SKPayment(product: p)
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().addPayment(pay as SKPayment)
    }
    
    //3
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        print("product request")
        let myProduct = response.products
        
        for product in myProduct {
            print("product added")
            print(product.productIdentifier)
            print(product.localizedTitle)
            print(product.localizedDescription)
            print(product.price)
            
            list.append(product )
        }
    }
    
    // 4
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {
        print("transactions restored")
        
        _ = []
        for transaction in queue.transactions {
            let t: SKPaymentTransaction = transaction
            
            let prodID = t.payment.productIdentifier as String
            
            switch prodID {
            case "imapp.skips1":
                print("Give them skips")
                iap1Func()
            default:
                print("IAP not setup")
            }
            
        }
    }
    
    // 5
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("add payment")
        
        for transaction:AnyObject in transactions {
            var trans = transaction as! SKPaymentTransaction
            print(trans.error)
            
            switch trans.transactionState {
                
            case .Purchased:
                print("buy, ok unlock iap here")
                print(p.productIdentifier)
                
                let prodID = p.productIdentifier as String
                switch prodID {
                case "imapp.skips1":
                    print("Give them skips!!")
                    iap1Func()
                default:
                    print("IAP not setup")
                }
                
                queue.finishTransaction(trans)
                break;
            case .Failed:
                print("buy error")
                queue.finishTransaction(trans)
                break;
            default:
                print("default")
                break;
                
            }
        }
        
        // 6
        func finishTransaction(trans:SKPaymentTransaction) //This is called when user hits cancel
        {
            print("finish trans")
            SKPaymentQueue.defaultQueue().finishTransaction(trans)
        }
        
        //7
        func paymentQueue(queue: SKPaymentQueue!, removedTransactions transactions: [AnyObject]!)
        {
            print("remove trans");
        }
    }
    
    func iap1Action(sender:UIButton!)
    {
        print("Trigger IAP 1")
        
        for product in list {
            let prodID = product.productIdentifier
            if(prodID == "imapp.skips1") {
                p = product
                buyProduct()
                break;
            }
        }
        
    }
    func iap1Func() {
        print("THEY GET UNLIMITED SKIPS")
    }
    
    
    //=============================================================================================
    
    
    func startedEntering(textfield: UITextField)
    {
        searchBar.hasError = true
        searchBar.kDefaultErrorColor = UIColor.clearColor()
        
        searchBar.setPlaceHolder("Right now, I'm..")
        moveArrowIn()
    }
    
    func updateLabel()
    {
//        if searchBar.floating == false {
//        if ellipseCount < 3
//        {
//        searchBar.setPlaceHolder(searchBar.getPlaceholder()+".")
//            //searchBar.label.center.x += screenSize.width*(4/330)
//            ellipseCount++
//        }
//        else {
//            ellipseCount = 0
//            searchBar.setPlaceHolder("Right now, I'm")
//        }
//        }
    }
    
    public func moveArrowIn()
    {
        //print("func in \(arrowIsIn)")
        if !arrowIsIn
        {
        UIView.animateWithDuration(0.73, delay: 0, usingSpringWithDamping:
            0.9, initialSpringVelocity: 1.2, options: [], animations: { //or .55 for faster or 0.8
                
                //above change the duration to the time it will take,
                //and fiddle with the springs between 0-1 until you are happy with the effect.
                self.arrowUp.center.y -= screenSize.height * (558/568)
                //chnage frame however you want to here
                
            }, completion: { finished in
                //code that runs after the transition is complete here
                UIView.animateWithDuration(0.75, delay:0, options: [.Repeat, .Autoreverse], animations: {
                    
                    self.arrowUp.center.y += screenSize.height * (6/568)
                    
                    }, completion: nil)
                
        })
            
            arrowIsIn = !arrowIsIn
        }

    }//FIX THIS!!!
    public func moveArrowOut()
    {
        //print("func out \(arrowIsIn)")
        if arrowIsIn == true
        {
        UIView.animateWithDuration(0.35, delay: 0, usingSpringWithDamping:
            0.9, initialSpringVelocity: 1.2, options: [], animations: { //or .55 for faster or 0.8
                
                //above change the duration to the time it will take,
                //and fiddle with the springs between 0-1 until you are happy with the effect.
                self.arrowUp.center.y -= screenSize.height * (80/568)
                //chnage frame however you want to here
                
            }, completion: { finished in
                UIView.animateWithDuration(0, delay: 0, options: [], animations: { //or .55 for faster or 0.8
                    
                    self.arrowUp.hidden = true
                        self.arrowUp.center.y = screenSize.height * 1.1
                    
                        //chnage frame however you want to here
                        
                    }, completion: { finished in
                        self.arrowUp.hidden = false
                })
        })
            
            arrowIsIn = !arrowIsIn
            //print("func out \(arrowIsIn)")
        }
    }

    
    func deSelect(sender: AnyObject) {
        
        dismissKeyboard()
        searchBar.resignFirstResponder()
        textFieldShouldEndEditing(searchBar)
        if searchBar.floating == true {
            searchBar.label.textColor = searchBar.kDefaultActiveColor
        }
        
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldEndEditing(textField: UITextField!) -> Bool {
        return true
    }
    
    func showIdeaView()
    {
        externalViewUp = true
        
        viewGestureRecognizer.enabled = false
        self.addChildViewController(v)
        self.view.addSubview(v.view)
        v.didMoveToParentViewController(self)
        
        v.view.frame = self.view.bounds
        
    }
    func showErrorView()
    {
        externalViewUp = true
        
        //view.userInteractionEnabled = false
        viewGestureRecognizer.enabled = false
        self.addChildViewController(e)
        self.view.addSubview(e.view)
        e.didMoveToParentViewController(self)
        
        e.view.frame = self.view.bounds
    }
    
    public func goSearch(sender: AnyObject) {
        let mood = searchBar.text
        
        if !(mood?.isEmpty)!
        {
            ParseHelper.searchPosts(mood!, completionBlock: handleIdea)
            //showIdeaView()
            
        }
        else {
            print("have to search something")
        }
        deSelect(self)
        if arrowIsIn == true
        {
            moveArrowOut()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        var rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func handleIdea (results: [PFObject]?, error: NSError?) {
        
        timesThru = 0
        
        
        //Send to idea chooser
        
        if results?.isEmpty == true
        {
            //print("nil!!")
            print("no results! Error!")
            e.errorNum = 1
            
            showErrorView()
            displayNoIdea()
            
        }
        else {
            
            showIdeaView()
            chooseRandIdea(results)
        }
        
    } //move menu in at first
    
    func chooseRandIdea(results: [PFObject]?)
    {
        
//        let rand1a = Int(arc4random_uniform(UInt32(results!.count/2)))
//        let rand1b = Int(arc4random_uniform(UInt32(results!.count/4)))
//        let rand2 = Int(arc4random_uniform(UInt32(results!.count/2))+UInt32(results!.count/2))
//        
//        let randArray = [rand1a, rand1b, rand2]
//        
//        let actualRand = randArray[Int(arc4random_uniform(3))]
        
//        let selectedIdea = results![actualRand]
        
        let rand = Int(arc4random_uniform(UInt32(results!.count)))
        
        let selectedIdea = results![rand]
        
        let postId = String(selectedIdea.objectId)
        
        let ideaArray = prefs.arrayForKey("seenIdeas") //later - separate user default array tied with key variable name for better randomize or do by newest
        
        
        //make sure idea hasnt been seen yet
        if ideaArray!.contains(postId) //idea has been seen
        {
            timesThru += 1
            print("cant use this!")
            
            if(timesThru<10)
            {
                chooseRandIdea(results)
            }
            else {
                
                //Relent
                usedIdeasArray.removeAll()
                usedIdeasArray.append(postId)
                prefs.setValue(usedIdeasArray, forKey: "seenIdeas")
                prefs.synchronize()
                
                displayIdea(selectedIdea["mood"] as! String, text: selectedIdea["ideaText"] as! String)
                
            }
            
        }
            
        else { //idea hasnt been seen
            
            usedIdeasArray.append(postId)
            
            prefs.setValue(usedIdeasArray, forKey: "seenIdeas")
            prefs.synchronize()
            
            displayIdea(selectedIdea["mood"] as! String, text: selectedIdea["ideaText"] as! String)
            
            
            print("called normal end")
        }
        
    }
    
    func displayIdea(mood: String, text: String)
    {
        print("Here it is: \(mood):  \(text)")
        
        print("The array:")
        print(prefs.objectForKey("seenIdeas"))
        
        v.setIdeaLabels(mood, idea: text)
    }
    func displayNoIdea()
    {
        print("Sorry kid..")
    }


}
public func colorWithHexString (hex:String) -> UIColor {
    var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
    
    if (cString.hasPrefix("#")) {
        cString = (cString as NSString).substringFromIndex(1)
    }
    
    if (cString.characters.count != 6) {
        return UIColor.grayColor()
    }
    
    let rString = (cString as NSString).substringToIndex(2)
    let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
    let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
    
    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
    NSScanner(string: rString).scanHexInt(&r)
    NSScanner(string: gString).scanHexInt(&g)
    NSScanner(string: bString).scanHexInt(&b)
    
    
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
}

