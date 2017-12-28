//
//  JsonDuck.m
//  DuckType
//
//  Created by paprika on 2017/12/26.
//  Copyright © 2017年 paprika. All rights reserved.
//

#import "JsonDuck.h"

@interface JsonDuck()
@property(nonatomic,strong)NSMutableDictionary *innerDic;
@end

@implementation JsonDuck
@synthesize jsonString = _jsonString;

id JsonDuckCreateWithJson(NSString *json){
    return [[JsonDuck alloc] initWithJsonString:json];
}

-(instancetype)initWithJsonString:(NSString *)json{
    if (json) {
        self->_jsonString = [json copy];
        NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            self.innerDic = [jsonObject mutableCopy];
        }
        return self;
    }
    return nil;
}

-(NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    SEL changedSel = sel;
    if ([self propertyNameScanFromGetterSel:sel]) {
        changedSel = @selector(objectForKey:);
    }else if([self propertyNameScanFromSetterSel:sel]){
        changedSel = @selector(setObject:forKey:);
    }
    //此句代表这个类的innerDic属性将接受消息并执行objectForKey或者setObject:forKey:方法
    NSMethodSignature *sign = [[self.innerDic class]
                               instanceMethodSignatureForSelector:changedSel];
    return sign;
}

-(void)forwardInvocation:(NSInvocation *)invocation{
    NSString *propertyName = nil;
    propertyName = [self propertyNameScanFromGetterSel:invocation.selector];
    if (propertyName) {
        invocation.selector = @selector(objectForKey:);
        [invocation setArgument:&propertyName atIndex:2];
        [invocation invokeWithTarget:self.innerDic];
        return;
    }
    propertyName = [self propertyNameScanFromSetterSel:invocation.selector];
    if (propertyName) {
        invocation.selector = @selector(setObject:forKey:);
        [invocation setArgument:&propertyName atIndex:3];
        [invocation invokeWithTarget:self.innerDic];
        return;
    }
    [super forwardInvocation:invocation];
}

#pragma mark - Helpers
- (NSString *)propertyNameScanFromGetterSel:(SEL)sel{
    NSString *selName = NSStringFromSelector(sel);
    NSUInteger parameterCount = [[selName componentsSeparatedByString:@":"] count] -1;
    if (parameterCount == 0) {
        return selName;
    }
    return nil;
}

- (NSString *)propertyNameScanFromSetterSel:(SEL)sel{
    
    NSString *selName = NSStringFromSelector(sel);
    NSUInteger parameterCount = [[selName componentsSeparatedByString:@":"] count] - 1;
    if ([selName hasPrefix:@"set"] && parameterCount == 1) {
        NSUInteger firstColonLocation = [selName rangeOfString:@":"].location;
        return [selName substringWithRange:NSMakeRange(3, firstColonLocation-3)].lowercaseString;
    }
    return nil;
}

@end




































