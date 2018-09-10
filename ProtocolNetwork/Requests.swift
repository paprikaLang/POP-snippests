//
//  Requests.swift
//  ProtocolNetwork
//
//  Created by paprika on 2017/9/26.
//  Copyright © 2017年 OneV's Den. All rights reserved.
//
/*
 重构前的代码:请求里的任务太重,和user耦合太深,24,26两行可以做成面向对象的形式把parse从request分离出来
 再把send从request抽离出来,单独定义一个类或者协议来负责发送请求
 */
import Foundation

enum HTTPMethods:String {
    case GET
    case POST
}
//创建一个protocol来代表请求,对请求来说,只需要知道路径HTTP和参数
protocol Requests {
    var host:String{get}
    var path:String{get}
    var method:HTTPMethods{get}
    var parameter:[String:Any]{get}
    //回调的参数类型不能是User,关联类型把回调参数抽象成为上层通用的Responses类
    associatedtype Responses
    //提供一个接口让遵守协议的类都可以获取data, 并在内部转换.
    func parse(data:Data)->Responses?
}
extension Requests{
    func send(handler:@escaping(Responses?)->Void){

        let url = URL(string:host.appending(path))!
        var request = URLRequest(url:url)
        request.httpMethod = method.rawValue
        let task = URLSession.shared.dataTask(with: request){data,_,error in

            if let data = data,let res = self.parse(data: data){
                DispatchQueue.main.async {
                    handler(res)
                }}else{
                    DispatchQueue.main.async {
                        handler(nil)
                }}
                }
        task.resume()
    }
}
struct Users {
    let name: String
    let message:String
    init?(data:Data) {
        guard let obj = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else {
            return nil
        }
        guard let name = obj?["name"] as? String,
            let message = obj?["message"] as? String else{
                return nil
        }
        self.name = name
        self.message = message
    }
    
    
}

struct UsersRequest:Requests {
    let name:String
    let host = "http://baidu.com"
    var path: String {
        return "/users/\(name)"
    }
    let method: HTTPMethods = .GET
    let parameter: [String : Any] = [:]
    typealias Responses = Users
    func parse(data: Data) -> Users? {
        return Users(data: data)
    }
}



















