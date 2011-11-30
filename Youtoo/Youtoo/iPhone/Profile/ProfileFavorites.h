//
//  ProfileFavorites.h
//  Youtoo
//
//  Created by PRABAKAR MP on 29/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSMAdvertisingProtocol.h"

@class 	ASINetworkQueue;
@class ItemModel;
@class ItemStorage;
@interface ProfileFavorites : UIViewController <UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate, CSMAdvertisingProtocol> {
    
    
    UITableView *tableview;
    NSXMLParser					*rssParser;
    NSMutableDictionary			*item;
    NSMutableArray			*imageArray;
	NSString					*currentElement;
    BOOL						isNetworkOperation;
    UILabel *creditsLbl;
    UILabel *profileName;
    UIImageView *profileImage;
    ASINetworkQueue			*networkQueue;    
    UIActivityIndicatorView *activityIndicator;
    ItemModel *myItemModel;
    ItemStorage					*itemStorage;
    BOOL myOwnCalled;
    NSTimer *reloadTImer;
    NSString *userid;
}
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, retain) IBOutlet     UITableView *tableview;
@property (nonatomic, retain) NSXMLParser *rssParser;
@property BOOL isNetworkOperation;
@property (nonatomic, copy) NSString *currentElement;
@property (nonatomic, copy) NSString *sendResult;
@property (nonatomic, retain) ItemStorage *itemStorage;
@property (nonatomic, retain) NSMutableDictionary *item;
@property (nonatomic, retain) NSMutableArray *imageArray;
@property(nonatomic, retain) IBOutlet UILabel *creditLbl;
@property(nonatomic, retain) IBOutlet UILabel *profileName;
@property(nonatomic, retain) IBOutlet UIImageView *profileImage;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
- (id)setupFavNib:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil :(ItemModel *)aModel :(BOOL) myOwn :(NSString *) userID;
-(void) reloadScreen:(NSTimer*)timer;
-(IBAction) backAction : (id) sender;
-(void) callProfileFrienView;
@end
