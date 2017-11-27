//
//  SunInfoView.m
//  YoCelsius
//
//  Created by XianMingYou on 15/2/21.
//
//  https://github.com/YouXianMing
//  http://www.cnblogs.com/YouXianMing/
//

#import "SunInfoView.h"
#import "SunView.h"
#import "TitleMoveLabel.h"
#import "CGRectStoreValue.h"

@interface SunInfoView (){
    float _sun_W;
    float _sunoffset_Y;
}

@property (nonatomic, strong) TitleMoveLabel    *movetitleLabel;
@property (nonatomic, strong) SunView        *sunriseView;
@property (nonatomic, strong) UILabel           *sunriseTimeLabel;
@property (nonatomic, strong) SunView        *sunsetView;
@property (nonatomic, strong) UILabel           *sunsetTimeLabel;

@end

@implementation SunInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.sunsireValue = [SunriseAndSunset new];
        self.sunsetValue = [SunriseAndSunset new];
    }
    return self;
}

/**
 *  创建出view
 */
- (void)buildView {
    _sun_W = F_I6(50);
    float sunoffset_X = F_I6(50);
    _sunoffset_Y = F_I6(60);

    self.movetitleLabel = [TitleMoveLabel withText:@"Sunrise/Sunset"];
    [self.movetitleLabel buildView];
    [self addSubview:self.movetitleLabel];
    
    // 日出的view
    self.sunriseView = [[SunView alloc] initWithFrame:CGRectMake(sunoffset_X, _sunoffset_Y , _sun_W , _sun_W * 2)];
    self.sunriseView.ifSunrise = YES;
    [self.sunriseView buildView];
    [self addSubview:self.sunriseView];
    // 日出时间标签
    self.sunriseTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _sun_W, _sun_W, _sun_W/2)];
    self.sunriseTimeLabel.alpha         = 0.f;
    self.sunriseTimeLabel.textAlignment = NSTextAlignmentCenter;
    self.sunriseTimeLabel.font          = [UIFont fontWithName:LATO_BOLD size:LATO_10];
    self.sunriseTimeLabel.textColor = [UIColor blackColor];
    [self.sunriseView addSubview:self.sunriseTimeLabel];
    
    // 日落的view
    self.sunsetView = [[SunView alloc] initWithFrame:CGRectMake(sunoffset_X + _sun_W + 10, _sunoffset_Y + 5 , _sun_W, _sun_W * 2)];
    self.sunsetView.ifSunrise = NO;
    [self.sunsetView buildView];
    [self addSubview:self.sunsetView];
    // 日落时间标签
    self.sunsetTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _sun_W/2, _sun_W, _sun_W/2)];
    self.sunsetTimeLabel.textAlignment = NSTextAlignmentCenter;
    self.sunsetTimeLabel.alpha         = 0.f;
    self.sunsetTimeLabel.font          = [UIFont fontWithName:LATO_BOLD size:LATO_10];
    self.sunsetTimeLabel.textColor = [UIColor blackColor];
    [self.sunsetView addSubview:self.sunsetTimeLabel];
    
    [self startStatue];
}

/**
 *  显示
 */
- (void)show {
    
    [self.movetitleLabel show];
    
    // 动画持续时间
    CGFloat duration = 1.75f;
    // 日出动画
    [self.sunriseView showWithDuration:1.5];
    // 日落动画
    [self.sunsetView showWithDuration:1.5];
    WeakSelf
    [UIView animateWithDuration:duration animations:^{
        [weakSelf showStatue];
    }];
}

/**
 *  隐藏
 */
- (void)hide {
    
    [self.movetitleLabel hide];
    
    CGFloat duration = 0.75f;
    // 日出动画隐藏
    [self.sunriseView hideWithDuration:duration];
    // 日落动画隐藏
    [self.sunsetView hideWithDuration:duration];
    
    WeakSelf
    [UIView animateWithDuration:duration animations:^{
        
        [weakSelf hideStatue];
        
    } completion:^(BOOL finished) {
        [weakSelf startStatue];
    }];
}

-(void)startStatue{
    self.sunriseView.y = _sunoffset_Y + 10;
    self.sunriseView.y = _sunoffset_Y - 5 ;
}

-(void)showStatue{
    self.sunriseView.y = _sunoffset_Y ;
    self.sunsetView.y = _sunoffset_Y + 5 ;
    
    self.sunriseTimeLabel.text  = self.sunsireValue.timeString;
    self.sunriseTimeLabel.alpha = 1.f;
    
    self.sunsetTimeLabel.text   = self.sunsetValue.timeString;
    self.sunsetTimeLabel.alpha  = 1.f;
}

-(void)hideStatue{
    self.sunriseView.y = _sunoffset_Y - 10;
    self.sunsetView.y = _sunoffset_Y + 15 ;
    
    self.sunriseTimeLabel.alpha = 0.f;
    self.sunsetTimeLabel.alpha  = 0.f;
}

@end
