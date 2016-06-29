//
//  PostModelTests.m
//  BabylonTest
//
//  Created by Appaji Tholeti on 28/06/2016.
//  Copyright © 2016 Tholeti Consultyancy Services. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Post.h"

@interface PostModelTests : XCTestCase

@property (nonatomic,strong) Post *post;

@end

@implementation PostModelTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}



-(void) testPostModel
{
    NSError *error;
    NSDictionary *postDictionary = @{@"userId": @11,
                                     @"id": @12,
                                     @"title": @"test_title",
                                     @"body": @"test_body"};
    
    Post *post= [MTLJSONAdapter modelOfClass:[Post class] fromJSONDictionary:postDictionary error:&error];
    XCTAssertTrue([post.title isEqualToString:@"test_title"], @"title is incorrect");
    XCTAssertTrue([post.message isEqualToString:@"test_body"], @"body is incorrect");
    XCTAssertTrue(post.userId == 11 , @"user id is incorrect");
    XCTAssertTrue(post.postId== 12, @"post id  is incorrect");
    
}

@end
