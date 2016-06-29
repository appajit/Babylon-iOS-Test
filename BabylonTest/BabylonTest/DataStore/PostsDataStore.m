//
//  DataStore.m
//  BabylonTest
//
//  Created by Appaji Tholeti on 26/06/2016.
//  Copyright © 2016 Tholeti Consultyancy Services. All rights reserved.
//

#import "PostsDataStore.h"

static NSString * const kDataArchiveFileName = @"postsDataInfo";

@implementation PostsDataStore


-(NSString*) archiveFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *path= [documentsPath stringByAppendingPathComponent:kDataArchiveFileName];
    return path;
}

-(void) archivePostsData:(id) dataObject
{
    [NSKeyedArchiver archiveRootObject:dataObject toFile:[self archiveFilePath]];
}


-(id) unarchivePostsData
{
    id unarchiveObject = [NSKeyedUnarchiver unarchiveObjectWithFile:[self archiveFilePath]];
    return unarchiveObject;
}



@end
