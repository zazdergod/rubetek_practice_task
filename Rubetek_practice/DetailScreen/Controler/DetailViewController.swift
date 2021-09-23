//
//  DetailViewController.swift
//  Rubetek_practice
//
//  Created by Ilya Buzyrev on 22.09.2021.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    @IBOutlet weak var instanceTitle: UILabel!
    @IBOutlet weak var instanceImageView: UIImageView!
    @IBOutlet weak var recView: UIView!
    @IBOutlet weak var openDoorView: UIView!
    
    private var instance: Instance?
    private var isDoorView: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInstanceImageView()
        setupOpenView()
        setupTitle()
    }
    @IBAction func goBack(_ sender: Any) {
        self.popBack()
    }
    
    
}

extension DetailViewController {
    
    public func setupInstance(instance: Instance, isDoor: Bool) {
        self.instance = instance
        self.isDoorView = isDoor
    }
    
    private func setupInstanceImageView() {
        if let snapshot = instance?.snapshot, snapshot != "" {
            let url = URL(string: snapshot)
            instanceImageView.kf.setImage(with: url)
        }
        if let rec = instance?.rec, rec {
            recView.isHidden = false
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