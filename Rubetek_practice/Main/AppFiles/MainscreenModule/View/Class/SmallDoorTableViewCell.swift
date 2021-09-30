//
//  SmallDoorTableViewCell.swift
//  Rubetek_practice
//
//  Created by Ilya Buzyrev on 22.09.2021.
//

import UIKit

class SmallDoorTableViewCell: RubetekUITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func setup(data: Any?) {
        guard let door = data as? Door else { return }
        titleLabel.text = door.name
    }
}
