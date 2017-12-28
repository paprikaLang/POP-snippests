//
//  JsonDuck.h
//  DuckType
//
//  Created by paprika on 2017/12/26.
//  Copyright © 2017年 paprika. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonDuck : NSProxy
@property (nonatomic, copy, readonly) NSString *jsonString;
@end

