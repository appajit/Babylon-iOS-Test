//
//  PostsService.m
//  BabylonTest
//
//  Created by Appaji Tholeti on 26/06/2016.
//  Copyright © 2016 Tholeti Consultyancy Services. All rights reserved.
//

#import "PostsDataService.h"
#import "NetworkManager.h"
#import "Post.h"
#import "User.h"
#import "Comment.h"
#import "PostsDataStore.h"
#import "PostsDataInfo.h"

//data url
static NSString *const kBaseURL = @"http://jsonplaceholder.typicode.com";
static NSString *const kPostsURL = @"/posts";
static NSString *const kUsersURL = @"/users";
static NSString *const kCommentsURL = @"/comments";


@interface PostsDataService ()

@property (nonatomic,strong) NetworkManager *networkManager;
@property (nonatomic,strong) PostsDataStore *dataStore;
@property (nonatomic,strong) NSArray* posts;
@property (nonatomic,strong) NSArray* users;
@property (nonatomic,strong) NSArray* comments;

@property (nonatomic,copy) DataServiceCompletionBlock completionBlock;

@end

@implementation PostsDataService


-(instancetype) initWithNetworkManger:(NetworkManager*) networkManager
                       postsDataStore:(PostsDataStore*) dataStore
{
    self = [super init];
    if(self)
    {
        _networkManager = networkManager;
        _dataStore = dataStore;
    }
    
    return self;
}


-(void) getPostsWithCompletionBlock:(DataServiceCompletionBlock) completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kBaseURL,kPostsURL];
    self.completionBlock = completionBlock;
   
    __weak typeof(self) weakSelf = self;
    [self.networkManager asyncDownladDataFromURL:urlString
                                   enableCaching:NO
                             withCompletionBlock:^(NSData *data, NetworkErrorType errorType){
                                 
                                 __strong typeof(self) strongSelf = weakSelf;
                                 if(!strongSelf) {
                                     return;
                                 }
                                 
                                 //decode posts data from json
                                 NSArray *posts;
                                 if(errorType == NetworkErrorType_None)
                                 {
                                     posts = [self modelFromData:data withModelClass:[Post class]];
                                 }
                                 
                                 //if posts data is available, fetch users data
                                 if(posts)
                                 {
                                     strongSelf.posts = posts;
                                     [strongSelf getPostUsers];
                                 }
                                 else
                                 {
                                     [strongSelf notifyFailedStatusWithArchivedDataIfAvailable];
                                 }
                                 
                             }];
    
}

-(void) getPostUsers
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kBaseURL,kUsersURL];
    
    __weak typeof(self) weakSelf = self;
    [self.networkManager asyncDownladDataFromURL:urlString
                                   enableCaching:NO
                             withCompletionBlock:^(NSData *data, NetworkErrorType errorType){
                                 
                                 __strong typeof(self) strongSelf = weakSelf;
                                 if(!strongSelf) {
                                     return;
                                 }
                                 
                                 NSArray *users;
                                 if(errorType == NetworkErrorType_None)
                                 {
                                     users = [strongSelf modelFromData:data withModelClass:[User class]];
                                 }
                                 
                                 //if users data is availabled fetch comments data
                                 if(users)
                                 {
                                     strongSelf.users = users;
                                     [strongSelf getPostComments];
                                 }
                                 else
                                 {
                                     [strongSelf notifyFailedStatusWithArchivedDataIfAvailable];
                                 }
                             }];
}


-(void) getPostComments
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kBaseURL,kCommentsURL];
    
    __weak typeof(self) weakSelf = self;
    [self.networkManager asyncDownladDataFromURL:urlString
                                   enableCaching:NO
                             withCompletionBlock:^(NSData *data, NetworkErrorType errorType){
                                 
                                 
                                 __strong typeof(self) strongSelf = weakSelf;
                                 if(!strongSelf) {
                                     return;
                                 }
                                 
                                 NSArray *comments;
                                 if(errorType == NetworkErrorType_None)
                                 {
                                     comments = [strongSelf modelFromData:data withModelClass:[Comment class]];
                                 }
                                 
                                 //if comments are available means all the required information is available.Archive the all
                                 //information  and then notify with succes status.
                                 if(comments)
                                 {
                                     strongSelf.comments = comments;
                                     [strongSelf archivePostsDataAndNotifySuccessStatus];
                                 }
                                 //if  required information is not available notify with failure status.
                                 else
                                 {
                                     [strongSelf notifyFailedStatusWithArchivedDataIfAvailable];
                                 }
                             }];
}



- (id)modelFromData:(NSData*)data
     withModelClass:(Class)modelClass {
    if(modelClass == Nil || data == nil) {
        return nil;
    }
    NSError* jsonError;
    id responseObject;
    NSArray *JSONArray = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingAllowFragments
                                                           error:&jsonError];
    if(jsonError == nil) {
        responseObject = [MTLJSONAdapter modelsOfClass:modelClass
                                         fromJSONArray:JSONArray
                                                 error:&jsonError];
    }
    
    return responseObject;
}

-(void) notifyFailedStatusWithArchivedDataIfAvailable
{
    PostsDataInfo *dataInfo = [self.dataStore unarchivePostsData];
    if(self.completionBlock)
    {
        self.completionBlock(dataInfo,PostsDataServiceStatusFailed);
    }
}

-(void) archivePostsDataAndNotifySuccessStatus
{
    //prepare the posts data info and then archive it.
    PostsDataInfo *postDataInfo = [PostsDataInfo new];
    [postDataInfo prepateInfoWithPosts:self.posts users:self.users comments:self.comments];
    [self.dataStore archivePostsData:postDataInfo];
    if(self.completionBlock)
    {
        self.completionBlock(postDataInfo,PostsDataServiceStatusSuccessful);
    }
}


@end
