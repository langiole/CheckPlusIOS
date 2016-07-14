//
//  SignInViewController.swift
//  CheckPlusIOS
//
//  Created by Lee Angioletti on 7/13/16.
//  Copyright © 2016 Lee Angioletti. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    let settings = SettingVariables.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        // Uncomment to automatically sign in the user.
        //GIDSignIn.sharedInstance().signInSilently()
        print("hi")
        GIDSignIn.sharedInstance().signOut()
        
        // TODO(developer) Configure the sign-in button look/feel
        // ...
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError?) {
        print("here")
        if let error = error {
            print("error")
            //self.showMessagePrompt(error.localizedDescription)
            return
        }
        
        let authentication = user.authentication
        let credential = FIRGoogleAuthProvider.credentialWithIDToken(authentication.idToken,
                                                                     accessToken: authentication.accessToken)
        // ...
        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
            // ...
            if error != nil {
                print("1")
                print(error?.localizedDescription)
                return
            }
            else {
                print("user logged in")
                let tasks = self.createArray()
                self.settings.rootRef.child("users/" + (user?.uid)!).child("task").setValue(tasks)
            }
        }
    }
    
    func createArray() -> NSDictionary {
        var dict = [String: Bool]()
        for item in settings.todoList {
            dict[item.text] = item.completed
        }

        return dict as! NSDictionary
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
