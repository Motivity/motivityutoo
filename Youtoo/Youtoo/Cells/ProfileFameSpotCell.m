//
//  ProfileFameSpotCell.m
//  Youtoo
//
//  Created by PRABAKAR MP on 25/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "ProfileFameSpotCell.h"


@implementation ProfileFameSpotCell

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
    likesLbl = [[UILabel alloc] initWithFrame:CGRectMake(150.0, 38.0, 168.0, 15.0)];
	likesLbl.textAlignment = UITextAlignmentLeft;
	likesLbl.backgroundColor = [UIColor clearColor];
	likesLbl.font = [UIFont boldSystemFontOfSize:11.0];
	likesLbl.textColor = [UIColor grayColor];
    likesLbl.text = @"Num";
	[self.contentView addSubview:likesLbl];
    
    likesImgView = [[UIImageView alloc] initWithFrame:CGRectMake(109.0, 30.0, 38.0, 33.0)];
	likesImgView.image = [UIImage imageNamed:@"38_profile_viewFS-heart.png"];
	likesImgView.contentMode = UIViewContentModeScaleAspectFit;
	[self.contentView addSubview:likesImgView];
    
    visitLbl = [[UILabel alloc] initWithFrame:CGRectMake(250.0, 40.0, 168.0, 15.0)];
	visitLbl.textAlignment = UITextAlignmentLeft;
	visitLbl.backgroundColor = [UIColor clearColor];
	visitLbl.font = [UIFont boldSystemFontOfSize:11.0];
	visitLbl.textColor = [UIColor grayColor];
    visitLbl.text = @"Num";
	[self.contentView addSubview:visitLbl];
    
    visitImgView = [[UIImageView alloc] initWithFrame:CGRectMake(190.0, 30.0, 44.0, 32.0)];
	visitImgView.image = [UIImage imageNamed:@"38_profile_viewFS-eye.png"];
	visitImgView.contentMode = UIViewContentModeScaleAspectFit;
	[self.contentView addSubview:visitImgView];


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
    [likesLbl release];
    [visitLbl release];
    [likesImgView release];
    [visitImgView release];
    [iconImageView release];
    
    [super dealloc];
}

@end
