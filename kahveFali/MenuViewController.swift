//
//  SecondViewController.swift
//  kahveFali
//
//  Created by Erim Şengezer on 25.09.2019.
//  Copyright © 2019 Erim Şengezer. All rights reserved.
//

import UIKit
import Parse
import SCLAlertView

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    //MARK: - Variables
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - IBActions
    
    
    
    //MARK: - Statements
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.tableFooterView = UIView()
        
    }

    //MARK: - Table Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.menuImage.image = UIImage(named: "privacy-policy")
            cell.menuText.text = "Gizlilik Politikası"
            return cell
            
        case 1:
            cell.menuImage.image = UIImage(named: "policy")
            cell.menuText.text = "Kullanım Şartları"
            return cell
            
        case 2:
            cell.menuImage.image = UIImage(named: "logout")
            cell.menuText.text = "Çıkış Yap"
            return cell
            
        default:
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let url = "https://scalculate.erimsengezer.com"
            openURL("https://scalculate.erimsengezer.com")
            
            UIApplication.shared.open(URL(string: url)!)
        case 1:
            let url = "https://scalculate.erimsengezer.com"
            openURL("https://scalculate.erimsengezer.com")
            UIApplication.shared.open(URL(string: url)!)
        case 2:
            if (PFUser.current() != nil){
                PFUser.logOutInBackground { (error) in
                    if error != nil {
                        SCLAlertView().showError("HATA ! ", subTitle: "Çıkış yapamadınız")
                    }else {
                        
                            
                            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "LoginStoryboardID") as! LoginViewController
                            
                            
                            self.present(vc, animated: true, completion: nil)
                            
                        
                    }
                }
            }
        default:
            return
        }
    }
    
    func openURL(_ url : String){
        
    }
    
    
}

