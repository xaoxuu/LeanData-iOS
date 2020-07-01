//
//  DataDetailVM.swift
//  LeanData
//
//  Created by xu on 2020/7/1.
//  Copyright © 2020 xaoxuu. All rights reserved.
//

import UIKit
import LeanCloud

class DataDetailVM: NSObject {
    
    var object: LCObject
    
    var keys = [String]()
    
    weak var controller: UIViewController?
    weak var view: DataTable?
    
    init(object: LCObject) {
        self.object = object
        
        if let dict = object.jsonValue as? [String : LCValueConvertible] {
            for k in dict.keys.sorted() {
                if ["__type", "className"].contains(k) == false {
                    keys.append(k)
                }
            }
        }
        
    }
    
}

extension DataDetailVM: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DataCell.description(), for: indexPath)
        let k = keys[indexPath.section]
        let obj = object.get(k)
        if let str = obj?.stringValue {
            cell.textLabel?.text =  str
        } else if let date = obj?.dateValue {
            cell.textLabel?.text =  date.fullDesc
        } else {
            cell.textLabel?.text = obj?.lcValue.jsonString
        }
        if ["__type", "className", "objectId", "createdAt", "updatedAt"].contains(k) == false {
            cell.textLabel?.alpha = 1
            cell.isUserInteractionEnabled = true
        } else {
            cell.textLabel?.alpha = 0.5
            cell.isUserInteractionEnabled = false
        }
        return cell
    }
    
}

extension DataDetailVM: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let k = keys[indexPath.section]
        let vc = EditTextVC(title: k, text: "") { (str) in
            ProHUD.Alert.push("update", scene: .update) { (a) in
                a.update { (vm) in
                    vm.title = "正在更新"
                }
            }
            try? self.object.set(k, value: str)
            self.object.save { (result) in
                switch result {
                case .success:
                    ProHUD.Alert.push("update", scene: .success) { (a) in
                        a.update { (vm) in
                            vm.title = "更新成功"
                        }
                    }
                    tableView.reloadRows(at: [indexPath], with: .automatic)
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
        }
        let obj = object.get(k)
        if let str = obj?.stringValue {
            vc.tv.text =  str
        } else if let date = obj?.dateValue {
            vc.tv.text =  date.fullDesc
        } else {
            vc.tv.text = obj?.lcValue.jsonString
        }
        controller?.present(vc, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return keys[section]
    }
    
}
