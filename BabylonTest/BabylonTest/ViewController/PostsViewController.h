//
//  MasterViewController.h
//  BabylonTest
//
//  Created by Appaji Tholeti on 25/06/2016.
//  Copyright © 2016 Tholeti Consultyancy Services. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostsDataService.h"

@class PostDetailViewController;

@interface PostsViewController : UITableViewController

@property (strong, nonatomic) PostDetailViewController *detailViewController;

/**
 *  API to inject Posts data service to fetch the data
 *
 *  @param dataService Posts data service object
 */
-(void) injectDataService:(PostsDataService*) dataService;


@end

