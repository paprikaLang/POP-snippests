//
//  ViewController.swift
//  ProtocolNetwork
//
//  Created by WANG WEI on 2016/08/16.
//  Copyright © 2016年 OneV's Den. All rights reserved.
//
/*
 *总体思路*

 高度解耦使得改变请求方式或者请求体其中一方而不改变另一方成为可能,非常易于测试和扩展.对于response的data转模型,在Decodable中可以任意实现第三方JSON解析库
 */
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = ""
        messageLabel.text = ""
        //send<T: Request>(_ r: T, handler: @escaping (T.Response?) -> Void),T通过parse转换成了user
        //解耦后,发送请求的类(URLSessionRequestSender)和请求本身(UserRequest)就分离开了(UserRequest可以换成FoodRequest,AnimalRequest)
        URLSessionRequestSender().send(UserRequest(name: "onevcat")) { user in
            self.nameLabel.text = user?.name ?? ""
            self.messageLabel.text = user?.message ?? ""
        }
        //解耦前,请求和send是绑定的
        let request = UsersRequest(name: "paprika")
        request.send { (user) in
            if let user = user{
                print("\(user.message)from\(user.name)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

