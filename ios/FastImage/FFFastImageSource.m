#import "FFFastImageSource.h"

@implementation FFFastImageSource

- (instancetype)initWithURL:(NSURL *)url
                placeholder:(NSURL *)placeholder
                   priority:(FFFPriority)priority
                    headers:(NSDictionary *)headers
{
    self = [super init];
    if (self) {
        _uri = url;
        _placeholder = placeholder;
        _priority = priority;
        _headers = headers;
    }
    return self;
}

@end
