//
//  LogInScreen.h
//  Youtoo
//
//  Created by PRABAKAR MP on 19/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSMAdvertisingProtocol.h"

@class 	ASINetworkQueue;
@interface LogInScreen : UIViewController<UITextFieldDelegate, NSXMLParserDelegate,CSMAdvertisingProtocol > {
    
    @private
    UITextField *userNameField;
    UITextField *passwordField;
    UIButton *createBtn;
    UIButton *facebookBtn;
    UIButton *twitterBtn;
    UIButton *enterYoutooBtn;
    UIButton *forgotPasswrdBtn;
    BOOL bAlreadyMovedUp;
    BOOL bTxtViewEditing;
    id					delegateController;
    BOOL					isNetworkOperation;
    ASINetworkQueue			*networkQueue;
    NSString				*currentElement;
    NSString				*userIDCode;
    NSString				*sendResult;
    NSXMLParser				*rssParser;
    UIActivityIndicatorView *activityIndicator;
    
    NSMutableData *receivedData;
    int getProfile;
    NSThread *firstThread;
}
@property BOOL isNetworkOperation;
@property BOOL isPostOperation;
@property (nonatomic, readwrite) int getProfile;
@property (nonatomic, copy) NSString *currentElement;
@property (nonatomic, copy) NSString *userIDCode;
@property (nonatomic, copy) NSString *sendResult;
@property (nonatomic, retain) NSXMLParser *rssParser;
@property(nonatomic, retain)IBOutlet  UITextField *userNameField;
@property(nonatomic, retain)IBOutlet  UITextField *passwordField;
@property(nonatomic, retain)IBOutlet  UIButton *createBtn; 
@property(nonatomic, retain)IBOutlet  UIButton *facebookBtn;
@property(nonatomic, retain)IBOutlet  UIButton *twitterBtn;
@property(nonatomic, retain)IBOutlet  UIButton *enterYoutooBtn;
@property(nonatomic, retain)IBOutlet  UIButton *forgotPasswrdBtn;
@property (nonatomic, assign) id delegateController;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

-(IBAction)goToRegiater;
-(IBAction) facebookAction;
-(IBAction) twitterAction;
-(IBAction) forGotPasswrd;
-(IBAction) enterYoutooAction;
- (void)setViewMovedUp:(BOOL)movedUp;
- (void)updateView;
- (BOOL)canShowAdvertising;
- (void)advertisingWillHide;
- (void)advertisingDidShow;
- (void)reloadPage;
-(void)getUserProfile;
- (void)parseXMLFilewithNSData:(NSData *)data;

@end
