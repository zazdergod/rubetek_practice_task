//
//  CameraTableViewCell.swift
//  Rubetek_practice
//
//  Created by Ilya Buzyrev on 22.09.2021.
//

import UIKit
import Kingfisher

class CameraTableViewCell: RubetekUITableViewCell {

    @IBOutlet weak var cameraImage: UIImageView!
    @IBOutlet weak var cameraTitle: UILabel!
    @IBOutlet weak var favoriteImage: UIImageView!

    override func setup(data: Any?) {
        guard let camera = data as? Camera else { return }
        if !camera.favorites {
            favoriteImage.isHidden = true
        }
        cameraTitle.text = camera.name
        if let snapshot = camera.snapshot {
            let url = URL(string: snapshot)
            cameraImage.kf.setImage(with: url)
        }
    } 
}
