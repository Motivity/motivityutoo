//
//  More.h
//  Youtoo
//
//  Created by PRABAKAR MP on 16/09/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CSMAdvertisingProtocol.h"

@class 	ASINetworkQueue;
@interface More : UIViewController <CSMAdvertisingProtocol, UITableViewDataSource, UITableViewDelegate>{
    NSArray *list;
    ASINetworkQueue			*networkQueue;
    UITableView *tableView;

}
@property(nonatomic, retain) IBOutlet  UITableView *tableView;
-(void) callProfileFrienView;
@end
