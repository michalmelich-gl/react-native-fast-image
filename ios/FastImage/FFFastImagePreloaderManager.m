#import "FFFastImagePreloaderManager.h"
#import "FFFastImagePreloader.h"
#import "FFFastImageSource.h"

@implementation FFFastImagePreloaderManager
{
    bool _hasListeners;
    NSMutableDictionary* _preloaders;
}

RCT_EXPORT_MODULE(FastImagePreloaderManager);

- (dispatch_queue_t)methodQueue
{
    return dispatch_queue_create("com.dylanvann.fastimage.FastImagePreloaderManager", DISPATCH_QUEUE_SERIAL);
}

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

-(instancetype) init {
    if (self = [super init]) {
        _preloaders = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"fffastimage-progress", @"fffastimage-complete"];
}

- (void) imagePrefetcher:(nonnull SDWebImagePrefetcher *)imagePrefetcher
 didFinishWithTotalCount:(NSUInteger)totalCount
            skippedCount:(NSUInteger)skippedCount
{
    NSNumber* id = ((FFFastImagePreloader*) imagePrefetcher).id;
    [_preloaders removeObjectForKey:id];
    [self sendEventWithName:@"fffastimage-complete"
                       body:@{ @"id": id, @"finished": [NSNumber numberWithLong:totalCount], @"skipped": [NSNumber numberWithLong:skippedCount]}
     ];
}

- (void) imagePrefetcher:(nonnull SDWebImagePrefetcher *)imagePrefetcher
          didPrefetchURL:(nullable NSURL *)imageURL
           finishedCount:(NSUInteger)finishedCount
              totalCount:(NSUInteger)totalCount
{
    NSNumber* id = ((FFFastImagePreloader*) imagePrefetcher).id;
    [self sendEventWithName:@"fffastimage-progress"
                       body:@{ @"id": id, @"finished": [NSNumber numberWithLong:finishedCount], @"total": [NSNumber numberWithLong:totalCount] }
     ];
}

RCT_EXPORT_METHOD(createPreloader:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    FFFastImagePreloader* preloader = [[FFFastImagePreloader alloc] init];
    preloader.delegate = self;
    _preloaders[preloader.id] = preloader;
    resolve(preloader.id);
}

RCT_EXPORT_METHOD(preload:(nonnull NSNumber*)preloaderId sources:(nonnull NSArray<FFFastImageSource *> *)sources cacheControl:(FFFCacheControl)cacheControl) {
    NSMutableArray *urls = [NSMutableArray arrayWithCapacity:sources.count];
    
    [sources enumerateObjectsUsingBlock:^(FFFastImageSource * _Nonnull source, NSUInteger idx, BOOL * _Nonnull stop) {
        [source.headers enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString* header, BOOL *stop) {
            [[SDWebImageDownloader sharedDownloader] setValue:header forHTTPHeaderField:key];
        }];
        [urls setObject:source.url atIndexedSubscript:idx];
    }];
    
    SDWebImageOptions options = SDWebImageLowPriority;
    
    switch (cacheControl) {
        case FFFCacheControlWeb:
            options |= SDWebImageRefreshCached;
            break;
        case FFFCacheControlCacheOnly:
            options |= SDWebImageCacheMemoryOnly;
            break;
        case FFFCacheControlImmutable:
            break;
    }
    
    FFFastImagePreloader* preloader = _preloaders[preloaderId];
    preloader.options = options;
    
    [preloader prefetchURLs:urls];
}

RCT_EXPORT_METHOD(cancelPreload:(nonnull NSNumber*)preloaderId) {
    FFFastImagePreloader* preloader = _preloaders[preloaderId];
    [preloader cancelPrefetching];
}

@end
