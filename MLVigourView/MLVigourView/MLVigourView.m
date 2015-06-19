//
//  MLVigourView.m
//  MLVigourView
//
//  Created by 马龙 on 15/6/19.
//  Copyright (c) 2015年 xiaojukeji. All rights reserved.
//



#import "MLVigourView.h"
#import "MLCommonFunctions.h"

#define kDefaultBubbleColor [UIColor colorWithRed:0 green:0.722 blue:1 alpha:1]

static const CGFloat kDefaultRadius = 30.0;
static const CGFloat kDefaultViscosity = 20.0;

@interface MLVigourView ()

/**
 *  气泡上显示数字的label
 */
@property (nonatomic,strong)UILabel * bubbleLabel;


/**
 *  拖动时的前方视图，即被拖动的视图
 */
@property (nonatomic,strong)UIView * frontView;

/**
 *  拖动时的后视图，即被拖动的视图
 */
@property (nonatomic,strong)UIView * backView;


@end

@implementation MLVigourView
{
    CGPoint initialPoint;
    
    CGFloat r1; // backView
    CGFloat r2; // frontView
    CGFloat x1;
    CGFloat y1;
    CGFloat x2;
    CGFloat y2;
    CGFloat centerDistance;
    CGFloat cosDigree;
    CGFloat sinDigree;
    
    CGPoint pointA; //A
    CGPoint pointB; //B
    CGPoint pointD; //D
    CGPoint pointC; //C
    CGPoint pointO; //O
    CGPoint pointP; //P
    
    CGRect oldBackViewFrame;
    CGPoint oldBackViewCenter;
    
    CAShapeLayer * shapeLayer;
    UIBezierPath * cutePath;
    UIColor * fillColorForCute;
    
    UIPanGestureRecognizer * pan;
    UITapGestureRecognizer * tap;
}

/**
 *  初始化粘性视图对象
 *
 *  @param centerPoint     视图初始中心点坐标
 *  @param bubbleRadius    气泡半径
 *  @param bubbleViscosity 气泡拖拽粘性，即可拖拽的具体跟自身半径的比率
 *  @param bubbleColor     气泡颜色
 *  @param containerView   气泡父视图
 *
 *  @return 气泡实例
 */
- (instancetype)initWithCenter:(CGPoint)centerPoint
                  bubbleRadius:(CGFloat)bubbleRadius
               bubbleViscosity:(CGFloat)bubbleViscosity
                   bubbleColor:(UIColor *)bubbleColor
                 containerView:(UIView *)containerView
{
    self = [super initWithFrame:CGRectMake(centerPoint.x, centerPoint.y, 0.0, 0.0)];
    if (self) {
        
        initialPoint = centerPoint;
        _viscosity = bubbleViscosity;     //设置默认粘度
        _bubbleWidth = bubbleRadius;      //设置默认宽度
        self.bubbleColor = bubbleColor;
        self.containerView = containerView;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CGFLOAT_MIN * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setUp];
        });
        return self;
    }
    return nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithCenter:CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame)) bubbleRadius:kDefaultRadius bubbleViscosity:kDefaultViscosity containerView:nil];
    if (self) {

        return self;
    }
    return nil;
}

/**
 *  初始化粘性视图对象
 *
 *  @param centerPoint     视图初始中心点坐标
 *  @param containerView   气泡父视图
 *
 *  @return 气泡实例
 */
- (instancetype)initWithCenter:(CGPoint)centerPoint
                 containerView:(UIView *)containerView{
    self = [self initWithCenter:centerPoint bubbleRadius:kDefaultRadius bubbleViscosity:kDefaultViscosity bubbleColor:kDefaultBubbleColor containerView:containerView];
    if (self) {
        return self;
    }
    return nil;
}

/**
 *  初始化粘性视图对象
 *
 *  @param centerPoint     视图初始中心点坐标
 *  @param bubbleRadius    气泡半径
 *  @param containerView   气泡父视图
 *
 *  @return 气泡实例
 */
- (instancetype)initWithCenter:(CGPoint)centerPoint
                  bubbleRadius:(CGFloat)bubbleRadius
                 containerView:(UIView *)containerView
{
    self = [self initWithCenter:centerPoint bubbleRadius:bubbleRadius bubbleViscosity:kDefaultViscosity bubbleColor:kDefaultBubbleColor containerView:containerView];
    if (self) {
        return self;
    }
    return nil;
}

