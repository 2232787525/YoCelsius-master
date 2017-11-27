//
//  SunsetView.h
//  YoCelsius
//
//  Created by XianMingYou on 15/2/21.
//
//  https://github.com/YouXianMing
//  http://www.cnblogs.com/YouXianMing/
//

#import <UIKit/UIKit.h>

@interface SunView : UIView

@property(nonatomic,assign)BOOL ifSunrise;
@property (nonatomic) CGRect upCenterRect;
@property (nonatomic) CGRect downCenterRect;

/**
 *  显示动画
 */
- (void)showWithDuration:(CGFloat)duration;

/**
 *  隐藏动画
 */
- (void)hideWithDuration:(CGFloat)duration;

/**
 *  创建出view(先初始化出view,然后再传图片)
 */
- (void)buildView;

@end
