//
//  SunsetView.m
//  YoCelsius
//
//  Created by XianMingYou on 15/2/21.
//
//  https://github.com/YouXianMing
//  http://www.cnblogs.com/YouXianMing/
//

#import "SunView.h"

@interface SunView ()

@property (nonatomic, strong) UIView                *upView;
@property (nonatomic, strong) UIView                *downView;
@property (nonatomic, strong) UIImageView           *sunImageView;
@property (nonatomic, strong) UIImageView           *moonImageView;
@property (nonatomic, strong) UIView                *lineView;

@end

@implementation SunView
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width  = self.width;
        CGFloat height = self.height / 2.f;
        
        self.upCenterRect   = CGRectMake(0, 0, width, height);
        self.downCenterRect = CGRectMake(0, height, width, height);
    }
    return self;
}

- (void)buildView {
    
    self.upView                     = [[UIView alloc] initWithFrame:self.upCenterRect];
    self.upView.clipsToBounds = YES;
    [self addSubview:self.upView];
    
    self.downView                     = [[UIView alloc] initWithFrame:self.downCenterRect];
    self.downView.clipsToBounds = YES;
    [self addSubview:self.downView];
    
    // 创建出太阳的view并存储一些相关参数
    self.sunImageView           = [[UIImageView alloc] initWithFrame:self.upView.frame];
    self.sunImageView.image     = [UIImage imageNamed:@"sun"];
    [self.upView addSubview:self.sunImageView];
    self.sunImageView.alpha     = 0.f;
    
    self.sunImageView.y         += self.sunImageView.height;
    self.sunImageView.y         += 10.f;
    
    // 创建出月亮的view并存储一些相关参数
    self.moonImageView           = [[UIImageView alloc] initWithFrame:self.upView.bounds];
    self.moonImageView.image     = [UIImage imageNamed:@"moon"];
    self.moonImageView.y        -= self.moonImageView.height;
    [self.downView addSubview:self.moonImageView];
   
    self.moonImageView.y        += self.moonImageView.height;
    self.moonImageView.y        += 10.f;
    self.moonImageView.alpha = 0.f;
    
    // 中间的线条
    self.lineView                 = [[UIView alloc] initWithFrame:CGRectMake(0, self.height / 2.f, self.width, 1)];
    self.lineView.backgroundColor = COLOR_CIRCLE_;
    [self addSubview:self.lineView];
    self.lineView.alpha = 0.f;
}

/**
 *  显示动画
 */
- (void)showWithDuration:(CGFloat)duration {
    WeakSelf
    [UIView animateWithDuration:duration animations:^{
        [weakSelf showStatue];
    }];
}

/**
 *  隐藏动画
 */
- (void)hideWithDuration:(CGFloat)duration {
    [UIView animateWithDuration:duration animations:^{
        [self hideStatue];
    } completion:^(BOOL finished) {
        [self startStatue];
    }];
}

-(void)startStatue{
    if (self.ifSunrise) {//两张图都在下方
        self.sunImageView.y = self.upView.height;
        self.moonImageView.y = 0;
        self.upView.clipsToBounds = YES;
    }else{              //两张图都在上方
        self.sunImageView.y = 0;
        self.moonImageView.y = -self.upView.height;
        self.downView.clipsToBounds = YES;
    }
}

-(void)showStatue{
    if (self.ifSunrise) {//两张图都在上方
        self.sunImageView.y = 0;
        self.moonImageView.y = -self.upView.height;
    }else{              //两张图都在下方
        self.sunImageView.y = self.upView.height;
        self.moonImageView.y = 0;
    }
    self.sunImageView.alpha = 1.f;
    self.moonImageView.alpha = 1.f;
    self.lineView.alpha = 1.f;
}

-(void)hideStatue{
    if (self.ifSunrise) {//太阳往上
        self.sunImageView.y = -self.upView.height/2;
        self.upView.clipsToBounds = NO;
    }else{              //月亮往下
        self.moonImageView.y = self.downView.height/2;
        self.downView.clipsToBounds = NO;
    }
    self.sunImageView.alpha = 0.f;
    self.moonImageView.alpha          = 0.f;
    self.lineView.alpha = 0.f;
}
@end
