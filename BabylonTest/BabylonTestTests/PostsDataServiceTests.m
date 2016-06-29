//
//  BabylonTestTests.m
//  BabylonTestTests
//
//  Created by Appaji Tholeti on 28/06/2016.
//  Copyright © 2016 Tholeti Consultyancy Services. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "PostsDataService.h"
#import "NetworkManager.h"
#import "PostsDataInfo.h"
#import "User.h"
#import "Post.h"
#import "Comment.h"
#import "PostsDataStore.h"


@interface BabylonTestTests : XCTestCase

@property (nonatomic,strong) id mockNetworkManager;
@property (nonatomic,strong) id mockPostsDataStore;

@property (nonatomic,strong) PostsDataService *postsDataService;


@end

@implementation BabylonTestTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.mockNetworkManager = [OCMockObject niceMockForClass:[NetworkManager class]];
    self.mockPostsDataStore = [OCMockObject niceMockForClass:[PostsDataStore class]];
    self.postsDataService = [[PostsDataService alloc] initWithNetworkManger:self.mockNetworkManager
                             postsDataStore:self.mockPostsDataStore];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void) testGetPostsSuccessfully
{
    //Expectation
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing get posts Works Correctly!"];

    void (^proxyBlock)(NSInvocation *) = ^(NSInvocation *invocation)
    {
        void (^passedBlock)(NSData *data, NetworkErrorType errorType);
        [invocation getArgument:&passedBlock atIndex:4];
        __unsafe_unretained NSString *urlString;
        NSString *dataFileName;
        [invocation getArgument:&urlString atIndex:2];
        if([urlString hasSuffix:@"/posts"])
        {
            dataFileName = @"posts.json";
        }
        else if([urlString hasSuffix:@"/users"])
        {
            dataFileName = @"users.json";
        }
        else if([urlString hasSuffix:@"/comments"])
        {
            dataFileName = @"comments.json";
        }
        
        NSString *filePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:dataFileName];
        
        NSData* jsonData = [NSData dataWithContentsOfFile:filePath];
        passedBlock(jsonData, NetworkErrorType_None);
    };
    [[[self.mockNetworkManager stub] andDo:proxyBlock] asyncDownladDataFromURL:[OCMArg any] enableCaching:NO withCompletionBlock:[OCMArg any]];
    
    
    __block PostsDataInfo *postsInfo;
    __block PostsDataServiceStatus getPostsStatus;
    [self.postsDataService getPostsWithCompletionBlock:^(PostsDataInfo *postsDataInfo, PostsDataServiceStatus status) {
       
        postsInfo = postsDataInfo;
        getPostsStatus = status;
        [expectation fulfill];
    }];
    
    
    [self waitForExpectationsWithTimeout:1 handler:^(NSError *error) {
        
        if(error)
        {
            XCTFail(@"testGetPostsSuccessfully::Expectation Failed with error: %@", error);
        } else {
            
            XCTAssertTrue(postsInfo.posts.count == 2,@"number of posts should be 2");
            XCTAssertTrue(getPostsStatus == PostsDataServiceStatusSuccessful,@"status should be successful");
        }
        
    }];
}

-(void) testGetPostsFailed
{
    //Expectation
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing get posts failed Works Correctly!"];
    
    void (^proxyBlock)(NSInvocation *) = ^(NSInvocation *invocation)
    {
        void (^passedBlock)(NSData *data, NetworkErrorType errorType);
        [invocation getArgument:&passedBlock atIndex:4];
        passedBlock(nil, NetworkErrorType_ServerError);
    };
    [[[self.mockNetworkManager stub] andDo:proxyBlock] asyncDownladDataFromURL:[OCMArg any] enableCaching:NO withCompletionBlock:[OCMArg any]];
    
    
    __block PostsDataInfo *postsInfo;
    __block PostsDataServiceStatus getPostsStatus;
    [self.postsDataService getPostsWithCompletionBlock:^(PostsDataInfo *postsDataInfo, PostsDataServiceStatus status) {
        
        postsInfo = postsDataInfo;
        getPostsStatus = status;
        [expectation fulfill];
    }];
    
    
    [self waitForExpectationsWithTimeout:1 handler:^(NSError *error) {
        
        if(error)
        {
            XCTFail(@"testGetPostsSuccessfully::Expectation Failed with error: %@", error);
        } else {
            
            XCTAssertTrue(postsInfo == nil,@"posts info should be nil");
            XCTAssertTrue(getPostsStatus == PostsDataServiceStatusFailed,@"status should be failed");
        }
        
    }];
}


-(void) testGetPostsFromDataStore
{
    //Expectation
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing get posts  from Data Store Works Correctly!"];
    
    void (^proxyBlock)(NSInvocation *) = ^(NSInvocation *invocation)
    {
        void (^passedBlock)(NSData *data, NetworkErrorType errorType);
        [invocation getArgument:&passedBlock atIndex:4];
        passedBlock(nil, NetworkErrorType_ServerError);
    };
    [[[self.mockNetworkManager stub] andDo:proxyBlock] asyncDownladDataFromURL:[OCMArg any] enableCaching:NO withCompletionBlock:[OCMArg any]];
    
    
    NSError *error;
    NSDictionary *postDictionary = @{@"userId": @1,
                                     @"id": @1,
                                     @"title": @"test_title",
                                     @"body": @"test_body"};
    
    Post *post= [MTLJSONAdapter modelOfClass:[Post class] fromJSONDictionary:postDictionary error:&error];
    NSDictionary *userDictionary = @{@"id": @1,
                                     @"name": @"Leanne Graham",
                                     @"username": @"Bret"};
    User *user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:userDictionary error:&error];
    
    NSDictionary *commentDictionary = @{@"postId": @1,
                                        @"id": @1,
                                        @"name": @"comment_name",
                                        @"body": @"comment_body"};
    Comment *comment = [MTLJSONAdapter modelOfClass:[Comment class] fromJSONDictionary:commentDictionary error:&error];
    PostsDataInfo *postDataInfo = [PostsDataInfo new];
    [postDataInfo prepateInfoWithPosts:@[post] users:@[user] comments:@[comment]];
    [[[self.mockPostsDataStore stub] andReturn:postDataInfo] unarchivePostsData];
    
    __block PostsDataInfo *postsInfo;
    __block PostsDataServiceStatus getPostsStatus;
    [self.postsDataService getPostsWithCompletionBlock:^(PostsDataInfo *postsDataInfo, PostsDataServiceStatus status) {
        
        postsInfo = postsDataInfo;
        getPostsStatus = status;
        [expectation fulfill];
    }];
    
    
    [self waitForExpectationsWithTimeout:1 handler:^(NSError *error) {
        
        if(error)
        {
            XCTFail(@"testGetPostsSuccessfully::Expectation Failed with error: %@", error);
        } else {
            
            XCTAssertTrue(postsInfo.posts.count == 1,@"number of posts should be 1");
            XCTAssertTrue(getPostsStatus == PostsDataServiceStatusFailed,@"status should be failed");

        }
        
    }];
}


@end
