//
//  Test.h
//  DuckType
//
//  Created by paprika on 2017/12/27.
//  Copyright © 2017年 paprika. All rights reserved.
//
#import <Foundation/Foundation.h>

// Protocol
@protocol GirlFriend <NSObject>

- (void)kiss;

@end


// Imp A
@interface 林志玲 : NSObject <GirlFriend>
@end

@implementation 林志玲

- (void)kiss
{
    NSLog(@"林志玲 kissed me");
}

@end

// Imp B
@interface 凤姐 : NSObject <GirlFriend>
@end

@implementation 凤姐

- (void)kiss
{
    NSLog(@"凤姐 kissed me");
}

@end