/**
 *  初始化粘性视图对象
 *
 *  @param centerPoint     视图初始中心点坐标
 *  @param bubbleRadius    气泡半径
 *
 *  @return 气泡实例
 */
- (instancetype)initWithCenter:(CGPoint)centerPoint
                  bubbleRadius:(CGFloat)bubbleRadius
{
    self = [self initWithCenter:centerPoint bubbleRadius:bubbleRadius bubbleViscosity:kDefaultViscosity bubbleColor:kDefaultBubbleColor containerView:nil];
    if (self) {
        return self;
    }
    return nil;
}

/**
 *  初始化粘性视图对象
 *
 *  @param centerPoint     视图初始中心点坐标
 *  @param bubbleRadius    气泡半径
 *  @param bubbleViscosity 气泡拖拽粘性，即可拖拽的具体跟自身半径的比率
 *  @param containerView   气泡父视图
 *
 *  @return 气泡实例
 */
- (instancetype)initWithCenter:(CGPoint)centerPoint
                  bubbleRadius:(CGFloat)bubbleRadius
               bubbleViscosity:(CGFloat)bubbleViscosity
                 containerView:(UIView *)containerView
{
    self = [self initWithCenter:centerPoint bubbleRadius:bubbleRadius bubbleViscosity:bubbleViscosity bubbleColor:kDefaultBubbleColor containerView:containerView];
    if (self) {
        return self;
    }
    return nil;
}

#pragma mark getters

- (UIView *)frontView{
    if (!_frontView) {
        _frontView = [[UIView alloc]initWithFrame:CGRectMake(initialPoint.x,initialPoint.y, self.bubbleWidth, self.bubbleWidth)];
        
        r2 = self.frontView.bounds.size.width / 2;
        _frontView.layer.cornerRadius = r2;
        _frontView.backgroundColor = self.bubColor;
        
    }
    return _frontView;
}

- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:self.frontView.frame];
        r1 = _backView.bounds.size.width / 2;
        _backView.layer.cornerRadius = r1;
        _backView.backgroundColor = self.bubColor;
    }
    return _backView;
}

- (UILabel *)bubbleLabel
{
    if (!_bubbleLabel) {
        _bubbleLabel = [[UILabel alloc]init];
        _bubbleLabel.frame = CGRectMake(0, 0, self.frontView.bounds.size.width, self.frontView.bounds.size.height);
        _bubbleLabel.textColor = [UIColor whiteColor];
        _bubbleLabel.textAlignment = NSTextAlignmentCenter;
        [self.frontView insertSubview:_bubbleLabel atIndex:0];
        
    }
    return _bubbleLabel;
}
#pragma mark setters
/**
 * 设置父视图
 */
- (void)setContainerView:(UIView *)containerView
{
    if (_containerView == containerView) return;
    
    if (_containerView) [self removeFromSuperview];
    
    _containerView = containerView;
    
    [_containerView addSubview:self];
    
}

/**
 *  设置气泡颜色
 */
- (void)setBubbleColor:(UIColor *)bubbleColor
{
    if (_bubColor == bubbleColor) {
        return;
    }
    _bubColor = bubbleColor;
    self.frontView.backgroundColor = _bubColor;
    self.backView.backgroundColor = _bubColor;
    [self setNeedsDisplay];
}

/**
 *  设置文本
 *
 */
- (void)setText:(NSString *)text{
    if ([_text isEqualToString:text]) {
        return;
    }
    _text = text;
    self.bubbleLabel.text = _text;
    [self setNeedsDisplay];
}

/**
 *  设置拖拽手势
 */
- (void)setOpenPanGesture:(BOOL)openPanGesture{
    if (_openPanGesture == openPanGesture) {
        return;
    }
    _openPanGesture = openPanGesture;
    if (_openPanGesture) {
        if (!pan) {
            pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragBubbleAction:)];
        }
        [self.frontView addGestureRecognizer:pan];
        
    }else{
        if (pan) [self.frontView removeGestureRecognizer:pan];
    }
}

- (void)setOpenTapGesture:(BOOL)openTapGesture
{
    if (_openTapGesture == openTapGesture) {
        return;
    }
    _openTapGesture = openTapGesture;
    if (_openTapGesture) {
        if (!tap) {
            tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bubbleTapAction:)];
        }
        [self.frontView addGestureRecognizer:tap];
    }else{
        if (tap) [self.frontView removeGestureRecognizer:tap];
    }
}

