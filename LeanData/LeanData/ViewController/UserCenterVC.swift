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
        
        
        let addBtn = BaseButton(title: "新增表") { [weak self] in
            self?.present(EditTextVC(title: "新增表", text: nil) { (str) in
                if let user = UserManager.currentUser {
                    try? user.append("table", element: str)
                }
            }, animated: true, completion: nil)
            
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
        vm.addSection(title: "个人信息") { (sec) in
            sec.addRow(title: UserManager.currentUser?.email?.stringValue, subtitle: "当前登录的账号") {
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
        
        vm.addSection(title: "关注表") { (sec) in
            
        }
        vm.addSection(title: "列") { (sec) in
            sec.addRow(title: "test") {
                
            }
        }
    }
}
