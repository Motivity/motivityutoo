//
//  ProfileFavoritesCell.m
//  Youtoo
//
//  Created by PRABAKAR MP on 29/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "ProfileFavoritesCell.h"
#import "ItemModel.h"

@implementation ProfileFavoritesCell
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
	_titleLabel = [[UITextView alloc] initWithFrame:CGRectMake(100.0, 5.0, 220.0, 67.0)];
	_titleLabel.textAlignment = UITextAlignmentLeft;
	_titleLabel.backgroundColor = [UIColor clearColor];
	//_titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
	//_titleLabel.textColor = [UIColor blackColor];
    _titleLabel.editable = NO;
    _titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
	_titleLabel.textColor = [UIColor colorWithRed:0.15 green:0.29 blue:0.43 alpha:1.0];
    //_titleLabel.text = @"Batman";
	[self.contentView addSubview:_titleLabel];
   
    /*subTitle = [[UILabel alloc] initWithFrame:CGRectMake(111.0, 25.0, 168.0, 15.0)];
	subTitle.textAlignment = UITextAlignmentLeft;
	subTitle.backgroundColor = [UIColor clearColor];
	subTitle.font = [UIFont boldSystemFontOfSize:11.0];
	subTitle.textColor = [UIColor grayColor];
    subTitle.text = @"What was your favorite episode from season 1?";
	[self.contentView addSubview:subTitle];
    
    visitLbl = [[UILabel alloc] initWithFrame:CGRectMake(111.0, 40.0, 168.0, 15.0)];
	visitLbl.textAlignment = UITextAlignmentLeft;
	visitLbl.backgroundColor = [UIColor clearColor];
	visitLbl.font = [UIFont boldSystemFontOfSize:11.0];
	visitLbl.textColor = [UIColor grayColor];
    visitLbl.text = @"Next airing at:";
	[self.contentView addSubview:visitLbl];
    
    dateLbl = [[UILabel alloc] initWithFrame:CGRectMake(111.0, 55.0, 168.0, 15.0)];
	dateLbl.textAlignment = UITextAlignmentLeft;
	dateLbl.backgroundColor = [UIColor clearColor];
	dateLbl.font = [UIFont boldSystemFontOfSize:11.0];
	dateLbl.textColor = [UIColor blackColor];
    dateLbl.text = @"Date";
	[self.contentView addSubview:dateLbl];    
    */
	iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 5.0, 87.0, 70.0)];
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
	
    if ( itemModel.title!=NULL )
        _titleLabel.text = itemModel.title;
    else
        _titleLabel.text = @"My Favorite";
    
	if (nil != itemModel.storageImage)
	{
		iconImageView.image = itemModel.storageImage;
	}
    else
        iconImageView.image = [UIImage imageNamed:@"logo.png"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [_titleLabel release];
    [iconImageView release];
    
    if ( itemModel )
        [itemModel release];
    
    [super dealloc];
}

@end
