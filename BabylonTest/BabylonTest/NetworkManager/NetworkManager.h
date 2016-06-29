//
//  NetworkManager.h
//  BabylonTest
//
//  Created by Appaji Tholeti on 25/06/2016.
//  Copyright © 2016 Tholeti Consultyancy Services. All rights reserved.
////
#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger,NetworkErrorType)
{
    NetworkErrorType_None,//no error
    NetworkErrorType_InternetNotAvailable,// offline
    NetworkErrorType_ServerError // server error
};

typedef void(^NetworkManagerCompletionBlock)(NSData *data, NetworkErrorType errorType);

@interface NetworkManager : NSObject

/**
 *  Shared instance of Network manager
 * .
 *
 *  @returns instance object
 */
+ (NetworkManager*)sharedInstance;
/**
 *  downloads the data asynchronously.if caching is enabled,the url response is cached to avoid 
 *  downdloading again if the response data is available.
 *
 *  @param urlString  url from which data to be downloaded
 *
 *
 *  @param competionBlock  block to be called on download completion
 */
-(void) asyncDownladDataFromURL:(NSString*) urlString
                  enableCaching:(BOOL) enableCaching
             withCompletionBlock:(NetworkManagerCompletionBlock) completionBlock;

@end
