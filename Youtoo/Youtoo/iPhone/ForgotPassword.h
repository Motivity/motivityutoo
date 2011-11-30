//
//  ForgotPassword.h
//  Youtoo
//
//  Created by PRABAKAR MP on 15/09/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSMAdvertisingProtocol.h"

@class 	ASINetworkQueue;
@interface ForgotPassword : UIViewController <UITextFieldDelegate, NSXMLParserDelegate, CSMAdvertisingProtocol> {
     UITextField *emailFld;
     UITextField *newPasswordFld;
     UITextField *confrmPasswordFld;
     UIButton *changePasswdBtn;
    
    BOOL bAlreadyMovedUp;
    BOOL bTxtViewEditing;
    
    NSString *email;
    NSString *newPassword;
    NSString *confirmPassword;
    
    NSXMLParser				*rssParser;
    UIActivityIndicatorView *activityIndicator;
    BOOL					isNetworkOperation;
    ASINetworkQueue			*networkQueue;
    NSString				*sendResult;
    NSString				*currentElement;
    UIButton *backButton;
}
@property  BOOL					isNetworkOperation;;
@property(nonatomic, retain) IBOutlet UITextField *emailFld;
@property(nonatomic, retain) IBOutlet UITextField *newPasswordFld;
@property(nonatomic, retain) IBOutlet UITextField *confrmPasswordFld;
@property(nonatomic, retain) IBOutlet UIButton *changePasswdBtn;
@property(nonatomic, retain) IBOutlet UIButton *backButton;
@property (nonatomic, copy) NSString *sendResult;
@property (nonatomic, retain) NSXMLParser *rssParser;
@property (nonatomic, copy) NSString *currentElement;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
-(IBAction)conformPasswordAct:(id)sender;
- (void)setViewMovedUp:(BOOL)movedUp;
- (void)updateView;
- (BOOL)canShowAdvertising;
-(void) reloadPage;
-(IBAction) backAction : (id) sender;

@end
