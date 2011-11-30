//
//  AboutYoutooCredits.h
//  Youtoo
//
//  Created by PRABAKAR MP on 16/09/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSMAdvertisingProtocol.h"

//@class 	ASINetworkQueue;



@interface AboutYoutooCredits : UIViewController <UITextViewDelegate,NSXMLParserDelegate, CSMAdvertisingProtocol> {
    NSXMLParser					*rssParser;
    NSMutableArray			*item;
    NSMutableArray			*imageArray;
	NSString					*currentElement;
    BOOL						isNetworkOperation;
    UILabel *creditsLbl;
 //   ASINetworkQueue			*networkQueue;    
    UIActivityIndicatorView *activityIndicator;
    NSString *aboutCreditsString;
    UITextView  *aboutYoutooCredits;
}
@property (nonatomic, retain) NSXMLParser *rssParser;
@property BOOL isNetworkOperation;
@property (nonatomic, retain) UITextView  *aboutYoutooCredits;
@property (nonatomic, copy) NSString *currentElement;
@property (nonatomic, copy) NSString *sendResult;
@property (nonatomic, retain) NSMutableArray *item;
@property (nonatomic, retain) NSMutableArray *imageArray;
@property(nonatomic, retain) IBOutlet UILabel *creditLbl;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain)  NSString *aboutCreditsString;
-(IBAction) backAction : (id) sender;
-(void) callProfileFrienView;
@end
