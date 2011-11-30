//
//  Schedule.h
//  Youtoo
//
//  Created by PRABAKAR MP on 29/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSMAdvertisingProtocol.h"
@class ItemStorage;

@interface Schedule : UIViewController <UITableViewDelegate, NSXMLParserDelegate, UITableViewDataSource, CSMAdvertisingProtocol>{
    
    UITableView *tableview;
    NSXMLParser					*rssParser;
    ItemStorage					*itemStorage;
    NSMutableDictionary			*item;
	NSString					*currentElement;
    BOOL						isNetworkOperation;
    NSMutableArray *showName;
    NSMutableArray *showImage;
    NSMutableArray *showTime;
    NSMutableArray *listOfItems;
    NSMutableArray *listOfImages;
    UIActivityIndicatorView *activityIndicator;
    UILabel *dateLbl;
    int tabSelected;
    IBOutlet UIButton *viewByTime;
    IBOutlet UIButton *viewByName;
    int btnTag;
    
    UIButton *btn1;
    UIButton *btn2;
    UILabel *lbl1;
    UILabel *lbl2;
}
@property (nonatomic, readwrite) int btnTag;
@property (nonatomic, retain) IBOutlet     UITableView *tableview;
@property (nonatomic, retain) NSXMLParser *rssParser;
@property (nonatomic, retain) ItemStorage *itemStorage;
@property (nonatomic, copy) NSString *currentElement;
@property (nonatomic, retain) NSMutableDictionary *item;
@property (nonatomic, retain)  NSMutableArray *showName;
@property (nonatomic, retain)  NSMutableArray *showImage;
@property (nonatomic, retain)  NSMutableArray *showTime;
@property (nonatomic, retain)  IBOutlet  UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet     UILabel *dateLbl;
@property (nonatomic, readwrite) int tabSelected;
@property (nonatomic, retain) IBOutlet UIButton *viewByTime;
@property (nonatomic, retain) IBOutlet UIButton *viewByName;

- (void)homeControlSelector:(NSNotification *)notification;
- (BOOL)canShowAdvertising;
- (void)advertisingWillHide;
- (void)advertisingDidShow;
- (void)reloadPage;
-(IBAction) viewByTimeAction;
-(IBAction) viewByNameAction;
-(void) callProfileFrienView;
- (void)reloadTable:(NSTimer*)timer;
- (void)reloadTableAgain:(NSTimer*)timer;
- (void)homeControlSelector:(NSNotification *)notification;

@end
