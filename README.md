# POPDemo

![](https://ws4.sinaimg.cn/large/006tNc79gy1fjxjf4u1guj310o0ic3zr.jpg)

Demo含重构前(Requests.swift)和重构后(Request.swift)的代码,重构的思想类似APIKit的核心思想:Type-safe networking abstraction layer that associates request type with response type.这样设计是为了对发送请求的类只需要传入一个请求就能得到请求对应的模型;并且高度解耦使得请求方法或请求定义的改变都不会影响另一方,非常易于测试和扩展.

![](https://ws1.sinaimg.cn/large/006tNc79ly1fk4nj5awkmj319o0t4abw.jpg)

在Laravel的框架中,Service Container,Service Provider,Facades,Contracts(图中四个$data是等价的)也一同实现了面向协议最核心的思想.

 - 易于维护:与Facades不同,需要声明对协议的依赖,而协议的内部遵守的方法一目了然.
 - 解耦:只要绑定一串关键字('config')无需关心协议是谁实现的,怎么实现的.易于测试和重构.
 - 实现灵活:在Service Provider的register方法里根据不同的配置环境返回不同的Resolved Class实现协议.
 
Laravel的这些特点正是上面的Swift Demo所追求的.不同语言之间的借鉴和启发是一件很快乐的事.

