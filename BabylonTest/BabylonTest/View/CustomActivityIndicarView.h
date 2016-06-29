//
//  CustomActivityIndicarView.h
//  BabylonTest
//
//  Created by Appaji Tholeti on 25/06/2016.
//  Copyright © 2016 Tholeti Consultyancy Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomActivityIndicarView : UIActivityIndicatorView

/**
 *  provides custom activity indicator view
 *
 *  @param displayView view on which the indicatorto be shown
 *
 *  @return custom indicator view instance
 */
+(instancetype) activityIndicatorForDisplayView:(UIView*) displayView;
@end
