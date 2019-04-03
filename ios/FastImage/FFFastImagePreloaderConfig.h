//
//  FFFastImagePreloaderConfig.h
//  FastImage
//
//  Created by melicmi on 02/04/2019.
//  Copyright © 2019 vovkasm. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FFFastImagePreloaderConfig : NSObject
@property (nonatomic, strong, nullable) NSString *ns;
@property (nonatomic, strong, nullable) NSString *cachePath;
@property (nonatomic, assign) NSInteger maxCacheAge;

- (instancetype)initWithNamespace:(nullable NSString *)ns cachePath:(nullable NSString *)cachePath maxCacheAge:(NSInteger)maxCacheAge;

@end

NS_ASSUME_NONNULL_END
