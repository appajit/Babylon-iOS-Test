//
//  User.h
//  BabylonTest
//
//  Created by Appaji Tholeti on 26/06/2016.
//  Copyright © 2016 Tholeti Consultyancy Services. All rights reserved.
//

#import "Mantle.h"


@interface User : MTLModel <MTLJSONSerializing>

@property (nonatomic,readonly) NSInteger userId;
@property (nonatomic,copy,readonly) NSString *name;


@end
