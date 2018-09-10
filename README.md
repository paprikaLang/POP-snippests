

## Laravel


<img src="https://paprika-dev.b0.upaiyun.com/tFzHvi9gwz3vdu5W2k8CkTRUXbyKCaD1vbPFQ1sp.jpeg" width="900"/>
  
**Service Container** : IOC 控制反转是指消费类不需要自己创建所需的服务, 只要提出来可由服务容器解决.


**Service Provider** : 在 register 方法中绑定字符串, 返回 Resolved Class. 消费类引入字符串即可, 无需绑定和注入依赖.


**Facades** : 通过自定义 Facades 类,在 getFacadeAccessor 方法中返回 what to resolve from the container, __callStatic() 魔法方法会 defer calls from facade object to 
the resolved object.


**Contracts** : 提供了定义核心服务的接口, 比如缓存. 应用时可以在消费类中注入缓存服务的接口, 实现的背后是 Memcached 还是 Redis 消费类无需知晓, 这样的松耦合非常易于 重构 和 测试 .

<img src="https://paprika-dev.b0.upaiyun.com/QhMU4vxMacXflvr86V9nX5mVtVoga4s1KDQs7gHl.jpeg" width="500"/>


## Golang


Golang  interface 接口是对 duck typing 的一组行为的描述, 实现其所有行为的 struct 都默认实现了这个接口.

<img src="http://paprika-dev.b0.upaiyun.com/SKlgT3lf7VgWXgBNc92uAC1gv2hUXcEk0ozrK4WK.jpeg" width="600"/>

<img src="http://paprika-dev.b0.upaiyun.com/UhKzASJ97nWt6Wkdcq4Pr0LaepqSTzEduFgjbyi9.jpeg" width="600"/>


## OC


OC 版对 protocol 注入 duck type 的实现.

<img src="http://paprika-dev.b0.upaiyun.com/KBcT1JkfZubfjl4ZvSpFSRS17YAFGYHEV3fLS2Dk.jpeg" width="600"/>


## Swift


```swift
protocol Requests {
    var host:String{get}
    var path:String{get}
    var method:HTTPMethods{get}
    var parameter:[String:Any]{get}
   
    associatedtype Responses
    
    func parse(data:Data)->Responses?
}

extension Requests{
    func send(handler:@escaping(Responses?)->Void){
      ... ...
      handler(Response.parse(data: data))}}
    
struct Users {
    init?(data:Data) {... }} 

//显式遵守协议    
struct UsersRequest:Requests {
    ... ...
    typealias Responses = Users
    func parse(data: Data) -> Users? {
        return Users(data: data)
    }
}
```

上面 Requests 协议中的 `associatedtype` 关键字和 Golang 中的 `type SonInLaw interface` 都可以理解成为 '比武招亲' 的招贴 ---- 只要符合上面的基本要求, 能者之间可以公平竞争. 不过 Swift 必须显式遵守协议, 而 Golang 可以隐式实现接口.

**喵神** 的这个网络请求协议之后又做了进一步的解耦重构, 主要有下面两方面:

> 1. 如何请求数据, Request 无需知晓. 抽离 URLSession , 交给协议 RequestSender .

> 2. 如何 data 转 model, Model 无需知晓. 抽离 JSONSerialization , 交给协议 Decodable . 

```swift
 let request = UsersRequest(name: "paprika")
 request.send { (user) in ... }
                      -- 重构前
```

```swift
struct URLSessionRequestSender: RequestSender {
    func send<T: Request>(_ r: T, handler: @escaping (T.Response?) -> Void) {...}}
                      -- 重构后
```


喵神重构方案的灵感来自于 APIKit 这款框架:

```swift
let request = SearchRepositoriesRequest(query: "paprika")
Session.send(request) { result in ...}      
                      -- APIKit
```

形式上看, 从 `request.send` 到 `Session.send(request)` 很像 JavaScript 里的 Reflect .
```JavaScript
var user = {name: 'frank', age:12};
user.name;    
Reflect.get(user,'name');
```
```JavaScript
var user = {lives:3};
var proxy =new Proxy(user, {
    get(target, prop){
        return Reflect.get(target, prop)
    },
    set(target, prop, value) {
        if(prop === 'lives' && value < 0) {
            value = 0
        }
        return Reflect.set(target, prop, value)
    }
})
```
    
功能上看, 它们都能 '暗箱操作' 将要返回的数据而在代码层面无需大的改动(后面也会有 Proxy 实现解耦的方案代码), 如对于 复杂 缓慢 的请求方式 Docker , 测试时可以拦截 request , mock 本地假数据.

```swift
struct TestRequestSender: RequestSender {
    func send<T : Request>(_ r: T, handler: @escaping (T.Response?) -> Void) {
        switch r.path {
            case "/users/paprika/...":
            ... }}
```
说到拦截请求, 这里顺便提一下两款调试工具: Charles 和 Burp Suite

<img src="http://paprika-dev.b0.upaiyun.com/Fo37ep1QhK29HMyh3rWOfjYZehOJp1XHl7Ai2EOm.jpeg" width="600"/>
<img src="http://paprika-dev.b0.upaiyun.com/EG2uprvBaDPbM6oyCTqB5xCrFz9MYHVsASGqpCWC.jpeg" width="600"/>
<img src="http://paprika-dev.b0.upaiyun.com/iU9959TKRfTOBO7noXT39RadDf1fMNSASKQLw7wU.jpeg" width="600"/>
<img src="http://paprika-dev.b0.upaiyun.com/l5VERFuQnm3PL8HfZhXoaZDYi7FTIUY0nK5PeHoE.jpeg" width="600"/>

Charles 和 Burp Suite 的原理是监听程序的端口, 并作为程序代理, 在传输请求的过程中处理请求数据. 


## Javascript


前面提到过, 应用 proxy 代理也可以在 web 服务中拦截请求, 实现同样的 请求和请求方式之间的解耦, 并对返回数据依情景自定义.

```JavaScript
const service = createWebService('http:example.com/data');

service.users().then(json => {
    const users = JSON.parse(json);
    ...
})

function createWebService(baseUrl){
    return new Proxy({}, {
         get(target, route, receiver) {
            return () => httpGet(baseUrl + '/' + route);
         }
    });
}
```

```swift
//Swift
Session.send(Request(query: "users")) { result in ...}      
                      -- APIKit

//Javascript
service.users().then(json => {})
                      -- Proxy
```

另: 

[Golang: generates method stubs for implementing an interface](https://github.com/josharian/impl)

[Swift: 通过 struct, enum, protocol 分别对代码重构达成易于测试和 Type-safe 的效果](https://github.com/paprikaLang/DeepEmbedding)

