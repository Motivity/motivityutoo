//
//  LineController.h
//  ALN
//
//  Created by Ihor Xom on 9/24/10.
//  Copyright 2010 OneHeartMovie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AdvModel, ProfileLineController, AdvertisingLineController;

@interface LineController : NSObject < NSXMLParserDelegate, UIAlertViewDelegate >
{
	AdvModel			*advModel;
	
@private
	ProfileLineController		*profileLineController;
	AdvertisingLineController	*advertisingLineController;
	NSXMLParser					*rssParser;
	NSString					*currentElement;
	NSTimer						*updateTimer;
	BOOL						isNetworkOperation;
	BOOL						isProfileAdvertising;
    UIViewController		*selectedController;
}
@property BOOL isProfileAdvertising;
@property (nonatomic, copy) NSString *currentElement;
@property (nonatomic, retain) NSXMLParser *rssParser;
@property (nonatomic, retain) AdvModel *advModel;
@property (nonatomic, retain) ProfileLineController *profileLineController;
@property (nonatomic, retain) AdvertisingLineController *advertisingLineController;
@property (nonatomic, assign) UIViewController *selectedController;

+ (LineController *)sharedLineController;
- (void)stopAdvertising;
- (void)startAdvertising;
- (void)updateBottomLine:(NSTimer*)theTimer;
- (IBAction)showProfileController;
- (IBAction)showAdvertisingController;
- (BOOL)isShownAdvertising;
-(void) selectedController : (UIViewController *) selectController;
-(void) launchProfile;
@end
