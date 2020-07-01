//
//  DataDetailVC.swift
//  LeanData
//
//  Created by xu on 2020/7/1.
//  Copyright © 2020 xaoxuu. All rights reserved.
//

import UIKit
import LeanCloud

class DataDetailVC: BaseVC {
    
    let table = DataTable()
    let vm: DataDetailVM
    
    init(object: LCObject) {
        self.vm = DataDetailVM(object: object)
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "编辑"
        
        view.addSubview(table)
        table.snp.makeConstraints { (mk) in
            mk.edges.equalToSuperview()
        }
        table.dataSource = vm
        table.delegate = vm
        vm.view = table
        vm.controller = self
        
    }
    
    
    override func loadRightNavBtnImage() -> UIImage? {
        return UIImage(systemName: "trash.fill")
    }
    
    override func didTappedRightNavBtn(_ sender: UIBarButtonItem) {
        Alert.push("delete", scene: .delete) { (vc) in
            vc.update { (vm) in
                vm.add(action: .destructive, title: "删除") {
                    Alert.push("delete", scene: .update) { (vc) in
                        vc.update { (vm) in
                            vm.remove(action: 0,1)
                        }
                    }
                    self.vm.object.delete { (result) in
                        switch result {
                        case .success:
                            Alert.push("delete", scene: .success) { (vc) in
                                vc.update { (vm) in
                                    vm.title = "删除成功"
                                }
                            }
                            self.navigationController?.popViewController(animated: true)
                            NotificationCenter.default.post(name: NSNotification.Name.init("reload"), object: nil)
                            break
                        case .failure(error: let error):
                            print(error)
                            ProHUD.Alert.push("delete", scene: .failure) { (a) in
                                a.update { (vm) in
                                    vm.title = "删除失败"
                                    vm.message = error.reason
                                    vm.duration = 3
                                }
                            }
                        }
                        
                    }
                }
                vm.add(action: .cancel, title: "取消", handler: nil)
            }
        }
        
    }
    

}
