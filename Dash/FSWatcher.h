//
//  FSWatcher.h
//  Dash
//
//  Created by Sidney on 8/18/17.
//  Copyright © 2017 Sidney San Martín. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSWatcher : NSObject
- (instancetype)initWithPaths:(NSArray<NSString*>*)paths cb:(void(^)(void))cb;
@end
