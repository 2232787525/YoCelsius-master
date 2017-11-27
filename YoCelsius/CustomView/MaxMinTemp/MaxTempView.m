//
//  MaxTempView.m
//  YoCelsius
//
//  Created by XianMingYou on 15/2/20.
//
//  https://github.com/YouXianMing
//  http://www.cnblogs.com/YouXianMing/
//

#import "MaxTempView.h"
#import "GridView.h"
#import "CountLabel.h"
#import "TitleMoveLabel.h"
#import "CGRectStoreValue.h"

@interface MaxTempView ()

@property (nonatomic, strong) GridView  *gridView;

@property (nonatomic, strong) UIView            *centerLineView;

@property (nonatomic, strong) UIView            *minTempView;

@property (nonatomic, strong) UIView            *maxTempView;

@property (nonatomic, strong) UIView            *maxCountView;

@property (nonatomic, strong) UIView            *minCountView;

@property (nonatomic, strong) CountLabel        *maxTempCountLabel;
@property (nonatomic, strong) CountLabel        *minTempCountLabel;

@property (nonatomic, strong) TitleMoveLabel    *titleMoveLabel;

@property (nonatomic, assign)CGFloat gridOffsetX;
@property (nonatomic, assign)CGFloat gridOffsetY;


@end

@implementation MaxTempView

- (void)buildView {
    
    self.gridOffsetX = 30;
    self.gridOffsetY = 45*Width/320;
    
    // 创建出格子view
    self.gridView       = [[GridView alloc] initWithFrame:CGRectZero];
    self.gridView.alpha = 0.f;
    self.gridView.origin     = CGPointMake(self.gridOffsetX, self.gridOffsetY);
    self.gridView.gridLength = 23*Width/320;
    [self.gridView buildView];
    [self addSubview:self.gridView];
    
    // 中间的横条view
    self.centerLineView = [[UIView alloc] initWithFrame:CGRectMake(self.gridOffsetX, _gridView.gridLength * 2 + self.gridOffsetY, _gridView.gridLength * 5, 1.f)];
    self.centerLineView.backgroundColor = [UIColor blackColor];
    
    // 最小温度
    self.minTempView = [[UIView alloc] init];
    self.minTempView.width = _gridView.gridLength;
    self.minTempView.backgroundColor = [UIColor blackColor];
    self.minTempView.alpha = 0.f;
    [self addSubview:self.minTempView];
    
    // 最低温度显示
    self.minCountView = [[UIView alloc] init];
    [self addSubview:self.minCountView];
    self.minCountView.alpha = 0.f;
    self.minCountView.bounds = CGRectMake(0, 0, _gridView.gridLength, _gridView.gridLength/2);

    // 最大温度
    self.maxTempView = [[UIView alloc] init];
    self.maxTempView.width = _gridView.gridLength;
    self.maxTempView.backgroundColor = [UIColor blackColor];
    self.maxTempView.alpha = 0.f;
    
    // 最大温度显示
    self.maxCountView = [[UIView alloc] init];
    [self addSubview:self.minCountView];
    [self addSubview:self.maxCountView];
    self.maxCountView.alpha = 0.f;
    self.maxCountView.bounds = CGRectMake(0, 0, _gridView.gridLength, _gridView.gridLength/2);
    
    // 最大温度动态显示
    self.maxTempCountLabel = [[CountLabel alloc] initWithFrame:CGRectMake(0, 0, _gridView.gridLength, _gridView.gridLength)];
    [self.maxCountView addSubview:self.maxTempCountLabel];

    // 最小温度动态显示
    self.minTempCountLabel = [[CountLabel alloc] initWithFrame:CGRectMake(0, 0, _gridView.gridLength, _gridView.gridLength)];
    [self.minCountView addSubview:self.minTempCountLabel];
    
    [self addSubview:self.maxTempView];
    [self addSubview:self.centerLineView];
    
    self.titleMoveLabel = [TitleMoveLabel withText:@"Min/Max Temp"];
    [self.titleMoveLabel buildView];
    [self addSubview:self.titleMoveLabel];
    
    [self startStatue];
    [self countAnimation];
}

