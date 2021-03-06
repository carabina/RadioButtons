//
//  CJButtonControllerView.m
//  CJSliderViewControllerDemo
//
//  Created by lichq on 14-11-5.
//  Copyright (c) 2014年 lichq. All rights reserved.
//

#import "CJButtonControllerView.h"

static NSInteger kMaxRadioButtonsShowViewCountDefault = 3;
static NSInteger kSelectedIndexDefault = 0;

@interface CJButtonControllerView () <RadioButtonsDataSource, RadioButtonsDelegate, RadioComposeViewDataSource, RadioComposeViewDelegate> {
    
    
}
@property (nonatomic, strong) IBOutlet RadioButtons *sliderRadioButtons;
@property (nonatomic, strong) IBOutlet RadioComposeView *radioComposeView;
@property (nonatomic, assign) NSInteger currentSelectedIndex;
@property (nonatomic, strong) NSLayoutConstraint *sliderRadioButtonsHeightlayoutConstraint;

@end

@implementation CJButtonControllerView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self commonInit];
}


- (void)reloadData {
    self.sliderRadioButtonsHeightlayoutConstraint.constant = self.radioButtonsHeight;
    self.sliderRadioButtons.dataSource = self;
    self.radioComposeView.dataSource = self;
}

- (void)commonInit {
    //RadioButtons
    self.sliderRadioButtons = [[RadioButtons alloc] initWithFrame:CGRectZero];
    self.sliderRadioButtons.showLineImageView = self.showLineImageView;
    self.sliderRadioButtons.lineImage = self.lineImage;
    self.sliderRadioButtons.lineImageViewHeight = self.lineImageViewHeight;
//    self.sliderRadioButtons.dataSource = self;
    self.sliderRadioButtons.delegate = self;
    [self addSubview:self.sliderRadioButtons];
    self.sliderRadioButtons.translatesAutoresizingMaskIntoConstraints = NO;
    //left
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.sliderRadioButtons
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:0]];
    //right
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.sliderRadioButtons
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1
                                                      constant:0]];
    //top
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.sliderRadioButtons
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:0]];
    //height
    self.sliderRadioButtonsHeightlayoutConstraint =
            [NSLayoutConstraint constraintWithItem:self.sliderRadioButtons
                                         attribute:NSLayoutAttributeHeight
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:nil
                                         attribute:NSLayoutAttributeNotAnAttribute
                                        multiplier:1
                                          constant:self.radioButtonsHeight];
    [self addConstraint:self.sliderRadioButtonsHeightlayoutConstraint];
    
    //RadioControllers
    self.radioComposeView = [[RadioComposeView alloc] initWithFrame:CGRectZero];
//    self.radioComposeView.dataSource = self;
    self.radioComposeView.delegate = self;
    [self addSubview:self.radioComposeView];
    self.radioComposeView.translatesAutoresizingMaskIntoConstraints = NO;
    //left
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.radioComposeView
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:0]];
    //right
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.radioComposeView
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1
                                                      constant:0]];
    //top
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.radioComposeView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.sliderRadioButtons
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:0]];
    //bottom
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.radioComposeView
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:0]];
    
    //Self
    self.defaultSelectedIndex = kSelectedIndexDefault;
    self.maxRadioButtonsShowViewCount = kMaxRadioButtonsShowViewCountDefault;
}

/** 完整的描述请参见文件头部 */
- (void)addLeftArrowImage:(UIImage *)leftArrowImage rightArrowImage:(UIImage *)rightArrowImage withArrowImageWidth:(CGFloat)arrowImageWidth {
    [self.sliderRadioButtons addLeftArrowImage:leftArrowImage
                               rightArrowImage:rightArrowImage
                           withArrowImageWidth:arrowImageWidth];
}


#pragma mark - RadioButtonsDataSource
- (NSInteger)cj_defaultShowIndexInRadioButtons:(RadioButtons *)radioButtons {
    return self.defaultSelectedIndex;
}

- (NSInteger)cj_numberOfComponentsInRadioButtons:(RadioButtons *)radioButtons {
    return self.titles.count;
}

- (CGFloat)cj_radioButtons:(RadioButtons *)radioButtons widthForComponentAtIndex:(NSInteger)index  {
    NSInteger showViewCount = MIN(self.titles.count, self.maxRadioButtonsShowViewCount);
    CGFloat sectionWidth = CGRectGetWidth(radioButtons.frame)/showViewCount;
    sectionWidth = ceilf(sectionWidth); //重点注意：当使用除法计算width时候，为了避免计算出来的值受除后，余数太多，除不尽(eg:102.66666666666667)，而造成的之后在通过左右箭头点击来寻找”要找的按钮“的时候，计算出现问题（”要找的按钮“需与“左右侧箭头的最左最右侧值”进行精确的比较），所以这里我们需要一个整数值，故我们这边选择向上取整。
    
    return sectionWidth;
}

- (RadioButton *)cj_radioButtons:(RadioButtons *)radioButtons cellForComponentAtIndex:(NSInteger)index {
    NSArray *radioButtonNib = [[NSBundle mainBundle]loadNibNamed:@"RadioButton_Slider" owner:nil options:nil];
    RadioButton *radioButton = [radioButtonNib lastObject];
    [radioButton setTitle:self.titles[index]];
    radioButton.textNormalColor = [UIColor blackColor];
    radioButton.textSelectedColor = [UIColor greenColor];
    
    return radioButton;
}


#pragma mark - RadioComposeViewDataSource
- (NSInteger)cj_defaultShowIndexInRadioComposeView:(RadioComposeView *)radioComposeView {
    return self.defaultSelectedIndex;
}

- (NSArray<UIView *> *)cj_radioViewsInRadioComposeView:(RadioComposeView *)radioComposeView {
    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (UIViewController *vc in self.componentViewControllers) {
        [views addObject:vc.view];
        [self.componentViewParentViewController addChildViewController:vc];//记得添加进去
    }
    
    return views;
}


#pragma mark - RadioButtonsDelegate & RadioComposeViewDelegate
- (void)cj_radioButtons:(RadioButtons *)radioButtons chooseIndex:(NSInteger)index_cur oldIndex:(NSInteger)index_old {
    //NSLog(@"index_old = %ld, index_cur = %ld", index_old, index_cur);
    [self.radioComposeView showViewWithIndex:index_cur];
    self.currentSelectedIndex = index_cur;
    
    [self doSomethingToCon_whereIndex:index_cur];
}

- (void)cj_radioComposeView:(RadioComposeView *)radioComposeView didChangeToIndex:(NSInteger)index {
    [self.sliderRadioButtons cj_selectComponentAtIndex:index animated:YES];
    self.currentSelectedIndex  = index;
    
    [self doSomethingToCon_whereIndex:index];
}


#pragma mark - 子类可选的继承方法
- (void)doSomethingToCon_whereIndex:(NSInteger)index {//若有类继承自此类，子类做一些额外的操作，比如“强制刷新”的操作
    
}


@end
