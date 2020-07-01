//
//  LoginManager.swift
//  LeanData
//
//  Created by xu on 2020/6/30.
//  Copyright © 2020 xaoxuu. All rights reserved.
//

import UIKit
import LoginUI
import LeanCloud
import ProHUD

struct LoginManager {
    
    static var isLogin: Bool {
        if let _ = LCApplication.default.currentUser {
            return true
        } else {
            return false
        }
    }

    
    
    static func setup() {
//        if let user = LCApplication.default.currentUser {
//            
//        } else {
//            
//        }
    }
    
    static func login(from vc: UIViewController) {
        // 设置登录
        LoginUI.logo = UIImage(systemName: "icloud")
        LoginUI.title = "LeanData"
        LoginUI.agreementURL = URL(string: "https://xaoxuu.com")
        LoginUI.onTappedLogin { (acc, psw) in
            Alert.push("login", scene: .login)
            let _ = LCUser.logIn(username: acc, password: psw) { (result) in
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                    switch result {
                    case .success:
                        if let sessionToken = result.object?.sessionToken {
                            UserDefaults.standard.set(sessionToken.rawValue, forKey: "leancloud.sessionToken")
                            UserDefaults.standard.set(acc, forKey: "leancloud.account")
                            UserDefaults.standard.synchronize()
                        }
                    case .failure(let error):
                        debugPrint(error)
                    }
                    DispatchQueue.main.async {
                        LoginUI.unlockButtons()
                        Alert.push("login") { (vc) in
                            vc.update { (vm) in
                                if result.isSuccess {
                                    vm.scene = .success
                                    vm.title = "登录成功"
                                    LoginUI.dismiss()
                                } else {
                                    vm.scene = .failure
                                    vm.title = "登录失败"
                                    vm.message = result.error?.localizedDescription
                                }
                            }
                        }
                    }
                })
            }
        }
        LoginUI.onTappedSignup { (acc, psw) in
            Alert.push("login", scene: .signup)
            DispatchQueue.global().async {
                let user = LCUser()
                user.username = LCString(acc)
                user.password = LCString(psw)
                user.email = user.username
                let result = user.signUp()
                switch result {
                case .success:
                    break
                case .failure(let error):
                    debugPrint(error)
                }
                DispatchQueue.main.async {
                    LoginUI.unlockButtons()
                    Alert.push("login") { (vc) in
                        vc.update { (vm) in
                            if result.isSuccess {
                                vm.scene = .success
                                vm.title = "注册成功"
                            } else {
                                vm.scene = .failure
                                vm.title = "注册失败"
                                vm.message = result.error?.localizedDescription
                            }
                        }
                        
                    }
                }
            }
        }
        LoginUI.accountDefault = UserDefaults.standard.string(forKey: "leancloud.account")
        LoginUI.present(from: vc)
    }
    
}

extension ProHUD.Scene {
    static var login: ProHUD.Scene {
        var scene = ProHUD.Scene.init(identifier: "login.rotate")
        scene.image = UIImage(named: "prohud.rainbow.circle")
        scene.title = "正在登录"
        scene.alertDuration = 0
        scene.toastDuration = 0
        return scene
    }
    static var signup: ProHUD.Scene {
        var scene = ProHUD.Scene.init(identifier: "signup.rotate")
        scene.image = UIImage(named: "prohud.rainbow.circle")
        scene.title = "正在注册"
        scene.alertDuration = 0
        scene.toastDuration = 0
        return scene
    }
}
