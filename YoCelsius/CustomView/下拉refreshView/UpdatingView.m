//
//  UpdatingView.m
//  YoCelsius
//
//  Created by XianMingYou on 15/2/28.
//
//  https://github.com/YouXianMing
//  http://www.cnblogs.com/YouXianMing/
//

#import "UpdatingView.h"

#define UPDATING_HEIGHY  20.f

@interface UpdatingView ()
@property (nonatomic, strong) UILabel   *label;// 标题
@property (nonatomic, strong) UILabel   *failedLabel;// 失败
@property (nonatomic, strong) SnowView  *snow;// 下雪
@property (nonatomic, strong) UIColor   *showColor;
@end

@implementation UpdatingView

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)showColor {
    
    self = [super initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    if (self) {
        if (!showColor) {
            self.showColor = [UIColor colorWithRed:0 green:191/255.0 blue:255/255.0 alpha:0.9];//蓝
        }else{
            self.showColor = showColor;
        }
        [self initLabel];
        [self initSnow];
        
        // 关闭用户交互
        self.userInteractionEnabled = NO;
    }
    
    return self;
}

- (void)initLabel {
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, Width / 2.f, Width, UPDATING_HEIGHY)];
    [self addSubview:self.label];
    self.label.textColor        = self.showColor;

    self.label.textAlignment    = NSTextAlignmentCenter;
    self.label.font             = [UIFont fontWithName:LATO_LIGHT size:18.f];
    self.label.text             = @"Updating . . .";
    self.label.GCDTimerInterval = @(0.8f);
    self.label.glowDuration     = @(0.7f);
    self.label.glowLayerOpacity = @(0.7f);
    [self.label createGlowLayerWithColor:[UIColor whiteColor]
                              glowRadius:2.f];
    [self.label startGlow];
    
    
    self.label.alpha               = 0.f;
    
    self.failedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, Width / 2.f, Width, UPDATING_HEIGHY)];
    [self addSubview:self.failedLabel];
    self.failedLabel.textColor        = [UIColor whiteColor];
    self.failedLabel.textAlignment    = NSTextAlignmentCenter;
    self.failedLabel.font             = [UIFont fontWithName:LATO_LIGHT size:24.f];
    self.failedLabel.text             = @"Failed";
    self.failedLabel.GCDTimerInterval = @(0.8f);
    self.failedLabel.glowDuration     = @(0.7f);
    self.failedLabel.glowLayerOpacity = @(1.f);
    [self.failedLabel createGlowLayerWithColor:[UIColor redColor]
                              glowRadius:2.f];
    [self.failedLabel startGlow];
    
    self.failedLabel.alpha               = 0.f;
}

- (void)initSnow {
    float W = Width-250;
    self.snow = [[SnowView alloc] initWithFrame:CGRectMake(0, 0, W, W)];
    //在图片形状内发射粒子
    self.snow.layer.mask = [CALayer createMaskLayerWithSize:CGSizeMake(W, W)
                                               maskPNGImage:[UIImage imageNamed:@"alpha"]];
    self.snow.snowColor  = self.showColor;
    [self addSubview:self.snow];
    self.snow.snowImage  = [UIImage imageNamed:@"snow"];
//    self.snow.snowImage  = [UIImage imageNamed:@"love"];

    self.snow.birthRate  = 30.f;   //每秒产生粒子数
    self.snow.gravity    = 7.f;    //重力
    [self.snow showSnow];
    self.snow.alpha      = 0.f;
    
    self.snow.center = self.center;
    self.label.y = (self.frame.size.height- W)/2 + W + 20;
    self.failedLabel.top = self.label.top;
}

- (void)show {
    
    [UIView animateWithDuration:1.f animations:^{
        self.snow.alpha      = 1.f;
        //1.4倍比例缩放
        self.snow.transform= CGAffineTransformMakeScale(1.4, 1.4);
        self.label.alpha     = 1.f;
    } completion:^(BOOL finished) {
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.75f animations:^{
        self.snow.alpha     = 0.f;
        
        //消失时 缩小回1倍大小
        //self.snow.transform = CGAffineTransformIdentity;
        self.snow.transform    = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
        self.label.alpha    = 0.f;
        self.failedLabel.alpha = 0.f;
        
    } completion:^(BOOL finished) {
    }];
}

- (void)insertIntoView:(UIView *)view {
}

- (void)showFailed {
    
    [UIView animateWithDuration:1.5f animations:^{
        // 隐藏label标签
        self.label.alpha = 0.f;
    } completion:^(BOOL finished) {

        [UIView animateWithDuration:1.f animations:^{
            // 显示failed标签
            self.failedLabel.alpha = 1.f;
        } completion:^(BOOL finished) {
        }];
    }];
}

//-(void)setShowColor:(UIColor *)showColor{
//    _showColor = showColor;
//    self.snow.snowColor  = showColor;
//    self.label.textColor = showColor;
//}

@end
