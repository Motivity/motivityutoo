//
//  Videos.h
//  Youtoo
//
//  Created by PRABAKAR MP on 30/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSMAdvertisingProtocol.h"

@class ItemStorage;
@class ItemModel;

@interface Videos : UIViewController <UITableViewDelegate, UITableViewDataSource, CSMAdvertisingProtocol> {
    
    UITableView *tableview;
    NSArray *list;
    
    ItemModel *myItemModel;
    
    NSXMLParser					*rssParser;
    ItemStorage					*itemStorage;
    NSMutableDictionary			*item;
    NSString					*currentElement;
    BOOL						isNetworkOperation;
    UIActivityIndicatorView *activityIndicator;
}
@property (nonatomic, retain) IBOutlet     UITableView *tableview;
@property (nonatomic, retain)  IBOutlet  UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) NSXMLParser *rssParser;
@property (nonatomic, retain) ItemStorage *itemStorage;
@property (nonatomic, copy) NSString *currentElement;
@property (nonatomic, retain) NSMutableDictionary *item;
- (BOOL)canShowAdvertising;

+(UIImage *)makeRoundCornerImage : (UIImage*) img : (int) cornerWidth : (int) cornerHeight;
static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight);
- (void)didStopLoadData;
-(void) callProfileFrienView;

@end
