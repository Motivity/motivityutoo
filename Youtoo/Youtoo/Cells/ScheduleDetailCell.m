//
//  FameSpotCell.m
//  Youtoo
//
//  Created by PRABAKAR MP on 23/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "ScheduleDetailCell.h"
#import "ItemModel.h"

@implementation ScheduleDetailCell

@synthesize itemModel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCellLabels];
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    return self;
}
- (void)createCellLabels
{
	_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(111.0, 8.0, 182.0, 17.0)];
	_titleLabel.textAlignment = UITextAlignmentLeft;
	_titleLabel.backgroundColor = [UIColor clearColor];
	_titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
	_titleLabel.textColor = [UIColor blackColor];
    //_titleLabel.text = @"Batman";
	[self.contentView addSubview:_titleLabel];
    
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
	
	//if (nil != itemModel.storageImage)
	{
		_titleLabel.text = itemModel.showName;
        if ( nil == itemModel.storageImage )
            iconImageView.image = [UIImage imageNamed:@"logo.png"];
        else
            iconImageView.image = itemModel.storageImage;
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)dealloc
{
    [super dealloc];
}

@end
