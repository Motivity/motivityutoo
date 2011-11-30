//
//  VideosShowPage.h
//  Youtoo
//
//  Created by PRABAKAR MP on 30/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSMAdvertisingProtocol.h"

@class ItemStorage;
@class ItemModel;


@interface VideosShowPage : UIViewController <UITableViewDataSource, UITableViewDelegate, CSMAdvertisingProtocol> {
    
    UITableView *tableview;
    NSArray *list;
    
    ItemModel *myItemModel;
    
    NSXMLParser					*rssParser;
    ItemStorage					*itemStorage;
    NSMutableDictionary			*item;
    NSString					*currentElement;
    BOOL						isNetworkOperation;
    UIActivityIndicatorView *activityIndicator;
    UILabel *titleLbl;
}
@property (nonatomic, retain) IBOutlet     UITableView *tableview;
@property (nonatomic, retain) NSXMLParser *rssParser;
@property (nonatomic, retain) ItemStorage *itemStorage;
@property (nonatomic, copy) NSString *currentElement;
@property (nonatomic, retain) NSMutableDictionary *item;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UILabel *titleLbl;
- (BOOL)canShowAdvertising;
- (void)advertisingWillHide;
- (void)advertisingDidShow;
- (void)reloadPage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil  :(ItemModel *)aModel;
static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight);
-(UIImage *)makeRoundCornerImage : (UIImage*) img : (int) cornerWidth : (int) cornerHeight;
-(IBAction) backAction : (id) sender;
-(void) callProfileFrienView;
@end
