//
//  ItemStorage.m
//  ALN
//
//  Created by Ihor Xom on 4/15/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "ItemStorage.h"
#import "ItemModel.h"
#import "Constants.h"

@interface ItemStorage (PrivateMethods)
- (void)createImageDirectoryPath;
- (BOOL)writeData:(NSData *)data atPath:(NSString *)writePath;
- (void)downloadImagesInBackground;
- (void)loadImageFromModel:(ItemModel *)itemModel;
- (void)notifyReloadCellWithModel:(ItemModel *)itemModel;
@end

@implementation ItemStorage

@synthesize imageDirectoryPath = _imageDirectoryPath;
@synthesize storageList = _storageList;
@synthesize threadObj;

- (id)init
{
	self = [super init];
	if (nil != self)
	{
		_storageList = [[NSMutableArray alloc] init];
		[self createImageDirectoryPath];
	}
	return self;
}

- (void)createImageDirectoryPath
{
	NSArray *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	self.imageDirectoryPath = [[path objectAtIndex:0] stringByAppendingPathComponent:@"images"];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL isDirectory = NO;
	NSError *error = nil;
	BOOL folderExists = ([fileManager fileExistsAtPath:self.imageDirectoryPath 
		isDirectory:&isDirectory] && isDirectory);
	if (NO == folderExists)
	{
		BOOL isCreated = [fileManager createDirectoryAtPath:self.imageDirectoryPath 
			withIntermediateDirectories:NO attributes:nil error:&error];
		
		if (!isCreated)
		{
			NSLog(@"Failed to create folder \"%@\", reason - %@", self.imageDirectoryPath, 
				  [error localizedDescription]);
		}
	}
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

- (void)downloadImages
{
	[NSThread detachNewThreadSelector:@selector(downloadImagesInBackground) toTarget:self withObject:threadObj];
}

- (void)downloadImagesInBackground
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	if (nil != _storageList && [_storageList count] > 0)
	{
		for (ItemModel *model in _storageList)
		{
			[self loadImageFromModel:model];
		}
	}
	[self performSelectorOnMainThread:@selector(notifyImagesDidLoad) 
						   withObject:nil waitUntilDone:NO];

	[pool release];
}

-(void) stopThread
{
    [NSThread exit];     
}

