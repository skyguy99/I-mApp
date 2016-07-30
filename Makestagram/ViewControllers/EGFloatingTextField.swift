//
//  EGFloatingTextField.swift
//  EGFloatingTextField
//
//  Created by Enis Gayretli on 26.05.2015.
//
//
import UIKit
import Foundation


public enum EGFloatingTextFieldValidationType {
    case Email
    case Number
    case Search
}

public class EGFloatingTextField: UITextField {
    
    private typealias EGFloatingTextFieldValidationBlock = ((text:String,inout message:String)-> Bool)!
    
    public var validationType : EGFloatingTextFieldValidationType!
    
    
    private var emailValidationBlock  : EGFloatingTextFieldValidationBlock
    private var numberValidationBlock : EGFloatingTextFieldValidationBlock
    private var searchValidationBlock : EGFloatingTextFieldValidationBlock
    
    
    var kDefaultInactiveColor = UIColor(white: CGFloat(0), alpha: CGFloat(0.7)) //black
    var kDefaultActiveColor = UIColor.blueColor()
    var kDefaultErrorColor = UIColor(white: CGFloat(0), alpha: CGFloat(0.7))
    var kDefaultLineHeight = CGFloat(21)
    var kDefaultLabelTextColor = UIColor(white: CGFloat(0), alpha: CGFloat(0.7))
    var kDefaultActiveBorderColor = UIColor.blueColor()
    
    
    public var floatingLabel : Bool!
    var label : UILabel!
    var labelFont : UIFont!
    var labelTextColor : UIColor!
    var activeBorder : UIView!
    var floating : Bool!
    var active : Bool!
    var hasError : Bool!
    var errorMessage : String!
    var originalPlaceholder : String!
    
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    func commonInit(){
        
        self.emailValidationBlock = ({(text:String, inout message: String) -> Bool in
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
            
            let emailTest = NSPredicate(format:"SELF MATCHES %@" , emailRegex)
            
            let  isValid = emailTest.evaluateWithObject(text)
            if !isValid {
                message = "Invalid Email Address"
            }
            return isValid;
        })
        self.numberValidationBlock = ({(text:String,inout message: String) -> Bool in
            let numRegex = "[0-9.+-]+";
            let numTest = NSPredicate(format:"SELF MATCHES %@" , numRegex)
            
            let isValid =  numTest.evaluateWithObject(text)
            if !isValid {
                message = "Invalid Number"
            }
            return isValid;
            
        })
        
        self.searchValidationBlock = ({(text:String,inout message: String) -> Bool in
            return true;
            
        })
        
        self.floating = false
        self.hasError = false
       
        self.labelTextColor = kDefaultLabelTextColor
        self.label = UILabel(frame: CGRectZero)
        self.label.font = UIFont(name: "Roboto-Light", size: screenSize.height * (24/568)) //custom
        self.label.textColor = self.labelTextColor
        self.label.textAlignment = NSTextAlignment.Center
        self.label.numberOfLines = 1
        self.label.layer.masksToBounds = false
        self.addSubview(self.label)
        
        
        self.activeBorder = UIView(frame: CGRectZero)
        self.activeBorder.backgroundColor = kDefaultActiveColor
        //self.activeBorder.backgroundColor = kDefaultActiveBorderColor
        self.activeBorder.layer.opacity = 0
        self.addSubview(self.activeBorder)
        
        self.label.autoAlignAxis(ALAxis.Horizontal, toSameAxisOfView: self)
        self.label.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Left, ofView: self)
        self.label.autoMatchDimension(ALDimension.Width, toDimension: ALDimension.Width, ofView: self)
        self.label.autoMatchDimension(ALDimension.Height, toDimension: ALDimension.Height, ofView: self)
        
