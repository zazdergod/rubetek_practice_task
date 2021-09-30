//
//  DetailViewController.swift
//  Rubetek_practice
//
//  Created by Ilya Buzyrev on 22.09.2021.
//

import UIKit
import Kingfisher

class DetailViewController: RubetecViewController {
    
    @IBOutlet weak var instanceTitle: UILabel!
    @IBOutlet weak var instanceImageView: UIImageView!
    @IBOutlet weak var recView: UIView!
    @IBOutlet weak var openDoorView: UIView!
    @IBOutlet weak var zoomButton: UIButton!
    
    private var instance: WorkInstance?
    private var isDoorView: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInstanceImageView()
        setupOpenView()
        setupTitle()
    }
    
    @IBAction func zoomCamera(_ sender: Any) {
        print("zoom")
    }
    
}

extension DetailViewController {
    
    public func setupInstance(instance: WorkInstance, isDoor: Bool) {
        self.instance = instance
        self.isDoorView = isDoor
    }
    
    private func setupInstanceImageView() {
        if let snapshot = instance?.snapshot, snapshot != "" {
            let url = URL(string: snapshot)
            instanceImageView.kf.setImage(with: url)
        }
        
        if let isDoorView = isDoorView, isDoorView {
            zoomButton.isHidden = true
        }
    }
    
    private func setupTitle() {
        if let name = instance?.name {
            instanceTitle.text = name
        }
    }
    
    private func setupOpenView() {
        if let isDoorView = isDoorView, isDoorView {
            openDoorView.isHidden = false
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openDoor(sender:)))
            openDoorView.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    @objc func openDoor(sender: Any) {
        print("Open")
    }
}
