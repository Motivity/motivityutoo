//
//  RecordAfameSpot.h
//  Youtoo
//
//  Created by PRABAKAR MP on 23/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSMAdvertisingProtocol.h"
@class ItemStorage;
@class ItemModel;
@interface RecordAfameSpot : UIViewController <UITableViewDelegate, UITableViewDataSource, CSMAdvertisingProtocol, NSXMLParserDelegate> {
    UITableView *tableview;
    UIButton *fameSptShowBtn;
    NSXMLParser					*rssParser;
    ItemStorage					*itemStorage;
    ItemStorage					*topicitemStorage;
    NSMutableDictionary			*item;
    NSMutableDictionary			*topicitem;
    NSString					*currentElement;
    BOOL						isNetworkOperation;
    UIActivityIndicatorView *activityIndicator;
    UIButton *btn1;
    UIButton *btn2;
    UILabel *lbl1;
    UILabel *lbl2;
    int tabSelected;
    UIButton *programs;
    UIButton *topics;
    ItemModel *myItemModel;
    UILabel *selectLbl;
    int firsttimeProgramCalled;
    UIButton *uploadViewBtn;
    UIButton *recordViewBtn;
    UIImageView* chooseImg;
}

@property (nonatomic, readwrite) int firsttimeProgramCalled;
@property (nonatomic, retain)  IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet     UITableView *tableview;
@property (nonatomic, retain) NSXMLParser *rssParser;
@property (nonatomic, retain) UIButton *uploadViewBtn;
@property (nonatomic, retain) UIButton *recordViewBtn;
@property (nonatomic, retain) UIImageView* chooseImg;
@property (nonatomic, retain) ItemStorage *itemStorage;
@property (nonatomic, retain) ItemStorage *topicitemStorage;
@property (nonatomic, copy) NSString *currentElement;
@property (nonatomic, retain) NSMutableDictionary *item;
@property (nonatomic, retain) NSMutableDictionary *topicitem;
@property (nonatomic, readwrite) int tabSelected;
@property (nonatomic, retain)  IBOutlet   UIButton *topics;
@property (nonatomic, retain) IBOutlet  UIButton *programs;
@property (nonatomic, retain) IBOutlet UILabel *selectLbl;
- (BOOL)canShowAdvertising;
-(IBAction) backAction : (id) sender;
-(IBAction) programsAction;
-(void) DownloadRecordFameSpotImages;
-(IBAction) TopicsAction:(UIButton*) sender;
-(void) callProfileFrienView;
-(void)recordViewAct:(id)sender;
-(void)uploadViewAct:(id)sender;
- (void)reloadTableAgain:(NSTimer*)timer;
- (void)reloadTable:(NSTimer*)timer;
- (void)reloadTableAgain:(NSTimer*)timer;

@end
