//
//  NetworkManager.m
//  BabylonTest
//
//  Created by Appaji Tholeti on 25/06/2016.
//  Copyright © 2016 Tholeti Consultyancy Services. All rights reserved.
////

#import "NetworkManager.h"

@interface NetworkManager ()
@property (atomic, strong) dispatch_queue_t dispatchQueue;
@property (atomic, strong) NSURLSession *urlCachedSession;
@property (atomic, strong) NSURLSession *defaultSession;


@end

@implementation NetworkManager

+ (NetworkManager*)sharedInstance; {

    //to make sure that only one is created and shared.
    static dispatch_once_t once;
    static NetworkManager* sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        
    });
    return sharedInstance;
}


-(instancetype) init
{
    self = [super init];
    if(self)
    {
        //queue to serialise the network calls
        _dispatchQueue = dispatch_queue_create("NetworkSerialQueue", DISPATCH_QUEUE_SERIAL);
        NSURLSessionConfiguration *cachedSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        cachedSessionConfiguration.requestCachePolicy = NSURLRequestReturnCacheDataElseLoad;
        
        //cached session to cache the url responses.
        _urlCachedSession = [NSURLSession sessionWithConfiguration:cachedSessionConfiguration];
        NSURLSessionConfiguration *defaultSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultSessionConfiguration.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
        //default session without any caching
        _defaultSession = [NSURLSession sessionWithConfiguration:defaultSessionConfiguration];
    }
    
    return self;
}

-(void) asyncDownladDataFromURL:(NSString*) urlString
                  enableCaching:(BOOL) enableCaching
            withCompletionBlock:(NetworkManagerCompletionBlock) completionBlock
{
    dispatch_async(_dispatchQueue, ^{
        
        //prepare url from the given url string
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSession *urlSession = enableCaching? self.urlCachedSession:self.defaultSession;
      
        __weak typeof(self) weakSelf = self;
        NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request
                                                       completionHandler:^(NSData * _Nullable data,
                                                                           NSURLResponse * _Nullable response,
                                                                           NSError * _Nullable error) {
                                                           
                                                           
                                                           __strong typeof(self) strongSelf = weakSelf;
                                                           if (strongSelf)
                                                           {
                                                               //prepare the error type if any
                                                               NetworkErrorType errorType = [strongSelf errorTypeFromResponse:response
                                                                                                                        error:error];
                                                               if(completionBlock)
                                                               {
                                                                   completionBlock(data,errorType);
                                                               }
                                                           }
                                                       }];
        [dataTask resume];
    });
}



-(NetworkErrorType) errorTypeFromResponse:(NSURLResponse*) response error:(NSError*) error
{
    NSUInteger statusCode = [(NSHTTPURLResponse*) response statusCode];
    //successful resonse
    if (error == nil && (statusCode >= 200 && statusCode <= 299))
    {
        return NetworkErrorType_None;
    }
    
    //internet is not available
    if(error.code == kCFURLErrorNotConnectedToInternet)
    {
        return  NetworkErrorType_InternetNotAvailable;
    }
    
    //server returns non 2xx server error
    return NetworkErrorType_ServerError;
}

@end

