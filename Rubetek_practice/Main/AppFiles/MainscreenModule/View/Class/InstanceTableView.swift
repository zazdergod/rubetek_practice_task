//
//  RubetekUITableView.swift
//  Rubetek_practice
//
//  Created by Ilya Buzyrev on 27.09.2021.
//

import UIKit
import RealmSwift

class InstanceTableView: RubetekUITableView {
    
    enum CellHeight: CGFloat {
        case small = 100
        case big = 300
    }
    
    enum CellNames: String {
        case cameraCell = "CameraTableViewCell"
        case doorCell = "DoorTableViewCell"
        case smallDoorCell = "SmallDoorTableViewCell"
    }
    
    private var refreshAction: (() -> Void)?
    private var cellTapped: ((WorkInstance) -> Void)?
    private var showMessage: ((UIAlertController) -> Void)?
    private var isCameraShow: Bool = true
    
    public func setUpHandlers(isCameraShow: Bool, refreshAction: @escaping (() -> Void), cellTapped: @escaping ((WorkInstance) -> Void), showMessage: @escaping (UIAlertController) -> Void) {
        self.isCameraShow = isCameraShow
        self.cellTapped = cellTapped
        self.showMessage = showMessage
        self.refreshAction = refreshAction
    }

    
    public func changeShowing(isCameraShow: Bool) {
        self.isCameraShow = isCameraShow
    }
    
    
    @objc func refreshTable(sender: Any) {
        refreshAction?()
    }
    
    
    override func setup() {
        register(UINib(nibName: CellNames.cameraCell.rawValue, bundle: nil), forCellReuseIdentifier: CellNames.cameraCell.rawValue)
        register(UINib(nibName: CellNames.doorCell.rawValue, bundle: nil), forCellReuseIdentifier: CellNames.doorCell.rawValue)
        register(UINib(nibName: CellNames.smallDoorCell.rawValue, bundle: nil), forCellReuseIdentifier: CellNames.smallDoorCell.rawValue)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTable(sender:)), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    
    override func setupItems(items: [Any]) {
        var itemsList = [RubetekUITableView.CellData]()
        for item in items {
            var height: CGFloat
            var id: String
            if let instance = item as? Door {
                if instance.snapshot == nil {
                    height = CellHeight.small.rawValue
                    id = CellNames.smallDoorCell.rawValue
                } else {
                    height = CellHeight.big.rawValue
                    id = CellNames.doorCell.rawValue
                }
            } else {
                height = CellHeight.big.rawValue
                id = CellNames.cameraCell.rawValue
            }
            let cellTapped = { [weak self] in
                
                if let instance = item as? WorkInstance {
                    self?.cellTapped?(instance)
                }
            }
            itemsList.append(RubetekUITableView.CellData(id: id,
                                                             data: item,
                                                             cellTapped: cellTapped,
                                                             height: height))
        }
        self.items = itemsList
        reloadData()
        refreshControl?.endRefreshing()
    }
    
    
    override func setupTrailingContext(indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favorite = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, _ in
            let instance = self?.items[indexPath.row].data as? WorkInstance
            instance?.toggleFavorite()
        }
        favorite.image = UIImage(systemName: "star.fill")
        let changeName = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, _ in
            let alert = UIAlertController(title: nil, message: "Сменить имя", preferredStyle: .alert)
            alert.addTextField { textfield in
                textfield.text = ""
            }
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] _ in
                guard let textfield = alert?.textFields?[0] else { return }
                let instance = self?.items[indexPath.row].data as? WorkInstance
                guard let text = textfield.text else { return }
                instance?.changeTheName(newName: text)
            }))
            self?.showMessage?(alert)
        }
        changeName.image = UIImage(systemName: "pencil")
        return UISwipeActionsConfiguration(actions: [favorite, changeName])
    }
    
}
