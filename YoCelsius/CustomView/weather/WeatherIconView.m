//
//  WeatherIconView.m
//  YoCelsius
//
//  Created by XianMingYou on 15/2/24.
//
//  https://github.com/YouXianMing
//  http://www.cnblogs.com/YouXianMing/
//

#import "WeatherIconView.h"
#import "TitleMoveLabel.h"
#import "UIView+GlowView.h" //闪的动画
#import "WeatherNumberMeaningTransform.h" //天气code转天气字体对应的字母
//#import "CGRectStoreValue.h"

@interface WeatherIconViewStoreValue : NSObject

@property (nonatomic) CGRect startRect;
@property (nonatomic) CGRect midRect;
@property (nonatomic) CGRect endRect;

@end

@implementation WeatherIconViewStoreValue

@end

@interface WeatherIconView ()

@property (nonatomic, strong) TitleMoveLabel     *titleMoveLabel;
@property (nonatomic, strong) UILabel            *glowLabel;

@end

@implementation WeatherIconView

/**
 *  创建出view
 */
- (void)buildView {
    
    self.titleMoveLabel = [TitleMoveLabel withText:@"Weather"];
    [self addSubview:self.titleMoveLabel];
    
    self.glowLabel               = [[UILabel alloc] init];
    self.glowLabel.textAlignment = NSTextAlignmentCenter;
    self.glowLabel.textColor     = [UIColor colorWithRed:244/255.0 green:164/255.0 blue:96/255.0 alpha:1];

}

/**
 *  显示
 */
- (void)show {
    
    [self.titleMoveLabel show];
    
    self.glowLabel.frame= CGRectMake(0, 20, self.frame.size.width, self.frame.size.height-20);
    [self addSubview:self.glowLabel];
    //天气字体
    self.glowLabel.font      = [UIFont fontWithName:WEATHER_TIME size: 80*Width/320.0];

    self.GCDTimerInterval        = @(1.75);
    self.glowLayerOpacity        = @(1.5);
    self.glowDuration            = @(1.f);

    //天气code转天气字体对应的字母
    self.glowLabel.text          = [WeatherNumberMeaningTransform fontTextWeatherNumber:self.weatherNumber];
    //WeatherNumberMeaningTransform iconColor: 不同天气返回不同的color
    
    //设置闪的参数
    self.glowLabel.alpha         = 1.f;
    [self.glowLabel createGlowLayerWithColor:[WeatherNumberMeaningTransform iconColor:self.weatherNumber] glowRadius:2.f];
    
    
    //开始闪的动画
    [self.glowLabel startGlow];
    self.glowLabel.alpha         = 0.f;

    [UIView animateWithDuration:1.75 animations:^{

        self.glowLabel.alpha = 1.f;
    }];
}

/**
 *  隐藏
 */
- (void)hide {
    
    [self.titleMoveLabel hide];
    
    [UIView animateWithDuration:0.75 animations:^{
        
        self.glowLabel.alpha = 0.f;
        
    } completion:^(BOOL finished) {
        
        [self.glowLabel removeFromSuperview];
    }];
}

@end
