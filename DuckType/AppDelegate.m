//
//  AppDelegate.m
//  DuckType
//
//  Created by paprika on 2017/12/26.
//  Copyright © 2017年 paprika. All rights reserved.

#import "AppDelegate.h"
#import "ManEntity.h"
#import "BoyEntity.h"
#import "DIProxy.h"
#import "Test.h"
#import "JsonDuck.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

extern id JsonDuckCreateWithJson(NSString *json);

- (void)duckTypeDemo{
    
    NSString *json = @"{\"name\": \"paprika\", \"sex\": \"boy\", \"age\": 27,\"school\":2,\"teacher\": \"Mr.Wu\"}";
    
    JsonDuck<BoyEntity,ManEntity> *man= JsonDuckCreateWithJson(json);
    NSLog(@"%@",man.jsonString);
    
    NSObject<BoyEntity,ManEntity> *obj= JsonDuckCreateWithJson(json);
    NSLog(@"%@, %@,",obj.name, obj.age);
    
    obj.name = @"east north";
    obj.age = @100;
    NSLog(@"%@, %@", obj.name, obj.age);
    
    NSNumber<BoyEntity,ManEntity> *num= JsonDuckCreateWithJson(json);
    NSLog(@"%@, %@", num.school, num.teacher);
    NSLog(@"%@, %@", num.name, num.age);
    
}

extern id DIProxyCreate(void);

- (void)injectDepDemo{
    
    林志玲 *implementA = [林志玲 new];
    凤姐 *implementB = [凤姐 new];
    
    id<GirlFriend, DIProxy> proxy = DIProxyCreate();
    [proxy injectDependencyObject:implementA forProtocol:@protocol(GirlFriend)];
    [proxy kiss];
    [proxy injectDependencyObject:implementB forProtocol:@protocol(GirlFriend)];
    [proxy kiss];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self duckTypeDemo];
    [self injectDepDemo];
    
    return YES;
}
@end
