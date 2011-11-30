//
//  ProfileFollowing.h
//  Youtoo
//
//  Created by PRABAKAR MP on 29/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSMAdvertisingProtocol.h"
@class ItemStorage;
@class ItemModel;

@interface ProfileFollowing : UIViewController <UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate, CSMAdvertisingProtocol> {
    
    
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
    NSTimer *reloadTImer;
    UILabel *titleLabel;
    UIActivityIndicatorView *activityIndicator;
    UILabel *profileName;
    UIImageView *profileImage;
    UILabel *creditLbl;
      BOOL myOwnCalled;
    NSString *userid;
}
@property (nonatomic, copy) NSString *userid;
@property   BOOL myOwnCalled;;
@property (nonatomic, retain) IBOutlet UILabel *profileName;
@property (nonatomic, retain) IBOutlet  UIImageView *profileImage;
@property (nonatomic, retain) IBOutlet   UILabel *creditLbl;
@property (nonatomic, retain) IBOutlet     UITableView *tableview;
@property (nonatomic, retain) IBOutlet     UILabel *titleLabel;
@property (nonatomic, retain)  IBOutlet  UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) NSXMLParser *rssParser;
@property (nonatomic, retain) ItemStorage *itemStorage;
@property (nonatomic, copy) NSString *currentElement;
@property (nonatomic, retain) NSMutableDictionary *item;
-(IBAction) buttonPressed: (id) sender;
- (BOOL)canShowAdvertising;
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (void)didStopLoadData;
- (id)setupFollowingNib:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil :(ItemModel *)aModel:(BOOL) myOwn :(NSString *) userID;
-(IBAction) backAction : (id) sender;
-(void) callProfileFrienView;
- (void)reloadTable:(NSTimer*)timer;
- (void)homeControlSelector:(NSNotification *)notification;

@end
