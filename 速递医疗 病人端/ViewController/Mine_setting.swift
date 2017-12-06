//
//  Mine_setting.swift
//  速递医疗 病人端
//
//  Created by admin on 2017/11/3.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class Mine_setting: BaseViewController, UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let label1 = cell.viewWithTag(1) as! UILabel
        let label2 = cell.viewWithTag(2) as! UILabel
        label1.text = "退出登录"
        label2.text = "点击回到登录界面"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            logout()
        default:
            dPrint(message: "error")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavTitle(title: "我的设置")
        // Do any additional setup after loading the view.
    }

    
    private func logout() {
        NetWorkUtil<BaseAPIBean>.init(method: .exit).newRequest { (bean, json) in
            if bean.code == 100 {
                user_default.clearUserDefaultValue()
                let vc_login = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
                EMClient.shared().logout(false, completion: { (error)
                    in
                    if error == nil {
                        Toast("环信退出成功")
                    }else {
                        Toast("环信退出失败")
                    }
                })
                APPLICATION.window?.rootViewController = vc_login
            }else {
                Toast(bean.msg!)
            }
        }
        
    }

}
