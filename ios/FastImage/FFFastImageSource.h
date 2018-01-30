#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FFFPriority) {
    FFFPriorityLow,
    FFFPriorityNormal,
    FFFPriorityHigh
};

typedef NS_OPTIONS(NSUInteger, FFFOptions) {
    FFFOptionsNone                 = 0,
    FFFOptionsRefreshCachedImage   = 1 << 0
};

/**
 * Object containing an image URL and associated metadata.
 */
@interface FFFastImageSource : NSObject

@property (nonatomic) NSURL* uri;
@property (nonatomic) NSURL* placeholder;
@property (nonatomic) FFFPriority priority;
@property (nonatomic) FFFOptions options;
@property (nonatomic) NSDictionary *headers;

- (instancetype)initWithURL:(NSURL *)url
                placeholder:(NSURL *)placeholder
                   priority:(FFFPriority)priority
                    headers:(NSDictionary *)headers
                    options:(FFFOptions)options;

@end
