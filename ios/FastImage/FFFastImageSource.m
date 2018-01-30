#import "FFFastImageSource.h"

@implementation FFFastImageSource

- (instancetype)initWithURL:(NSURL *)url
                placeholder:(NSURL *)placeholder
                   priority:(FFFPriority)priority
                    headers:(NSDictionary *)headers
{
    return [self initWithURL:url placeholder:placeholder priority:priority headers:headers options:FFFOptionsNone];
}

- (instancetype)initWithURL:(NSURL *)url
                placeholder:(NSURL *)placeholder
                   priority:(FFFPriority)priority
                    headers:(NSDictionary *)headers
                    options:(FFFOptions)options
{
    self = [super init];
    if (self) {
        _uri = url;
        _placeholder = placeholder;
        _priority = priority;
        _headers = headers;
        _options = options;
    }
    return self;
}

@end
