//
//  DoorTableViewCell.swift
//  Rubetek_practice
//
//  Created by Ilya Buzyrev on 22.09.2021.
//

import UIKit
import Kingfisher

class DoorTableViewCell: UITableViewCell {

    @IBOutlet weak var doorImageView: UIImageView!
    @IBOutlet weak var doorTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    public func setupDoorTableCell(door: Instance) {
        if let snapshot = door.snapshot {
            let url = URL(string: snapshot)
            doorImageView.kf.setImage(with: url)
        } else {
            doorImageView.isHidden = true
        }
        doorTitle.text = door.name
    }
    
}
