//
//  ItemModel.m
//  ALN
//
//  Created by Ihor Xom on 4/17/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "ItemModel.h"
#import "Constants.h"

@interface ItemModel (PrivateMethods)
- (void)createImageDirectoryPath;
- (BOOL)writeData:(NSData *)data atPath:(NSString *)writePath;
- (void)notifyReloadCellWithModel:(ItemModel *)itemModel;
@end

static NSString *imageDirectoryPath = nil;

@implementation ItemModel

@synthesize isBlog;
@synthesize showID;
@synthesize title;
@synthesize description;
@synthesize imagePath, storageImage;
@synthesize showDate, showTime;
@synthesize summary, airDate;
@synthesize videoPath, preRollVideoPath, postRollVideoPath;
@synthesize authorName;
@synthesize line1, line2;
@synthesize preRolltitle,postRolltitle, checkedInCount, likedCount;
@synthesize scheduleShowId;
@synthesize episodeName;
@synthesize episodeStart;
@synthesize showName;
@synthesize questionName;
@synthesize episodeid;
@synthesize fameSpotCount;
@synthesize friendAvatar;
@synthesize friendName;
@synthesize friendUserID;
@synthesize friendCredit;
@synthesize questionID;
@synthesize myStreamContent;
@synthesize videoID;
@synthesize videoImagePath;
@synthesize avatarImagePath;
@synthesize favImagePath;
@synthesize mystreamVideoThumbnail;
@synthesize followCount;

#pragma mark -

- (void)dealloc
{
	self.showID = nil;
	self.authorName = nil;
	self.description = nil;
	self.title = nil;
	self.preRolltitle = nil;
	self.postRolltitle = nil;
	self.imagePath = nil;
	self.storageImage = nil;
	self.showDate = nil;
	self.showTime = nil;
	self.summary = nil;
	self.airDate = nil;
	self.videoPath = nil;
	self.line1 = nil;
	self.line2 = nil;
	self.preRollVideoPath = nil;
	self.postRollVideoPath = nil;
	self.checkedInCount = nil;
    self.likedCount = nil;
    self.scheduleShowId=nil;
    self.episodeName=nil;
    self.episodeStart=nil;
    self.questionName=nil;
    self.episodeid=nil;
    self.fameSpotCount = nil;
    self.friendAvatar = nil;
    self.friendName = nil;
    self.friendUserID = nil;
    self.friendCredit=nil;
    self.questionID = nil;
    self.myStreamContent =nil;
    self.videoID = nil;
     self.videoImagePath=nil;
    self.avatarImagePath = nil;
    self.favImagePath = nil;
    self.mystreamVideoThumbnail = nil;
    self.followCount = nil;
    
    [super dealloc];
}

- (void)createImageDirectoryPath
{
	NSArray *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	imageDirectoryPath = [[[path objectAtIndex:0] stringByAppendingPathComponent:@"images"] retain];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL isDirectory = NO;
	NSError *error = nil;
	BOOL folderExists = ([fileManager fileExistsAtPath:imageDirectoryPath 
		isDirectory:&isDirectory] && isDirectory);
	if (NO == folderExists)
	{
		BOOL isCreated = [fileManager createDirectoryAtPath:imageDirectoryPath 
			withIntermediateDirectories:NO attributes:nil error:&error];
		
		if (!isCreated)
		{
			NSLog(@"Failed to create folder \"%@\", reason - %@", imageDirectoryPath, 
				[error localizedDescription]);
		}
	}
}

