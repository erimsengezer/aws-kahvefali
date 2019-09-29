//
//  MenuTableViewCell.swift
//  kahveFali
//
//  Created by Erim Şengezer on 28.09.2019.
//  Copyright © 2019 Erim Şengezer. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var menuText: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
