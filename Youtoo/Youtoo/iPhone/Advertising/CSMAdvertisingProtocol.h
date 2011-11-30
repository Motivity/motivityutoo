//
//  CSMAdvertisingProtocol.h
//  ALN
//
//  Created by Ihor Xom on 11/12/10.
//  Copyright 2010 OneHeartMovie. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CSMAdvertisingProtocol

@required
- (BOOL)canShowAdvertising;

@optional
- (void)advertisingWillHide;
- (void)advertisingDidShow;

@end
