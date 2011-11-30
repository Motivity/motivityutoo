//
//  SelectAfameSpotCell.m
//  Youtoo
//
//  Created by PRABAKAR MP on 23/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "UpcomingEpisodesCell.h"
#import "ItemModel.h"

@implementation UpcomingEpisodesCell
@synthesize itemModel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCellLabels];
    
    }
    return self;
}
- (void)createCellLabels
{
	
	
	_showTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(111.0, 17.0, 200.0, 50.0)];
	_showTimeLabel.textAlignment = UITextAlignmentLeft;
	_showTimeLabel.backgroundColor = [UIColor clearColor];
	_showTimeLabel.font = [UIFont boldSystemFontOfSize:28.0];
	_showTimeLabel.textColor =[UIColor colorWithRed:0.14 green:0.29 blue:0.42 alpha:1];
     
     _showTimeLabel.numberOfLines = 4;
	[self.contentView addSubview:_showTimeLabel];
    
	iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(11.0, 6.0, 87.0, 65.0)];
	iconImageView.image = [UIImage imageNamed:@"image.png"];
	iconImageView.contentMode = UIViewContentModeScaleAspectFit;
	[self.contentView addSubview:iconImageView];
    
	
}

- (void)setItemModel:(ItemModel *)aModel
{
	if (aModel != itemModel)
	{
		[itemModel release];
		itemModel = [aModel retain];
	}
	
	//if (nil != itemModel.storageImage)
	{
		//_titleLabel.text = itemModel.episodeName;
        _showTimeLabel.text = itemModel.showTime;
        
        if ( nil == itemModel.storageImage )
            iconImageView.image = [UIImage imageNamed:@"logo.png"];
        else
            iconImageView.image = itemModel.storageImage;
	}
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [_showTimeLabel release];
    [iconImageView release];

    if ( itemModel )
        [itemModel release];
    
    [super dealloc];
}

@end
