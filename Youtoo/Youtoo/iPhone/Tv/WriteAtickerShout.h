//
//  WriteAtickerShout.h
//  Youtoo
//
//  Created by PRABAKAR MP on 23/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSMAdvertisingProtocol.h"

@class 	ASINetworkQueue;
@class ItemModel;
@interface WriteAtickerShout : UIViewController<UITextViewDelegate,NSXMLParserDelegate, CSMAdvertisingProtocol> {
    UITextView *textView;
    UITextField *textFld;
    
    IBOutlet UIButton *ticketSubmitBtn;
    NSString *advertisingString;
    NSXMLParser				*rssParser;
    ASINetworkQueue			*networkQueue;
	BOOL					isNetworkOperation;	
    NSString				*sendResult;
    NSString *currentElement;
    UIActivityIndicatorView *activityIndicator;
     UILabel *charCount;
    
    UIButton *mobile;
    UIButton *web;
    UIButton *tv;
    BOOL mobileIsChecked;  
    BOOL webIsChecked; 
    BOOL tvIsChecke;
    UIButton *twitterBtn;
    UIButton *fbBtn;
    UIButton *googleBtn;
    BOOL tweetIsChecked;  
    BOOL fbIsChecked; 
    BOOL googleIsChecke;
    ItemModel *myItemModel;
    UILabel *titleLabel;
}
@property(nonatomic, retain) IBOutlet UITextView *textView;
@property BOOL isNetworkOperation;
@property (nonatomic, retain)IBOutlet UIButton *ticketSubmitBtn;
@property (nonatomic, retain)IBOutlet UILabel *titleLabel;
@property (nonatomic, copy) NSString *advertisingString;
@property (nonatomic, copy) NSString *sendResult;
@property (nonatomic, copy) NSString *currentElement;
@property (nonatomic, retain) NSXMLParser *rssParser;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet     UILabel *charCount;
@property (nonatomic, retain) IBOutlet  UITextField *textFld;
@property (nonatomic, retain) IBOutlet  UIButton *mobile;
@property (nonatomic, retain) IBOutlet  UIButton *web;
@property (nonatomic, retain) IBOutlet UIButton *tv;
@property (nonatomic, retain) IBOutlet  UIButton *twitterBtn;
@property (nonatomic, retain) IBOutlet  UIButton *fbBtn;
@property (nonatomic, retain) IBOutlet UIButton *googleBtn;
@property   BOOL mobileIsChecked;
@property   BOOL webIsChecked; 
@property   BOOL tvIsChecke;
@property BOOL isPostOperation;
@property   BOOL tweetIsChecked; 
@property   BOOL fbIsChecked;
@property BOOL googleIsChecke;

-(IBAction) submitTickerShout :(id) sender;
-(IBAction) Cancel:(id)sender;
- (BOOL)canShowAdvertising;
-(IBAction)textFieldDidUpdate:(id)sender;

-(IBAction)mobileAction:(id)sender;
-(IBAction)webAction:(id)sender;
-(IBAction)tvAction:(id)sender;
-(void) callProfileFrienView;

-(IBAction)tweetBtnAction:(id)sender;
-(IBAction)fbBtnAction:(id)sender;
-(IBAction)googleBtnAction:(id)sender;
-(void) launchEarnScreen;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil :(ItemModel *)aModel;
-(void) reloadPage;
-(IBAction) backAction : (id) sender;
@end
