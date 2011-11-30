//
//  More.h
//  Youtoo
//
//  Created by PRABAKAR MP on 19/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSMAdvertisingProtocol.h"

@class 	ASINetworkQueue;
@interface More : UITableViewController <CSMAdvertisingProtocol> {
    
    NSArray *list;
     ASINetworkQueue			*networkQueue;
}


@end
