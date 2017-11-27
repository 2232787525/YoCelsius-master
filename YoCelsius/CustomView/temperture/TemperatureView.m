//
//  TemperatureView.m
//  YoCelsius
//
//  Created by XianMingYou on 15/2/22.
//
//  https://github.com/YouXianMing
//  http://www.cnblogs.com/YouXianMing/
//

#import "TemperatureView.h"
#import "CountLabel.h"
#import "TitleMoveLabel.h"
#import "CGRectStoreValue.h"
#import "UIView+GlowView.h" //闪的动画

@interface TemperatureView ()

@property (nonatomic, strong) CountLabel  *countLabel;
@property (nonatomic, strong) TitleMoveLabel         *titleMoveLabel;

@end

@implementation TemperatureView

- (void)buildView {
    
    // 尺寸
    CGRect rect = CGRectMake(0, 0, Width/2, Width/2);
    
    // 计数的数据
    self.countLabel= [[CountLabel alloc] initWithFrame:rect];
    [self addSubview:self.countLabel];
    
    // 标题
    self.titleMoveLabel = [TitleMoveLabel withText:@"Temperature"];
    [self addSubview:self.titleMoveLabel];
    
    [self countAnimation];
}

-(void)countAnimation{
    WeakSelf
    self.countLabel.animationCount.animationBlock = ^(NSNumber *number) {
        
        NSString *str = [NSString stringWithFormat:@"%ld", (long)[number integerValue]];
        UIColor *greenColor = [UIColor colorWithRed:0 green:128/255.0 blue:128/255.0 alpha:1];

        weakSelf.countLabel.countLabel.attributedText = [weakSelf.countLabel accessStr:str  color:greenColor textFont:nil unitStr:@"°" unitFont:nil unitColor:nil];
        
        if ([number intValue] == weakSelf.temperature) {
            //设置闪的参数
            weakSelf.countLabel.countLabel.alpha         = 3.f;
            [weakSelf.countLabel.countLabel createGlowLayerWithColor:greenColor glowRadius:2.f];
            //开始闪的动画
            [weakSelf.countLabel.countLabel startGlow];
        }
    };
}

- (void)show {
    CGFloat duration = 1.75f;
    self.countLabel.toValue = self.temperature;
    [self.countLabel showDuration:duration];
    [self.titleMoveLabel show];
}

- (void)hide {
    CGFloat duration = 0.75f;
    [self.countLabel hideDuration:duration];
    [self.titleMoveLabel hide];
}

@end
