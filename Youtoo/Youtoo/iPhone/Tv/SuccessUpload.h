//
//  SuccessUpload.h
//  Youtoo
//
//  Created by PRABAKAR MP on 24/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSMAdvertisingProtocol.h"

@interface SuccessUpload : UIViewController <CSMAdvertisingProtocol,NSXMLParserDelegate> {
    
    UILabel *creditLabel;
    
    NSXMLParser				*rssParser;
    NSString				*currentElement;
    BOOL bAuthDone;
}
@property (nonatomic, retain) IBOutlet UILabel *creditLabel;
@property BOOL bAuthDone;

- (BOOL)canShowAdvertising;
-(void) reloadPage;

@property (nonatomic, copy) NSString *currentElement;
@property (nonatomic, retain) NSXMLParser *rssParser;
-(void)updateCredits;

@end
