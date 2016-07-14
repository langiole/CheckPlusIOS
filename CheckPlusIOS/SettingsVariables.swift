//
//  SettingsVariables.swift
//  CheckPlusIOS
//
//  Created by Lee Angioletti on 7/13/16.
//  Copyright © 2016 Lee Angioletti. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SettingVariables {
    static let sharedInstance = SettingVariables()
    
    var delOnSwipe: Bool!
    var showBadge: Bool!
    var shakeToDismiss: Bool!
    var backgroundColor: UIColor!
    var todoList: [ToDoItem]!
    var arrPath: String!
    var rootRef: FIRDatabaseReference!
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    private init() { }
}