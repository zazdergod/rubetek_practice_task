//
//  ViewController.swift
//  Rubetek_practice
//
//  Created by Ilya Buzyrev on 21.09.2021.
//

import UIKit

class ViewController: RubetecViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var instansesTableView: RubetekUITableView!
    @IBOutlet weak var cameraBottomLine: UIView!
    @IBOutlet weak var doorBottomLine: UIView!
    
    
    private let networkManager = NetworkService()
    private var cameras: Array<Instance> = []
    private var doors: Array<Instance> = []
    private var isCameraShow: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        setupTableView()
    }
   
  
    @IBAction func chooseCameras(_ sender: Any) {
        isCameraShow = true
        doorBottomLine.isHidden = true
        cameraBottomLine.isHidden = false
    }
    
    @IBAction func chooseDoors(_ sender: Any) {
        isCameraShow = false
        doorBottomLine.isHidden = false
        cameraBottomLine.isHidden = true
    }
}

private extension ViewController {
    
    private func setupHeader() {
        headerView.layer.shadowOpacity = 0.6
        headerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        headerView.layer.shadowRadius = 2
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupTableView() {
        instansesTableView.setUpTable(isCameraShow: isCameraShow) { [weak self] in
            guard let isCameraShow = self?.isCameraShow else { return }
            switch isCameraShow {
            case true:
                Camera.readInstaces(refresh: true) { instList in
                    self?.instansesTableView.setInstanceList(instList: instList)
                }
            case false:
                Door.readInstaces(refresh: true) { instList in
                    self?.instansesTableView.setInstanceList(instList: instList)
                }
            }
        } cellTapped: { instance in
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            guard let detailVC = storyboard.instantiateViewController(withIdentifier: VCStoryboardID.detail.rawValue) as? DetailViewController else { return }
            self.navigationController?.pushViewController(detailVC, animated: true)
        }

    }
}

