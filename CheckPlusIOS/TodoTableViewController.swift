//
//  TodoTableViewController.swift
//  CheckPlusIOS
//
//  Created by Lee Angioletti on 7/13/16.
//  Copyright © 2016 Lee Angioletti. All rights reserved.
//

import UIKit
import CloudKit
import Firebase

class TodoTableViewController: UITableViewController, TodoTableViewCellDelegate {
    
    // setting variables
    let settings = SettingVariables.sharedInstance
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //rootRef.createchi
        fetchUserRecordID()
        settings.rootRef = FIRDatabase.database().reference()

        
        // for realoading from another class
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadTableData:", name: "reload", object: nil)
        
        // set cells and background
        //self.tableView.rowHeight = UIScreen.mainScreen().bounds.height / 10
        self.tableView.backgroundColor = UIColor.blackColor()
        
        // title for viewcontroller
        self.navigationController?.visibleViewController?.title = "To-do"
        
        // get and set stored variables
        settings.shakeToDismiss = settings.userDefaults.boolForKey(KeyEnums.shakeToDismiss.rawValue)
        settings.delOnSwipe = settings.userDefaults.boolForKey(KeyEnums.delOnSwipe.rawValue)
        settings.showBadge = settings.userDefaults.boolForKey(KeyEnums.showBadge.rawValue)
        let r = settings.userDefaults.floatForKey(KeyEnums.backgroundColorR.rawValue)
        let g = settings.userDefaults.floatForKey(KeyEnums.backgroundColorG.rawValue)
        let b = settings.userDefaults.floatForKey(KeyEnums.backgroundColorB.rawValue)
        settings.backgroundColor = UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1.0)
        if settings.backgroundColor == nil {
            settings.backgroundColor = UIColor(red:0.20, green:0.60, blue:0.86, alpha: 1.0)
        }
        if r == 0 && b == 0 && g == 0 {
            settings.backgroundColor = UIColor(red:0.20, green:0.60, blue:0.86, alpha: 1.0)
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let tempArr = defaults.objectForKey("todoList") as? NSData {
            settings.todoList = NSKeyedUnarchiver.unarchiveObjectWithData(tempArr) as! [ToDoItem]
        }
        else {
            settings.todoList = []
            settings.todoList.append(ToDoItem(text: "Pull down to add a task", completed: false))
            settings.todoList.append(ToDoItem(text: "Swipe right to complete a task", completed: false))
            settings.todoList.append(ToDoItem(text: "Swipe left to delete a task", completed: false))
            settings.todoList.append(ToDoItem(text: "Check the settings to customize", completed: false))
        }
        
        settings.rootRef.child("users/Y7ejrxqvY4cbLNKK3MNPMF8Qu4G3/task").observeEventType(.Value, withBlock: {(snap: FIRDataSnapshot) in
            let dict = snap.value as! [String : Bool]
            self.settings.todoList = []
            for item in dict {
                print(item.0)
                self.settings.todoList.append(ToDoItem(text: item.0, completed: item.1))
            }
            self.tableView.reloadData()
        })
        print(settings.todoList[1].completed)
        
        if settings.todoList.count == 0 {
            addEmptyLabel()
        }
        
        // delegate
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(TodoTableViewCell.self, forCellReuseIdentifier: "cell")
        
        // make seperators go edge to edge
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.separatorColor = UIColor.blackColor()
        
    }
    
    func fetchUserRecordID() {
        let defaultContainer = CKContainer.defaultContainer()
        
        defaultContainer.fetchUserRecordIDWithCompletionHandler{ (recordID, error) -> Void in
            if let responseError = error {
                print(responseError)
                print("WHAT!!!")
            }
            else if let userRecordId = recordID {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.fetchUserRecord(userRecordId)
                })
            }
        }
        
    }
    
    func fetchUserRecord(recordID: CKRecordID) {
        // Fetch Default Container
        let defaultContainer = CKContainer.defaultContainer()
        
        // Fetch Private Database
        let privateDatabase = defaultContainer.privateCloudDatabase
        
        // Fetch User Record
        privateDatabase.fetchRecordWithID(recordID) { (record, error) -> Void in
            if let responseError = error {
                print(responseError)
                
            } else if let userRecord = record {
                print(userRecord)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // hide status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if settings.userDefaults.boolForKey("shakeToDismiss") == true {
            // create alert message
            let refreshAlert = UIAlertController(title: "Dismiss all completed tasks?", message: nil, preferredStyle: .Alert)
            
            // user clicks ok
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                for item in self.settings.todoList {
                    if item.completed {
                        self.deleteItem(item)
                    }
                }
            }))
            
            // user clicks cancel
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
                
            }))
            
            if event?.subtype == UIEventSubtype.MotionShake {
                presentViewController(refreshAlert, animated: true, completion: nil)
            }
        }
        
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settings.todoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TodoTableViewCell
        
        // Configure the cell...
        let centerY = self.tableView.rowHeight / 2.0
        let item = self.settings.todoList[indexPath.row]
        cell.textField.text = item.text
        cell.selectionStyle = .None
        cell.delegate = self
        cell.toDoItem = item
        cell.boxImageView.center.y = centerY
        cell.checkImageView.center.y = centerY
        cell.textField.center.y = centerY
        cell.textField.textColor = UIColor.whiteColor()
        
        // update badgeCount
        if !item.completed {
            cell.cellIsUncomplete()
        }
        else {
            cell.cellIsComplete()
        }
        
        // make seperators go edge to edge
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
    
    // delete task from list
    func deleteItem(_ item: ToDoItem) {
        let index = self.settings.todoList.indexOf(item)
        if  index == nil {
            return
        }
        self.settings.todoList.removeAtIndex(index!)
        let indexPath = NSIndexPath(forRow: index!, inSection: 0)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        if self.settings.todoList.count == 0 {
            addEmptyLabel()
        }
    }
    
    // complete task from list
    func completeItem(_ item: ToDoItem) {
        let index = self.settings.todoList.indexOf(item)
        if index == nil {
            return
        }
        self.settings.todoList[index!].completed = true
    }
    
    // uncomplete an item from the list
    func uncompleteItem(_ item: ToDoItem) {
        let index = self.settings.todoList.indexOf(item)
        if index == nil {
            return
        }
        self.settings.todoList[index!].completed = false
    }
    
    // add item to list and tableview
    func addItem() {
        let toDoItem = ToDoItem(text: "", completed: false)
        self.settings.todoList.insert(toDoItem, atIndex: 0)
        tableView.reloadData()
        if self.settings.todoList.count == 1 {
            self.tableView.viewWithTag(100)?.removeFromSuperview()
        }
        // enter edit mode
        var editCell: TodoTableViewCell
        let visibleCells = tableView.visibleCells as! [TodoTableViewCell]
        for cell in visibleCells {
            if (cell.toDoItem === toDoItem) {
                editCell = cell
                editCell.textField.becomeFirstResponder()
                break
            }
        }
    }
    
    let placeHolderCell = TodoTableViewCell()
    var pullDown = false
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        pullDown = scrollView.contentOffset.y <= 0.0
        if pullDown {
            placeHolderCell.backgroundColor = settings.backgroundColor
            placeHolderCell.textField.text = "Pull down to add"
            tableView.insertSubview(placeHolderCell, atIndex: 0)
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 && pullDown {
            placeHolderCell.frame = CGRect(x: 0, y: -tableView.rowHeight, width: tableView.frame.size.width, height: tableView.rowHeight)
            if scrollView.contentOffset.y < -tableView.rowHeight && pullDown {
                scrollView.scrollEnabled = false
            }
        }
        else {
            placeHolderCell.removeFromSuperview()
            pullDown = false
        }
        
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !scrollView.scrollEnabled {
            addItem()
            placeHolderCell.removeFromSuperview()
            scrollView.scrollEnabled = true
        }
        pullDown = false
    }
    
    // add empty label when there are no tasks
    func addEmptyLabel() {
        let screenHeight = UIScreen.mainScreen().bounds.height
        let screenWidth = UIScreen.mainScreen().bounds.width
        let emptyLabel = UILabel(frame: CGRect(x: 0, y: screenHeight * 0.25, width: screenWidth, height: screenHeight * 0.10))
        emptyLabel.adjustsFontSizeToFitWidth = true
        emptyLabel.textAlignment = .Center
        emptyLabel.textColor = UIColor.whiteColor()
        emptyLabel.text = "Looks like you've checked everything off!\nPull down to add a new task."
        emptyLabel.numberOfLines = 0
        emptyLabel.tag = 100
        tableView.addSubview(emptyLabel)
    }
    
    // move text box up
    // func cellDidBeginEditing(_ editingCell: TodoTableViewCell) {
    //     let editingOffset = tableView.contentOffset.y - editingCell.frame.origin.y as CGFloat
    //     let visibleCells = tableView.visibleCells as! [TodoTableViewCell]
    //     for cell in visibleCells {
    //       UIView.animate(withDuration: 0.3, animations: {() in
    //         cell.transform = CGAffineTransform(translationX: 0, y: editingOffset)
    //       if cell !== editingCell {
    //         cell.alpha = 0.3
    //   }
    //         })
    //     }
    //     scrolling = true
    //  }
    
    
    // reload list from another class
    func reloadTableData(notification: NSNotification) {
        tableView.reloadData()
    }
    
}