//
//  LaunchScreenViewController.swift
//  Grouffee
//
//  Created by Christhopher Ravian Hartono on 05/12/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    @IBOutlet weak var activityInd : UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        activityInd.frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
        activityInd.center.x = view.center.x
        activityInd.center.y = view.center.y + 130.0
        activityInd.startAnimating()
        activityInd.activityIndicatorViewStyle = .whiteLarge
    }
}
