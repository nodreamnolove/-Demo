//
//  RotateView.h
//  SKDemo
//
//  Created by 段瑞权 on 16/1/21.
//  Copyright © 2016年 WanJi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RotateView : UIView


@property (nonatomic,strong) UIImage * image;

-(void)startRotate;
-(void)stopRotate;
@end
