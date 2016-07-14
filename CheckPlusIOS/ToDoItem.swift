//
//  ToDoItem.swift
//  CheckPlusIOS
//
//  Created by Lee Angioletti on 7/13/16.
//  Copyright © 2016 Lee Angioletti. All rights reserved.
//

import UIKit

class ToDoItem: NSObject, NSCoding {
    
    var text: String
    var completed: Bool
    
    init(text: String, completed: Bool) {
        self.text = text
        self.completed = completed
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.text, forKey: "text")
        aCoder.encodeBool(self.completed, forKey: "completed")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.text = aDecoder.decodeObjectForKey("text") as! String
        self.completed = aDecoder.decodeBoolForKey("completed")
    }
}