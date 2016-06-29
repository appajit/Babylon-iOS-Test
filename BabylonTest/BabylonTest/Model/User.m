//
//  User.m
//  BabylonTest
//
//  Created by Appaji Tholeti on 26/06/2016.
//  Copyright © 2016 Tholeti Consultyancy Services. All rights reserved.
//

#import "User.h"

@implementation User

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"userId"    : @"id",
             @"name"    : @"name"
             };
}
@end
