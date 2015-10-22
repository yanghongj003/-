//
//  ViewController.m
//  猜图
//
//  Created by zpon on 15-4-4.
//  Copyright (c) 2015年 zpon. All rights reserved.
//

#import "ViewController.h"
#import "Question.h"
#define KbtnW 35
#define Kmargin 8
#define KbtnH KbtnW
#define Kcolumn 7

@interface ViewController ()<UIAlertViewDelegate>
{
    NSUInteger _number;// 记录当前的题目
    UIView *_coverView;// 遮盖view
}
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UIButton *coinBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;

/**
 *  模型数组
 */
@property (nonatomic,strong) NSArray *dataArr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageBtnW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageBtnH;
@property (weak, nonatomic) IBOutlet UIView *optionView;
/**
 *   存放答案按钮
 */
@property (nonatomic,strong) NSMutableArray *answerBtn;
/**
 *  存放选项按钮
 */
@property (nonatomic,strong) NSMutableArray *optionBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
     [super viewDidLoad];
     _number = 0;
    [self setUpView:self.dataArr[_number]];
}
/**
 *  懒加载
 */
- (NSArray *)dataArr
{
    if (!_dataArr)
    {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"questions.plist" ofType:nil];
        NSArray *arr = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *temp = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            Question *que = [Question questionWithDic:dic];
            [temp addObject:que];
        }
        _dataArr = temp;
    }
    return _dataArr;
}
/**
 *  设置界面view
 *  @param 模型对象
 */
