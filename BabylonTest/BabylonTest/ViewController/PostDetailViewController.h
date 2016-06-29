//
//  DetailViewController.h
//  BabylonTest
//
//  Created by Appaji Tholeti on 25/06/2016.
//  Copyright © 2016 Tholeti Consultyancy Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PostsDataService;
@class Post;
@class User;

@interface PostDetailViewController : UIViewController

/**
 *  configures the selected post details in the UI
 *
 *  @param post     selected post
 *  @param user     selected post user
 *  @param comments post specific comments
 */
-(void) configurePost:(Post*) post
             withUser:(User*) user
             withComments:(NSArray*) comments;
@end