- (id)initWithDict:(NSDictionary *)aDict
{
	self = [super init];
	if (nil != self)
	{
		NSNumber *blogNumber = [aDict objectForKey:@"isblog"];
		if (nil != blogNumber)
		{
			self.isBlog = [blogNumber boolValue];
		}
		NSString *stringID = [aDict objectForKey:@"showid"]; // NEW
		if (nil != stringID)
		{
			self.showID = stringID;
		}
        NSString *epstringID = [aDict objectForKey:@"episodename"];
		if (nil != epstringID)
		{
			self.episodeName = epstringID;
		}
        NSString *likeconuntstrID = [aDict objectForKey:@"likecount"];
		if (nil != likeconuntstrID)
		{
			self.likedCount = likeconuntstrID;
		}
        NSString *followconuntstrID = [aDict objectForKey:@"followcount"];
		if (nil != followconuntstrID)
		{
			self.followCount = followconuntstrID;
		}
        NSString *epID = [aDict objectForKey:@"episodeid"];
		if (nil != epID)
		{
			self.episodeid = epID;
		}
        NSString *vidID = [aDict objectForKey:@"id"];
		if (nil != vidID)
		{
			self.videoID = vidID;
		}
        NSString *fameCount = [aDict objectForKey:@"famespots"];
		if (nil != fameCount)
		{
			self.fameSpotCount = fameCount;
		}
        NSString *avatarFriend = [aDict objectForKey:@"avatar"];
		if (nil != avatarFriend)
		{
			self.imagePath = avatarFriend;
            //NSLog(@"self.imagePath: %@", self.imagePath);
		}
        /*NSString *favThumbnail = [aDict objectForKey:@"thumbnail"];
		if (nil != favThumbnail)
		{
			self.favImagePath = favThumbnail;
		}*/
        NSString *friendCredits = [aDict objectForKey:@"friendCredit"];
		if (nil != friendCredits)
		{
			NSLog(@"friendCredit: %@", friendCredits);
            
            self.friendCredit = friendCredits;
            
            NSLog(@"self.friendCredit: %@", self.friendCredit);
		}
        NSString *frienName = [aDict objectForKey:@"username"];
		if (nil != frienName)
		{
			self.friendName = frienName;
		}
        NSString *frienUserID = [aDict objectForKey:@"userid"];
		if (nil != frienUserID)
		{
			self.friendUserID = frienUserID;
		}
        
        NSString *stremContent = [aDict objectForKey:@"content"];
		if (nil != stremContent)
		{
			self.myStreamContent = stremContent;
		}
        
        NSString *questionStr = [aDict objectForKey:@"question"];
		if (nil != questionStr)
		{
			self.questionName = questionStr;
		}
        NSString *questionIDStr = [aDict objectForKey:@"questionid"];
		if (nil != questionIDStr)
		{
			self.questionID = questionIDStr;
		}
        NSString *featuredVidFriendsImage = [aDict objectForKey:@"image"];
		if (nil != featuredVidFriendsImage)
		{
			NSLog(@"featuredVidFriendsImage: %@", featuredVidFriendsImage);
            self.imagePath  = featuredVidFriendsImage;
		}
        NSString *userImage = [aDict objectForKey:@"user_image"];
		if (nil != featuredVidFriendsImage)
		{
			NSLog(@"userImage: %@", userImage);
            self.imagePath  = userImage;
		}
        NSString *uservid = [aDict objectForKey:@"video"];
		if (nil != uservid)
		{
			NSLog(@"uservid: %@", uservid);
            self.videoPath  = uservid;
		}
		self.description = [aDict objectForKey:@"description"];
		if (nil == self.description)
		{
			self.description = @"Nondescript";
		}
		self.title = [aDict objectForKey:@"title"];
		if (nil == self.title)
		{
			self.title = @"Untitled";
		}
		self.preRolltitle = [aDict objectForKey:@"title"];
		if (nil == self.preRolltitle)
		{
			self.preRolltitle = @"Untitled";
		}
		self.postRolltitle = [aDict objectForKey:@"title"];
		if (nil == self.postRolltitle)
		{
			self.postRolltitle = @"Untitled";
		}
        self.favImagePath=[aDict objectForKey:@"thumbnail"]; // NEW
        self.mystreamVideoThumbnail = [aDict objectForKey:@"videothumbnail"];
        self.videoImagePath=[aDict objectForKey:@"image"];
        if ( self.mystreamVideoThumbnail==NULL )
            self.avatarImagePath=[aDict objectForKey:@"avatar"];        
		self.showDate = [aDict objectForKey:@"date"];
        self.showName = [aDict objectForKey:@"showname"]; // NEW
        self.scheduleShowId=[aDict objectForKey:@"showid"]; // NEW
		self.showTime = [aDict objectForKey:@"showtime"]; 
		self.imagePath = [aDict objectForKey:@"showimage"]; // NEW
        self.episodeStart=[aDict objectForKey:@"start"]; // NEW
        
		if (nil != self.imagePath)
		{
			if ([self.imagePath rangeOfString:@"uservideos"].length > 0)
			{
				self.authorName = [aDict objectForKey:@"username"];
			}
		}
		
		self.summary = [aDict objectForKey:@"summary"];
		if (nil == self.summary)
		{
			self.summary = @"No summary available";
		}
		self.airDate = [aDict objectForKey:@"airdatetime"];
		if (nil == self.airDate)
		{
			self.airDate = @"Unknown date";
		}
        
        //self.videoPath = [aDict objectForKey:@"video"];
		self.preRollVideoPath = [aDict objectForKey:@"video"];
		self.postRollVideoPath = [aDict objectForKey:@"video"];
		self.line1 = [aDict objectForKey:@"line1"];
		self.line2 = [aDict objectForKey:@"line2"];
		if (nil == imageDirectoryPath)
		{
			[self createImageDirectoryPath];
		}
	}
	return self;
}

