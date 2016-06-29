//
//  Comment.h
//  BabylonTest
//
//  Created by Appaji Tholeti on 26/06/2016.
//  Copyright © 2016 Tholeti Consultyancy Services. All rights reserved.
//

#import "Mantle.h"

@interface Comment : MTLModel <MTLJSONSerializing>

@property (nonatomic,readonly) NSInteger postId;

@end
