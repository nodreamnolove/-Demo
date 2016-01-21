//
//  RotateView.m
//  SKDemo
//
//  Created by hmh on 16/1/21.
//  Copyright © 2016年 WanJi. All rights reserved.
//

#import "RotateView.h"
@interface RotateView()

@property (nonatomic,strong) UIImageView * imageview;

@property (nonatomic,strong) CADisplayLink * displayLink;

@end


@implementation RotateView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:frame];
//        imgV.image = [UIImage imageNamed:@"scan"];
        [self addSubview:imgV];
        self.imageview = imgV;
    }
    return self;
}

-(void)setImage:(UIImage *)image
{
    _image = image;
    self.imageview.image = image;
}
-(void)startRotate
{
    if (self.displayLink) {
        return ;
    }
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(runRotate)];
    self.displayLink = link;
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

-(void)runRotate
{
    self.imageview.transform = CGAffineTransformRotate(self.imageview.transform, M_PI/100);
}

-(void)stopRotate
{
    [self.displayLink invalidate];
    self.displayLink = nil;
}
@end
