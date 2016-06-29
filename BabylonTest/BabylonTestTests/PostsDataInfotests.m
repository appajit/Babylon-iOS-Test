//
//  PostsDataInfotests.m
//  BabylonTest
//
//  Created by Appaji Tholeti on 28/06/2016.
//  Copyright © 2016 Tholeti Consultyancy Services. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "PostsDataInfo.h"
#import "User.h"
#import "Post.h"
#import "Comment.h"


@interface PostsDataInfotests : XCTestCase

@property (nonatomic,strong) PostsDataInfo *postsDataInfo;

@end

@implementation PostsDataInfotests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
     self.postsDataInfo = [PostsDataInfo new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void) testPostsDataInfoReturnsCorrectPosts
{
    
    NSString *filePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"posts.json"];
    NSData* jsonData = [NSData dataWithContentsOfFile:filePath];
    NSArray *posts = [self modelFromData:jsonData withModelClass:[Post class]];
    
    filePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"users.json"];
    jsonData = [NSData dataWithContentsOfFile:filePath];
    NSArray *users = [self modelFromData:jsonData withModelClass:[User class]];
    
    filePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"comments.json"];
    jsonData = [NSData dataWithContentsOfFile:filePath];
    NSArray *comments = [self modelFromData:jsonData withModelClass:[Comment class]];
    
    [self.postsDataInfo prepateInfoWithPosts:posts users:users comments:comments];
    
    Post *post = self.postsDataInfo.posts[1];
    User *user = [self.postsDataInfo userForPost:post];
    NSArray *postComments = [self.postsDataInfo commentsForPost:post];
    
    XCTAssertTrue(self.postsDataInfo.posts.count == 2, @"posts count should be 2");
    XCTAssertTrue([user.name isEqualToString:@"Ervin Howell"], @"user id should be 2");
    XCTAssertTrue(postComments.count == 2, @"comments count should be 2");
                                                        
    
    
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

@end
