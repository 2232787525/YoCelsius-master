//
//  WindSpeedView.m
//  YoCelsius
//
//  Created by XianMingYou on 15/2/19.
//
//  https://github.com/YouXianMing
//  http://www.cnblogs.com/YouXianMing/
//

#import "WindSpeedView.h"
#import "ThreeLineView.h"
#import "TitleMoveLabel.h"
#import "CGRectStoreValue.h"
#import "CountLabel.h"
@interface WindSpeedView (){
    float _windcountLab_X;//数字标签X
    float _windcountLab_Y;//数字标签Y
    
    float _line_H;       //支柱高
    float _gapFromCenter;//支柱距离圆点距离
}
@property (nonatomic, strong) ThreeLineView       *threeLineView;
@property (nonatomic, strong) UIView              *line;
@property (nonatomic, strong) UIView              *circleView;
@property (nonatomic, strong) TitleMoveLabel      *titleMoveLabel;
@property (nonatomic, strong) CountLabel          *windCountLabel;

@end

@implementation WindSpeedView


- (void)buildView {
    
    
    _windcountLab_X = F_I6(60);
    _windcountLab_Y = F_I6(133);
    _line_H = F_I6(60);
    _gapFromCenter = 3.f;
    
    // 创建出扇叶
    self.threeLineView = [[ThreeLineView alloc] initWithFrame:CGRectMake(F_I6(40), F_I6(50), F_I6(65), F_I6(65))];
    [self addSubview:self.threeLineView];
    
    // 头部位 标题
    self.titleMoveLabel = [TitleMoveLabel withText:@"Wind Speed"];
    [self addSubview:self.titleMoveLabel];
    
    // 创建出风速变化的标签
    self.windCountLabel = [[CountLabel alloc] init];
    [self addSubview:self.windCountLabel];
    
    // 创建出支柱
    self.line = [UIView new];
    [self addSubview:self.line];
    self.line.backgroundColor = [UIColor blackColor];
    
    // 创建出圆圈
    self.circleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 4)];
    self.circleView.center = self.threeLineView.center;
    self.circleView.layer.cornerRadius = self.circleView.height / 2.f;
    self.circleView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.circleView];
    
    //数字动态变化的设置
    [self countAnimation];
    
    [self startStatue];
}

//数字标签动画设置
-(void)countAnimation{
    WeakSelf
    self.windCountLabel.animationCount.animationBlock = ^(NSNumber *number) {
        
        UIFont *font1       = [UIFont fontWithName:LATO_REGULAR size:12.f];
        UIFont *font2       = [UIFont fontWithName:LATO_BOLD size:10.f];

        NSString *text = [NSString stringWithFormat:@"%.2f",[number floatValue]];
        
        weakSelf.windCountLabel.countLabel.attributedText = [weakSelf.windCountLabel accessStr:text  color:nil textFont:font1 unitStr:@" mps" unitFont:font2 unitColor:COLOR_CIRCLE_];
    };
}

- (void)show {
    
    CGFloat duration = 1.5;
    
    // 扇叶动画
    [self.threeLineView.layer removeAllAnimations];
    self.threeLineView.circleByOneSecond = self.circleByOneSecond; // 设置转速
    
    [GCDQueue executeInMainQueue:^{
        
        [self.threeLineView rotateImageViewWithCircleByOneSecond];
        
    } afterDelaySecs:0.01f];
    
    [self.threeLineView showWithDuration:duration animated:YES];
    
    // 标签数字动画
    self.windCountLabel.toValue = self.windSpeed;
    [self.windCountLabel showDuration:duration];
    
    // 标题
    [self.titleMoveLabel show];
    
    WeakSelf
    // 支柱动画 + 圆动画 + 文本动画 + 标签数字动画（位移）
    [UIView animateWithDuration:duration animations:^{
        [weakSelf showStatue];
    }];
}

- (void)hide {
    
    CGFloat duration = 0.75;
    // 扇叶动画
    [self.threeLineView hideWithDuration:duration animated:YES];
    // 标签数字动画
    [self.windCountLabel hideDuration:duration];
    // 标题
    [self.titleMoveLabel hide];
    
    WeakSelf
    // 支柱动画 + 圆动画 + 标签数字动画 （位移）
    [UIView animateWithDuration:duration animations:^{
        
        [weakSelf hideStatue];
        
    } completion:^(BOOL finished) {
        
        [weakSelf startStatue];
        
    }];
}

-(void)startStatue{
    self.line.centerX = self.threeLineView.centerX;
    self.line.y = self.threeLineView.centerY + _gapFromCenter + _line_H;
    self.line.height = 0;
    self.line.width = 2.f;
    self.line.alpha = 0;
    
    self.circleView.alpha = 0.f;

    self.windCountLabel.frame = CGRectMake(_windcountLab_X , _windcountLab_Y - 20 , F_I6(93), F_I6(15));
    self.windCountLabel.alpha = 0.f;
}

-(void)showStatue{
    self.line.y = self.threeLineView.centerY + _gapFromCenter ;
    self.line.height = _line_H;
    self.line.alpha = 1.f;
    
    self.circleView.alpha = 1.f;
    
    self.windCountLabel.x = _windcountLab_X;
    self.windCountLabel.y = _windcountLab_Y;
    self.windCountLabel.alpha = 1.f;
}

-(void)hideStatue{
    self.line.y = self.threeLineView.centerY + _gapFromCenter  ;
    self.line.height = 0;
    self.line.alpha = 0.f;
    
    self.circleView.alpha = 0.f;
    
    self.windCountLabel.y = _windcountLab_Y;
    self.windCountLabel.x = _windcountLab_X + 20;
    self.windCountLabel.alpha = 0.f;
}

@end
