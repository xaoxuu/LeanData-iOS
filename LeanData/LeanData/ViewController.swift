//
//  ViewController.swift
//  LeanData
//
//  Created by xu on 2020/6/30.
//  Copyright © 2020 xaoxuu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let vc = LoginVC()
//        present(vc, animated: true, completion: nil)
    }

    @IBAction func login(_ sender: UIButton) {
        LoginManager.login(from: self)
    }
}

