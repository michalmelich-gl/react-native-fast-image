//
//  FFFastImagePreloaderConfig.m
//  FastImage
//
//  Created by melicmi on 02/04/2019.
//  Copyright © 2019 vovkasm. All rights reserved.
//

#import "FFFastImagePreloaderConfig.h"

@implementation FFFastImagePreloaderConfig

- (instancetype)initWithNamespace:(NSString *)ns cachePath:(NSString *)cachePath maxCacheAge:(NSInteger)maxCacheAge
{
    self = [super init];
    
    if (self) {
        _ns = ns;
        _cachePath = cachePath;
        _maxCacheAge = maxCacheAge;
    }
    
    return self;
}

@end
