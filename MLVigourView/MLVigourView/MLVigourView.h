//
//  MLVigourView.h
//  MLVigourView
//
//  Created by 马龙 on 15/6/19.
//  Copyright (c) 2015年 xiaojukeji. All rights reserved.
//

/**
 *  当前类（粘性视图：MLVigourView）的核心代码（手势方法、setup、参数计算、动画添加和drawrect方法）来自于 杨骑滔(KittenYang)在github上的开源项目：https://github.com/reverse-eggplant/KYCuteView.git
 
 *  在原项目基础上，对接口和代码做了一些改动，以方便使用。
 */

#import <UIKit/UIKit.h>
@protocol MLVigourViewDelegate;


@interface MLVigourView : UIView
/**
 *  当前视图的父视图
 */
@property (nonatomic,weak)UIView * containerView;

/**
 *  气泡的直径：默认为30.0
 */
@property (nonatomic,assign)CGFloat bubbleWidth;

/**
 *  气泡粘性系数，越大可以拉得越长。默认为20.0
 */
@property (nonatomic,assign)CGFloat viscosity;

/**
 *  气泡颜色
 */
@property (nonatomic,strong)UIColor * bubColor;

/**
 *  是否隐藏气泡，默认为NO
 */
@property (nonatomic)BOOL bubbleHiden;

/**
 *  气泡的文本
 */
@property (nonatomic,copy)NSString * text;

/**
 *  打开或关闭拖拽手势。默认打开
 */
@property (nonatomic)BOOL openPanGesture;

/**
 *  打开或关闭tap手势。默认打开
 */
@property (nonatomic)BOOL openTapGesture;

/**
 *  轻拍消失
 */
@property (nonatomic)BOOL tapDisappear;

/**
 *  视图操作代理
 */
@property (nonatomic,weak)id <MLVigourViewDelegate> vigourViewDelegate;


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
                 containerView:(UIView *)containerView;

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
                 containerView:(UIView *)containerView;

/**
 *  初始化粘性视图对象
 *
 *  @param centerPoint     视图初始中心点坐标
 *  @param containerView   气泡父视图
 *
 *  @return 气泡实例
 */
- (instancetype)initWithCenter:(CGPoint)centerPoint
                 containerView:(UIView *)containerView;


/**
 *  初始化粘性视图对象
 *
 *  @param centerPoint     视图初始中心点坐标
 *  @param bubbleRadius    气泡半径
 *
 *  @return 气泡实例
 */
- (instancetype)initWithCenter:(CGPoint)centerPoint
                  bubbleRadius:(CGFloat)bubbleRadius;

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
                 containerView:(UIView *)containerView;
@end


@protocol MLVigourViewDelegate <NSObject>

@optional

/**
 *  粘性视图被轻拍时的代理方法
 *
 *  @param vigourView  被轻拍的视图
 *  @param tappedPoint 被拍到的点
 */
- (void)mlVigourView:(MLVigourView *)vigourView tappedOnPoint:(CGPoint)tappedPoint;

/**
 *  粘性视图被轻拖拽时的代理方法
 *
 *  @param vigourView  被拖拽的视图
 *  @param tappedPoint 拖拽正在经过的点
 */
- (void)mlVigourView:(MLVigourView *)vigourView paninOnPoint:(CGPoint)paningPoint;

@end


