//
//  ProfileEdit.h
//  Youtoo
//
//  Created by PRABAKAR MP on 24/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSMAdvertisingProtocol.h"

@class 	ASINetworkQueue;

@interface ProfileEdit : UIViewController <UITextFieldDelegate, NSXMLParserDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CSMAdvertisingProtocol> {
    
    UITextField *editZipFld;
    UILabel *creditsLbl;
    
    UITextField *nameFld;
    UITextField *emailFld;
    UITextField *bioFld;
    UIActivityIndicatorView *activityIndicator;
    BOOL bTxtViewEditing;
    NSString *selectedImage;
    UIImageView *avatarImg;
    BOOL bAlreadyMovedUp;
    UISwitch *facebook;
    UISwitch *twitter;
    UISwitch *youtube;
    UISwitch *youtoo;
    ASINetworkQueue			*networkQueue;
    UIButton *logout;    
    UIImageView *profileImage;
    UILabel *profileName;
    NSData* imageData;
     BOOL						isNetworkOperation;
    NSXMLParser				*rssParser;
    NSString				*currentElement;
    NSString				*sendResult;
    
    NSString *name;
    NSString *bio;
    NSString *email;
    NSString *avatar;
    NSString *zip;
    NSTimer *reloadTImer;
    NSMutableData *receivedData;
    BOOL bUpdateProfile;
    IBOutlet UIScrollView *scrollView;
}
@property (nonatomic, retain) ASINetworkQueue			*networkQueue;
@property BOOL isNetworkOperation;
@property BOOL bUpdateProfile;
@property (nonatomic, copy) NSString *currentElement;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *bio;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *zip;
@property (nonatomic, copy) NSString *sendResult;
@property (nonatomic, retain) NSXMLParser *rssParser;
@property (nonatomic, retain)  NSMutableData *receivedData;
@property (nonatomic, retain) IBOutlet UITextField *editZipFld;
@property (nonatomic, retain) IBOutlet UITextField *nameFld;
@property (nonatomic, retain) IBOutlet  UIButton *logout; 
@property (nonatomic, retain) IBOutlet UITextField *emailFld;
@property (nonatomic, retain) IBOutlet UITextField *bioFld;
@property (nonatomic, retain)  NSData* imageData;;
@property (nonatomic, retain) IBOutlet UIImageView *avatarImg;
@property (nonatomic, retain) IBOutlet UISwitch *facebook;
@property (nonatomic, retain) IBOutlet UISwitch *twitter;
@property (nonatomic, retain) IBOutlet UISwitch *youtube;
@property (nonatomic, retain) IBOutlet UISwitch *youtoo;
@property (nonatomic, retain)  UIActivityIndicatorView *activityIndicator;
@property(nonatomic, retain)IBOutlet  UILabel *creditsLbl;
@property(nonatomic, retain)  NSString *selectedImage;
@property(nonatomic, retain)IBOutlet UIImageView *profileImage;
@property(nonatomic, retain)IBOutlet   UILabel *profileName;
@property (nonatomic, retain) UIScrollView *scrollView;

- (BOOL)canShowAdvertising;
-(IBAction) saveEditUser :(id) sender;
-(IBAction) LaunchAlbum :(id) sender;
-(IBAction) logout :(id) sender;
-(void) reloadScreen:(NSTimer*)timer;
-(IBAction) backAction : (id) sender;
- (void)grabProfileInfoIntheBackgroud;
- (void)parseXMLFilewithData:(NSData *)strURL;
-(void) updateProfile;
-(void) callProfileFrienView;
-(void) updateProfileEditScreen;
@end
