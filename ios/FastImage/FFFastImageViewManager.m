#import "FFFastImageViewManager.h"
#import "FFFastImageView.h"
#import <SDWebImage/SDWebImageManager.h>

@interface FFFastImageViewManager ()
@property (nonatomic, strong) SDWebImageManager *imageManager;
@end

@implementation FFFastImageViewManager

RCT_EXPORT_MODULE(FastImageView)

- (FFFastImageView*)view {
    
    return [[FFFastImageView alloc] init];
}

RCT_EXPORT_VIEW_PROPERTY(source, FFFastImageSource)
RCT_EXPORT_VIEW_PROPERTY(placeholder, FFFastImageSource)
RCT_EXPORT_VIEW_PROPERTY(resizeMode, RCTResizeMode)
RCT_EXPORT_VIEW_PROPERTY(onFastImageLoadStart, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onFastImageProgress, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onFastImageError, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onFastImageLoad, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onFastImageLoadEnd, RCTDirectEventBlock)

RCT_EXPORT_METHOD(addReadOnlyCachePath:(NSString *)cachePath)
{
    [[SDImageCache sharedImageCache] addReadOnlyCachePath:cachePath];
}

@end