- (void)loadImageFromModel:(ItemModel *)itemModel
{	
	if (nil != itemModel.imagePath)
	{
		NSString *imageName = [itemModel.imagePath lastPathComponent];
		NSString *imagePath =  [self.imageDirectoryPath stringByAppendingPathComponent:imageName];
		NSFileManager *fileManager = [NSFileManager defaultManager];	
		BOOL success = [fileManager fileExistsAtPath:imagePath];
		if (success)
		{
			UIImage *anImage = [UIImage imageWithContentsOfFile:imagePath];
			itemModel.storageImage = anImage;
		}
		else
		{		
			NSURL *imageURL = [NSURL URLWithString: itemModel.imagePath];
			NSData *data = [NSData dataWithContentsOfURL:imageURL];
			if (nil != data)
			{
				UIImage *anImage = [UIImage imageWithData:data];
				itemModel.storageImage = anImage;
				
				[self writeData:data atPath:imagePath];
			}
		}
	}
    else   if (nil != itemModel.videoImagePath)
	{
		NSString *imageName = [itemModel.videoImagePath lastPathComponent];
		NSString *imagePath =  [self.imageDirectoryPath stringByAppendingPathComponent:imageName];
		NSFileManager *fileManager = [NSFileManager defaultManager];	
		BOOL success = [fileManager fileExistsAtPath:imagePath];
		if (success)
		{
			UIImage *anImage = [UIImage imageWithContentsOfFile:imagePath];
			itemModel.storageImage = anImage;
		}
		else
		{		
			NSURL *imageURL = [NSURL URLWithString: itemModel.videoImagePath];
			NSData *data = [NSData dataWithContentsOfURL:imageURL];
			if (nil != data)
			{
				UIImage *anImage = [UIImage imageWithData:data];
				itemModel.storageImage = anImage;
				
				[self writeData:data atPath:imagePath];
			}
		}
	}
    else if (nil != itemModel.avatarImagePath)
	{
		NSString *imageName = [itemModel.avatarImagePath lastPathComponent];
		NSString *imagePath =  [self.imageDirectoryPath stringByAppendingPathComponent:imageName];
		NSFileManager *fileManager = [NSFileManager defaultManager];	
		BOOL success = [fileManager fileExistsAtPath:imagePath];
		if (success)
		{
			UIImage *anImage = [UIImage imageWithContentsOfFile:imagePath];
			itemModel.storageImage = anImage;
		}
		else
		{		
			NSURL *imageURL = [NSURL URLWithString: itemModel.avatarImagePath];
			NSData *data = [NSData dataWithContentsOfURL:imageURL];
			if (nil != data)
			{
				UIImage *anImage = [UIImage imageWithData:data];
				itemModel.storageImage = anImage;
				
				[self writeData:data atPath:imagePath];
			}
		}
	}
    else if (nil != itemModel.favImagePath)
	{
		NSString *imageName = [itemModel.favImagePath lastPathComponent];
		NSString *imagePath =  [self.imageDirectoryPath stringByAppendingPathComponent:imageName];
		NSFileManager *fileManager = [NSFileManager defaultManager];	
		BOOL success = [fileManager fileExistsAtPath:imagePath];
		if (success)
		{
			UIImage *anImage = [UIImage imageWithContentsOfFile:imagePath];
			itemModel.storageImage = anImage;
		}
		else
		{		
			NSURL *imageURL = [NSURL URLWithString: itemModel.favImagePath];
			NSData *data = [NSData dataWithContentsOfURL:imageURL];
			if (nil != data)
			{
				UIImage *anImage = [UIImage imageWithData:data];
				itemModel.storageImage = anImage;
				
				[self writeData:data atPath:imagePath];
			}
		}
	}
    
    else if (nil != itemModel.mystreamVideoThumbnail)
	{
		NSString *imageName = [itemModel.mystreamVideoThumbnail lastPathComponent];
		NSString *imagePath =  [self.imageDirectoryPath stringByAppendingPathComponent:imageName];
		NSFileManager *fileManager = [NSFileManager defaultManager];	
		BOOL success = [fileManager fileExistsAtPath:imagePath];
		if (success)
		{
			UIImage *anImage = [UIImage imageWithContentsOfFile:imagePath];
			itemModel.storageImage = anImage;
		}
		else
		{		
			NSURL *imageURL = [NSURL URLWithString: itemModel.mystreamVideoThumbnail];
			NSData *data = [NSData dataWithContentsOfURL:imageURL];
			if (nil != data)
			{
				UIImage *anImage = [UIImage imageWithData:data];
				itemModel.storageImage = anImage;
				
				[self writeData:data atPath:imagePath];
			}
		}
	}
    


    
	[self performSelectorOnMainThread:@selector(notifyReloadCellWithModel:) 
						   withObject:itemModel waitUntilDone:NO];
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

- (void)notifyImagesDidLoad
{
	NSString *notifyString = kNotifyImagesDidLoad;
	
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
						  notifyString,	@"1", 
						  nil];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kBrowserNotification
		object:nil userInfo:dict];
}

- (void)cleanStorage
{
	[self.storageList removeAllObjects];
}

- (void)cleanImages
{
	if (nil != _storageList && [_storageList count] > 0)
	{
		for (ItemModel *model in _storageList)
		{
			model.storageImage = nil;
		}
	}
}

- (void)addFavoriteShow:(ItemModel *)favoriteModel
{
	if (nil != favoriteModel)
	{
		BOOL showIsPresent = NO;
		for (ItemModel *model in self.storageList)
		{
			if (nil != model.showID && nil != favoriteModel.showID && 
				[model.showID isEqualToString:favoriteModel.showID])
			{
				showIsPresent = YES;
				break;
			}
		}
		
		if (!showIsPresent)
		{
			[self.storageList addObject:favoriteModel];
			if (nil == favoriteModel.storageImage && nil != favoriteModel.imagePath)
			{
				[self loadImageFromModel:favoriteModel];
			}
		}
	}
}

#pragma mark -

- (void)dealloc
{
	[_imageDirectoryPath release];
	[_storageList release];
	
    [super dealloc];
}

@end