- (void)setTapDisappear:(BOOL)tapDisappear
{
    if (_tapDisappear == tapDisappear) {
        return;
    }
    _tapDisappear = tapDisappear;

}


#pragma mark  基础设置

-(void)setUp
{
    shapeLayer = [CAShapeLayer layer];
    self.backgroundColor = [UIColor clearColor];
    
    [self.containerView addSubview:self.backView];
    [self.containerView addSubview:self.frontView];
    self.openPanGesture = YES;
    self.openTapGesture = YES;
    x1 = _backView.center.x;
    y1 = _backView.center.y;
    x2 = self.frontView.center.x;
    y2 = self.frontView.center.y;
    
    pointA = CGPointMake(x1-r1,y1);   // A
    pointB = CGPointMake(x1+r1, y1);  // B
    pointD = CGPointMake(x2-r2, y2);  // D
    pointC = CGPointMake(x2+r2, y2);  // C
    pointO = CGPointMake(x1-r1,y1);   // O
    pointP = CGPointMake(x2+r2, y2);  // P
    
    oldBackViewFrame = _backView.frame;
    oldBackViewCenter = _backView.center;
    
    _backView.hidden = YES;//为了看到frontView的气泡晃动效果，需要展示隐藏backView
    [self AddAniamtionLikeGameCenterBubble];
}

#pragma mark  ----添加类似GameCenter的气泡晃动动画------
-(void)AddAniamtionLikeGameCenterBubble
{
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.repeatCount = INFINITY;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnimation.duration = 5.0;
    
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGRect circleContainer = CGRectInset(self.frontView.frame, self.frontView.bounds.size.width / 2 - 3, self.frontView.bounds.size.width / 2 - 3);
    CGPathAddEllipseInRect(curvedPath, NULL, circleContainer);
    
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    [self.frontView.layer addAnimation:pathAnimation forKey:@"myCircleAnimation"];
    
    CAKeyframeAnimation *scaleX = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];
    scaleX.duration = 1;
    scaleX.values = @[@1.0, @1.1, @1.0];
    scaleX.keyTimes = @[@0.0, @0.5, @1.0];
    scaleX.repeatCount = INFINITY;
    scaleX.autoreverses = YES;
    
    scaleX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [self.frontView.layer addAnimation:scaleX forKey:@"scaleXAnimation"];
    
    
    CAKeyframeAnimation *scaleY = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
    scaleY.duration = 1.5;
    scaleY.values = @[@1.0, @1.1, @1.0];
    scaleY.keyTimes = @[@0.0, @0.5, @1.0];
    scaleY.repeatCount = INFINITY;
    scaleY.autoreverses = YES;
    scaleY.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.frontView.layer addAnimation:scaleY forKey:@"scaleYAnimation"];
}

#pragma mark 手势action

-(void)dragBubbleAction:(UIPanGestureRecognizer *)panGesture
{
    if (!self.openPanGesture) {
        return;
    }
    
    CGPoint dragPoint = [panGesture locationInView:self.containerView];
    
    if (_vigourViewDelegate != nil) {
        if ([_vigourViewDelegate conformsToProtocol:@protocol(MLVigourViewDelegate)]) {
            if ([_vigourViewDelegate respondsToSelector:@selector(mlVigourView:paninOnPoint:)]) {
                [_vigourViewDelegate mlVigourView:self paninOnPoint:dragPoint];
            }
        }
    }
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        _backView.hidden = NO;
        fillColorForCute = self.bubColor;
        [self RemoveAniamtionLikeGameCenterBubble];
        
    }else if (panGesture.state == UIGestureRecognizerStateChanged){
        self.frontView.center = dragPoint;
        if (r1 <= 6) {
            
            fillColorForCute = [UIColor clearColor];
            _backView.hidden = YES;
            [shapeLayer removeFromSuperlayer];
        
        }
        
    }else if (panGesture.state == UIGestureRecognizerStateEnded || panGesture.state ==UIGestureRecognizerStateCancelled || panGesture.state == UIGestureRecognizerStateFailed){
        
        _backView.hidden = YES;
        fillColorForCute = [UIColor clearColor];
        [shapeLayer removeFromSuperlayer];
        [UIView animateWithDuration:0.5 delay:0.0f usingSpringWithDamping:0.4f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.frontView.center = oldBackViewCenter;
        } completion:^(BOOL finished) {
            
            if (finished) {
                [self AddAniamtionLikeGameCenterBubble];
            }
        }];
        
    }
    
    [self reCalculateBubbleArg];
    
}

