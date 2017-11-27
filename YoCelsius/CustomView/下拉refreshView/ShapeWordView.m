//TODO:字从左往右逐渐出现 从右往左逐渐消失的动画

//  ShapeWordView.m
//  PathWord
//
//  Created by XianMingYou on 15/3/6.
//
//  https://github.com/YouXianMing
//  http://www.cnblogs.com/YouXianMing/
//

#import "ShapeWordView.h"
#import <CoreText/CoreText.h>

@interface ShapeWordView ()

@property (nonatomic, strong) CAShapeLayer  *shapeLayer;

@end

@implementation ShapeWordView

- (void)buildView {
    
    // 过滤数据
    CGFloat   lineWidth   = (self.lineWidth <= 0 ? 0.5 : self.lineWidth);
    UIColor  *lineColor   = (self.lineColor == nil ? [UIColor blackColor] : self.lineColor);
    NSString *text        = self.text;
    if (!self.font) {
        self.font = [UIFont systemFontOfSize:18.f];
    }
    
    
    if (text == nil || text.length == 0) {
        
        return;
    }
    
    // 初始化layer
    self.shapeLayer             = [CAShapeLayer layer];
    self.shapeLayer.frame       = self.bounds;
    self.shapeLayer.lineWidth   = lineWidth;
    self.shapeLayer.fillColor   = [UIColor clearColor].CGColor;//填充色 如果字体较粗 clearColor效果就是空心字
    self.shapeLayer.strokeColor = self.lineColor.CGColor;
    
    self.shapeLayer.path = ([self transformToBezierPath:text]).CGPath;
    
    
    self.shapeLayer.bounds          = CGPathGetBoundingBox(self.shapeLayer.path);
    self.shapeLayer.geometryFlipped = YES;
    self.shapeLayer.strokeEnd       = 0.f;
    self.shapeLayer.fillRule        = kCAFillRuleEvenOdd;
    [self.layer addSublayer:self.shapeLayer];
}

- (UIBezierPath *)transformToBezierPath:(NSString *)string
{
    CGMutablePathRef paths = CGPathCreateMutable();
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string attributes:@{ NSFontAttributeName : self.font}];
    
    CTLineRef lineRef = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);
    CFArrayRef runArrRef = CTLineGetGlyphRuns(lineRef);
    
    int runIndex = 0;
    CTRunRef runb = (CTRunRef)CFArrayGetValueAtIndex(runArrRef, runIndex);
    CTFontRef runFontS = (CTFontRef)CFDictionaryGetValue(CTRunGetAttributes(runb), kCTFontAttributeName);

    for (int i = 0; i < CTRunGetGlyphCount(runb); i++) {
        CFRange range = CFRangeMake(i, 1);
        CGGlyph glyph = 0;
        CTRunGetGlyphs(runb, range, &glyph);
        CGPoint position = CGPointZero;
        CTRunGetPositions(runb, range, &position);

        position.y -= 1;
        position.x += 0;
        
        CGPathRef path = CTFontCreatePathForGlyph(runFontS, glyph, nil);
        
        CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
        CGPathAddPath(paths, &t, path);
        CGPathRelease(path);
    
    }
    CFRelease(runb);
    CFRelease(runFontS);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointZero];
    [bezierPath appendPath:[UIBezierPath bezierPathWithCGPath:paths]];
    
    CGPathRelease(paths);
    
    return bezierPath;
}

- (void)percent:(CGFloat)percent animated:(BOOL)animated {
    
    if (animated) {
        
        if (percent <= 0) {
            
            self.shapeLayer.strokeEnd = 0;
            self.shapeLayer.strokeEnd = 0;

            
        } else if (percent > 0 && percent <= 1) {
            
            self.shapeLayer.strokeEnd = percent;
            
        } else {
            
            self.shapeLayer.strokeEnd = 1.f;
        }
        
    } else {
        
        if (percent <= 0) {
            
            [CATransaction setDisableActions:YES];
            self.shapeLayer.strokeEnd = 0;
            [CATransaction setDisableActions:NO];
            
        } else if (percent > 0 && percent <= 1) {
            
            [CATransaction setDisableActions:YES];
            self.shapeLayer.strokeEnd = percent;
            [CATransaction setDisableActions:NO];
            
        } else {
            
            [CATransaction setDisableActions:YES];
            self.shapeLayer.strokeEnd = 1.f;
            [CATransaction setDisableActions:NO];
        }
    }
}

@end
