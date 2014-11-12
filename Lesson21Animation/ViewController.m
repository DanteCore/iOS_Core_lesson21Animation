//
//  ViewController.m
//  Lesson21Animation
//
//  Created by Serhii Onopriienko on 11/9/14.
//  Copyright (c) 2014 Serhii Onopriienko. All rights reserved.
//

#import "ViewController.h"





@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *horizontalViews;
@property (strong, nonatomic) NSMutableArray *circleViews;
@property (strong, nonatomic) NSArray *directions;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.horizontalViews = [[NSMutableArray alloc]init];
    self.circleViews = [[NSMutableArray alloc]init];
    
    
    CGPoint down = CGPointMake(15, CGRectGetHeight(self.view.frame) - 15);
    CGPoint right = CGPointMake(CGRectGetWidth(self.view.frame) - 15, CGRectGetHeight(self.view.frame) - 15);
    CGPoint up = CGPointMake(CGRectGetWidth(self.view.frame) - 15, 15);
    CGPoint left = CGPointMake(15, 15);
    
    UIColor *r = [UIColor redColor];
    UIColor *g = [UIColor greenColor];
    UIColor *b = [UIColor blueColor];
    UIColor *bl = [UIColor blackColor];
    
    
    self.directions = [NSArray arrayWithObjects:
                       [NSArray arrayWithObjects:[NSValue valueWithCGPoint:down], r, nil],
                       [NSArray arrayWithObjects:[NSValue valueWithCGPoint:right], g, nil],
                       [NSArray arrayWithObjects:[NSValue valueWithCGPoint:up], b, nil],
                       [NSArray arrayWithObjects:[NSValue valueWithCGPoint:left], bl, nil],
                           nil];
    
    
    for (int i = 1; i <= 5; i++) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(50, 100 * i, 30, 30)];
        view.backgroundColor = [self getRandomColor];
        [self.view addSubview:view];
        [self.horizontalViews addObject:view];
    }
    
    for (int i = 1; i <= 4; i++) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0 * i, 30, 30)];
        view.backgroundColor = [[self.directions objectAtIndex:i - 1] objectAtIndex:1];
        [self.view addSubview:view];
        [self.circleViews addObject:view];
    }
}





- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    for (int i = 0; i < 5; i++) {
        UIView *view = [self.horizontalViews objectAtIndex:i];
        [self move:view inHorizontalDirectionAtIndex:i+1];
    }
    
    
    
    for (int i = 0; i < 4; i++) {
        
        __weak UIView *view = [self.circleViews objectAtIndex:i];
        [self move:view inСircularDirectionToCorner:0 withDelay:i];
        

    }
}





#pragma mark - Move

- (void) move:(UIView *)view inHorizontalDirectionAtIndex:(int)i {
    
    UIViewAnimationOptions animationOptions = i << 16 | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse;
    
    [UIView animateWithDuration:1
                          delay:0
                        options:animationOptions
                     animations:^{
                         view.backgroundColor = [self getRandomColor];
                         view.center = CGPointMake(CGRectGetWidth(self.view.frame) - CGRectGetWidth(view.bounds)/2 - 50, 100 * i);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}






- (void) move:(UIView *)view inСircularDirectionToCorner:(int)cornerIndex withDelay:(int)delay{
    
    NSArray *array = [self.directions objectAtIndex:cornerIndex];
    CGPoint point = [(NSValue *)[array objectAtIndex:0] CGPointValue];
    UIColor *color = [array objectAtIndex:1];
    __block int corner = cornerIndex;
    
    [UIView animateWithDuration:1
                          delay:delay
                        options:UIViewAnimationOptionCurveLinear 
                     animations:^{
                         view.backgroundColor = color;
                         view.center = point;
                     }
                     completion:^(BOOL finished) {
                         if (corner == 3) {
                             corner = 0;
                         } else {
                             corner++;
                         }
                         
                         __weak UIView *v = view;
                         [self move:v inСircularDirectionToCorner:corner withDelay:0];
                     }];
}



#pragma mark - RandomGenerator

- (UIColor *) getRandomColor {
    
    CGFloat r = (arc4random() %256) / 255.f;
    CGFloat g = (arc4random() %256) / 255.f;
    CGFloat b = (arc4random() %256) / 255.f;
    return  [UIColor colorWithRed:r green:g blue:b alpha:1.f];
}

@end
