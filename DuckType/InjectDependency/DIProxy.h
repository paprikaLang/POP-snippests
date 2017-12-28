//
//  DIProxy.h
//  DuckType
//
//  Created by paprika on 2017/12/27.
//  Copyright © 2017年 paprika. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DIProxy <NSObject>
- (void)injectDependencyObject:(id)object forProtocol:(Protocol *)protocol;
@end
