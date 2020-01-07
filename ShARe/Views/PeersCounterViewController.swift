//
//  PeersCounterViewController.swift
//  ShARe
//
//  Created by Andrei Ostafciuc on 19/12/2019.
//  Copyright © 2019 Andrei Ostafciuc. All rights reserved.
//

import UIKit

class PeerCounterViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var counterContainerView: UIView!
    @IBOutlet weak var counterLabel: UILabel!
    
    //MARK: - Properties
    var peersCount = 0 {
        didSet {
            view.isHidden = peersCount == 0
            counterContainerView.isHidden = peersCount <= 1
            counterLabel.text = String(peersCount)
        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
      setupUI()
    }

  //MARK: - Setup UI
  private func setupUI() {
    view.isHidden = true
  }
}
