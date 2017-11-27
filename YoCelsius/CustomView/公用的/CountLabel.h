//TODO:数字变化的动画lable显示
//  TemperatureCountLabel.h
//  YoCelsius
//
//  Created by XianMingYou on 15/2/22.
//
//  https://github.com/YouXianMing
//  http://www.cnblogs.com/YouXianMing/
//

#import <UIKit/UIKit.h>
#import "NumberCount.h"
@interface CountLabel : UIView

/**
 *  起始值
 */
@property (nonatomic) CGFloat fromValue;

/**
 *  结束值
 */
@property (nonatomic) CGFloat toValue;

/**
 *  动画引擎
 */
@property (nonatomic, strong) NumberCount  *animationCount;

/**
 *  显示用的label
 */
@property (nonatomic, strong) UILabel         *countLabel;

/**
 *  显示动画
 *
 *  @param duration 动画时间
 */
- (void)showDuration:(CGFloat)duration;

/**
 *  隐藏动画
 *
 *  @param duration 隐藏时间
 */
- (void)hideDuration:(CGFloat)duration;

// 处理富文本
- (NSAttributedString *)accessStr:(NSString *)text color:(UIColor *)textColor textFont:(UIFont *)textFont unitStr:(NSString *)unit unitFont:(UIFont *)unitFont unitColor:(UIColor *)unitColor;

@end
