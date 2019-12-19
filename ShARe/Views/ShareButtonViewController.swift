//
//  ShareButtonViewController.swift
//  ShARe
//
//  Created by Andrei Ostafciuc on 19/12/2019.
//  Copyright © 2019 Andrei Ostafciuc. All rights reserved.
//

import UIKit

protocol ShareButtonViewControllerDelegate: class {
    func didPressShareButton(_ shareButtonViewController: ShareButtonViewController)
}

class ShareButtonViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var circularProgressBar: CiruclarProgressBar!
    
    //MARK: - Properties
    
    weak var delegate: ShareButtonViewControllerDelegate?
    
    public var shareEnabled = false {
        didSet {
            shareButton.tintColor = shareEnabled ?
                ARSceneConstants.Colors.shareButtonEnabled:
                ARSceneConstants.Colors.shareButtonDisabled
            shareButton.isEnabled = shareEnabled
        }
    }
    
    public let progressSteps: [(Double, UIColor)] = [
        (0.25, #colorLiteral(red: 1, green: 0.2705882353, blue: 0.2274509804, alpha: 1)),
        (0.5, #colorLiteral(red: 0.9254901961, green: 0.8392156863, blue: 0.07450980392, alpha: 1)),
        (0.75, #colorLiteral(red: 0.6862745098, green: 0.8901960784, blue: 0.1215686275, alpha: 1)),
        (1.0, #colorLiteral(red: 0.1960784314, green: 0.8431372549, blue: 0.2941176471, alpha: 1))
    ]
    
    public var progress: (Double, UIColor) = (0.0, .clear) {
        didSet {
            if oldValue != progress {
                circularProgressBar.setProgress(to: progress.0, withAnimation: true, duration: 0.3, color: progress.1)
            }
        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        setupCircularProgress()
    }
    
    private func setupCircularProgress() {
        circularProgressBar.lineWidth = 6
        circularProgressBar.fillBackgroundColor = UIColor(named: "circularBackgroundFillColor")!
    }
    
    @IBAction func shareButtonTouchUpInside(_ sender: Any) {
        delegate?.didPressShareButton(self)
    }
}
