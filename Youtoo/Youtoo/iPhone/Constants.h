//
//  Constants.h
//  ALN
//
//  Created by Ihor Xom on 4/16/10.
//  Copyright 2010 Home. All rights reserved.
//

#define		kBrowserNotification			@"BrowserNotification"
#define		kNotifyReloadTable				@"NotifyReloadTable"
#define		kNotifyImagesDidLoad			@"NotifyImagesDidLoad"

#define		kAdvertisingNotification		@"AdvertisingNotification"
#define		kNotifyReloadAdvertising		@"NotifyReloadAdvertising"

#define		kButtonTitleColor				[UIColor blackColor]
#define		kButtonHighlightedColor			[UIColor colorWithWhite:0.85 alpha:1.0]

typedef enum
{
	kFeaturesTag		= 0,
	kBLogsTickerTag		= 1,
	kBroadcastTickerTag	= 2,
	kVideoCaptureTag	= 3,
	kShowsTag			= 4,
	kScheduleTag		= 5,
	kFavoritesTag		= 6,
	kSettingsTag		= 7,
	kRadioTag			= 8,
	kTabBarCount
}
ALNTabItemTags;

typedef enum
{
	kUserNotRegistered		= 0,
	kUserIsRegistered		= 1,
	kUserIsSigningIn		= 2,
	kUserIsSignedInTicker	= 3
} 
UserRegistrationStatus;

extern const CGFloat kCheckStatusInterval;
extern const CGFloat kFloatingPanelHeight;
extern const CGFloat kAdvBarHeight;
extern const CGFloat kToolbarHeightPortrait;
extern const CGFloat kDurationMovingViewInterval;
extern const CGFloat kStatusBarHeight;
extern const CGFloat kNavigationBarHeight;

extern NSString *kBrowserBoldFontName;
extern NSString *kBrowserRegularFontName;
extern const CGFloat kElapsedTime;
extern const CGFloat kUpdatePeriod;
