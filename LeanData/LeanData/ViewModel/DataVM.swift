//
//  DataVM.swift
//  LeanData
//
//  Created by xu on 2020/7/1.
//  Copyright © 2020 xaoxuu. All rights reserved.
//

import UIKit
import LeanCloud

class DataVM: NSObject {
    
    typealias DataType = [String: LCValueConvertible]
    
    weak var controller: UIViewController?
    weak var view: DataTable?
    
    var schema: String
    var dataList = [LCObject]()
    
    let queue = DispatchQueue(label: "datavm")
    var skip = 0
    var limit = 50
    var hasNext = true
    
    init(schema: String) {
        self.schema = schema
    }
    
    func reload(completion: @escaping (LCError?) -> Void) {
        dataList.removeAll()
        skip = 0
        hasNext = true
        loadmore { (error) in
            completion(error)
        }
    }
    
    func loadmore(completion: @escaping (LCError?) -> Void) {
        guard hasNext == true else {
            return
        }
        queue.async {
            let query = LCQuery(className: self.schema)
            query.whereKey("createdAt", .descending)
            query.skip = self.skip
            query.limit = self.limit
            _ = query.find(cachePolicy: .networkElseCache) { result in
                switch result {
                case .success(objects: let rets):
                    self.dataList.append(contentsOf: rets)
                    if rets.count < self.limit {
                        self.hasNext = false
                    } else {
                        self.hasNext = true
                    }
                    DispatchQueue.main.async {
                        self.view?.reloadData()
                        completion(nil)
                    }
                    break
                case .failure(error: let error):
                    print(error)
                    DispatchQueue.main.async {
                        completion(error)
                    }
                }
            }
        }
    }
}

extension DataVM: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func dict(for index: Int) -> DataType? {
        if index < dataList.count {
            let obj = dataList[index]
            if let dict = obj.jsonValue as? DataType {
                return dict
            }
        }
        return nil
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DataCell.description(), for: indexPath)
        var detail = ""
        if indexPath.section < dataList.count {
            let obj = dataList[indexPath.section]
            detail += "createdAt: \(obj.createdAt?.dateValue?.fullDesc ?? "")\n"
            detail += "updatedAt: \(obj.updatedAt?.dateValue?.fullDesc ?? "")\n"
            if let dict = dict(for: indexPath.section) {
                for k in dict.keys.sorted() {
                    if ["__type", "className", "objectId", "createdAt", "updatedAt"].contains(k) == false {
                        let o = obj.get(k)
                        if let str = o?.stringValue {
                            detail += "\(k): \(str)\n"
                        } else if let date = o?.dateValue {
                            detail += "\(k): \(date.fullDesc)\n"
                        } else {
                            detail += "\(k): \(o?.lcValue.jsonString.description)\n"
                        }
                    }
                }
            }
            detail = detail.trimmingCharacters(in: .whitespacesAndNewlines)
            cell.detailTextLabel?.text = detail
        } 
        return cell
    }
    
}

extension DataVM: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = DataDetailVC(object: self.dataList[indexPath.section])
        self.controller?.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < dataList.count {
            return dataList[section].createdAt?.dateValue?.fullDesc ?? " "
        }
        return " "
    }
    
}

extension ProHUD.Scene {
    static var refresh: ProHUD.Scene {
        var scene = ProHUD.Scene.init(identifier: "login.rotate")
        scene.image = UIImage(named: "prohud.rainbow.circle")
        scene.title = "正在刷新"
        scene.message = "坐和放宽，我们正在帮你搞定一切。"
        scene.alertDuration = 0
        scene.toastDuration = 0
        return scene
    }
    static var update: ProHUD.Scene {
        var scene = ProHUD.Scene.init(identifier: "login.rotate")
        scene.image = UIImage(named: "prohud.rainbow.circle")
        scene.title = "正在更新"
        scene.alertDuration = 0
        scene.toastDuration = 0
        return scene
    }
}
