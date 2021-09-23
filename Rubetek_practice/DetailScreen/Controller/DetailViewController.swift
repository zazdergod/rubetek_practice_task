//
//  DetailViewController.swift
//  Rubetek_practice
//
//  Created by Ilya Buzyrev on 22.09.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    private var instance: Instance?

    override func viewDidLoad() {
        super.viewDidLoad()
        print(instance)
    }
    

    public func setupInstance(instance: Instance) {
        self.instance = instance
    }
    
}
