

## Laravel


<img src="https://paprika-dev.b0.upaiyun.com/tFzHvi9gwz3vdu5W2k8CkTRUXbyKCaD1vbPFQ1sp.jpeg" width="900"/>
 
**Service Container** : IOC控制反转是指消费类不需要自己创建所需的服务,只要提出来可由服务容器解决.


**Service Provider** : 在register方法中绑定字符串,返回Resolved Class.消费类引入字符串即可,无需绑定和注入依赖.


**Facades** : 通过自定义 Facades 类,在 getFacadeAccessor 方法中返回 what to resolve from the container, __callStatic() 魔法方法会 defer calls from facade object to 
the resolved object.


**Contracts** : **接口** . 提供了定义核心服务如缓存等等的接口.应用时可以在消费类中注入缓存服务的接口,实现的背后是 Memcached 还是 Redis 其实消费类并不需要知道,这样的松耦合非常易于重构和测试.

<img src="https://paprika-dev.b0.upaiyun.com/QhMU4vxMacXflvr86V9nX5mVtVoga4s1KDQs7gHl.jpeg" width="500"/>


## Golang


Golang 的 interface 接口是对一组行为的描述,实现其所有行为的 struct 就默认 隐式实现 了这个接口.

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
    func send(handler:@escaping(Responses?)->Void){...}}
    
struct Users {
    init?(data:Data) {... }}  
    
struct UsersRequest:Requests {
    ... ...
    typealias Responses = Users
    func parse(data: Data) -> Users? {
        return Users(data: data)
    }
}
```

**喵神** 的网络请求协议还借鉴了 APIKit 做了一些易于测试的重构.

```swift
 let request = UsersRequest(name: "paprika")
 request.send { (user) in ... }
                      --重构前
```

request 需要再做一次依赖注入, 实现和 **请求方式** 的解耦.

```swift
let request = SearchRepositoriesRequest(query: "APIKit")
Session.send(request) { result in ...}      
                      --APIKit
```

而 **面向协议编程** 的优势就在于 **解耦** .

```swift
struct URLSessionClient: Client {
    func send<T: Request>(_ r: T, handler: @escaping (T.Response?) -> Void) {...}}
                     --重构后
```
    
这样, 对于复杂,缓慢的请求方式如 docker ,测试时可以拦截request, mock本地假数据.

```swift
struct LocalFileClient: Client {
    func send<T : Request>(_ r: T, handler: @escaping (T.Response?) -> Void) {
        switch r.path {
            case "/users/paprika/...":
            ... }}
```
说到拦截请求, 修改返回数据, 要提一下两款工具: Charles 和 Burp Suite

<img src="http://paprika-dev.b0.upaiyun.com/Fo37ep1QhK29HMyh3rWOfjYZehOJp1XHl7Ai2EOm.jpeg" width="600"/>
<img src="http://paprika-dev.b0.upaiyun.com/EG2uprvBaDPbM6oyCTqB5xCrFz9MYHVsASGqpCWC.jpeg" width="600"/>
<img src="http://paprika-dev.b0.upaiyun.com/iU9959TKRfTOBO7noXT39RadDf1fMNSASKQLw7wU.jpeg" width="600"/>
<img src="http://paprika-dev.b0.upaiyun.com/l5VERFuQnm3PL8HfZhXoaZDYi7FTIUY0nK5PeHoE.jpeg" width="600"/>

Charles 和 Burp Suite 的原理其实都是监听程序的端口, 并作为程序代理, 在传输请求的过程中处理请求数据. 

在 JavaScript 中 也有 proxy 代理的概念, 也同样可以在 web 服务中拦截请求, 实现请求和请求方式之间的解耦(即请求的返回数据以何种方式获得无需知晓);同时, 对返回数据依情景自定义.

```javascript
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

另: 

[Golang: generates method stubs for implementing an interface](https://github.com/josharian/impl)

[Swift: 通过struct, enum, protocol分别对代码重构达成易于测试和Type-safe的效果](https://github.com/paprikaLang/DeepEmbedding)

