//
//  SubmitOrderTableViewController.swift
//  kahveFali
//
//  Created by Erim Şengezer on 28.09.2019.
//  Copyright © 2019 Erim Şengezer. All rights reserved.
//

import UIKit
import Parse
import ALCameraViewController
import ActionSheetPicker_3_0
import SCLAlertView

var playerId = ""

class SubmitOrderTableViewController: UITableViewController {
    
    // MARK: - Variables
    var selectedOrder : Order?
    
    
    // MARK: - IBActions
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func nameChangedAction(_ sender: UITextField) {
        
            if sender.text != ""{
                selectedOrder?.name = sender.text
            }
        
    }
    
    @IBAction func subjectChangedAction(_ sender: Any) {
        
        ActionSheetMultipleStringPicker.show(withTitle: "Konu Seç", rows: [
            ["Aşk", "İş", "Sağlık"]
            ], initialSelection: [selectedOrder?.subject! ?? 0], doneBlock: {
                picker, indexes, values in
            
                if let index = indexes?[0] as? Int {
                    self.selectedOrder?.subject = index
                    
                    
                    
                    if let cell = self.tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? SubmitOrder3TableViewCell{
                        if let name = values as? Array<String>{
                            cell.subjectButton.setTitle(name.first, for: .normal)
                        }
                    }
                }
                
                
            return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)

        
    }
    
    
    
    
    @IBAction func uploadImageAction(_ sender: UIButton) {
        
        let croppingParameters : CroppingParameters = CroppingParameters(
            isEnabled: true,
            allowResizing: true,
            allowMoving: true,
            minimumSize: CGSize(width: 200, height: 200))
        
        
        let croppingEnabled = true
        
        /// Provides an image picker wrapped inside a UINavigationController instance
        let imagePickerViewController = CameraViewController.imagePickerViewController(croppingParameters: croppingParameters) { [weak self] image, asset in
            
            if let image = image{
                if sender.tag == 0{
                    if let cell = self?.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? SubmitOrder1TableViewCell{
                        cell.image1Button.setBackgroundImage(image, for: .normal)
                    }
                    
                    if let imageData = image.jpegData(compressionQuality: 0.8){
                    
                    let imageObject = PFObject(className: "Images")
                    imageObject["image"] = PFFileObject(name: "image1.png", data: imageData)
                    
                        imageObject.saveInBackground(block: { (success, error) in
                            if error == nil {
                                self?.selectedOrder?.image1 = imageObject.objectId
                            }
                        })
                    
                    }
                    
                }else if sender.tag == 1{
                    if let cell = self?.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? SubmitOrder1TableViewCell{
                        cell.image2Button.setBackgroundImage(image, for: .normal)
                    }
                    
                    if let imageData = image.jpegData(compressionQuality: 0.8){
                        
                        let imageObject = PFObject(className: "Images")
                        imageObject["image"] = PFFileObject(name: "image2.png", data: imageData)
                        
                        imageObject.saveInBackground(block: { (success, error) in
                            if error == nil {
                                self?.selectedOrder?.image1 = imageObject.objectId
                            }
                        })
                        
                    }
                }
            }
            
            
            self?.dismiss(animated: true, completion: nil)
        }
        
        present(imagePickerViewController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func submitOrderAction(_ sender: Any) {
        
        dismisKeyboard()
        
        if let user = PFUser.current(){
            user.fetchInBackground { (fetchedUser, error) in
                if error == nil {
                    if let fetchedUser = fetchedUser{
                        let credits = fetchedUser["credit"] as! Int
                        
                        if credits < 10{
                            SCLAlertView().showError("Krediniz Yok", subTitle: "Yeterli krediniz yok. Lütfen kredi alınız.")
                        }else {
                            self.submitOrder()
                        }
                    }
                }
            }
        }
    }
    
    
    //MARK: - Statements
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
        
        selectedOrder = Order()
        selectedOrder?.userId = PFUser.current()?.objectId
        selectedOrder?.subject = 0
        selectedOrder?.status = 0
        selectedOrder?.text = "asd"
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismisKeyboard))
        view.addGestureRecognizer(tap)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitOrder0Cell", for: indexPath) as! SubmitOrder0TableViewCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitOrder1Cell", for: indexPath) as! SubmitOrder1TableViewCell
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitOrder2Cell", for: indexPath) as! SubmitOrder2TableViewCell
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitOrder3Cell", for: indexPath) as! SubmitOrder3TableViewCell
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitOrder4Cell", for: indexPath) as! SubmitOrder4TableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitOrder4Cell", for: indexPath) as! SubmitOrder4TableViewCell
            return cell
        }
        
        
        
    }
    
    //MARK: - Functions
    
    func submitOrder() {
        if let selectedOrder = selectedOrder{
            let params = [
                "userId" : selectedOrder.userId!,
                "subject" : selectedOrder.subject!,
                "status" : selectedOrder.status!,
                "image1" : selectedOrder.image1 ?? "",
                "image2" : selectedOrder.image2 ?? "",
                "name" : selectedOrder.name,
                "playerId" : playerId
                
                ] as [String : Any]
            
            PFCloud.callFunction(inBackground: "submitOrderCloud", withParameters: params) { (success, error) in
                if error == nil {
                    
                    SCLAlertView().showSuccess("Başarılı !", subTitle: "Falınız başarıyla gönderildi.")
                    
                }
            }
            
        }
    }
    
    @objc func dismisKeyboard() {
        view.endEditing(true)
    }


   

}
