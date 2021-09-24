//
//  SmallDoorTableViewCell.swift
//  Rubetek_practice
//
//  Created by Ilya Buzyrev on 22.09.2021.
//

import UIKit

class SmallDoorTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

     
    }
    
    public func setupDoorTableCell(door: Instance) {
        titleLabel.text = door.name
    }
    
}
