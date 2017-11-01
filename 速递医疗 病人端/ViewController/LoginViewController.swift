//
//  ViewController.swift
//  DoctorClient
//
//  Created by admin on 2017/8/7.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import SVProgressHUD
import Moya
import Toast_Swift
import ObjectMapper
import SwiftHash
import SwiftyJSON


class LoginViewController: BaseTextViewController {
    
    //MARK: - property
    
    
    @IBOutlet weak var tv_phone: UITextField!
    
    @IBOutlet weak var tv_pwd: UITextField!
    
    @IBOutlet weak var btn_login: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateButtonState()
        // 界面设置
        initTextFieldDelegate(tv_source: [tv_pwd, tv_phone])
        updateBtnState = updateButtonState
    }
    
    //MARK: - action
    @IBAction func click_login(_ sender: Any) {
        let phoneNum = tv_phone.text!
        let passNum =  tv_pwd.text!
        
        // FIXME:  需要做字符串验证
        
        SVProgressHUD.show()
        let Provider = MoyaProvider<API>()
        
        Provider.request(API.login(phoneNum, MD5(passNum))) { result in
            switch result {
            case let .success(response):
                do {
                    SVProgressHUD.dismiss()
                    let jsonObj =  try response.mapJSON()
                    let bean = Mapper<BaseAPIBean>().map(JSONObject: jsonObj)
                    if bean?.code == 100 {
                        let json = JSON(jsonObj)
                        let data = json["data"]
                        let userId = data["id"].intValue
                        let type = data["type"].boolValue
                        let pix = data["pix"].stringValue
                        let token = data["token"].stringValue
                        let username = data["username"].stringValue
                        UserDefaultUtil.setUserDefault(key: "userId", value: String(userId))
                        UserDefaultUtil.setUserDefault(key: "type", value: type)
                        UserDefaultUtil.setUserDefault(key: "pix", value: pix)
                        UserDefaultUtil.setUserDefault(key: "token", value: token)
                        UserDefaultUtil.setUserDefault(key: "username", value: username)
                        dPrint(message: data)
                        self.view.makeToast(bean!.msg!)
                    } else{
                        self.view.makeToast(bean!.msg!)
                    }
                }catch {
                    SVProgressHUD.dismiss()
                    self.view.makeToast(CATCHMSG)
                }
            case let .failure(error):
                SVProgressHUD.dismiss()
                dPrint(message: "error:\(error)")
                self.view.makeToast(ERRORMSG)
            }
        }
    }
    
    //MARK: - navigation
    @IBAction func unwindToLogin (segue: UIStoryboardSegue) {
        //nothing goes here
        
    }
    
    //MARK: - private method
    private func updateButtonState() {
        // Disable the  button if the text field is empty.
        let phoneText = tv_phone.text ?? ""
        let password = tv_pwd.text ?? ""
        
        btn_login.isEnabled = (!phoneText.isEmpty && !password.isEmpty)
        
    }
    
}

