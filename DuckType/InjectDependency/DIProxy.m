//
//  DIProxy.m
//  DuckType
//
//  Created by paprika on 2017/12/27.
//  Copyright © 2017年 paprika. All rights reserved.
//

#import "DIProxy.h"
@import ObjectiveC;
@interface DIProxy : NSProxy <DIProxy>
@property (nonatomic, strong) NSMutableDictionary *implementations;
- (id)init;
@end

@implementation DIProxy

id DIProxyCreate(){
    
    return [[DIProxy alloc] init];
}

- (id)init
{
    self.implementations = [NSMutableDictionary dictionary];
    return self;
}

- (void)injectDependencyObject:(id)object forProtocol:(Protocol *)protocol{
    NSParameterAssert(object && protocol);
    NSAssert([object conformsToProtocol:protocol], @"object %@ does not conform to protocol:%@",object,protocol);
    //字典由protocol做key,被注入对象做value
    self.implementations[NSStringFromProtocol(protocol)] = object;
}

#pragma mark - Message forwarding

- (BOOL)conformsToProtocol:(Protocol *)aProtocol
{
    for (NSString *protocolName in self.implementations.allKeys) {
        if (protocol_isEqual(aProtocol, NSProtocolFromString(protocolName))) {
            return YES;
        }
    }
    return [super conformsToProtocol:aProtocol];
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    for (id object in self.implementations.allValues) {
        //如果这个对象有sel方法可以响应,执行
        if ([object respondsToSelector:sel]) {
            return [object methodSignatureForSelector:sel];
        }
    }
    return [super methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation{
    for (id object in self.implementations.allValues) {
        if ([object respondsToSelector:invocation.selector]) {
            [invocation invokeWithTarget:object];
            return;
        }
    }
    [super forwardInvocation:invocation];
}


































@end
