//
//  UpcomingEpisodes.h
//  Youtoo
//
//  Created by PRABAKAR MP on 14/09/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSMAdvertisingProtocol.h"

@class ItemStorage;
@class ItemModel;

@interface UpcomingEpisodes : UIViewController <UITableViewDelegate,UITableViewDataSource,NSXMLParserDelegate, CSMAdvertisingProtocol> {
    
    UITableView *upcomingEpisodesTableview;
    ItemModel				*itemModel;
     ItemModel				*itemModelRetVal;
    ItemStorage					*itemStorage;
    UILabel                     *showNameTitle;
    
    NSXMLParser					*rssParser;
    //    ItemStorage					*itemStorage;
    NSMutableDictionary			*item;
	NSString					*currentElement;
    BOOL						isNetworkOperation;
    // ProfileLineController *profileLineController;
 
    //   ItemModel				*itemModel;
    NSString *str;
    
    NSMutableArray *showName;
    NSMutableArray *showTime;
    NSMutableArray *showImage;
    
    
}
@property (nonatomic, retain) ItemModel *itemModel;
@property (nonatomic, retain) ItemStorage *itemStorage;
@property (nonatomic, retain) NSXMLParser *rssParser;
@property (nonatomic, retain)  UIActivityIndicatorView *activityIndicator;
@property (nonatomic, copy) NSString *currentElement;
@property (nonatomic, retain) NSMutableDictionary *item;
@property (nonatomic, retain)   NSString *str;
@property (nonatomic, retain) IBOutlet   UITableView *upcomingEpisodesTableview;
//@property (nonatomic, retain) IBOutlet     UITableView *scheduleTableview;  
//@property (nonatomic, retain) ProfileLineController *profileLineController;

@property(nonatomic, retain)IBOutlet  UILabel *showNameTitle;
//@property (nonatomic, retain) ItemModel *itemModel;
- (void)homeControlSelector:(NSNotification *)notification;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil :(ItemModel *)aModel;
- (BOOL)canShowAdvertising;
-(IBAction) backAction : (id) sender;
-(void) callProfileFrienView;

@end
