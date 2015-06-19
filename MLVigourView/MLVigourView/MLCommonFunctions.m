//
//  MLCommonFunctions.m
//  MLVigourView
//
//  Created by 马龙 on 15/6/19.
//  Copyright (c) 2015年 xiaojukeji. All rights reserved.
//

#import "MLCommonFunctions.h"

CGFloat centerDistanceBetweenTwoView(UIView * view1,UIView * view2)
{
    CGFloat centerDistance = 0.0;
    CGFloat x1 = view1.center.x;
    CGFloat y1 = view1.center.y;
    CGFloat x2 = view2.center.x;
    CGFloat y2 = view2.center.y;
    
    centerDistance = sqrtf((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1));
    
    return centerDistance;
}

CGFloat cosDigreeBetweenTwoView(UIView * view1,UIView * view2)
{
    CGFloat centerDistance = 0.0;
    CGFloat x1 = view1.center.x;
    CGFloat y1 = view1.center.y;
    CGFloat x2 = view2.center.x;
    CGFloat y2 = view2.center.y;
    
    centerDistance = sqrtf((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1));
    
    CGFloat  cosDigree = (y2-y1)/centerDistance;

    return cosDigree;
    
}
CGFloat sinDigreeBetweenTwoView(UIView * view1,UIView * view2)
{
    CGFloat centerDistance = 0.0;
    CGFloat x1 = view1.center.x;
    CGFloat y1 = view1.center.y;
    CGFloat x2 = view2.center.x;
    CGFloat y2 = view2.center.y;
    
    centerDistance = sqrtf((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1));
    
    CGFloat  sinDigree = (x2-x1)/centerDistance;
    
    return sinDigree;
}

//以radius为半径，获取视图view的左手切点point
CGPoint viewLeftPoint(UIView * view,CGFloat radius,CGFloat cosDigree,CGFloat sinDigree)
{
    CGFloat centerX = view.center.x;
    CGFloat centerY = view.center.y;
    return  CGPointMake(centerX-radius*cosDigree, centerY+radius*sinDigree);
}

//以radius为半径，获取视图view的右手切点point
CGPoint viewRightPoint(UIView * view,CGFloat radius,CGFloat cosDigree,CGFloat sinDigree)
{
    CGFloat centerX = view.center.x;
    CGFloat centerY = view.center.y;
    return  CGPointMake(centerX+radius*cosDigree, centerY-radius*sinDigree);
}



