//
//  RubetekUITableViewCell.swift
//  Rubetek_practice
//
//  Created by Ilya Buzyrev on 30.09.2021.
//

import UIKit

class RubetekUITableViewCell: UITableViewCell {
    
    var item: RubetekUITableView.CellData?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        initSetup()
    }
    
    func initSetup() {}
    
    func setup(data: Any?) {}
    
    func getCellData() -> Any? { return item?.data }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
