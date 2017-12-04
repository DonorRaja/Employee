//
//  CustomerTableViewCell.swift
//  Task
//
//  Created by Guest User on 01/12/17.
//  Copyright © 2017 Guest User. All rights reserved.
//

import UIKit

class CustomerTableViewCell: UITableViewCell {
    
    //MARK: Outlets
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var age: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
