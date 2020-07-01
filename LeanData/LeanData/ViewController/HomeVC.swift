//
//  HomeVC.swift
//  LeanData
//
//  Created by xu on 2020/7/1.
//  Copyright © 2020 xaoxuu. All rights reserved.
//

import UIKit

class HomeVC: BaseVC {
    
    let table = DataTable()
    let vm = DataVM(schema: "Comment")
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "LeanData"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "icloud.and.arrow.down"), style: .plain, target: self, action: #selector(didTappedLeftNavBtn(_:)))
        
        
        view.addSubview(table)
        table.snp.makeConstraints { (mk) in
            mk.edges.equalToSuperview()
        }
        table.dataSource = vm
        table.delegate = vm
        vm.view = table
        vm.controller = self
        
        
        if LoginManager.isLogin {
            reloadData(toast: true, completion: nil)
        }
        
        let addBtn = UIButton(type: .system)
        addBtn.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        view.addSubview(addBtn)
        addBtn.imageView?.contentMode = .scaleAspectFit
        addBtn.imageView?.snp.makeConstraints({ (mk) in
            mk.width.height.equalTo(50)
        })
        addBtn.snp.makeConstraints { (mk) in
            mk.right.equalToSuperview().offset(-20)
            mk.bottom.equalToSuperview().offset(-60)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.onNeedReload(_:)), name: NSNotification.Name.init("reload"), object: nil)
    }
    
    override func loadRightNavBtnImage() -> UIImage? {
        if let user = UserManager.currentUser {
            return user.avatar ?? UIImage(systemName: "person.crop.circle.fill")
        } else {
            return nil
        }
    }
    
    override func loadRightNavBtnTitle() -> String? {
        if UserManager.currentUser == nil {
            return "登录"
        } else {
            return nil
        }
    }
    
    override func didTappedRightNavBtn(_ sender: UIBarButtonItem) {
        if LoginManager.isLogin {
            // 进入用户中心
            navigationController?.pushViewController(UserCenterVC(), animated: true)
        } else {
            // 登录
            LoginManager.login(from: self)
        }
    }
    
    @objc func didTappedLeftNavBtn(_ sender: UIBarButtonItem) {
        if LoginManager.isLogin {
            reloadData(toast: true, completion: nil)
        } else {
            // 登录
            LoginManager.login(from: self)
        }
    }

    @objc func onNeedReload(_ sender: NSNotification) {
        reloadData(toast: false, completion: nil)
    }
    func reloadData(toast: Bool = true, completion: (() -> Void)? = nil) {
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        if toast {
            Toast.push("reloadData", scene: .refresh) { (vc) in
                vc.isRemovable = false
            }
        }
        vm.reload { (err) in
            self.navigationItem.leftBarButtonItem?.isEnabled = true
            if toast {
                if let e = err {
                    Toast.push("reloadData") { (vc) in
                        vc.update { (vm) in
                            vm.scene = .error
                            vm.title = "刷新失败"
                            vm.message = e.reason
                        }
                    }
                } else {
                    Toast.pop("reloadData")
                }
            }
            completion?()
        }
    }
    
}
