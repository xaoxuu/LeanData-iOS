//
//  UserCenterVC.swift
//  LeanData
//
//  Created by xu on 2020/7/1.
//  Copyright © 2020 xaoxuu. All rights reserved.
//

import UIKit

class UserCenterVC: BaseListVC {
 
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "个人中心"
        
        setupTableView()
        
        
        let addBtn = BaseButton(title: "修改关注的表") { [weak self] in
            if let user = UserManager.currentUser {
                user.fetch(keys: ["table", "columns"], completionQueue: .main) { (ret) in
                    let table = user.get("table")?.stringValue
                    self?.present(EditTextVC(title: "修改关注的表", text: table) { (str) in
                        try? user.set("table", value: str)
                        try? user.set("columns", value: [String]())
                        user.save { (result) in
                            switch result {
                            case .success:
                                ProHUD.Alert.push("update", scene: .success) { (a) in
                                    a.update { (vm) in
                                        vm.title = "更新成功"
                                    }
                                }
                                self?.setupTableView()
                                UserDefaults.standard.set(str, forKey: "table")
                                UserDefaults.standard.synchronize()
                                NotificationCenter.default.post(name: NSNotification.Name.init("reload"), object: nil)
                                break
                            case .failure(error: let error):
                                print(error)
                                ProHUD.Alert.push("update", scene: .failure) { (a) in
                                    a.update { (vm) in
                                        vm.title = "更新失败"
                                        vm.message = error.reason
                                        vm.duration = 3
                                    }
                                }
                            }
                        }
                    }, animated: true, completion: nil)
                    
                }
                
            }
            
            
            
        }
        view.addSubview(addBtn)
        addBtn.snp.makeConstraints { (mk) in
            mk.height.equalTo(50)
            mk.left.equalToSuperview().offset(20)
            mk.right.equalToSuperview().offset(-20)
            mk.bottom.equalToSuperview().offset(-60)
        }
        
    }
    
    

}

extension UserCenterVC {
    func setupTableView() {
        vm.sections.removeAll()
        vm.addSection(title: "个人信息") { (sec) in
            sec.addRow(title: UserManager.currentUser?.email?.stringValue, subtitle: "这是您当前登录的账号") {
                Alert.push(scene: .warning, title: "是否注销", message: "您随时可以重新登录") { (a) in
                    a.update { (vm) in
                        vm.add(action: .destructive, title: "注销") {
                            LoginManager.logout()
                        }
                        vm.add(action: .cancel, title: "不注销", handler: nil)
                    }
                }
            }
        }
        if let user = UserManager.currentUser {
            
            user.fetch(keys: ["table", "columns"], completionQueue: .main) { [weak self] (result) in
                if let table = user.get("table")?.stringValue {
                    self?.vm.addSection(title: "关注的表：\(table)", callback: { (sec) in
                        func f(text: String? = nil) {
                            self?.present(EditTextVC(title: "关注的列", text: text) { (c) in
                                if var cls = user.get("columns")?.arrayValue as? [String] {
                                    if let t = text, let idx = cls.lastIndex(of: t) {
                                        cls.remove(at: idx)
                                    }
                                    if c.count > 0 {
                                        cls.append(c)
                                    }
                                    try? user.set("columns", value: cls)
                                } else {
                                    try? user.set("columns", value: [c])
                                }
                                user.save { (ret) in
                                    self?.setupTableView()
                                }
                            }, animated: true, completion: nil)
                        }
                        if let arr = user.get("columns")?.arrayValue as? [String] {
                            for c in arr {
                                sec.addRow(title: c) {
                                    f(text: c)
                                }
                            }
                        }
                        sec.addRow(title: "增加关注的列") {
                            f()
                        }
                    })
                    self?.tableView.reloadData()
                }
            }
            
        }
    }
}
