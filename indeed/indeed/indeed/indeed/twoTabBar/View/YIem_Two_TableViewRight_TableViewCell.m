//
//  YIem_Two_TableViewRight_TableViewCell.m
//  indeed
//
//  Created by YIem on 16/10/17.
//  Copyright © 2016年 YIem. All rights reserved.
//

#import "YIem_Two_TableViewRight_TableViewCell.h"


@interface YIem_Two_TableViewRight_TableViewCell ()


@property (nonatomic, strong) UIView *viewView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *briefLabel;

@end

@implementation YIem_Two_TableViewRight_TableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatSubViews];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    frame.size.height -= 10;
    frame.origin.x += 10;
    frame.origin.y += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)creatSubViews {
    
    self.viewView = [[UIView alloc] init];
    [self.contentView addSubview:_viewView];
    
    self.titleLabel = [[UILabel alloc] init];
    //    _titleLabel.backgroundColor = [UIColor whiteColor];
    [_viewView addSubview:_titleLabel];
    
    self.nameLabel = [[UILabel alloc] init];
    //    _nameLabel.backgroundColor = [UIColor whiteColor];
    [_viewView addSubview:_nameLabel];
    
    self.cityLabel = [[UILabel alloc] init];
    //    _cityLabel.backgroundColor = [UIColor whiteColor];
    [_viewView addSubview:_cityLabel];
    
    self.timeLabel = [[UILabel alloc] init];
    //    _timeLabel.backgroundColor = [UIColor whiteColor];
    [_viewView addSubview:_timeLabel];

    
    self.briefLabel = [[UILabel alloc] init];
    //    _briefLabel.backgroundColor = [UIColor whiteColor];
    _briefLabel.numberOfLines = 0;
    _briefLabel.font = [UIFont systemFontOfSize:12];
    _briefLabel.textAlignment = NSTextAlignmentCenter;
    [_viewView addSubview:_briefLabel];


    
}
- (void)layoutSubviews {
    _viewView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _titleLabel.frame = CGRectMake(10, 10, _viewView.frame.size.width - 10, 20);
    _nameLabel.frame = CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y + _titleLabel.frame.size.height, _titleLabel.frame.size.width, _titleLabel.frame.size.height);
    _cityLabel.frame = CGRectMake(_titleLabel.frame.origin.x, _nameLabel.frame.origin.y + _nameLabel.frame.size.height, _titleLabel.frame.size.width, _titleLabel.frame.size.height);
    _timeLabel.frame = CGRectMake(_titleLabel.frame.origin.x, _cityLabel.frame.origin.y + _cityLabel.frame.size.height, _titleLabel.frame.size.width, _titleLabel.frame.size.height);
    _briefLabel.frame = CGRectMake(_titleLabel.frame.origin.x, _timeLabel.frame.origin.y + _timeLabel.frame.size.height, self.frame.size.width - 20, 60);
    

}

- (void)setModel:(YIem_One_TabBar_Home_Model *)model {
    
    _model = model;
    
    _titleLabel.text = [NSString stringWithFormat:@"职位：%@",model.jobtitle];
    _nameLabel.text = [NSString stringWithFormat:@"公司名称：%@", model.company];
    _cityLabel.text = [NSString stringWithFormat:@"城市：%@", model.formattedLocation];
    _timeLabel.text = [NSString stringWithFormat:@"发布时间：%@", model.formattedRelativeTime];
    //    _sourceLabel.text = [NSString stringWithFormat:@"%@", model.source];
    NSString *str = [NSString stringWithFormat:@"摘要：%@", model.snippet];
    /// 排除 <b> </b>
    _briefLabel.text = [[str stringByReplacingOccurrencesOfString:@"<b>" withString:@""] stringByReplacingOccurrencesOfString:@"</b>" withString:@""];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
