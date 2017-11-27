//
//  HumidityView.m
//  YoCelsius
//
//  Created by XianMingYou on 15/2/18.
//
//  https://github.com/YouXianMing
//  http://www.cnblogs.com/YouXianMing/
//

#import "HumidityView.h"
#import "CircleView.h"
#import "RotatedAngleView.h"

#import "CountLabel.h"

#import "TitleMoveLabel.h"

@interface HumidityView ()

@property (nonatomic, strong) CircleView         *fullCircle;
@property (nonatomic, strong) CircleView         *showCircle;
@property (nonatomic, strong) RotatedAngleView   *rotateView;
@property (nonatomic, strong) CountLabel *countLabel;

@property (nonatomic, strong) TitleMoveLabel     *titleMoveLabel;

@end

@implementation HumidityView

- (void)buildView {
    
    //大的框架 圆的位置
    CGRect rotateRect = CGRectMake(30, 50, self.frame.size.width-60, self.frame.size.width-60);
    //圆的frame
    CGRect circleRect = CGRectMake(0, 0, rotateRect.size.width, rotateRect.size.width);
    
    // 移动的头部位
    self.titleMoveLabel = [TitleMoveLabel withText:@"Humidity"];
    [self addSubview:self.titleMoveLabel];
    
    // 完整的圆
    self.fullCircle           = [CircleView createDefaultViewWithFrame:circleRect];
    self.fullCircle.lineColor = COLOR_CIRCLE_;
    [self.fullCircle buildView];
    
    // 局部显示的圆
    self.showCircle = [CircleView createDefaultViewWithFrame:circleRect];
    self.showCircle.lineColor = [UIColor colorWithRed:0 green:191/255.0 blue:1 alpha:1];
    self.showCircle.lineWidth = 5.0;
    [self.showCircle buildView];
    
    // 旋转的圆
    self.rotateView = [[RotatedAngleView alloc] initWithFrame:rotateRect];
    [self.rotateView addSubview:self.fullCircle];
    [self.rotateView addSubview:self.showCircle];
    [self addSubview:self.rotateView];
    

    // 计数的数据
    self.countLabel = [[CountLabel alloc] initWithFrame:rotateRect];
    self.countLabel.backgroundColor = [UIColor clearColor];
    self.countLabel.x += 4;
    [self addSubview:self.countLabel];
    
    [self countAnimation];
}


-(void)countAnimation{
    WeakSelf
    self.countLabel.animationCount.animationBlock = ^(NSNumber *number) {
        
        UIFont *font1       = [UIFont fontWithName:LATO_LIGHT size:40.f];
        UIFont *font2       = [UIFont fontWithName:LATO_LIGHT size:19.f];
        NSString *str = [NSString stringWithFormat:@"%ld", (long)[number integerValue]];
        
        weakSelf.countLabel.countLabel.attributedText = [weakSelf.countLabel accessStr:str  color:nil textFont:font1 unitStr:@"%" unitFont:font2 unitColor:COLOR_CIRCLE_];
    };
}

- (void)show {
    
    CGFloat circleFullPercent = 7.0/9;

    if (self.percent > circleFullPercent) {
        circleFullPercent = self.percent;
    }
    CGFloat duration          = 1.5;
    
    // 进行参数复位
    [self.fullCircle strokeEnd:0 animated:NO duration:0];
    [self.showCircle strokeEnd:0 animated:NO duration:0];
    [self.fullCircle strokeStart:0 animated:NO duration:0];
    [self.showCircle strokeStart:0 animated:NO duration:0];
    [self.rotateView roateAngle:0];
    
    // 标题显示
    [self.titleMoveLabel show];
    
    // 设置动画
    [self.fullCircle strokeEnd:circleFullPercent animated:YES duration:duration];
    [self.showCircle strokeEnd: self.percent animated:YES duration:duration];
    [self.rotateView roateAngle: 20 duration:duration];
    self.countLabel.toValue = self.percent * 100;
    [self.countLabel showDuration:duration];
}

- (void)hide {
    
    CGFloat duration          = 0.75;
    CGFloat circleFullPercent = 0.75;
    
    // 标题隐藏
    [self.titleMoveLabel hide];
    
    [self.fullCircle strokeStart:circleFullPercent animated:YES duration:duration];
    [self.showCircle strokeStart:self.percent * circleFullPercent animated:YES duration:duration];
    [self.rotateView roateAngle:90.f duration:duration];
    [self.countLabel hideDuration:duration];
}

@end
