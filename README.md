# POPDemo

![](https://ws3.sinaimg.cn/large/006tNc79ly1fjxj9hq3jqj31ck0ou0um.jpg)

Demo含重构前(Requests.swift)和重构后(Request.swift)的代码,重构的思想类似APIKit的核心思想:Type-safe networking abstraction layer that associates request type with response type.这样设计是为了对发送请求的类只需要传入一个请求就能得到请求对应的模型;并且高度解耦使得请求方法或请求定义的改变都不会影响另一方,非常易于测试和扩展.

