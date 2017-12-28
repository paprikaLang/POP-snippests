//
//  ManEntity.h
//  DuckType
//
//  Created by paprika on 2017/12/27.
//  Copyright © 2017年 paprika. All rights reserved.
//
// 无需实体类，只需要协议
@protocol ManEntity <NSObject>//伪继承
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *age; // 要用基本类型需要实现自动拆装箱
-(void)coding;
@end
