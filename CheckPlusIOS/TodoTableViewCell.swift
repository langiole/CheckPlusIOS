//
//  TodoTableViewCell.swift
//  CheckPlusIOS
//
//  Created by Lee Angioletti on 7/13/16.
//  Copyright © 2016 Lee Angioletti. All rights reserved.
//

import UIKit

protocol TodoTableViewCellDelegate {
    func deleteItem(_ toDoItem: ToDoItem)
    func completeItem(_ toDoItem: ToDoItem)
    func uncompleteItem(_ toDoItem: ToDoItem)
    //func cellTextWasChanged(_ cell: TodoTableViewCell)
    // func cellDidBeginEditing(_ editingCell: TodoTableViewCell)
    //func cellDidEndEditing(_ editingCell: TodoTableViewCell)
}

class TodoTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    var delegate: TodoTableViewCellDelegate!
    var toDoItem: ToDoItem!
    
    let settings = SettingVariables.sharedInstance
    
    var boxImageView: UIImageView!
    var checkImageView: UIImageView!
    var textField: UITextField!
    var centerY: CGFloat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // gesture recognizer
        let recognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        recognizer.delegate = self
        addGestureRecognizer(recognizer)
        
        // set background color
        setBackground()
        
        // create images
        setupImages()
        
        // create textfield
        setupTextField()
        
        // set indentation
        self.indentationLevel = Int(boxImageView.bounds.size.width)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // set background to default colors
    func setBackground() {
        self.backgroundColor = settings.backgroundColor
    }
    
    // setup box and check views
    func setupImages() {
        // create box image
        let boxImage = UIImage(named: "box")
        let centerY = bounds.size.height / 2
        
        boxImageView = UIImageView(frame: CGRect(x: 0.05 * bounds.size.width, y: 0, width: bounds.size.height / 2.0, height: bounds.size.height / 2.0))
        print(self.contentView.bounds.height)
        boxImageView.image = boxImage!.tintWithColor(UIColor.whiteColor())
        
        
        // create check image
        let checkImage = UIImage(named: "checkmark11")
        checkImageView = UIImageView(frame: CGRect(x: boxImageView.frame.origin.x, y: boxImageView.frame.origin.y, width: boxImageView.frame.width, height: boxImageView.frame.height))
        checkImageView.image = checkImage!.tintWithColor(UIColor.whiteColor())
        checkImageView.hidden = true
        
        // add the views
        addSubview(boxImageView)
        addSubview(checkImageView)
    }
    
    // setup textfield
    func setupTextField() {
        textField = UITextField(frame: CGRect(x: (boxImageView.frame.origin.x * 2) + boxImageView.frame.width, y: 0, width: bounds.size.width - boxImageView.frame.origin.x, height: bounds.size.height + (bounds.size.height / 2)))
        textField.center.y = bounds.size.height / 2.0
        textField.font =  UIFont(name: textField.font!.fontName, size: 20)
        textField.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha:1.0)
        textField.delegate = self
        addSubview(textField)
    }
    
    // close the keyboard on Enter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        toDoItem.text = textField.text!
        return false
    }
    
    func fadeToColor(_ oldColor: UIColor, newColor: UIColor, progress: CGFloat) -> UIColor {
        
        let oldRBG = CGColorGetComponents(oldColor.CGColor)
        let oldR = round(oldRBG[0] * 100) / 100
        let oldG = round(oldRBG[1] * 100) / 100
        let oldB = round(oldRBG[2] * 100) / 100
        
        let newRBG = CGColorGetComponents(newColor.CGColor)
        let newR = newRBG[0]
        let newG = newRBG[1]
        let newB = newRBG[2]
        
        let red =  (((newR - oldR) * progress) + oldR)
        let green =  (((newG - oldG) * progress) + oldG)
        let blue =  (((newB - oldB) * progress) + oldB)
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    
    func handlePan(_ recognizer: UIPanGestureRecognizer) {
        
        let rightSwipe = recognizer.velocityInView(self).x > 0
        let progress = abs(round((recognizer.translationInView(self).x / (self.frame.width / 2)) * 100) / 100)
        self.frame.origin.x = recognizer.translationInView(self).x
        let completeSwipe = abs(self.frame.origin.x) > self.frame.width / 2
        
        switch recognizer.state {
        case .Changed:
            if rightSwipe && !toDoItem.completed {
                self.backgroundColor = fadeToColor(self.backgroundColor!, newColor: UIColor(red: 0.01, green: 0.47, blue: 0.21, alpha: 1.0), progress: progress)
            }
            else if rightSwipe && toDoItem.completed {
                self.backgroundColor = fadeToColor(UIColor(red: 0.01, green: 0.47, blue: 0.21, alpha: 1.0), newColor: settings.backgroundColor, progress: progress)
            }
            else {
                self.backgroundColor = fadeToColor(self.backgroundColor!, newColor: UIColor(red:0.75, green:0.22, blue:0.17, alpha:1.0), progress: progress)
            }
            
            // item is completed
            if rightSwipe && completeSwipe {
                // complete swipe and item is already checked off: uncheck it
                if toDoItem.completed {
                    self.delegate.uncompleteItem(self.toDoItem)
                    recognizer.enabled = false
                    cellIsUncomplete()
                    snapCellBack()
                }
                    // item has not yet been completed: check it off
                else {
                    // delete item when completed
                    if settings.delOnSwipe != nil && settings.delOnSwipe {
                        recognizer.enabled = false
                        animateCheck()
                        swipeAndDeleteCell(false)
                    }
                        // standard item complete
                    else {
                        self.delegate.completeItem(self.toDoItem)
                        recognizer.enabled = false
                        animateCheck()
                        snapCellBack()
                    }
                }
            }
                // item is deleted
            else if !rightSwipe && completeSwipe {
                recognizer.enabled = false
                swipeAndDeleteCell(true)
                recognizer.enabled = true
            }
        case .Ended:
            if toDoItem.completed {
                self.backgroundColor = UIColor(red: 0.01, green: 0.47, blue: 0.21, alpha: 1.0)
            }
            else {
                self.backgroundColor = settings.backgroundColor
            }
            snapCellBack()
            
        default:
            recognizer.enabled = true
            
        }
        
    }
    
    func animateCheck() {
        var imgArry = [UIImage]()
        
        for num in 1...11 {
            let name = "checkmark" + String(num)
            imgArry.append(UIImage(named: name)!.tintWithColor(UIColor.whiteColor()))
            
        }
        checkImageView.animationImages = imgArry
        checkImageView.animationDuration = 0.4
        checkImageView.animationRepeatCount = 1
        checkImageView.image = checkImageView.animationImages?.last
        checkImageView.tintColor = UIColor.whiteColor()
        checkImageView.hidden = false
        checkImageView.startAnimating()
    }
    
    var animationOptions : UIViewAnimationOptions = [.AllowUserInteraction, .BeginFromCurrentState]
    var animationDuration : NSTimeInterval = 0.5
    var animationDelay : NSTimeInterval = 0
    var animationSpingDamping : CGFloat = 0.5
    var animationInitialVelocity : CGFloat = 1
    
    func snapCellBack() {
        UIView.animateWithDuration(self.animationDuration, delay: self.animationDelay, usingSpringWithDamping: self.animationSpingDamping, initialSpringVelocity: self.animationInitialVelocity, options: self.animationOptions, animations: { () -> Void in
            self.frame.origin.x = 0
            }, completion: nil)
    }
    
    func swipeAndDeleteCell(left: Bool) {
        var endFrame: CGRect!
        if left {
            endFrame = CGRect(x: -bounds.size.width, y: frame.origin.y, width: bounds.size.width, height: bounds.size.height)
        }
        else {
            endFrame = CGRect(x: bounds.size.width, y: frame.origin.y, width: bounds.size.width, height: bounds.size.height)
        }
        UIView.animateWithDuration(0.4, animations: {self.frame = endFrame}, completion: {finished in
            self.hidden = true
            self.delegate.deleteItem(self.toDoItem)
        })
    }
    
    func cellIsComplete() {
        if checkImageView != nil {
            checkImageView.hidden = false
        }
        self.backgroundColor = UIColor(red: 0.01, green: 0.47, blue: 0.21, alpha: 1.0)
    }
    
    func cellIsUncomplete() {
        if checkImageView != nil {
            checkImageView.hidden = true
        }
        self.backgroundColor = settings.backgroundColor
    }
    
    // decides when a gesture should be recognized
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translationInView(superview)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
        }
        return false
    }
    
}