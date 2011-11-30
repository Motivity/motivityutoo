//
//  SelectAfameSpot.h
//  Youtoo
//
//  Created by PRABAKAR MP on 23/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSMAdvertisingProtocol.h"

@class ItemModel;
@class ItemStorage;

@interface SelectAfameSpot : UIViewController <UITableViewDelegate, UITableViewDataSource, UITableViewDataSource, CSMAdvertisingProtocol, NSXMLParserDelegate, UIImagePickerControllerDelegate, UINavigationBarDelegate> {
    UITableView *tableview;
    UIImageView *backImageView;
    
    ItemModel *myItemModel;
    
    NSXMLParser					*rssParser;
    ItemStorage					*itemStorage;
    NSMutableDictionary			*item;
    NSString					*currentElement;
    BOOL						isNetworkOperation;
    UIActivityIndicatorView *activityIndicator;
    UILabel *titleLabel;
    UIButton *uploadViewBtn;
    UIButton *recordViewBtn;
    UIImageView* chooseImg;
}
@property (nonatomic, retain) IBOutlet     UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet  UITableView *tableview;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) NSXMLParser *rssParser;
@property (nonatomic, retain) ItemStorage *itemStorage;
@property (nonatomic, copy) NSString *currentElement;
@property (nonatomic, retain) NSMutableDictionary *item;
@property (nonatomic, retain) UIButton *uploadViewBtn;
@property (nonatomic, retain) UIButton *recordViewBtn;
@property (nonatomic, retain) UIImageView* chooseImg;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil :(ItemModel *)aModel;
- (BOOL)canShowAdvertising;
-(IBAction) backAction : (id) sender;
-(void) callProfileFrienView;
- (void)didStopLoadData;

@end
