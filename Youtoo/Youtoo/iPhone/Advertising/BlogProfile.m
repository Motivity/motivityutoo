//
//  BlogProfile.m
//  ALN
//
//  Created by Ihor Xom on 10/17/10.
//  Copyright 2010 OneHeartMovie. All rights reserved.
//

#import "BlogProfile.h"
#import "YoutooAppDelegate.h"
#import "ItemModel.h"
#import "AdvModel.h"

@interface BlogProfile (PrivateMethods)
- (void)applyModelToProfile;
- (void)startReadingProfile;
- (NSString *)correctString:(NSString *)originalURLString;
- (NSInteger)calculateLineCountIn:(NSString *)aDescripion forLabel:(UILabel *)aLabel;
@end

static const CGFloat kEnoughWidth = 5000;
static const CGFloat kLineHeight = 21.0;
static const NSInteger kMaxTextRows = 4;

@implementation BlogProfile

@synthesize model;
@synthesize itemModel;
@synthesize rssParser;
@synthesize currentElement;
@synthesize activityIndicator;	
@synthesize profilePhoto;
@synthesize nameLabel;
@synthesize birthdayLabel;
@synthesize cityLabel;
@synthesize movieGenreLabel;
@synthesize movieListLabel;
@synthesize interestsLabel;
@synthesize movieGenreTitle;
@synthesize moviesTitle;

- (id)init
{
	self = [super initWithNibName:@"BlogProfile" bundle:nil];
	if (nil != self)
	{
		model = [[AdvModel alloc] init];
	}
	return self;
}

- (void)dealloc
{
	self.currentElement = nil;
	[model release];
	[rssParser release];
	[itemModel release];
	[activityIndicator release];	
	[profilePhoto release];
	[nameLabel release];
	[birthdayLabel release];
	[cityLabel release];
	[movieGenreLabel release];
	[movieListLabel release];
	[interestsLabel release];
	[movieGenreTitle release];
	[moviesTitle release];
    [super dealloc];
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.title = NSLocalizedString(@"Profile", @"Nav Title");
}

- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
	self.profilePhoto = nil;
	self.nameLabel = nil;
	self.birthdayLabel = nil;
	self.cityLabel = nil;
	self.movieGenreLabel = nil;
	self.movieListLabel = nil;
	self.interestsLabel = nil;
	self.movieGenreTitle = nil;
	self.moviesTitle = nil;
    self.activityIndicator = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	if (nil != self.itemModel)
	{
		[self startReadingProfile];
	}
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.selectedController = nil;	

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
	
	if (nil != self.rssParser)
	{
		[self.rssParser abortParsing];
	}		
}



- (void)startReadingProfile
{
	[activityIndicator startAnimating];
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    // Get the current timezone in hours and send to server...
    NSDate *sourceDate = [NSDate dateWithTimeIntervalSinceNow:3600 * 24 * 60];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    int timeZoneOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate] / 3600;
    NSLog(@"sourceDate=%@ timeZoneOffset=%d", sourceDate, timeZoneOffset);
    NSString *advURLString;
    NSMutableString *tempURLStr = [[NSMutableString alloc] init];
   // [tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/profile/%@?offset=%d&sessioncookie=%@", self.itemModel.authorName, timeZoneOffset,appDelegate.sessionCookie];
     [tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/profile/%@?offset=%d", self.itemModel.authorName, timeZoneOffset];

    advURLString = [tempURLStr copy];
    NSLog(advURLString);
    [tempURLStr release];
    tempURLStr=nil;
	[NSThread detachNewThreadSelector:@selector(parseXMLFilewithData:) toTarget:self withObject:advURLString];
    
}

- (void)applyModelToProfile
{
	[self.activityIndicator stopAnimating];
	self.nameLabel.text = self.model.name;
	if (nil != self.model.profileImage)
	{
		self.profilePhoto.image = self.model.profileImage;
	}
	else
	{
		self.profilePhoto.image = self.model.storageImage;
	}
	
	if (nil != self.model.birthDay)
	{
		self.birthdayLabel.text = self.model.birthDay;
	}
	
	if (nil != self.model.homeTown)
	{
		self.cityLabel.text = self.model.homeTown;
	}
	
	CGFloat interestsHeight = kLineHeight;
	if (nil != self.model.interests)
	{
		NSString *interests = self.model.interests;
		NSInteger linesCount = 1;
		if (nil != interests && [interests length] > 0)
		{
			linesCount = [self calculateLineCountIn:interests forLabel:self.interestsLabel];
			self.interestsLabel.numberOfLines = linesCount;
		}
		interestsHeight = fmax(kLineHeight, kLineHeight * linesCount);
		self.interestsLabel.frame = CGRectMake(100.0, 224.0, self.interestsLabel.frame.size.width, interestsHeight);
		self.interestsLabel.text = self.model.interests;
	}
	self.movieGenreTitle.frame = CGRectMake(20.0, 195.0 + interestsHeight, 110.0, 21.0);
	self.movieGenreLabel.frame = CGRectMake(130.0, 195.0 + interestsHeight, 190.0, 21.0);
	if (nil != self.model.moviesGenre)
	{
		self.movieGenreLabel.text = self.model.moviesGenre;
	}
	self.moviesTitle.frame = CGRectMake(20.0, 227.0 + interestsHeight, 72.0, 21.0);
	if (nil != self.model.movies)
	{
		NSString *movies = self.model.movies;
		NSInteger linesCount = [self calculateLineCountIn:movies forLabel:self.movieListLabel];
		self.movieListLabel.numberOfLines = linesCount;
		CGFloat labelHeight = kLineHeight * linesCount;
		self.movieListLabel.frame = CGRectMake(100.0, 227 + interestsHeight, 200.0, labelHeight);
		self.movieListLabel.text = self.model.movies;
	}
}

