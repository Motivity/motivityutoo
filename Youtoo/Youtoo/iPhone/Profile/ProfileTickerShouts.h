//
//  ProfileTickerShouts.h
//  Youtoo
//
//  Created by PRABAKAR MP on 29/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSMAdvertisingProtocol.h"

@class 	ASINetworkQueue;
@class ItemModel;
@interface ProfileTickerShouts : UIViewController <UITableViewDataSource, UITableViewDelegate, CSMAdvertisingProtocol, NSXMLParserDelegate> {
    
    UILabel *creditLbl;
    
    ASINetworkQueue			*networkQueue;    
    NSString				*sendResult;
    NSXMLParser				*rssParser;
    BOOL isNetworkOperation;
    NSString				*currentElement;
    UILabel *creditsLbl;
    UIActivityIndicatorView *activityIndicator;
    UITableView *tableview;
    NSMutableArray			*item;
    NSMutableArray			*timeArr;
    NSMutableArray			*dateArr;
    UITextView *tickerShouts;
    ItemModel *myItemModel;
    UILabel *profileName;
     UIImageView *profileImage;
    BOOL myOwnCalled;
    NSTimer *reloadTImer;
    NSString *userid;
}
@property (nonatomic, copy) NSString *userid;
@property (nonatomic,retain) ASINetworkQueue *networkQueue;
@property (nonatomic, retain) IBOutlet     UITableView *tableview;
@property (nonatomic, retain) IBOutlet      UIImageView *profileImage;
@property(nonatomic, retain) IBOutlet UILabel *creditLbl;
@property(nonatomic, retain) UITextView *tickerShouts;
@property (nonatomic, retain) NSMutableArray *item;
@property (nonatomic, retain) NSMutableArray *timeArr;
@property (nonatomic, retain) NSMutableArray *dateArr;
@property BOOL isNetworkOperation;
@property BOOL myOwnCalled;
@property (nonatomic, copy) NSString *currentElement;
@property (nonatomic, copy) NSString *sendResult;
@property (nonatomic, retain) NSXMLParser *rssParser;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic, retain)IBOutlet   UILabel *profileName;
- (BOOL)canShowAdvertising;
- (void)advertisingWillHide;
- (void)advertisingDidShow;
- (id)setupTickerib:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil :(ItemModel *)aModel :(BOOL) myOwn :(NSString *) userID;
-(void) reloadScreen:(NSTimer*)timer;
-(IBAction) backAction : (id) sender;
-(void) callProfileFrienView;
@end
