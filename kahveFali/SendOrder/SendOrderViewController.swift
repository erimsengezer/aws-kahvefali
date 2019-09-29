//
//  SendOrderViewController.swift
//  kahveFali
//
//  Created by Erim Şengezer on 28.09.2019.
//  Copyright © 2019 Erim Şengezer. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class SendOrderViewController: UIViewController {

    //MARK: - Variables
    
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var creditText: UIButton!
    
    
    //MARK: - IBActions
    @IBAction func goSubmitOrderAction(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "SubmitOrderStoryboardID") as! SubmitOrderTableViewController
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func creditAdd(_ sender: Any) {
        
        if let user = PFUser.current(){
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            user.incrementKey("credit", byAmount: 10)
            
            user.saveInBackground { (success, error) in
                MBProgressHUD.hide(for: self.view, animated: true)
                if error == nil {
                    
                    self.getUserData()
                    
                }
            }
        }
        
    }
    
    
    
    //MARK: - Statements
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getUserData()
    }

    
    //MARK: - Functions
    
    func getUserData() {
        
        if let user = PFUser.current(){
            user.fetchInBackground { (fetchedUser, error) in
                if error == nil{
                    
                    if let fetchedUser = fetchedUser{
                        if let credits = fetchedUser["credit"] as? Int{
                            self.creditText.setTitle("\(String(credits)) Kredi", for: .normal)
                        }
                    }
                    
                    
                }
            }
        }
        
    }
}
