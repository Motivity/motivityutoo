//
//  HelpScreen.h
//  Youtoo
//
//  Created by PRABAKAR MP on 02/09/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSMAdvertisingProtocol.h"

@interface HelpScreen : UITableViewController <CSMAdvertisingProtocol>{
    NSArray *listOfItems;
    
}

- (BOOL)canShowAdvertising;

@end
