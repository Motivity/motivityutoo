//
//  VideosShowDetailPage.h
//  Youtoo
//
//  Created by PRABAKAR MP on 30/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSMAdvertisingProtocol.h"

@class ItemStorage;
@class ItemModel;

@interface VideosShowDetailPage : UIViewController <UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate, CSMAdvertisingProtocol> {
    
    UITableView *tableview;
    NSArray *list;
    
    NSXMLParser					*rssParser;
    ItemStorage					*itemStorage;
    NSMutableDictionary			*item;
	NSString					*currentElement;
    BOOL						isNetworkOperation;
    ItemModel *myItemModel;
    UIButton *btn1;
    UIButton *btn2;
    UILabel *lbl1;
    UILabel *lbl2;
    
    UILabel *titleLabel;
    UIActivityIndicatorView *activityIndicator;
    NSTimer *reloadTImer;
}

@property (nonatomic, retain) IBOutlet     UITableView *tableview;
@property (nonatomic, retain) IBOutlet     UILabel *titleLabel;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) NSXMLParser *rssParser;
@property (nonatomic, retain) ItemStorage *itemStorage;
@property (nonatomic, copy) NSString *currentElement;
@property (nonatomic, retain) NSMutableDictionary *item;
- (BOOL)canShowAdvertising;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil :(ItemModel *)aModel;
- (void)reloadTable:(NSTimer*)timer;
- (void)didStopLoadData;
-(IBAction) buttonPressed: (id) sender;
- (void)reloadPage;
-(IBAction) backAction : (id) sender;
-(void) callProfileFrienView;

@end
