//
//  PaintView.m
//  Quartz2D
//
//  Created by 李保磊 on 16/5/9.
//  Copyright (c) 2016年 李保磊. All rights reserved.
//

#import "PaintView.h"

@interface PaintView ()

@property (nonatomic,strong) NSMutableArray *points;
@property (nonatomic,strong) NSMutableArray *lines;

@end

@implementation PaintView

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(30, 50, 80, 50)];
        back.backgroundColor = [UIColor cyanColor];
        [back setTitle:@"后 退" forState:UIControlStateNormal];
        [back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:back];
        
        
        UIButton *cut = [[UIButton alloc] initWithFrame:CGRectMake(140, 50, 80, 50)];
        cut.backgroundColor = [UIColor cyanColor];
        [cut setTitle:@"截 图" forState:UIControlStateNormal];
        [cut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cut addTarget:self action:@selector(cut:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cut];
        
        UIButton *clear = [[UIButton alloc] initWithFrame:CGRectMake(250, 50, 80, 50)];
        clear.backgroundColor = [UIColor cyanColor];
        [clear setTitle:@"清 空" forState:UIControlStateNormal];
        [clear setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [clear addTarget:self action:@selector(clearEvent) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:clear];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetLineWidth(ctx, 5);
    if (self.lines.count > 0) {
        for (int j = 0; j < self.lines.count; j++) {
            NSArray *points = self.lines[j];
            if (points.count > 0) {
                CGPoint start = [[points firstObject] CGPointValue];
                CGContextMoveToPoint(ctx, start.x, start.y);
                for (int i = 1; i < points.count; i++) {
                    CGPoint next = [points[i] CGPointValue];
                    CGContextAddLineToPoint(ctx, next.x, next.y);
                }
                CGContextStrokePath(ctx);
            }
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    _points = [NSMutableArray array];
    [self.lines addObject:self.points];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    // 拿到touches里面的touch
    UITouch *touch = [touches anyObject];
    // 将touch转换成CGPoint
    CGPoint point = [touch locationInView:self];
    [self.points addObject:[NSValue valueWithCGPoint:point]];
    [self setNeedsDisplay];
}

- (void)back:(UIButton *)button{
    if (self.lines > 0) {
        [self.lines removeLastObject];
        [self setNeedsDisplay];
    }
}
/**
 *  截图
 */
- (void)cut:(UIButton *)button{
    // 创建图片上下文
    UIGraphicsBeginImageContext(self.bounds.size);
    // 将我们的涂层渲染到上下文中
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    // 从上下文中拿到图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭图片的上下文
    UIGraphicsEndImageContext();
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Prompt" message:@"Save image to your photos Album?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"No,thanks" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 存储
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }];
    
    [alertController addAction:cancel];
    [alertController addAction:sure];
    [self.controller presentViewController:alertController animated:NO completion:nil];
    
    
}

- (void)clearEvent{
    
    [self.points removeAllObjects];
    
    [self.lines removeAllObjects];
    
    [self setNeedsDisplay];
}

/**
 *  存放多条线的数组
 */
-(NSMutableArray *)lines{
    if (_lines == nil) {
        _lines = [NSMutableArray array];
    }
    return _lines;
}

@end
