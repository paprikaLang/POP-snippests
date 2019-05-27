### 一 Laravel-Echo

> Laravel Echo enables real-time web applications through the use of WebSockets and hooks directly into Laravel's event broadcasting features. 

```bash
valet secure echo-push                 //HTTPS
BROADCAST_DRIVER=pusher                //.env -> pusher
composer require pusher/pusher-php-server   //communicate between servers and devices
php artisan make:event OrderUpdated    //create event 
```

生成的 OrderUpdated 事件实现了 `Illuminate\Contracts\Broadcasting\ShouldBroadcast` 协议的 `broadcastOn` 方法.

```php
use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;

class OrderUpdated implements ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;
    public $order;
    public function __construct($order)
    {
        $this->order = $order;
    }
    public function broadcastOn()
    {
        return new PrivateChannel('channel_name');
        //return new PresenceChannel('channel_name');
    }
}
```

```php
namespace Illuminate\Contracts\Broadcasting;
interface ShouldBroadcast
{
	public function broadcastOn();
}
```

`broadcastOn` 的返回值对不同类型的 channel(PrivateChannel 或者 PresenceChannel) 通用; 在 Swift 中函数需要明确返回值类型, 通过 `associatedtype` 也可预设一种通用类型.

当事件被触发时 `event(new \App\Events\OrderUpdated($order))`, `broadcastOn` 会将传递到 `channel_name` 中的 $order 发送给 `pusher` .

`pusher` 最后将数据广播给订阅了这个频道的客户端.

```javascript
const Echo = require('laravel-echo');
window.Pusher = require('pusher-js');

window.Echo = new Echo({
    broadcaster: 'pusher',
    key: '7***',
    cluster: 'mt1',
    encrypted: true
});
window.Echo.channel('channel_name')
            .listen('OrderUpdated',function (e) {
                $('#title').text(e.order.name)
            })
```


<br>


### 二 Swift Protocol

喵神在重构 **[[网络请求协议]](https://github.com/MDCC2016/ProtocolNetwork)** 时对 data 转 model 的方法 `parse` 就应用了一个通用的关联类型 `associatedtype Responses` ，将回调参数 model 进行抽象.

```swift
    protocol Requests {

      var host:String { get }
      var path:String { get }
      var method:HTTPMethods { get }
      var parameter:[String:Any] { get }
     
      associatedtype Responses
      
      func parse(data: Data)->Responses?
    }

    extension Requests{
      func send(handler: @escaping(Responses?)-> Void ) {
        ... ...
        handler(Response.parse(data: data))
      }
    }
        
    struct Users {
      init?(data: Data) { ... }
    } 

    struct UsersRequest:Requests {
      ... ...
      typealias Responses = Users
      func parse(data: Data) -> Users? {
        return Users(data: data)
      }
    }
```

而对于如何请求数据, Request 其实无需知晓, 应该交给抽象的协议 RequestSender 来做.

```swift
UsersRequest(name: "paprika").send { (user) in ... }
 
                      -- 重构前
```

```swift
URLSessionRequestSender().send(UserRequest(name: "paprika")) { user in ... }

                      -- 重构后
```
    
拦截 request 进行测试:

```swift
struct TestRequestSender: RequestSender {
  func send<T : Request>(_ r: T, handler: @escaping (T.Response?) -> Void) {
    switch r.path {
      case "/users/paprika/...":
      ...
    }
  }
}
```

在 JavaScript 中通过 proxy 也能实现上面的 `URLSessionRequestSender`:

```javascript
const Service = createWebService('http:example.com/data');

Service.users().then(json => {
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
URLSessionRequestSender().send(UserRequest(name: "paprika")) { user in ... }    
                      -- Swift

Service.users().then(json => {})
                      -- JavaScript
```


<br>


### 三 Ioc 依赖反转

```javascript
class RedisProvider extends ServiceProvider {
	register() {
		// 绑定到 Ioc 
		this.app.bind('Adonis/Addons/RedisFactory', () => require('../src/RedisFactory'))
		// 实现单例
		this.app.singleton('Adonis/Addons/Redis', (app) => {
			// 配置依赖项: use 获取 Ioc 容器 中的服务类
			const RedisFactory = app.use('Adonis/Addons/RedisFactory')
			const Config = app.use('Adonis/Src/Config')

			const Redis = require('../src/Redis')
			return new Redis(Config, RedisFactory)
		})
		// 取别名
		this.app.alias('Adonis/Addons/Redis', 'Redis')
	}
}
```

通过 ` app.use('Adonis/Addons/Redis') ` 从 Ioc Container 中获取服务类 Redis 时 bind 的回调函数里已经完成了依赖注入, 消费类不必关心这些依赖如何解析, Ioc Container 会自动完成.

如果没有绑定到 Ioc , Laravel 会用反射机制来解析这个实例和依赖. 

```php
	class Bar {}
	class Foo {}
	class Foos{
	    public $bar;
	    public function __construct(Bar $bar)
	    {
	      $this->bar = $bar;
	    }
	}
	// App::bind('Foo',function (){
	//     // dd('call here');
	//     return new Foos(new Bar());
	// });

	Route::get('/index',function (){
	    // dd($foo);
	    dd(app('Foo'));
	});
```

其实依赖反转的原则是 *依赖于抽象而非具体*, 类似 `associatedtype Responses: Decodable` 用抽象的 Contracts 来定义具体的 Bar 如何实现, 这样带来的灵活性非常易于代码的重构.


```php
interface SessionStorage {}
class FileSessionStorage implements SessionStorage {}
class MysqlSessionStorage implements SessionStorage {}

//依赖抽象的 SessionStorage
class Auth{
  protected $session;

  public function __construct( SessionStorage $session ){
    $this->session = $session;
  }
}
//接口不能实例化, 需要一个具体的绑定. 如果想更改SessionStorage的具体实现只需更换这个绑定
App:bind( 'SessionStorage', 'MysqlSessionStorage' );
```


