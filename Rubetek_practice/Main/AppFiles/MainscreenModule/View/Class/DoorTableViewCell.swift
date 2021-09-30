//
//  DoorTableViewCell.swift
//  Rubetek_practice
//
//  Created by Ilya Buzyrev on 22.09.2021.
//

import UIKit
import Kingfisher

class DoorTableViewCell: RubetekUITableViewCell {

    @IBOutlet weak var doorImageView: UIImageView!
    @IBOutlet weak var doorTitle: UILabel!
    
    override func setup(data: Any?) {
        guard let door = data as? Door else { return }
        if let snapshot = door.snapshot {
            let url = URL(string: snapshot)
            doorImageView.kf.setImage(with: url)
        } else {
            doorImageView.isHidden = true
        }
        doorTitle.text = door.name
    }
}
