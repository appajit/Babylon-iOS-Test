//
//  PostsService.h
//  BabylonTest
//
//  Created by Appaji Tholeti on 26/06/2016.
//  Copyright © 2016 Tholeti Consultyancy Services. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,PostsDataServiceStatus)
{
    PostsDataServiceStatusSuccessful,
    PostsDataServiceStatusFailed
};

@class NetworkManager;
@class PostsDataInfo;
@class PostsDataStore;

typedef void(^DataServiceCompletionBlock)(PostsDataInfo* postsDataInfo,PostsDataServiceStatus status);


@interface PostsDataService : NSObject

/**
 *  initializer of the service
 *
 *  @param networkManager network manager to handle http requests
 *
 *  @return returns instance object
 */
-(instancetype) initWithNetworkManger:(NetworkManager*) networkManager
                       postsDataStore:(PostsDataStore*) dataStore;

/**
 *  Fetches the posts data info from the server.In case of any server error, returns
 *  archived data if it is available
 *
 *  @param completionBlock completion block to notify when data fectching is completed
 */
-(void) getPostsWithCompletionBlock:(DataServiceCompletionBlock) completionBlock;

@end
