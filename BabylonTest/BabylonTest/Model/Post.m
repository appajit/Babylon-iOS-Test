//
//  Post.m
//  BabylonTest
//
//  Created by Appaji Tholeti on 26/06/2016.
//  Copyright © 2016 Tholeti Consultyancy Services. All rights reserved.
//

#import "Post.h"

@implementation Post

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"userId"    : @"userId",
             @"postId"    : @"id",
             @"title"    : @"title",
             @"message"    : @"body"
             };
}



@end
