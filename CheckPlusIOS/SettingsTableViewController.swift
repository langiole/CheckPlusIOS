//
//  SettingsTableViewController.swift
//  CheckPlusIOS
//
//  Created by Lee Angioletti on 7/13/16.
//  Copyright © 2016 Lee Angioletti. All rights reserved.
//

import UIKit

// global settings

class SettingsTableViewController: UITableViewController {
    
    // switches
    @IBOutlet weak var badgeSwitch: UISwitch!
    @IBOutlet weak var shakeSwitch: UISwitch!
    @IBOutlet weak var deleteSwitch: UISwitch!
    
    let settings = SettingVariables.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set title
        self.navigationController?.visibleViewController?.title = "Settings"
        
        // get stored data and set variables when view loads
        badgeSwitch.on = settings.userDefaults.boolForKey(KeyEnums.badgeSwitchState.rawValue)
        shakeSwitch.on = settings.userDefaults.boolForKey(KeyEnums.shakeSwitchState.rawValue)
        deleteSwitch.on = settings.userDefaults.boolForKey(KeyEnums.deleteSwitchState.rawValue)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    
    // exit the settings page
    @IBAction func exitSettingsButton(_ sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
        NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
        
        // save settings
        settings.userDefaults.setBool(badgeSwitch.on, forKey: KeyEnums.badgeSwitchState.rawValue)
        settings.userDefaults.setBool(shakeSwitch.on, forKey: KeyEnums.shakeSwitchState.rawValue)
        settings.userDefaults.setBool(deleteSwitch.on, forKey: KeyEnums.deleteSwitchState.rawValue)
        settings.userDefaults.setBool(settings.shakeToDismiss, forKey: KeyEnums.shakeToDismiss.rawValue)
        settings.userDefaults.setBool(settings.showBadge, forKey: KeyEnums.showBadge.rawValue)
        settings.userDefaults.setBool(settings.delOnSwipe, forKey: KeyEnums.delOnSwipe.rawValue)
        let rgb = CGColorGetComponents(settings.backgroundColor.CGColor)
        settings.userDefaults.setFloat(Float(rgb[0]), forKey: KeyEnums.backgroundColorR.rawValue)
        settings.userDefaults.setFloat(Float(rgb[1]), forKey: KeyEnums.backgroundColorG.rawValue)
        settings.userDefaults.setFloat(Float(rgb[2]), forKey: KeyEnums.backgroundColorB.rawValue)
        settings.userDefaults.synchronize()
    }
    
    // hide status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // TOGGLES: - Switches for the settings page
    
    // badgeSwitch
    @IBAction func badgeNumSlider(sender: AnyObject) {
        if badgeSwitch.on {
            settings.showBadge = true
            let settingsNotif = UIUserNotificationSettings(forTypes: .Badge, categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(settingsNotif)
        }
        else{
            settings.showBadge = false
        }
    }
    
    // shakeSwitch
    @IBAction func shakeToDismissAction(sender: AnyObject) {
        if shakeSwitch.on {
            settings.shakeToDismiss = true
        }
        else {
            settings.shakeToDismiss = false
        }
    }
    
    // deleteSwitch
    @IBAction func deleteOnSwipe(sender: AnyObject) {
        if deleteSwitch.on {
            settings.delOnSwipe = true
        }
        else {
            settings.delOnSwipe = false
        }
    }
    
    @IBAction func signInSlider(sender: AnyObject) {
        
    }
    
    
}