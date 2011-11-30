//
//  RegisterScreen.h
//  Youtoo
//
//  Created by PRABAKAR MP on 19/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSMAdvertisingProtocol.h"

@class 	ASINetworkQueue;
@interface RegisterScreen : UIViewController<UITextFieldDelegate,NSXMLParserDelegate,CSMAdvertisingProtocol> {
    
    UITextField *emailFld;
    UITextField *useNameFld;
    UITextField *passwrdFld;
    UITextField *confrmPasswrdFld;
    UITextField *zipCodeFld;
    UIButton *acceptBtn;
    UIButton *registrBtn;
    BOOL accptIsClicked;
    BOOL bAlreadyMovedUp;
    BOOL bTxtViewEditing;
    NSXMLParser				*rssParser;
    UIActivityIndicatorView *activityIndicator;
    BOOL					isNetworkOperation;
    ASINetworkQueue			*networkQueue;
    NSString				*sendResult;
    NSString				*currentElement;
    NSString *username;
    NSString *password;
    NSString *confirmPassword;
    NSString *zipcodeStr;
    NSString *email;
}

@property BOOL accptIsClicked;;
@property BOOL isNetworkOperation;
@property(nonatomic, retain)IBOutlet  UITextField *emailFld;
@property(nonatomic, retain)IBOutlet  UITextField *useNameFld;
@property(nonatomic, retain)IBOutlet  UITextField *passwrdFld;
@property(nonatomic, retain)IBOutlet  UITextField *confrmPasswrdFld;
@property(nonatomic, retain)IBOutlet  UITextField *zipCodeFld;
@property (nonatomic, copy) NSString *sendResult;
@property (nonatomic, retain) NSXMLParser *rssParser;
@property(nonatomic, retain)IBOutlet  UIButton *acceptBtn;
@property(nonatomic, retain)IBOutlet  UIButton *registrBtn;
@property (nonatomic, copy) NSString *currentElement;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

-(IBAction)goToTabBar;
-(IBAction)registerAction;
-(IBAction)acceptAction;
- (void)setViewMovedUp:(BOOL)movedUp;
- (void)updateView;
- (void)doneButton:(id)sender ;
- (BOOL)canShowAdvertising;
- (void)advertisingWillHide;
- (BOOL)canShowAdvertising;
-(void) reloadPage;
-(IBAction) backAction;

@end
