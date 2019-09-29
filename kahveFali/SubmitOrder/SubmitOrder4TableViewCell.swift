//
//  SubmitOrder4TableViewCell.swift
//  kahveFali
//
//  Created by Erim Şengezer on 28.09.2019.
//  Copyright © 2019 Erim Şengezer. All rights reserved.
//

import UIKit

class SubmitOrder4TableViewCell: UITableViewCell {

    
    //MARK: - IBOutlets
    @IBOutlet weak var sendButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        sendButton.layer.cornerRadius = 4
        sendButton.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
