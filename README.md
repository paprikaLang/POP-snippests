# POPDemo

![](https://ws3.sinaimg.cn/large/006tNc79ly1fjx9ibxe9ij31ck0ou0um.jpg)


Demo含有重构前(Requests.swift)和重构后(Request.swift)的代码,重构思想类似APIKit的核心思想:Type-safe networking abstraction layer that associates request type with response type.这样做是为了发送请求的类只需要传入一个请求就能得到请求对应的模型,高度解耦使得请求方法或请求定义的改变都不会影响另一方,易于测试和扩展.

