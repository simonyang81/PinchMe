//
//  ViewController.m
//  PinchMe
//
//  Created by Simon Yang on 10/22/16.
//  Copyright © 2016 Simon Yang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation ViewController

// 定义 当前缩放比例 和 先前缩放比例
CGFloat scale, previousScale;

// 定义 当前旋转角度 和 先前旋转角度
CGFloat rotation, previousRotation;

// 定义 当前位置 和 先前位置
CGFloat location, previousLocation;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    previousScale = 1;
    UIImage *image = [UIImage imageNamed:@"yosemite-meadows"];
    self.imageView = [[UIImageView alloc] initWithImage:image];
    self.imageView.userInteractionEnabled = YES;
    self.imageView.center = self.view.center;
    [self.view addSubview:self.imageView];

    UIPinchGestureRecognizer *pinchGesture
            = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(doPinch:)];
    pinchGesture.delegate = self;
    [self.imageView addGestureRecognizer:pinchGesture];

    UIRotationGestureRecognizer *rotationGesture
            = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(doRotate:)];
    rotationGesture.delegate = self;
    [self.imageView addGestureRecognizer:rotationGesture];

    UIPanGestureRecognizer *panGesture
            = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(doPan:)];
    panGesture.delegate = self;
    [self.imageView addGestureRecognizer:panGesture];


}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
        shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


-(void)transformImageView{
    CGAffineTransform t = CGAffineTransformMakeScale(scale * previousScale, scale * previousScale);
    self.imageView.transform = CGAffineTransformRotate(t, rotation + previousRotation);
}

-(void)doPinch:(UIPinchGestureRecognizer *)gesture{
    scale = gesture.scale;
    [self transformImageView];
    if (gesture.state == UIGestureRecognizerStateEnded) {
        previousScale = scale * previousScale;
        scale = 1;
    }
}

-(void)doRotate:(UIRotationGestureRecognizer *)gesture{
    rotation = gesture.rotation;
    [self transformImageView];
    if (gesture.state == UIGestureRecognizerStateEnded) {
        previousRotation = rotation + previousRotation;
        rotation = 0;
    }
}

-(void)doPan:(UIPanGestureRecognizer *)gesture{
    UIView *view = gesture.view;
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [gesture setTranslation:CGPointZero inView:view.superview];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
