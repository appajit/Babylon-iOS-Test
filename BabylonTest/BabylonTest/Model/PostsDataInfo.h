//
//  Posts.h
//  BabylonTest
//
//  Created by Appaji Tholeti on 26/06/2016.
//  Copyright © 2016 Tholeti Consultyancy Services. All rights reserved.
//

#import "Mantle.h"

@class Post;
@class User;

@interface PostsDataInfo : NSObject<NSCoding>

/**
 *  posts lists
 */
@property (nonatomic,strong,readonly) NSArray *posts;

/**
 *  prepares posts with it respective comments list and user info
 *
 *  @param posts    posts list
 *  @param users    users list
 *  @param comments comments list
 */
-(void) prepateInfoWithPosts:(NSArray*) posts
                               users:(NSArray*) users
                            comments:(NSArray*) comments;

/**
 *  provides the lists of comments for the given post
 *
 *  @param post post object
 *
 *  @return list of comments for the given post
 */
-(NSArray*) commentsForPost:(Post*) post;

/**
 *  provides the user info for the given post
 *
 *  @param post post
 *
 *  @return user object posted the post
 */
-(User*) userForPost:(Post*) post;

@end
