

## Laravel

![](https://paprika-dev.b0.upaiyun.com/tFzHvi9gwz3vdu5W2k8CkTRUXbyKCaD1vbPFQ1sp.jpeg)
 
**Service Container** : IOC控制反转是指消费类不需要自己创建所需的服务,只要提出来可由服务容器解析.

**Service Provider** : 在register方法中绑定字符串,返回Resolved Class.消费类引入字符串即可,无需绑定和注入依赖.


**Facades** : 通过自定义Facades类,在getFacadeAccessor方法中返回绑定好的字符串,可以这样调用:
Config::get('database.default');

 
**Contracts** : 就是本项目的主角: **接口**.Laravel里叫契约, 提供了定义核心服务如缓存...的接口.应用时可以在消费类中注入缓存服务的接口,实现的背后是Memcached还是Redis其实消费类并不需要知道,这样的松耦合非常易于重构和测试.

![](https://paprika-dev.b0.upaiyun.com/QhMU4vxMacXflvr86V9nX5mVtVoga4s1KDQs7gHl.jpeg)


## Golang

Go的interface接口是对一组行为的描述,实现其所有行为的类都默认satisfy了这个接口.而**依赖注入**则丰富了接口的实现:

![](http://paprika-dev.b0.upaiyun.com/SKlgT3lf7VgWXgBNc92uAC1gv2hUXcEk0ozrK4WK.jpeg)

![](http://paprika-dev.b0.upaiyun.com/UhKzASJ97nWt6Wkdcq4Pr0LaepqSTzEduFgjbyi9.jpeg)


## OC

参照Go的依赖注入就会很容易理解孙源的OC版"志玲/凤姐之吻"了.这里的protocol就相当于Go的interface,实现的原理都滥觞于ISP ---- 接口依赖隔离:

![](http://paprika-dev.b0.upaiyun.com/KBcT1JkfZubfjl4ZvSpFSRS17YAFGYHEV3fLS2Dk.jpeg)


## Swift

```pt
protocol Requests {
    var host:String{get}
    var path:String{get}
    var method:HTTPMethods{get}
    var parameter:[String:Any]{get}
   
    associatedtype Responses
    //依赖注入点
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
        //依赖注入(和前面Go的db注入是不是很像呢)
        return Users(data: data)
    }
}

URLSessionRequestSender().send(UserRequest(name: "paprika")) { user in ...}
```

这个例子可以用来理解APIKit的思想 :
```
Type-safe networking abstraction layer that associates request type with response type.
```

[通过struct, enum, protocol分别对代码重构达成易于测试和Type-safe的效果](https://github.com/paprikaLang/DeepEmbedding)

