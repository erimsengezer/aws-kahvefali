//
//  FirstViewController.swift
//  kahveFali
//
//  Created by Erim Şengezer on 25.09.2019.
//  Copyright © 2019 Erim Şengezer. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import FBSDKLoginKit
import SCLAlertView
import MBProgressHUD

class LoginViewController: UIViewController {

    //MARK: - Variables
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    
    
    //MARK: - IBActions
    
    @IBAction func emailButtonClicked(_ sender: Any) {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : RegisterViewController = storyboard.instantiateViewController(withIdentifier: "RegisterStoryboardID") as! RegisterViewController
        
        vc.isRegistering = false
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func registerButtonAction(_ sender: Any) {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : RegisterViewController = storyboard.instantiateViewController(withIdentifier: "RegisterStoryboardID") as! RegisterViewController
        
        vc.isRegistering = true
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func facebookButtonClicked(_ sender: Any) {
        
       let permissions = ["public_profile"]
        
        PFFacebookUtils.logInInBackground(withReadPermissions: permissions) { (user, error) in
            
            if error == nil {
                
                if let user = user {
                    
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                    UIApplication.shared.beginIgnoringInteractionEvents()
                    
                    if user.isNew{
                        
                        var incoming_facebook : NSDictionary?
                        
                        if (AccessToken.current) != nil {
                            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email"]).start(completionHandler: { (connection, result, error) in
                                
                                if error == nil {
                                    incoming_facebook = result as! NSDictionary?
                                    
                                    if let incoming_facebook = incoming_facebook{
                                        
                                        if (incoming_facebook.object(forKey: "email") != nil){
                                            user["email"] = incoming_facebook.object(forKey: "email")
                                        }
                                        
                                        if (incoming_facebook.object(forKey: "first_name") != nil){
                                            user["name"] = incoming_facebook.object(forKey: "first_name")
                                        }
                                        
                                        if (incoming_facebook.object(forKey: "last_name") != nil){
                                            user["surname"] = incoming_facebook.object(forKey: "last_name")
                                        }
                                        
                                        
                                    }
                                }
                                
                                // First credit
                                
                                user["credit"] = 10
                                
                                let acl = PFACL()
                                acl.hasPublicReadAccess = true
                                acl.hasPublicWriteAccess = true
                                
                                user.acl = acl
                                user.saveInBackground(block: { (success, eroor) in
                                    if error == nil {
                                        self.redirect()
                                    }else {
                                        SCLAlertView().showError("Hata", subTitle: "Başarısız")
                                    }
                                })
                                
                            })
                        }
                        
                    }else{
                        self.redirect()
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }
                    
                }
                
            }else {
                
                SCLAlertView().showError("HATA !", subTitle: error!.localizedDescription)
                
            }
            
        }
        
    }
    
    
    
    //MARK: - Statements
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        checkUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        changeRadius(button: facebookButton)
        changeRadius(button: emailButton)
        
    }

    //MARK: - Functions

    func changeRadius(button: UIButton){
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
    }
    
    func redirect() {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TabBarStoryboardID") as! UITabBarController
        
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func checkUser() {
        
        if PFUser.current() != nil {
            redirect()
        }
        
    }
    
}

