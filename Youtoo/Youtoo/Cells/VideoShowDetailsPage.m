//
//  VideoShowDetailsPage.m
//  Youtoo
//
//  Created by Subrahmanyam Chaturvedula's on 22/09/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "VideoShowDetailsPage.h"
#import "ItemModel.h"

#import "VideosDone.h"

@implementation VideoShowDetailsPage

@synthesize itemModel;
@synthesize itemModel2;
@synthesize delegateController;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //currRow = row;
        //dataCount = storageCount;
        //[self createCellLabels];
    }
    return self;
}

-(void) getCurrRow :(int) row :(NSUInteger) storageCount
{
    currRow = row;
     dataCount = storageCount;
}
- (void)createCellLabels :(NSUInteger) storageCount
{
    
    dataCount = storageCount;

    
    NSUInteger val = (currRow)+(currRow);
    
    btn1 = [[[UIButton alloc] initWithFrame:CGRectMake(39.0, 6.0, 100.0, 100.0)] autorelease];
       
    //[btn1 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:btn1];
    //[btn1 release];
    
    lbl1 = [[[UILabel alloc] initWithFrame:CGRectMake(39.0, 104.0, 100.0, 40.0)] autorelease];
    lbl1.textAlignment = UITextAlignmentLeft;
    lbl1.backgroundColor = [UIColor clearColor];
   [lbl1 setFont:[UIFont systemFontOfSize:14.0]];
     lbl1.numberOfLines = 2;
    lbl1.textColor = [UIColor colorWithRed:0.015 green:0.2 blue:0.26 alpha:1];
    [self.contentView addSubview:lbl1];
    //[lbl1 release];
    
    //if ( (currRow==0 && dataCount>1) ||  currRow>0 )
    {
    
    btn2 = [[[UIButton alloc] initWithFrame:CGRectMake(180.0, 6.0, 100.0, 100.0)] autorelease];  
    
    
    NSLog(@"btn1.tag : %d", btn2.tag );
    [self.contentView addSubview:btn2];
    //[btn2 release];
    
    lbl2 = [[[UILabel alloc] initWithFrame:CGRectMake(180.0, 104.0, 100.0, 40.0)] autorelease];
    lbl2.textAlignment = UITextAlignmentLeft;
    lbl2.backgroundColor = [UIColor clearColor];
    [lbl2 setFont:[UIFont systemFontOfSize:14.0]];
        lbl2.numberOfLines = 2;
    lbl2.textColor = [UIColor colorWithRed:0.015 green:0.2 blue:0.26 alpha:1];
    [self.contentView addSubview:lbl2];
    //[lbl2 release];
        
    }
    /////////////////////////////////
    
}

- (void)setItemModel:(ItemModel *)aModel
{
	if (aModel != itemModel)
	{
		[itemModel release];
		itemModel = [aModel retain];
	}
    
	lbl1.text = itemModel.friendName;
    
    NSUInteger val = (currRow)+(currRow);
    btn1.tag = (currRow==0)?currRow: val;
    [btn1 addTarget:self.delegateController action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    lbl1.tag = currRow;   
    
	if (nil != itemModel.storageImage)
	{
        [btn1 setImage:aModel.storageImage forState:UIControlStateNormal];        
	}
    else
    {
        [btn1 setImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
    }
}

- (void)setItemModel2:(ItemModel *)aModel
{
	//NSLog(@"dataCount: %d ; currRow: %d", dataCount, currRow);
    
    if ( (currRow==0 && dataCount>1) ||  currRow>0 )
    {
            
	if (aModel != itemModel2)
	{
		[itemModel2 release];
		itemModel2 = [aModel retain];
	}
    
    lbl2.text = itemModel2.friendName;
    
    NSUInteger val = (currRow)+(currRow);
    btn2.tag = (currRow==0)?(currRow+1):val+1;
    [btn2 addTarget:self.delegateController action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
    lbl2.tag = currRow+1; 
        
	if (nil != itemModel.storageImage)
	{
        [btn2 setImage:itemModel2.storageImage forState:UIControlStateNormal];
	}
    else
    {
        [btn2 setImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
    }
    
    }
}

-(IBAction) buttonPressed: (id) sender
{
    UIButton *button = (UIButton *)sender;
    NSLog(@"Btn Tag in Video Detail Cell: %d", [sender tag]);
    
    if ([self.delegateController respondsToSelector:@selector(buttonPressed:)])
	{
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dealloc
{
    if ( itemModel )
        [itemModel release];
    if ( itemModel2 )
        [itemModel2 release];
    
    [super dealloc];
}

@end
