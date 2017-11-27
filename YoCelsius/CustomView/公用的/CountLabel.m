//TODO:数字变化的动画lable显示
//  TemperatureCountLabel.m
//  YoCelsius
//
//  Created by XianMingYou on 15/2/22.
//
//  https://github.com/YouXianMing
//  http://www.cnblogs.com/YouXianMing/
//

#import "CountLabel.h"
#import "NSString+RichText.h"

@interface CountLabel ()<NumberCountDelegate>

@end

@implementation CountLabel

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.animationCount= [NumberCount new];
    }
    return self;
}

- (void)showDuration:(CGFloat)duration {
    
    self.countLabel               = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.countLabel];
    self.countLabel.alpha         = 0;
    self.countLabel.adjustsFontSizeToFitWidth = YES;
    self.countLabel.numberOfLines = 0;
    
    self.animationCount.fromValue = self.fromValue;
    self.animationCount.toValue   = self.toValue;
    self.animationCount.duration  = duration;
    [self.animationCount startAnimation];
    
    [UIView animateWithDuration:duration animations:^{
        self.countLabel.alpha     = 1.f;
    }];
}

- (void)hideDuration:(CGFloat)duration {
    [UIView animateWithDuration:duration animations:^{
        self.countLabel.alpha=0;
    } completion:^(BOOL finished) {
        [self.countLabel removeFromSuperview];
    }];
}

// 处理富文本
- (NSAttributedString *)accessStr:(NSString *)text color:(UIColor *)textColor textFont:(UIFont *)textFont unitStr:(NSString *)unit unitFont:(UIFont *)unitFont unitColor:(UIColor *)unitColor{
    
    NSString *totalStr = [NSString stringWithFormat:@"%@%@", text, unit];
    
    if (!textColor) {
        textColor = [UIColor blackColor];
    }
    if (!unitColor) {
        unitColor = textColor;
    }
    if (!textFont) {
        textFont = [UIFont fontWithName:LATO_THIN size:75.0*Width/320];
    }
    if (!unitFont) {
        unitFont = textFont;
    }
    
    NSRange totalRange   = [totalStr range];              // 全局的区域
    NSRange countRange   = [text rangeFrom:totalStr]; // %的区域
    NSRange duRange      = [unit    rangeFrom:totalStr]; // °
    
    return [totalStr createAttributedStringAndConfig:
            @[
              // 数字设置
              [ConfigAttributedString font:textFont
                                     range:countRange],
              // °数
              [ConfigAttributedString font:unitFont
                                     range:duRange],
              // 颜色
              [ConfigAttributedString foregroundColor:textColor
                                                range:totalRange],
              
              [ConfigAttributedString foregroundColor:unitColor
                                                range:duRange],
              ]];
}


@end