- (void)setUpView:(Question *)que
{
    // 先把所有按钮移除
    
    [self.answerBtn makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.optionBtn makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 1:设置顶部标题
    self.topLabel.text = [NSString stringWithFormat:@"%u/%lu",_number+1,(unsigned long)self.dataArr.count];
    self.titleLabel.text = que.title;
    self.imageBtn.imageView.image = [UIImage imageNamed:que.icon];
    
    // 2:设置 option界面
    // 2.1 答案按钮
    NSUInteger number = que.answer.length;
    self.answerBtn = [NSMutableArray array];
    CGFloat leftMargin =(self.view.frame.size.width-number*KbtnW-(number-1)*Kmargin)/2;
    for (int i = 0; i<number; i++) {
        CGFloat btnX  = leftMargin+(KbtnW+Kmargin)*i;
        CGFloat btnY  = 0;
        CGFloat btnW  = KbtnW;
        CGFloat btnH  = KbtnH;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_answer"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_answer_highlighted"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(answerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.optionView addSubview:btn];
        [self.answerBtn addObject:btn];
    }
    
    // 2.2 选项按钮
    
    NSUInteger numberOption = que.options.count;
    self.optionBtn = [NSMutableArray array];
    CGFloat leftMarginOption =(self.view.frame.size.width-Kcolumn*KbtnW-(Kcolumn-1)*Kmargin)/2;
    for (int i = 0; i<numberOption; i++) {
        
        NSUInteger row = i/Kcolumn;
        NSUInteger column = i%Kcolumn;
        
        CGFloat btnX  = leftMarginOption+(KbtnW+Kmargin)*column;
        CGFloat btnY  = Kmargin+KbtnW+(KbtnH+Kmargin)*row;
        CGFloat btnW  = KbtnW;
        CGFloat btnH  = KbtnH;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [btn setTitle:[que.options objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitle:[que.options objectAtIndex:i] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_option"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_option_highlighted"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(optionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.optionView addSubview:btn];
        [self.optionBtn addObject:btn];
    }
}
/**
 *  答案按钮点击
 */
- (void)answerBtnClick:(UIButton *)btn
{
    for (int i=0;i<self.optionBtn.count;i++) {
        UIButton *oBtn = self.optionBtn[i];
        if ([oBtn.currentTitle isEqualToString:btn.currentTitle]&&oBtn.hidden==YES) {
            oBtn.hidden = NO;
            [btn setTitle:nil forState:UIControlStateNormal];
            [btn setTitle:nil forState:UIControlStateHighlighted];
            break;
        }
    }
    // 改变字体颜色
    for (UIButton *aBtn in self.answerBtn) {
        [aBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [aBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    }
}
/**
 *  选项按钮点击
 */
- (void)optionBtnClick:(UIButton *)btn
{
    for (int i=0;i<self.answerBtn.count;i++) {
        UIButton *aBtn = self.answerBtn[i];
        if (!aBtn.currentTitle) {
            [aBtn setTitle:btn.currentTitle forState:UIControlStateNormal];
            [aBtn setTitle:btn.currentTitle forState:UIControlStateHighlighted];
             btn.hidden = YES;
             break;
        }
    }
    BOOL finish = YES;
    NSMutableString *answer = [NSMutableString string];
    for (UIButton *aBtn in self.answerBtn) {
        if (!aBtn.currentTitle) {
            finish = NO;
        }
        if (aBtn.currentTitle) {
             [answer appendString:aBtn.currentTitle];
        }
    }
    // 答完题后判断是否正确（不正确字体显示红色）
    if (finish) {
        Question *que = self.dataArr[_number];
        if (![que.answer isEqualToString:answer]) {
            for (UIButton *aBn in self.answerBtn) {
                [aBn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [aBn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
            }
        }
        else
        {
            for (UIButton *aBn in self.answerBtn) {
                [aBn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [aBn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
            }
            if (_number<self.dataArr.count-1) {
                _number++;
                [self performSelector:@selector(setUpView:) withObject:self.dataArr[_number] afterDelay:1.0];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"恭喜你,已经全部通关" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
        }
    }
}
- (IBAction)btnDidClick:(id)sender {
    
    UIButton *btn =(UIButton*)sender;
    if ([btn.currentTitle isEqual:@"下一题"]) {
        [self nextQuestion:btn];
    }
    else if ([btn.currentTitle isEqual:@"大图"]) {
        [self imageBtnDidClick:nil];
    }
    else if ([btn.currentTitle isEqual:@"提示"]) {
        [self prompt];
    }
    else if ([btn.currentTitle isEqual:@"帮助"]) {
        [self help];
    }
}
// 下一个问题
- (void)nextQuestion:(UIButton *)btn
{
    if (_number<self.dataArr.count-1) {
        _number++;
        [self setUpView:self.dataArr[_number]];
        btn.enabled = YES;
    }
    else{
        btn.enabled = NO;
    }
}
/**
 *  imageBtn监听点击
 */
- (IBAction)imageBtnDidClick:(id)sender {
    
    if (_coverView)
    {
        [UIView animateWithDuration:0.5 animations:^{
        _coverView.alpha = 0.0;
        self.imageBtnH.constant = 120;
        self.imageBtnW.constant = 120;
        [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
            [_coverView removeFromSuperview];
            _coverView = nil;
        }];
    }
    else
    {
        UIView *coverView = [[UIView alloc]initWithFrame:self.view.bounds];
        coverView.backgroundColor = [UIColor blackColor];
        coverView.alpha = 0.0;
        [self.view addSubview:coverView];
        [self.view bringSubviewToFront:self.imageBtn];
        _coverView = coverView;
        [UIView animateWithDuration:0.5 animations:^{
            coverView.alpha = 0.5;
            self.imageBtnH.constant  = self.view.frame.size.width;
            self.imageBtnW.constant = self.view.frame.size.width;
            [self.view layoutIfNeeded];
        }];
    }
}
/**
 *  提示
 */
- (void)prompt
{
    for (UIButton *btn in self.answerBtn) {
        // 先清理答案按钮的文字
        [self answerBtnClick:btn];
    }
    Question *que = self.dataArr[_number];
    NSString *str= [que.answer substringToIndex:1];
    for (UIButton *btn in self.optionBtn) {
        if ([btn.currentTitle isEqualToString:str]) {
            [self optionBtnClick:btn];
            break;
        }
    }
}
/**
 *  帮助
 */
- (void)help
{
  
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"-----");
}
@end
