//
//  Posts.m
//  BabylonTest
//
//  Created by Appaji Tholeti on 26/06/2016.
//  Copyright © 2016 Tholeti Consultyancy Services. All rights reserved.
//

#import "PostsDataInfo.h"
#import "Post.h"
#import "User.h"
#import "Comment.h"


static NSString *const kPostsDataKey = @"PostsKey";
static NSString *const kUsersDataKey = @"UsersKey";
static NSString *const kCommentsDataKey = @"CommentsKey";


@interface PostsDataInfo ()

@property (nonatomic,strong,readwrite) NSArray *posts;
@property (nonatomic,strong) NSDictionary *users;
@property (nonatomic,strong) NSDictionary *postComments;



@end

@implementation PostsDataInfo




-(instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        _posts = [aDecoder decodeObjectForKey:kPostsDataKey];
        _users = [aDecoder decodeObjectForKey:kUsersDataKey];
        _postComments = [aDecoder decodeObjectForKey:kCommentsDataKey];
    }
    
    return self;
}


-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.posts forKey:kPostsDataKey];
    [aCoder encodeObject:self.users forKey:kUsersDataKey];
    [aCoder encodeObject:self.postComments forKey:kCommentsDataKey];
}


-(void) prepateInfoWithPosts:(NSArray*) posts
                       users:(NSArray*) users
                    comments:(NSArray*) comments
{
    
    NSMutableDictionary *postCommentsDictionary = [NSMutableDictionary dictionary];
    //for each post prepare its corresponding comments list
    for (Post *post in posts)
    {
        NSMutableArray *postComments = [NSMutableArray array];
        for (Comment *comment in comments)
        {
            if(comment.postId == post.postId)
            {
                [postComments addObject:comment];
            }
        }
        postCommentsDictionary[@(post.postId)] = postComments;
    }
    
    //prepates the users dictionary with user id as a key for search criteria
    NSMutableDictionary *usersDictionary =  [NSMutableDictionary dictionary];
    for (User *user in users)
    {
        usersDictionary[@(user.userId)] = user;
    }
    self.posts = posts;
    self.postComments = postCommentsDictionary;
    self.users = usersDictionary;
}

-(NSArray*) commentsForPost:(Post*) post
{
    NSArray *comments = self.postComments[@(post.postId)];
    return  comments;
}

-(User*) userForPost:(Post*) post
{
    User *user = self.users[@(post.userId)];
    return user;
    
}



@end