//数字标签动画设置
-(void)countAnimation{
    WeakSelf
    self.maxTempCountLabel.animationCount.animationBlock = ^(NSNumber *number) {
        
        UIFont *font1       = [UIFont fontWithName:LATO_BOLD size:8.f];
        UIFont *font2       = [UIFont fontWithName:LATO_REGULAR size:12.f];
        NSString *unitStr = [NSString stringWithFormat:@"%ld°",[number integerValue]];
        
        weakSelf.maxTempCountLabel.countLabel.attributedText = [weakSelf.maxTempCountLabel accessStr:@"Max "  color:nil textFont:font1 unitStr:unitStr unitFont:font2 unitColor:nil];
        weakSelf.maxTempCountLabel.countLabel.numberOfLines = 1;
        [weakSelf.maxTempCountLabel.countLabel sizeToFit];
    };
    
    self.minTempCountLabel.animationCount.animationBlock = ^(NSNumber *number) {
        
        UIFont *font1       = [UIFont fontWithName:LATO_BOLD size:8.f];
        UIFont *font2       = [UIFont fontWithName:LATO_REGULAR size:12.f];
        NSString *unitStr = [NSString stringWithFormat:@"%ld°",[number integerValue]];
        
        weakSelf.minTempCountLabel.countLabel.attributedText = [weakSelf.minTempCountLabel accessStr:@"Min "  color:nil textFont:font1 unitStr:unitStr unitFont:font2 unitColor:nil];
        weakSelf.minTempCountLabel.countLabel.numberOfLines = 1;
        [weakSelf.minTempCountLabel.countLabel sizeToFit];
    };
}

- (void)show {
    CGFloat duration = 1.75;
    // 标题显示
    [self.titleMoveLabel show];
    
    // 格子动画效果
    [self.gridView showWithDuration:1.5f];
    
    self.maxTempCountLabel.toValue = self.maxTemp;
    [self.maxTempCountLabel showDuration:duration];
    
    self.minTempCountLabel.toValue = self.minTemp;
    [self.minTempCountLabel showDuration:duration];
    
    WeakSelf
    // 中间线条动画效果
    [UIView animateWithDuration:0.75 delay:0.35 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        
        [weakSelf showStatue];
        
    } completion:^(BOOL finished) {
    }];
}

- (void)hide {
    // 标题隐藏
    [self.titleMoveLabel hide];
    
    CGFloat duration = 0.75f;
    // 格子动画效果
    [self.gridView hideWithDuration:duration];
    [self.maxTempCountLabel hideDuration:duration];
    [self.minTempCountLabel hideDuration:duration];

    WeakSelf
    [UIView animateWithDuration:duration animations:^{
        [weakSelf hideStatue];
    } completion:^(BOOL finished) {
        [self startStatue];
    }];
}

-(void)startStatue{
    self.centerLineView.width = 0.f;
    self.centerLineView.x = _gridView.gridLength * 5;
    self.centerLineView.alpha = 0.f;
    
    self.minCountView.x = _gridView.gridLength + self.gridOffsetX;
    self.minCountView.y = _gridView.gridLength * 2 + self.gridOffsetY;
    self.minCountView.alpha = 0;

    self.maxCountView.x = _gridView.gridLength *3 + self.gridOffsetX;
    self.maxCountView.y = _gridView.gridLength * 2 + self.gridOffsetY;
    self.maxCountView.alpha = 0;
    
    self.maxTempView.x = _gridView.gridLength *3 + self.gridOffsetX;
    self.maxTempView.height = 0;

    self.minTempView.x = _gridView.gridLength + self.gridOffsetX;
    self.minTempView.height = 0;
}

-(void)showStatue{
    self.centerLineView.width = _gridView.gridLength * 5;
    self.centerLineView.x = 30;
    self.centerLineView.alpha = 1.f;
    
    self.maxCountView.alpha = 1.f;
    self.minCountView.alpha = 1.f;

    self.minTempView.y -= self.minTemp;
    self.minTempView.height = self.minTemp;
    self.minTempView.alpha  = 1.f;
    
    self.maxTempView.y -= self.maxTemp;
    self.maxTempView.height = self.maxTemp;
    self.maxTempView.alpha  = 1.f;
    
    if (self.maxTemp>=0) {
        self.maxCountView.y =  self.maxCountView.y - _gridView.gridLength/2;
    }
    if (self.minTemp>=0) {
        self.minCountView.y =  self.minCountView.y - _gridView.gridLength/2;
    }
    self.maxCountView.y -= self.maxTemp;
    self.minCountView.y -= self.minTemp;
}

-(void)hideStatue{
    //复位
    self.centerLineView.width = 0.f;
    self.centerLineView.x = _gridView.gridLength * 5;
    self.centerLineView.alpha = 0.f;
    
    //温度横条
    self.maxTempView.y  = _gridView.gridLength * 2 + self.gridOffsetY;
    self.maxTempView.height  = 0;
    self.maxTempView.alpha = 0.f;

    self.minTempView.y  = _gridView.gridLength * 2 + self.gridOffsetY;
    self.minTempView.height  = 0;
    self.minTempView.alpha = 0.f;
    
    //温度文字
    self.maxCountView.x  += 10;
    self.minCountView.x  += 10;
    self.maxCountView.alpha   = 0.f;
    self.minCountView.alpha   = 0.f;
}

@end
