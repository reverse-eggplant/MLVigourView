//
//  MLCommonFunctions.h
//  MLVigourView
//
//  Created by 马龙 on 15/6/19.
//  Copyright (c) 2015年 xiaojukeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef MLCenterDistanceBetweenTwoView
#define MLCenterDistanceBetweenTwoView(__View1__,__View2__) centerDistanceBetweenTwoView(__View1__,__View2__)
#endif

#ifndef MLCosDigreeBetweenTwoView
#define MLCosDigreeBetweenTwoView(__View1__,__View2__) cosDigreeBetweenTwoView(__View1__,__View2__)
#endif

#ifndef MLSinDigreeBetweenTwoView
#define MLSinDigreeBetweenTwoView(__View1__,__View2__) sinDigreeBetweenTwoView(__View1__,__View2__)
#endif

#ifndef MLViewLeftPoint
#define MLViewLeftPoint(__View__,__Radius__,__CosDigree__,__SinDigree__) viewLeftPoint(__View__,__Radius__,__CosDigree__,__SinDigree__)
#endif

#ifndef MLViewRightPoint
#define MLViewRightPoint(__View__,__Radius__,__CosDigree__,__SinDigree__) viewRightPoint(__View__,__Radius__,__CosDigree__,__SinDigree__)
#endif

//获取两个视图中心点连线的距离
CGFloat centerDistanceBetweenTwoView(UIView * view1,UIView * view2);

//获取两个视图中心点连线的水平角度cos值
CGFloat cosDigreeBetweenTwoView(UIView * view1,UIView * view2);

//获取两个视图中心点连线的水平角度sin值
CGFloat sinDigreeBetweenTwoView(UIView * view1,UIView * view2);

//以radius为半径，获取视图view的左手切点point
CGPoint viewLeftPoint(UIView * view,CGFloat radius,CGFloat cosDigree,CGFloat sinDigree);

//以radius为半径，获取视图view的右手切点point
CGPoint viewRightPoint(UIView * view,CGFloat radius,CGFloat cosDigree,CGFloat sinDigree);

