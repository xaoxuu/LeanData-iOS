//
//  BaseVC.swift
//  LeanData
//
//  Created by xu on 2020/7/1.
//  Copyright © 2020 xaoxuu. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        if let img = loadRightNavBtnImage() {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(didTappedRightNavBtn(_:)))
        } else if let str = loadRightNavBtnTitle() {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: str, style: .plain, target: self, action: #selector(didTappedRightNavBtn(_:)))
        }
        
    }
    
    func loadRightNavBtnImage() -> UIImage? {
        return nil
    }
    func loadRightNavBtnTitle() -> String? {
        return nil
    }
    
    @objc func didTappedRightNavBtn(_ sender: UIBarButtonItem) {
        
    }
    
}

protocol NavBtn {}

extension NavBtn {
    
}
