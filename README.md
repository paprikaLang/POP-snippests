# POPDemo

## Swift

![](https://paprika-dev.b0.upaiyun.com/kYmMCvuTxDgUNhAXNPXFaPjjDjnBC0lrrK2GI8cw.jpeg)

通过对比重构前(Requests.swift)和重构后(Request.swift)的代码,可以帮助理解Swift和APIKit的面向接口编程的核心思想:
```
Type-safe networking abstraction layer that associates request type with response type.
```
对发送请求的类只需要传入一个请求就能得到请求对应的模型,请求方法和请求定义高度解耦,任何一方的改变都不会影响另一方,非常易于**测试**和**扩展**.

[通过struct, enum, protocol分别对代码重构达成易于测试和Type-safe的效果](https://github.com/paprikaLang/DeepEmbedding)


## PHP

![](https://paprika-dev.b0.upaiyun.com/Y4BUXXgzCtjlIqPaNpOBO62c7VLkiLM5VtOen7eX.jpeg)

 Laravel非常优秀的特点是面向接口和封装,和Swift-Protocol实现的原理都滥觞于ISP ---- 接口依赖隔离.
 
**Contracts** :

 - 易于维护:与Facades不同,协议需要声明,查看协议的方法简单清晰,一目了然.
 - 解耦:只要绑定一串关键字('config')无需关心协议是谁实现的,怎么实现的.易于测试和重构.
 - 实现灵活:在Service Provider的register方法里根据不同的配置环境返回不同的Resolved Class实现协议.
 
**Service Container** : IOC控制反转是指消费类不需要自己创建所需的服务,只要提出来可由服务容器解析具体对象.


**Service Provider** : 在register方法中绑定字符串,返回Resolved Class.消费类引入字符串即可,无需绑定引入的类所需的依赖.


**Facades** : 通过自定义Facades类,在getFacadeAccessor方法中返回绑定好的字符串,可以这样调用对象的方法:
Config::get('database.default');


![](https://paprika-dev.b0.upaiyun.com/QhMU4vxMacXflvr86V9nX5mVtVoga4s1KDQs7gHl.jpeg)