- (void)downloadImage
{
	if (nil != self.imagePath)
	{
		NSString *imageName = [self.imagePath lastPathComponent];
		NSString *imageDevicePath =  [imageDirectoryPath stringByAppendingPathComponent:imageName];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		BOOL success = [fileManager fileExistsAtPath:imageDevicePath];
		if (success)
		{
			UIImage *anImage = [UIImage imageWithContentsOfFile:imageDevicePath];
			self.storageImage = anImage;
		}
		else
		{		
			NSURL *imageURL = [NSURL URLWithString: self.imagePath];
			NSData *data = [NSData dataWithContentsOfURL:imageURL];
			if (nil != data)
			{
				UIImage *anImage = [UIImage imageWithData:data];
				self.storageImage = anImage;
				[self writeData:data atPath:imageDevicePath];
			}
		}
	}
    else if (nil != self.videoImagePath)
	{
		NSString *videoimageName = [self.videoImagePath lastPathComponent];
		NSString *imageDevicePath =  [imageDirectoryPath stringByAppendingPathComponent:videoimageName];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		BOOL success = [fileManager fileExistsAtPath:imageDevicePath];
		if (success)
		{
			UIImage *anImage = [UIImage imageWithContentsOfFile:imageDevicePath];
			self.storageImage = anImage;
		}
		else
		{		
			NSURL *imageURL = [NSURL URLWithString: self.videoImagePath];
			NSData *data = [NSData dataWithContentsOfURL:imageURL];
			if (nil != data)
			{
				UIImage *anImage = [UIImage imageWithData:data];
				self.storageImage = anImage;
				[self writeData:data atPath:imageDevicePath];
			}
		}
	}
    else if (nil != self.avatarImagePath)
	{
		NSString *videoimageName = [self.avatarImagePath lastPathComponent];
		NSString *imageDevicePath =  [imageDirectoryPath stringByAppendingPathComponent:videoimageName];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		BOOL success = [fileManager fileExistsAtPath:imageDevicePath];
		if (success)
		{
			UIImage *anImage = [UIImage imageWithContentsOfFile:imageDevicePath];
			self.storageImage = anImage;
		}
		else
		{		
			NSURL *imageURL = [NSURL URLWithString: self.avatarImagePath];
			NSData *data = [NSData dataWithContentsOfURL:imageURL];
			if (nil != data)
			{
				UIImage *anImage = [UIImage imageWithData:data];
				self.storageImage = anImage;
				[self writeData:data atPath:imageDevicePath];
			}
		}
	}
	else if (nil != self.favImagePath)
	{
		NSString *videoimageName = [self.favImagePath lastPathComponent];
		NSString *imageDevicePath =  [imageDirectoryPath stringByAppendingPathComponent:videoimageName];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		BOOL success = [fileManager fileExistsAtPath:imageDevicePath];
		if (success)
		{
			UIImage *anImage = [UIImage imageWithContentsOfFile:imageDevicePath];
			self.storageImage = anImage;
		}
		else
		{		
			NSURL *imageURL = [NSURL URLWithString: self.favImagePath];
			NSData *data = [NSData dataWithContentsOfURL:imageURL];
			if (nil != data)
			{
				UIImage *anImage = [UIImage imageWithData:data];
				self.storageImage = anImage;
				[self writeData:data atPath:imageDevicePath];
			}
		}
	}
    
    else if (nil != self.mystreamVideoThumbnail)
	{
		NSString *videoimageName = [self.mystreamVideoThumbnail lastPathComponent];
		NSString *imageDevicePath =  [imageDirectoryPath stringByAppendingPathComponent:videoimageName];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		BOOL success = [fileManager fileExistsAtPath:imageDevicePath];
		if (success)
		{
			UIImage *anImage = [UIImage imageWithContentsOfFile:imageDevicePath];
			self.storageImage = anImage;
		}
		else
		{		
			NSURL *imageURL = [NSURL URLWithString: self.mystreamVideoThumbnail];
			NSData *data = [NSData dataWithContentsOfURL:imageURL];
			if (nil != data)
			{
				UIImage *anImage = [UIImage imageWithData:data];
				self.storageImage = anImage;
				[self writeData:data atPath:imageDevicePath];
			}
		}
	}

	
	[self performSelectorOnMainThread:@selector(notifyReloadCellWithModel:) 
		withObject:self waitUntilDone:NO];
}

- (BOOL)writeData:(NSData *)data atPath:(NSString *)writePath
{
	NSError *error = nil;
	BOOL success = [data writeToFile:writePath atomically:NO];
	if (!success)
	{
		NSLog(@"Failed to save file \"%@\"; Reason - %@", writePath, [error localizedDescription]);
	}
	
	return success;
}

- (void)notifyReloadCellWithModel:(ItemModel *)itemModel
{
	NSString *notifyString = kNotifyReloadTable;
	
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
						  notifyString,		@"1", 
						  itemModel,		@"ItemModel", nil];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kBrowserNotification
		object:nil userInfo:dict];
}

@end
