//
//  IntroductionView.m
//  Introduction-1
//
//  Created by Alex on 15/9/17.
//  Copyright (c) 2015年 Alex. All rights reserved.
//

#import "IntroductionView.h"

#define isIPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

@interface IntroductionView()<UIScrollViewDelegate>
{
    UIButton *skipBtn;
}

//引导页的image数组
@property (strong, nonatomic) NSArray *guidePageImageArr;

@end

@implementation IntroductionView

static IntroductionView * _intro = nil;

+ (instancetype)sharedInstnce
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _intro = [[IntroductionView alloc]init];
    });
    return _intro;
}

- (void)showIntroductionView
{
    UIWindow *window = [[[UIApplication sharedApplication]delegate]window];
    _intro.frame = window.frame;
    _intro.pagingEnabled = YES;
    _intro.bounces = NO;
    _intro.delegate = self;
    _intro.showsHorizontalScrollIndicator = NO;
    [window addSubview:_intro];
    
    NSString *imageName =  nil;
    if (isIPhone4) {
        //iPhone4、4s的引导页
        imageName = @"guidePage640";
    }else{
        //iPhone5、5s、6、plus的宽高比都是0.56左右  所以都用plus尺寸的引导页
        imageName = @"guidePage1080";
    }
    NSMutableArray *imageNameArr = [NSMutableArray array];
    for (NSInteger i=1; i<=3; i++) {
        NSString *newImageName = [imageName stringByAppendingFormat:@"_%d",(int)i];
        UIImage *image = [UIImage imageNamed:newImageName];
        if (image) {
            [imageNameArr addObject:image];
        }
    }
    
    CGRect frame = window.bounds;
    for (NSInteger i=0; i<imageNameArr.count; i++) {
        UIImage *image = imageNameArr[i];
        frame.origin.x = frame.size.width*i;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
        imageView.image = image;
        [self addSubview:imageView];
        
        if (i == imageNameArr.count-1) {
            CGRect bf = CGRectZero;
            bf.size = CGSizeMake(129, 40);
            bf.origin.x = frame.origin.x + (frame.size.width - bf.size.width) / 2.;
            bf.origin.y = frame.size.height - bf.size.height - 25.f;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
            btn.frame = bf;
            [btn setImage:[UIImage imageNamed:@"skipBtn"] forState:UIControlStateNormal];
            [btn addTarget:self
                    action:@selector(onTapLastGuidePage:)
          forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapLastGuidePage:)];
            [imageView addGestureRecognizer:tap];
        }
    }
    self.contentSize = CGSizeMake(frame.size.width*imageNameArr.count, frame.size.height);
    self.contentOffset = CGPointZero;
}

- (void)onTapLastGuidePage:(id)sender
{
    [UIView animateWithDuration:2.0 animations:^{
        self.alpha = 0.;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark -
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    NSInteger index = scrollView.frame.size.width/appDelegate.window.frame.size.width;
//    skipBtn.hidden = (index == _guidePageImageArr.count-1);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    CGRect skFrame = skipBtn.frame;
//    if (scrollView.contentOffset.x <= appDelegate.window.frame.size.width) {
//        skFrame.origin.x = appDelegate.window.frame.size.width - 10. - skFrame.size.width + scrollView.contentOffset.x;
//        skipBtn.frame = skFrame;
//        skipBtn.hidden = NO;
//    }else{
//        skipBtn.hidden = YES;
//    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
