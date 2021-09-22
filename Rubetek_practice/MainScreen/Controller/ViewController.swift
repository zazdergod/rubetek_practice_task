//
//  ViewController.swift
//  Rubetek_practice
//
//  Created by Ilya Buzyrev on 21.09.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var instansesTableView: UITableView!
    
    private let networkManager = NetworkService()
    private let cacher = Cacher()
    private var cameras: Array<Instance> = []
    private var doors: Array<Instance> = []
    private var isShowingCameras: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        setupTableView()
        getCameras()
    }
   
  
    @IBAction func chooseCameras(_ sender: Any) {
        isShowingCameras = true
        self.getCameras()
    }
    
    @IBAction func chooseDoors(_ sender: Any) {
        isShowingCameras = false
        self.getDoors()
    }
}

private extension ViewController {
    
    private func setupHeader() {
        headerView.layer.shadowOpacity = 0.6
        headerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        headerView.layer.shadowRadius = 2
    }
    
    private func setupTableView() {
        instansesTableView.dataSource = self
        instansesTableView.delegate = self
        instansesTableView.register(UINib(nibName: "CameraTableViewCell", bundle: nil), forCellReuseIdentifier: "cameraCell")
        instansesTableView.register(UINib(nibName: "DoorTableViewCell", bundle: nil), forCellReuseIdentifier: "doorCell")
        instansesTableView.register(UINib(nibName: "SmallDoorTableViewCell", bundle: nil), forCellReuseIdentifier: "smallDoorCell")
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTable(sender:)), for: .valueChanged)
        instansesTableView.refreshControl = refreshControl
    }
    
    @objc func refreshTable(sender: UIRefreshControl) {
        if isShowingCameras {
            updateCameras {
                sender.endRefreshing()
            }
        } else {
            updateDoors {
                sender.endRefreshing()
            }
        }
    }
    
    
    private func getCameras() {
        let cameras = cacher.read(isCamera: true)
        if cameras.count != 0 {
            self.cameras = cameras
        } else {
            updateCameras {
                
            }
        }
    }
    
    private func updateCameras(completion: @escaping () -> Void) {
        networkManager.requestCameras {[weak self] cameras, rooms, error in
            if let error = error {
                print(error)
            } else if let cameras = cameras {
                self?.cameras = cameras
         
                DispatchQueue.main.async {
          
                    self?.instansesTableView.reloadData()
                    self?.cacher.addList(list: cameras, isCamera: true)
                }
            }
        }
    }
    
    private func getDoors() {
        let doors = cacher.read(isCamera: false)
        if doors.count != 0 {
            self.doors = doors
        } else {
            updateDoors {
                
            }
        }
    }
    
    private func updateDoors(completion: @escaping () -> Void) {
        networkManager.requestDoors {[weak self] doors, error in
            if let error = error {
                print(error)
            } else if let doors = doors {
         
                self?.doors = doors
                DispatchQueue.main.async {
                
                    self?.instansesTableView.reloadData()
                    self?.cacher.addList(list: doors, isCamera: false)
                }
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isShowingCameras ? cameras.count : doors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isShowingCameras {
            let cell = instansesTableView.dequeueReusableCell(withIdentifier: "cameraCell") as! CameraTableViewCell
            cell.setupCameraTableCell(camera: cameras[indexPath.row])
            return cell
        } else {
            let door = doors[indexPath.row]
            if let snapshot = door.snapshot, snapshot != "" {
                let cell = instansesTableView.dequeueReusableCell(withIdentifier: "doorCell") as! DoorTableViewCell
                cell.setupDoorTableCell(door: doors[indexPath.row])
                return cell
            } else {
                let cell = instansesTableView.dequeueReusableCell(withIdentifier: "smallDoorCell") as! SmallDoorTableViewCell
                cell.setupDoorTableCell(door: doors[indexPath.row])
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isShowingCameras {
            return 300
        } else {
            let door = doors[indexPath.row]
            if let snapshot = door.snapshot, snapshot != "" {
                return 300
            } else {
                return 100
            }
        }
    }
    
}