        self.activeBorder.autoPinEdge(ALEdge.Bottom, toEdge: ALEdge.Bottom, ofView: self)
        self.activeBorder.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Left, ofView: self)
        self.activeBorder.autoPinEdge(ALEdge.Right, toEdge: ALEdge.Right, ofView: self)
        self.activeBorder.autoSetDimension(ALDimension.Height, toSize: 4.5)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("textDidChange:"), name: "UITextFieldTextDidChangeNotification", object: self)
    }
    public func setPlaceHolder(placeholder:String){
        self.label.text = placeholder
    }
    public func getPlaceholder()->String {
        return self.label.text!
    }
    
    override public func becomeFirstResponder() -> Bool {
        
        print("func 1")
        let flag:Bool = super.becomeFirstResponder()
        
        if flag {
            
            if self.floatingLabel! {
                
                if !self.floating! || self.text!.isEmpty {
                    self.floatLabelToTop()
                    self.floating = true
                }
            } else {
                self.label.textColor = kDefaultActiveColor
                self.label.layer.opacity = 0
            }
            self.showActiveBorder()
        }
        
        self.active=flag
        return flag
    }
    public func activateWithout()
    {
//        super.becomeFirstResponder()
//        self.floatingLabel = true
//        self.floating = true
        self.active = true
        self.showActiveBorder()
        self.floatLabelToTop2()
        
    }
    
    override public func resignFirstResponder() -> Bool {
        
        let flag:Bool = super.becomeFirstResponder()
        
        if flag {
            
            if self.floatingLabel! {
                
                if self.floating! && self.text!.isEmpty {
                    self.animateLabelBack()
                    self.floating = false
                }
            } else {
                if self.text!.isEmpty {
                    self.label.layer.opacity = 1
                }
            }
            self.label.textColor = kDefaultInactiveColor
            self.showInactiveBorder()
            self.validate()
        }
        self.active = flag
        super.resignFirstResponder()
        return flag
        
    }
    
    //this for inactive border
    override public func drawRect(rect: CGRect){
        super.drawRect(rect)
        
        let borderColor = self.hasError! ? kDefaultActiveColor : kDefaultErrorColor
        
        let textRect = self.textRectForBounds(rect)
        
        let context = UIGraphicsGetCurrentContext()
        let borderlines : [CGPoint] = [CGPointMake(0, CGRectGetHeight(textRect) - 1),
            CGPointMake(CGRectGetWidth(textRect), CGRectGetHeight(textRect) - 1)]
        
        if  self.enabled  {
            
            CGContextBeginPath(context);
            CGContextAddLines(context, borderlines, 2);
            CGContextSetLineWidth(context, 1.3);
            CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
            CGContextStrokePath(context);
            
//            self.borderlines.transform = CATransform3DMakeScale(CGFloat(0.01), CGFloat(1.0), 1)
//            self.activeBorder.layer.opacity = 1
//            CATransaction.begin()
//            self.activeBorder.layer.transform = CATransform3DMakeScale(CGFloat(0.03), CGFloat(1.0), 1)
//            let anim2 = CABasicAnimation(keyPath: "transform")
//            let fromTransform = CATransform3DMakeScale(CGFloat(0.01), CGFloat(1.0), 1)
//            let toTransform = CATransform3DMakeScale(CGFloat(1.0), CGFloat(1.0), 1)
//            anim2.fromValue = NSValue(CATransform3D: fromTransform)
//            anim2.toValue = NSValue(CATransform3D: toTransform)
//            anim2.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
//            anim2.fillMode = kCAFillModeForwards
//            anim2.removedOnCompletion = false
//            self.activeBorder.layer.addAnimation(anim2, forKey: "_activeBorder")
//            CATransaction.commit()
            
        } else {
            
            CGContextBeginPath(context);
            CGContextAddLines(context, borderlines, 2);
            CGContextSetLineWidth(context, 1.0);
            let  dashPattern : [CGFloat]  = [2, 4]
            CGContextSetLineDash(context, 0, dashPattern, 2);
            CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
            CGContextStrokePath(context);
            
        }
    }
    
    func textDidChange(notif: NSNotification){
        self.validate()
    }
    
    func floatLabelToTop() {
 
        
        CATransaction.begin()
        CATransaction.setCompletionBlock { () -> Void in
            self.label.textColor = self.kDefaultActiveColor
        }
        
        let anim2 = CABasicAnimation(keyPath: "transform")
        let fromTransform = CATransform3DMakeScale(CGFloat(1.0), CGFloat(1.0), CGFloat(1))
        var toTransform = CATransform3DMakeScale(CGFloat(0.75), CGFloat(0.75), CGFloat(1))
        toTransform = CATransform3DTranslate(toTransform, 0, -CGRectGetHeight(self.label.frame), 0)
        anim2.fromValue = NSValue(CATransform3D: fromTransform)
        anim2.toValue = NSValue(CATransform3D: toTransform)
        anim2.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        let animGroup = CAAnimationGroup()
        animGroup.animations = [anim2]
        animGroup.duration = 0.3
        animGroup.fillMode = kCAFillModeForwards;
        animGroup.removedOnCompletion = false;
        self.label.font = UIFont(name: "Roboto-Black", size: (self.label.font?.pointSize)!)
        self.label.layer.addAnimation(animGroup, forKey: "_floatingLabel")
        self.clipsToBounds = false
        CATransaction.commit()
    }
    func floatLabelToTop2() {
        
        CATransaction.begin()
        CATransaction.setCompletionBlock { () -> Void in
            self.label.textColor = self.kDefaultActiveColor
        }
        
        let anim2 = CABasicAnimation(keyPath: "transform")
        let fromTransform = CATransform3DMakeScale(CGFloat(1.0), CGFloat(1.0), CGFloat(1))
        var toTransform = CATransform3DMakeScale(CGFloat(0.75), CGFloat(0.75), CGFloat(1))
        toTransform = CATransform3DTranslate(toTransform, 0, screenSize.height * -(50/568), 0)
        anim2.fromValue = NSValue(CATransform3D: fromTransform)
        anim2.toValue = NSValue(CATransform3D: toTransform)
        anim2.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        let animGroup = CAAnimationGroup()
        animGroup.animations = [anim2]
        animGroup.duration = 0.3
        animGroup.fillMode = kCAFillModeForwards;
        animGroup.removedOnCompletion = false;
        self.label.font = UIFont(name: "Roboto-Black", size: (self.label.font?.pointSize)!)
        self.label.layer.addAnimation(animGroup, forKey: "_floatingLabel")
        self.clipsToBounds = false
        CATransaction.commit()
    }
    func showActiveBorder() {
        
        //kDefaultErrorColor = UIColor.clearColor()
        self.activeBorder.layer.transform = CATransform3DMakeScale(CGFloat(0.01), CGFloat(1.0), 1)
        self.activeBorder.layer.opacity = 1
        CATransaction.begin()
        self.activeBorder.layer.transform = CATransform3DMakeScale(CGFloat(0.03), CGFloat(1.0), 1)
        let anim2 = CABasicAnimation(keyPath: "transform")
        let fromTransform = CATransform3DMakeScale(CGFloat(0.01), CGFloat(1.0), 1)
        let toTransform = CATransform3DMakeScale(CGFloat(1.0), CGFloat(1.0), 1)
        anim2.fromValue = NSValue(CATransform3D: fromTransform)
        anim2.toValue = NSValue(CATransform3D: toTransform)
        anim2.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        anim2.fillMode = kCAFillModeForwards
        anim2.removedOnCompletion = false
        self.activeBorder.layer.addAnimation(anim2, forKey: "_activeBorder")
        CATransaction.commit()
        
    }
    
    func animateLabelBack() {
        
        CATransaction.begin()
        CATransaction.setCompletionBlock { () -> Void in
            self.label.textColor = self.kDefaultInactiveColor
        }
        
        let anim2 = CABasicAnimation(keyPath: "transform")
        var fromTransform = CATransform3DMakeScale(0.5, 0.5, 1)
        fromTransform = CATransform3DTranslate(fromTransform, 0, -CGRectGetHeight(self.label.frame), 0);
        let toTransform = CATransform3DMakeScale(1.0, 1.0, 1)
        anim2.fromValue = NSValue(CATransform3D: fromTransform)
        anim2.toValue = NSValue(CATransform3D: toTransform)
        anim2.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        let animGroup = CAAnimationGroup()
        animGroup.animations = [anim2]
        animGroup.duration = 0.3
        animGroup.fillMode = kCAFillModeForwards;
        animGroup.removedOnCompletion = false;
        self.label.font = UIFont(name: "Roboto-Light", size: (self.label.font?.pointSize)!)
        self.label.text = originalPlaceholder
        
        self.label.layer.addAnimation(animGroup, forKey: "_animateLabelBack")
        CATransaction.commit()
        
    }
    func showInactiveBorder() {
        
        CATransaction.begin()
        CATransaction.setCompletionBlock { () -> Void in
            self.activeBorder.layer.opacity = 0
        }
        let anim2 = CABasicAnimation(keyPath: "transform")
        let fromTransform = CATransform3DMakeScale(1.0, 1.0, 1)
        let toTransform = CATransform3DMakeScale(0.01, 1.0, 1)
        anim2.fromValue = NSValue(CATransform3D: fromTransform)
        anim2.toValue = NSValue(CATransform3D: toTransform)
        anim2.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        anim2.fillMode = kCAFillModeForwards
        anim2.removedOnCompletion = false
        self.activeBorder.layer.addAnimation(anim2, forKey: "_activeBorder")
        CATransaction.commit()
    }
    
    func performValidation(isValid:Bool,message:String){
        //dont need this
        
//        if !isValid {
//            self.hasError = true
//            self.errorMessage = message
//            self.labelTextColor = kDefaultErrorColor
//            self.activeBorder.backgroundColor = kDefaultErrorColor
//            self.setNeedsDisplay()
//        } else {
//            self.hasError = false
//            self.errorMessage = nil
//            self.labelTextColor = kDefaultActiveColor
//            self.activeBorder.backgroundColor = kDefaultActiveColor
//            self.setNeedsDisplay()
//        }
    }
    
    func validate(){
        
        if self.validationType != nil {
            var message : String = ""
            
            if self.validationType! == .Email || self.validationType! == .Search {
                
                var isValid = self.emailValidationBlock(text: self.text!, message: &message)
                
                performValidation(isValid,message: message)
                
            } else {
                var isValid = self.numberValidationBlock(text: self.text!, message: &message)
                
                performValidation(isValid,message: message)
            }
        }
    }
    
    
}

extension EGFloatingTextField {
    
}
