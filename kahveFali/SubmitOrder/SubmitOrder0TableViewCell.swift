//
//  SubmitOrder0TableViewCell.swift
//  kahveFali
//
//  Created by Erim Şengezer on 28.09.2019.
//  Copyright © 2019 Erim Şengezer. All rights reserved.
//

import UIKit

class SubmitOrder0TableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var closeButton: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        closeButton.layer.cornerRadius = closeButton.layer.frame.width / 2
        closeButton.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
