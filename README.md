## Laravel

<img src="https://paprika-dev.b0.upaiyun.com/Nm1DwGb05sbL6r8qnf18iyz5hSivfEmoVoLS51t9.jpeg" width="700"/>

**Service Container** : 

<img src="https://paprika-dev.b0.upaiyun.com/kc2COoxypzeRM7z3goQbBqa11n8ItrOb47ZfMLQ3.jpeg" width="400"/>

Ioc—Inversion of Control -- “控制反转”. 消费类只管声明需要的服务( Foo $foo ), 无需创建和实现它. Laravel 会利用反射机制自动实例化这个 Foo 类和依赖注入到 Foo 中的 Bar .
或者在 `use Foo` 前添加 Facades , 也可以轻松炫酷实现控制反转. [[查看demo]](https://github.com/paprikaLang/POP-snippests/blob/laravel/routes/web.php#L4)

**Service Provider** : 在 register 方法中绑定字符串(app->singleton('files')), 返回 Resolved Class. 消费类引入字符串, 可以省去绑定和注入依赖.

<img src="https://paprika-dev.b0.upaiyun.com/TPTOzV0naXP2XYisqFs5ouvPL3AQhHXoXb4OspKQ.jpeg" width="400"/>

**Facades** : 在 PHP 里，如果访问了不可访问的静态方法，会调用 __callstatic 来实例化 ` $instance = static::getFacadeRoot(); ` [详细请参考](https://segmentfault.com/a/1190000009171779#articleHeader0)

```bash
'aliases' => [
  'App' => Illuminate\Support\Facades\App::class,
]
```

**Contracts** : 提供了定义核心服务的接口, 比如缓存. 其实缓存实现的背后是 Memcached 还是 Redis , 消费类无需知晓, 所以只要在消费类中注入缓存服务的接口即可. 

这样的**松耦合**非常易于 重构 和 测试 .

[不同语言的"Contracts"]

<img src="https://paprika-dev.b0.upaiyun.com/6BYJtdX8csiC3e6G55IU6ao02jPcBDUAtdDazp8k.jpeg" width="500"/>


**看一个 Laravel-Echo 的例子**:

> Laravel Echo enables real-time web applications through the use of WebSockets and hooks directly into Laravel's event broadcasting features. 

```
valet secure echo-push               //HTTPS
BROADCAST_DRIVER=pusher              //pusher
composer require pusher/pusher-php-server "~3.0"  //communication between servers and devices
php artisan make:event OrderUpdated  //创建触发事件
```

生成的 OrderUpdated 事件实现了 `Illuminate\Contracts\Broadcasting\ShouldBroadcast` 协议的 `broadcastOn` 方法.

<img src="https://paprika-dev.b0.upaiyun.com/rDnaMNHvDUqbP48UT39ub4EcsD6UdvTvdyPyDmoV.jpeg" width="400"/>

<img src="https://paprika-dev.b0.upaiyun.com/GukIgeAjd3kxjXXMe6oDfjOYd9YzQI1gnlk7A0mj.jpeg" width="400"/>

当事件被触发时 `event(new \App\Events\OrderUpdated($order))`, broadcastOn 会把 orders 频道里的数据发送给 pusher .

Channel 可以换成 PrivateChannel 或者 PresenceChannel 来实现不同的功能.

<img src="https://paprika-dev.b0.upaiyun.com/l9l4ZOl6yfJHWwvKUw1J2z615eMcfiPEQRtaAyhX.jpeg" width="400"/>

pusher 最后将数据广播给订阅这个频道的客户端

<img src="https://paprika-dev.b0.upaiyun.com/Nbsl6Yak8fkHdXyjRlfNssjrQyqjaq7YMzssjl34.jpeg" width="400"/>

<br>

## Swift

<br>

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

喵神的 **[[网络请求协议]](https://github.com/MDCC2016/ProtocolNetwork)** 和 Laravel-Echo 实例对比来看:

```php
class OrderUpdated implements ShouldBroadcast
{
  public function broadcastOn()
  {
      return new Channel('orders');
  }
}
                -- laravel
```
```swift
struct UsersRequest:Requests {
    typealias Responses = Users
    func parse(data: Data) -> Users? {
        return Users(data: data)
    }
}
                -- swift
```

其实还可以做进一步的解耦重构, 主要有下面两方面:

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
    
这样, 对于 复杂 缓慢 的请求方式如 Docker , 测试时就可以拦截 request , mock 本地假数据了.

```swift
struct TestRequestSender: RequestSender {
    func send<T : Request>(_ r: T, handler: @escaping (T.Response?) -> Void) {
        switch r.path {
            case "/users/paprika/...":
            ... }}
```

<br>

## Javascript

<br>
JavaScript 也有 Proxy 代理的概念, 同样可以在 web 服务中拦截请求, 实现类似 请求(Requests)和请求方式(RequestSender)之间的解耦.

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

