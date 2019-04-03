#import <React/RCTConvert.h>

@class FFFastImageSource;
@class FFFastImagePreloaderConfig;

@interface RCTConvert (FFFastImage)

+ (FFFastImageSource *)FFFastImageSource:(id)json;
+ (FFFastImagePreloaderConfig *)FFFastImagePreloaderConfig:(id)json;

@end
