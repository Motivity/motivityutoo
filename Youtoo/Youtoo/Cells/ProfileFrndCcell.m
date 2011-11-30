//
//  ProfileFrndCcell.m
//  Youtoo
//
//  Created by PRABAKAR MP on 08/09/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "ProfileFrndCcell.h"
#import "ItemModel.h"

@implementation ProfileFrndCcell
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
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(111.0, 8.0, 182.0, 17.0)];
	_timeLabel.textAlignment = UITextAlignmentLeft;
	_timeLabel.backgroundColor = [UIColor clearColor];
	_timeLabel.font = [UIFont boldSystemFontOfSize:17.0];
	_timeLabel.textColor = [UIColor blackColor];
    // _timeLabel.text = @"Time";
	//[self.contentView addSubview:_timeLabel];
    
	_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(111.0, 30.0, 182.0, 17.0)];
	_titleLabel.textAlignment = UITextAlignmentLeft;
	_titleLabel.backgroundColor = [UIColor clearColor];
	_titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
	_titleLabel.textColor = [UIColor blackColor];
    // _titleLabel.text = @"Batman(on air now)";
	[self.contentView addSubview:_titleLabel];
    
    subTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(111.0, 50.0, 182.0, 17.0)];
	subTitleLbl.textAlignment = UITextAlignmentLeft;
	subTitleLbl.backgroundColor = [UIColor clearColor];
	subTitleLbl.font = [UIFont boldSystemFontOfSize:12.0];
	subTitleLbl.textColor = [UIColor grayColor];
    // subTitleLbl.text = @"The Joker Goes to Scool";
	[self.contentView addSubview:subTitleLbl];
    
    
    
	iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(11.0, 6.0, 87.0, 65.0)];
	iconImageView.image = [UIImage imageNamed:@"logo.png"];
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
	
	if (nil != itemModel.storageImage)
	{
		_titleLabel.text = itemModel.title;
		//_timeLabel.text = [NSString stringWithFormat:@"%@ %@",itemModel.showDate, itemModel.showTime];
		//authorLabel.text = [NSString stringWithFormat:@"Author: %@",itemModel.authorName];
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
    [_timeLabel release];
    [subTitleLbl release];
    [_titleLabel release];
    [iconImageView release];
    if ( itemModel )
        [itemModel release];
    
    [super dealloc];
}

@end
