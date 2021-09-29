//
//  RubetekUITableView.swift
//  Rubetek_practice
//
//  Created by Ilya Buzyrev on 27.09.2021.
//

import UIKit
import RealmSwift

class RubetekUITableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    private var instList: [Instance]?
    private var askRefersh: (() -> Void)?
    private var cellTapped: ((Instance) -> Void)?
    private var showMessage: ((UIAlertController) -> Void)?
    private var notificationToken: NotificationToken?
    
    
    enum CellHeight: CGFloat {
        case small = 100
        case big = 300
    }
    
    private var isCameraShow: Bool = true
    
    enum CellNames: String {
        case cameraCell = "CameraTableViewCell"
        case doorCell = "DoorTableViewCell"
        case smallDoorCell = "SmallDoorTableViewCell"
    }
    
    
    public func setUpTable(isCameraShow: Bool, instList: [Instance], refreshAction: @escaping (() -> Void), cellTapped: @escaping ((Instance) -> Void), showMessage: @escaping (UIAlertController) -> Void) {
        register(UINib(nibName: CellNames.cameraCell.rawValue, bundle: nil), forCellReuseIdentifier: "cameraCell")
        register(UINib(nibName: CellNames.doorCell.rawValue, bundle: nil), forCellReuseIdentifier: "doorCell")
        register(UINib(nibName: CellNames.smallDoorCell.rawValue, bundle: nil), forCellReuseIdentifier: "smallDoorCell")
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTable(sender:)), for: .valueChanged)
        askRefersh = refreshAction
        self.refreshControl = refreshControl
        self.isCameraShow = isCameraShow
        self.cellTapped = cellTapped
        self.instList = instList
        self.showMessage = showMessage
        delegate = self
        dataSource = self
    }

    
    public func setInstanceList(instList: [Instance]) {
        self.instList = instList
        self.reloadData()
        self.refreshControl?.endRefreshing()
        let realm = try! Realm()
        guard let instance = instList.first else { return }
        let instances = realm.objects(type(of: instance).self)
        notificationToken = instances.observe { [weak self] (changes: RealmCollectionChange) in
            guard let self = self else { return }
            switch changes {
            case .initial(_):
                self.reloadData()
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                self.performBatchUpdates {
                    self.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                                             with: .automatic)
                } completion: { _ in
                    
                }

            case .error(let error):
                print(error)
            }
        }
    }
    
    public func changeShowing(isCameraShow: Bool) {
        self.isCameraShow = isCameraShow
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let instance = instList?[indexPath.row] as? Camera {
            let cell = dequeueReusableCell(withIdentifier: "cameraCell") as! CameraTableViewCell
            cell.setupCameraTableCell(camera: instance)
            return cell
        }
        if let instance = instList?[indexPath.row] as? Door {
            if let snapshot = instance.snapshot, snapshot != "" {
                let cell = dequeueReusableCell(withIdentifier: "doorCell") as! DoorTableViewCell
                cell.setupDoorTableCell(door: instance)
                return cell
            } else {
                let cell = dequeueReusableCell(withIdentifier: "smallDoorCell") as! SmallDoorTableViewCell
                cell.setupDoorTableCell(door: instance)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let instance = instList?[indexPath.row] as? Door, instance.snapshot == nil {
            return CellHeight.small.rawValue
        }
        return CellHeight.big.rawValue
    }
    

    @objc func refreshTable(sender: Any) {
        askRefersh?()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let instance = instList?[indexPath.row], let cellTapped = cellTapped {
            cellTapped(instance)
        }
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favorite = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, _ in
            let instance = self?.instList?[indexPath.row]
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
                let instance = self?.instList?[indexPath.row]
                guard let text = textfield.text else { return }
                instance?.changeTheName(newName: text)
            }))
            self?.showMessage?(alert)
        }
        changeName.image = UIImage(systemName: "pencil")
        return UISwipeActionsConfiguration(actions: [favorite, changeName])
    }

}
