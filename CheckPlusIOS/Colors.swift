//
//  Colors.swift
//  CheckPlusIOS
//
//  Created by Lee Angioletti on 7/13/16.
//  Copyright © 2016 Lee Angioletti. All rights reserved.
//

import UIKit

class Colors: NSObject {
    
    var color: UIColor
    var name: String
    var selected: Bool
    
    init(name: String, red: CGFloat, green: CGFloat, blue: CGFloat, selected: Bool) {
        self.color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        self.name = name
        self.selected = selected
    }
}