//
//  RegisterViewController.swift
//  kahveFali
//
//  Created by Erim Şengezer on 27.09.2019.
//  Copyright © 2019 Erim Şengezer. All rights reserved.
//

import UIKit
import MBProgressHUD
import SCLAlertView
import Parse

class RegisterViewController: UIViewController {
    
    
    //MARK: - Variables

    var isRegistering = true
    
    //MARK: - IBOutlets
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginButtton: UIButton!
    @IBOutlet weak var topLabel: UILabel!
    
    
    //MARK: - IBActions
    @IBAction func closeButtonClicked(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func loginRegisterActions(_ sender: Any) {
        
        if isRegistering{
            register()
        }else{
            login()
        }
        
    }
    
    //MARK: - Statements
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        checkUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeButtonRounded(button: closeButton)
        changeTexts()
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
    }
    
    //MARK: - Functions

    func makeButtonRounded(button: UIButton){
        
        button.layer.cornerRadius = button.layer.frame.width / 2
        button.layer.masksToBounds = true
        
    }
    
    func changeTexts() {
        
        if (isRegistering) {
            topLabel.text = "Email ile Kayıt Ol"
            loginButtton.setTitle("Kayıt Ol", for: .normal)
        }
        
    }
    
    
    
    func register() {
        dismissKeyboard()
        if (emailText.text == "" || passwordText.text == ""){
            SCLAlertView().showError("Hata !", subTitle: "Şifreniz veya email adresiniz boş olamaz")
        }else {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            UIApplication.shared.endIgnoringInteractionEvents()
            
            
            
            
            if let email = emailText.text, let password = passwordText.text {
                let user = PFUser()
                
                
                user.username = email.lowercased()
                user.email = email.lowercased()
                user.password = password
                user["credit"] = 10
                
                let acl = PFACL()
                
                acl.hasPublicWriteAccess = true
                acl.hasPublicReadAccess = true
                
                user.acl = acl
                user.signUpInBackground { (success, error) in
                    if error != nil {
                        SCLAlertView().showError("Hata", subTitle: "Hata oldu. Lütfen tekrar deneyin.")
                    }else{
                        self.redirect()
                    }
                }
            }
            
            
            
            
        }
        
        
    }
    
    func login() {
        dismissKeyboard()
        
        if (emailText.text == "" || passwordText.text == ""){
            SCLAlertView().showError("Hata !", subTitle: "Şifreniz veya email adresiniz boş olamaz")
        }else{
           
            MBProgressHUD.showAdded(to: self.view, animated: true)
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            // Login
            
            if let email = emailText.text, let password = passwordText.text {
                PFUser.logInWithUsername(inBackground: email.lowercased(), password: password) { (user, error) in
                    
                    //Loading Stop
                    MBProgressHUD.hide(for: self.view, animated: true)
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error == nil {
                        self.redirect()
                    }else {
                        SCLAlertView().showError("HATA ! ", subTitle: "Hata oluştu lütfen tekrar deneyiniz.")
                    }
                }
            }


            
            
            
        }
        
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
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
