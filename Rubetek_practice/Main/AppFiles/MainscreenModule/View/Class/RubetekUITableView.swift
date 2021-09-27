//
//  RubetekUITableView.swift
//  Rubetek_practice
//
//  Created by Ilya Buzyrev on 27.09.2021.
//

import UIKit

class RubetekUITableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    private var instList: [Instance]?
    private var askRefersh: (() -> Void)?
    private var cellTapped: ((Instance) -> Void)?
    
    
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
    
    
    public func setUpTable(isCameraShow: Bool, refreshAction: @escaping (() -> Void), cellTapped: @escaping ((Instance) -> Void)) {
        register(UINib(nibName: CellNames.cameraCell.rawValue, bundle: nil), forCellReuseIdentifier: "cameraCell")
        register(UINib(nibName: CellNames.doorCell.rawValue, bundle: nil), forCellReuseIdentifier: "doorCell")
        register(UINib(nibName: CellNames.smallDoorCell.rawValue, bundle: nil), forCellReuseIdentifier: "smallDoorCell")
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTable(sender:)), for: .valueChanged)
        askRefersh = refreshAction
        self.refreshControl = refreshControl
        self.isCameraShow = isCameraShow
        self.cellTapped = cellTapped
        delegate = self
        dataSource = self
    }

    
    public func setInstanceList(instList: [Instance]) {
        print(instList)
        self.instList = instList
        reloadData()
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


}