- (void)bubbleTapAction:(UITapGestureRecognizer *)tapGes
{
    
    if (tapGes.state == UIGestureRecognizerStateRecognized)
    {
        CGPoint tapPoint = [tapGes locationInView:self.containerView];
        
        if (_vigourViewDelegate != nil) {
            if ([_vigourViewDelegate conformsToProtocol:@protocol(MLVigourViewDelegate)]) {
                if ([_vigourViewDelegate respondsToSelector:@selector(mlVigourView:tappedOnPoint:)]) {
                    [_vigourViewDelegate mlVigourView:self tappedOnPoint:tapPoint];
                }
            }
        }
        
        CGRect currentFrame = self.frontView.frame;
        __weak typeof(self)weakSelf = self;
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect rect = CGRectInset(oldBackViewFrame, -fabs(tapPoint.x-oldBackViewCenter.x), -fabs(tapPoint.y-oldBackViewCenter.y));
            
            weakSelf.frontView.frame = rect;
            weakSelf.frontView.layer.cornerRadius = rect.size.width/2.0;
            weakSelf.bubbleLabel.center = CGPointMake(CGRectGetMidX(weakSelf.frontView.bounds), CGRectGetMidY(weakSelf.frontView.bounds));

        } completion:^(BOOL finished) {
            
            __strong typeof(weakSelf)strongSelf = weakSelf;
            [UIView animateWithDuration:0.3 animations:^{
                __weak typeof(strongSelf)anotherWeakSelf = self;
                anotherWeakSelf.frontView.frame = currentFrame;
                anotherWeakSelf.frontView.layer.cornerRadius = currentFrame.size.width/2.0;
                anotherWeakSelf.bubbleLabel.center = CGPointMake(CGRectGetMidX(anotherWeakSelf.frontView.bounds), CGRectGetMidY(anotherWeakSelf.frontView.bounds));
            }];
        }];
        
        if (self.tapDisappear) {
            [self removeFromSuperview];
        }

    }
}


#pragma mark  从新计算气泡参数

-(void)reCalculateBubbleArg
{
    x1 = _backView.center.x;
    y1 = _backView.center.y;
    x2 = self.frontView.center.x;
    y2 = self.frontView.center.y;
    
    centerDistance = sqrtf((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1));
    if (centerDistance == 0) {
        cosDigree = 1;
        sinDigree = 0;
    }else{
        cosDigree = (y2-y1)/centerDistance;
        sinDigree = (x2-x1)/centerDistance;
    }

    r1 = oldBackViewFrame.size.width / 2 - centerDistance/self.viscosity;
    
    pointA = CGPointMake(x1-r1*cosDigree, y1+r1*sinDigree);  // A
    pointB = CGPointMake(x1+r1*cosDigree, y1-r1*sinDigree); // B
    pointD = CGPointMake(x2-r2*cosDigree, y2+r2*sinDigree); // D
    pointC = CGPointMake(x2+r2*cosDigree, y2-r2*sinDigree);// C
    pointO = CGPointMake(pointA.x + (centerDistance / 2)*sinDigree, pointA.y + (centerDistance / 2)*cosDigree);
    pointP = CGPointMake(pointB.x + (centerDistance / 2)*sinDigree, pointB.y + (centerDistance / 2)*cosDigree);
    
    [self drawRect];
}

#pragma mark  重绘

-(void)drawRect
{
    _backView.center = oldBackViewCenter;
    _backView.bounds = CGRectMake(0, 0, r1*2, r1*2);
    _backView.layer.cornerRadius = r1;
    
    cutePath = [UIBezierPath bezierPath];
    [cutePath moveToPoint:pointA];
    [cutePath addQuadCurveToPoint:pointD controlPoint:pointO];
    [cutePath addLineToPoint:pointC];
    [cutePath addQuadCurveToPoint:pointB controlPoint:pointP];
    [cutePath moveToPoint:pointA];
    
    if (_backView.hidden == NO) {
        shapeLayer.path = [cutePath CGPath];
        shapeLayer.fillColor = [fillColorForCute CGColor];
        [self.containerView.layer insertSublayer:shapeLayer below:self.frontView.layer];
    }
    
}

-(void)RemoveAniamtionLikeGameCenterBubble{
    [self.frontView.layer removeAllAnimations];
}

@end
