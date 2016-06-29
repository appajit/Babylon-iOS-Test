//
//  DataStore.h
//  BabylonTest
//
//  Created by Appaji Tholeti on 26/06/2016.
//  Copyright © 2016 Tholeti Consultyancy Services. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PostsDataStore : NSObject

/**
 *  Archives the posts data info to a file
 *
 *  @param dataObject data object to be saved
 */
-(void) archivePostsData:(id) dataObject;

/**
 *  retrives the posts from the file
 *
 *  @return returns Posts data info object
 */
-(id) unarchivePostsData;


@end