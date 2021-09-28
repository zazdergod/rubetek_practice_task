//
//  ViewController.swift
//  Rubetek_practice
//
//  Created by Ilya Buzyrev on 21.09.2021.
//

import UIKit

class ViewController: RubetecViewController {
    
    
    @IBOutlet weak var instansesTableView: RubetekUITableView!
    @IBOutlet weak var headerView: RubetekHeaderView!
    
    
    
    private let networkManager = NetworkService()
    private var cameras: Array<Instance> = []
    private var doors: Array<Instance> = []
    private var isCameraShow: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        setupTableView()
    }
    
    
    
  
}

private extension ViewController {
    
    private func setupHeader() {
        headerView.layer.shadowOpacity = 0.6
        headerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        headerView.layer.shadowRadius = 2
        navigationController?.navigationBar.isHidden = true
        headerView.setupView(title: "Мой дом", firstSegmentTitle: "Камеры", secondSegmentTitle: "Двери") { [weak self] in
            guard let isCameraShow = self?.isCameraShow else { return }
            if !isCameraShow {
                self?.isCameraShow = !isCameraShow
                Camera.readInstaces(refresh: false) { instList in
                    self?.instansesTableView.setInstanceList(instList: instList)
                }
            }
        } secondSegmentTap: { [weak self] in
            guard let isCameraShow = self?.isCameraShow else { return }
            if isCameraShow {
                self?.isCameraShow = !isCameraShow
                Door.readInstaces(refresh: false) { instList in
                    self?.instansesTableView.setInstanceList(instList: instList)
                }
            }
        }

    }
    
    private func setupTableView() {
        Camera.readInstaces(refresh: false) { [weak self] instList in
            guard let isCameraShow = self?.isCameraShow else { return }
            self?.instansesTableView.setUpTable(isCameraShow: isCameraShow, instList: instList) { [weak self] in
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
                
            } cellTapped: { [weak self] instance in
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                guard let detailVC = storyboard.instantiateViewController(withIdentifier: VCStoryboardID.detail.rawValue) as? DetailViewController else { return }
                guard let isCameraShow = self?.isCameraShow else { return }
                detailVC.setupInstance(instance: instance, isDoor: !isCameraShow)
                self?.navigationController?.pushViewController(detailVC, animated: true)
            }
            
        }
    }
}

