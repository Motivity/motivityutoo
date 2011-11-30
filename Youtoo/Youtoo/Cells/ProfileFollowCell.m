//
//  ProfileFollowCell.m
//  Youtoo
//
//  Created by PRABAKAR MP on 29/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "ProfileFollowCell.h"


@implementation ProfileFollowCell

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
	_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(111.0, 8.0, 182.0, 17.0)];
	_titleLabel.textAlignment = UITextAlignmentLeft;
	_titleLabel.backgroundColor = [UIColor clearColor];
	_titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
	_titleLabel.textColor = [UIColor blackColor];
    _titleLabel.text = @"Batman";
	[self.contentView addSubview:_titleLabel];
    
	iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(11.0, 6.0, 87.0, 65.0)];
	iconImageView.image = [UIImage imageNamed:@"logo.png"];
	iconImageView.contentMode = UIViewContentModeScaleAspectFit;
	[self.contentView addSubview:iconImageView];
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
    
    [super dealloc];
}

@end