- (NSInteger)calculateLineCountIn:(NSString *)aDescripion forLabel:(UILabel *)aLabel
{
	NSArray *wordArray = [aDescripion componentsSeparatedByString:@" "];
	CGFloat labelWidth = aLabel.frame.size.width;
	NSInteger linesCount = 0;
	NSInteger nWord = 0;
	int ind = 0, wordInd = 0;
	if ([wordArray count] > 0)
	{
		for (ind = 0; ind < kMaxTextRows; ind++)
		{
			NSMutableString *lineStr = [NSMutableString new];
			BOOL isLineBroken = NO;
			for (wordInd = nWord; wordInd < [wordArray count]; wordInd++)
			{
				NSString *word = [wordArray objectAtIndex:wordInd];
				[lineStr appendString:word];
				if (wordInd < [wordArray count] - 1)
				{
					[lineStr appendString:@" "];
				}
				
				CGSize titleSize = [lineStr sizeWithFont:aLabel.font
					forWidth:kEnoughWidth lineBreakMode:UILineBreakModeWordWrap];
				
				if (titleSize.width > labelWidth)
				{
					nWord = wordInd;
					isLineBroken = YES;
					linesCount++;
					break;
				}
			}
			if (!isLineBroken)
			{
				linesCount++;
				[lineStr release];
				break;
			}
			[lineStr release];
		}
	}
	
	if (linesCount > kMaxTextRows)
	{
		linesCount = kMaxTextRows;
	}
	return linesCount;
}

#pragma mark -
#pragma mark Actions
#pragma mark -

- (void)setItemModel:(ItemModel *)aModel
{
	if (aModel != itemModel)
	{
		[itemModel release];
		itemModel = [aModel retain];
		if (nil != self.profilePhoto)
		{
			[self startReadingProfile];
		}
	}
}

- (IBAction)hideAction:(id)sender
{
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate showFloatingBar];
	[appDelegate startAdvertisingBar];
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark XMLParser
#pragma mark -

- (void)parseXMLFilewithData:(NSString *)strURL
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSURL *dataURL = [NSURL URLWithString:strURL];
	self.rssParser = [[[NSXMLParser alloc] initWithContentsOfURL:dataURL] autorelease];
	[self.rssParser setDelegate:self];
	[self.rssParser parse];
	[pool release];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
	
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	[self.activityIndicator stopAnimating];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
	attributes:(NSDictionary *)attributeDict
{
    self.currentElement = elementName;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	NSString *trimmString = [string stringByTrimmingCharactersInSet:
							 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	if ([trimmString length] > 0)
	{
		if ([self.currentElement isEqualToString:@"name"])
		{
			self.model.name = [self correctString:trimmString];
		}
		else if ([self.currentElement isEqualToString:@"user_image"])
		{
			self.model.profilePath = [self correctString:trimmString];
		}
		else if ([self.currentElement isEqualToString:@"birthday"])
		{
			self.model.birthDay = [self correctString:trimmString];
		}
		else if ([self.currentElement isEqualToString:@"city"])
		{
			self.model.homeTown = [self correctString:trimmString];
		}
		else if ([self.currentElement isEqualToString:@"interests"])
		{
			self.model.interests = [self correctString:trimmString];
		}
		else if ([self.currentElement isEqualToString:@"movies"])
		{
			self.model.movies = [self correctString:trimmString];
		}
		else if ([self.currentElement isEqualToString:@"movies_genre"])
		{
			self.model.moviesGenre = [self correctString:trimmString];
		}
	}
}

- (NSString *)correctString:(NSString *)originalURLString
{
	CFStringRef preprocessedString =
		CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, 
		(CFStringRef)originalURLString, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8);
	return [(NSString *)preprocessedString autorelease];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	[self.model loadProfileImage];
	[self performSelectorOnMainThread:@selector(applyModelToProfile) withObject:nil waitUntilDone:NO];
}

#pragma mark end XMLParser

@end
