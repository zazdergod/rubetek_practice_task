//
//  ElementsExtensions.swift
//  Rubetek_practice
//
//  Created by Ilya Buzyrev on 23.09.2021.
//

import Foundation
import UIKit

extension UIViewController {
    
    func popBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func popToRoot() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
