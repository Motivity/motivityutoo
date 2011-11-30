//
//  AdvModel.m
//  ALN
//
//  Created by Ihor Xom on 4/17/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "AdvModel.h"
#import "Constants.h"

@interface AdvModel (PrivateMethods)
- (void)createImageDirectoryPath;
- (BOOL)writeData:(NSData *)data atPath:(NSString *)writePath;
- (void)postUpdateAdvertisingNotification;
@end

static NSString *imageDirectoryPath = nil;
static AdvModel *sharedAdvertising = nil;

@implementation AdvModel

@synthesize text, name, homeTown, birthDay;
@synthesize imagePath, profilePath;
@synthesize storageImage, profileImage;
@synthesize interests, moviesGenre, movies;
@synthesize	advertisingPath;
@synthesize	moreinfoPath;

+ (AdvModel *)sharedAdvertising
{
	if (nil == sharedAdvertising)
	{
		sharedAdvertising = [[AdvModel alloc] init];
	}
	return sharedAdvertising;
	
}

- (id)init
{
	self = [super init];
	if (nil != self)
	{
		if (nil == imageDirectoryPath)
		{
			[self createImageDirectoryPath];
		}
	}
	return self;
}

- (void)dealloc
{
	[self initializeModel];
    [super dealloc];
}

- (void)initializeModel
{
	self.storageImage = nil;
	self.profileImage = nil;
	self.profilePath = nil;
	self.text = nil;
	self.name = nil;
	self.imagePath = nil;
	self.homeTown = nil;
	self.interests = nil;
	self.moviesGenre = nil;
	self.movies = nil;
	self.birthDay = nil;
	self.advertisingPath = nil;
    self.moreinfoPath = nil;
}

- (void)createImageDirectoryPath
{
	NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
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

- (void)setImagePath:(NSString *)aPath
{
	if (aPath != imagePath)
	{
		[imagePath release];
		imagePath = [aPath retain];
		if (nil != imagePath)
		{
			[self loadImage];
		}
	}
}

- (void)loadImage
{
	if (nil != self.imagePath)
	{
		NSString *imageName = [self.imagePath lastPathComponent];
		NSString *loadImagePath =  [imageDirectoryPath stringByAppendingPathComponent:imageName];
		NSFileManager *fileManager = [NSFileManager defaultManager];	
		BOOL success = [fileManager fileExistsAtPath:loadImagePath];
		if (success)
		{
			UIImage *anImage = [UIImage imageWithContentsOfFile:loadImagePath];
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
				[self writeData:data atPath:loadImagePath];
				[self performSelectorOnMainThread:@selector(postUpdateAdvertisingNotification) 
					withObject:nil waitUntilDone:NO];
			}
			else
			{
				self.storageImage = [UIImage imageNamed:@"defaultProfile.png"];
			}
		}
	}
	else
	{
		self.storageImage = [UIImage imageNamed:@"defaultProfile.png"];
	}
}

- (void)loadProfileImage
{
	if (nil != self.profilePath)
	{
		NSString *imageName = [self.profilePath lastPathComponent];
		NSString *loadImagePath =  [imageDirectoryPath stringByAppendingPathComponent:imageName];
		NSFileManager *fileManager = [NSFileManager defaultManager];	
		BOOL success = [fileManager fileExistsAtPath:loadImagePath];
		if (success)
		{
			self.profileImage =  [UIImage imageWithContentsOfFile:loadImagePath];
		}
		else
		{		
			NSURL *imageURL = [NSURL URLWithString: self.profilePath];
			NSData *data = [NSData dataWithContentsOfURL:imageURL];
			if (nil != data)
			{
				UIImage *anImage = [UIImage imageWithData:data];
				self.profileImage = anImage;
				[self writeData:data atPath:loadImagePath];
				[self performSelectorOnMainThread:@selector(postUpdateAdvertisingNotification) 
					withObject:nil waitUntilDone:NO];
			}
			else
			{
				self.profileImage = [UIImage imageNamed:@"defaultProfile.png"];
			}
		}
	}
	else
	{
		self.profileImage = [UIImage imageNamed:@"defaultProfile.png"];
	}
}

- (void)postUpdateAdvertisingNotification
{	
	[[NSNotificationCenter defaultCenter] postNotificationName:kAdvertisingNotification
		object:nil userInfo:nil];
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

@end
