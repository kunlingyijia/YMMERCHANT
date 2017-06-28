//
//  BaseViewController.h
//  BianMinMerchant
//
//  Created by kkk on 16/5/27.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^OKDefault)(UIAlertAction*defaultaction);
typedef void(^Cancel)(UIAlertAction *cancelaction);
typedef void(^ObjectBack)();
@interface BaseViewController : UIViewController
///ObjectBack
@property (nonatomic, copy) ObjectBack  Back ;
@property (nonatomic, copy) ObjectBack  RightBack ;
- (void)navigationTitleColor:(NSString *)colorStr;
- (void)showBackBtn;
- (void)showBackBtn:(ObjectBack)Back;
///
- (void)showRightBtnTitle:(NSString*)title Image:(NSString*)Image RightBtn:(ObjectBack)RightBtn;
- (void)showSuccessWith:(NSString *)str;
//回收键盘
- (void)endEditingAction:(UIView *)endView;
//加载网络图片
- (void)loadImageWithView:(UIImageView *)imageV urlStr:(NSString *)urlStr;
//缓冲
- (void)showProgress;
- (void)showProgressWithText:(NSString *)text;

- (void)showSucessProgress;
- (void)showSucessProgressWithText:(NSString *)text;

- (void)showErrorProgress;
- (void)showErrorProgressWithText:(NSString *)text;

- (void)hideProgress;

- (void)showToast:(NSString *)text;
///显示底图
-(void)ShowNodataView;
///移除底图
-(void)HiddenNodataView;
///取消确定 --居中
-(void)alertWithTitle:(NSString*)title message:(NSString*)message OKWithTitle:(NSString*)OKtitle  CancelWithTitle:(NSString*)Canceltitle withOKDefault:(OKDefault)defaultaction withCancel:(Cancel)cancelaction;
///单个确定 居下
-(void)alertSheetWithTitle:(NSString*)title message:(NSString*)message OKWithTitle:(NSString*)OKtitle   withOKDefault:(OKDefault)defaultaction;
///单个确定 居中
-(void)alertWithTitle:(NSString*)title message:(NSString*)message OKWithTitle:(NSString*)OKtitle   withOKDefault:(OKDefault)defaultaction;
///取消确定 --居下
-(void)alertActionSheetWithTitle:(NSString*)title message:(NSString*)message OKWithTitle:(NSString*)OKtitle  CancelWithTitle:(NSString*)Canceltitle withOKDefault:(OKDefault)defaultaction withCancel:(Cancel)cancelaction;
///取消-确定-确定 --居下
-(void)alertActionSheetWithTitle:(NSString*)title message:(NSString*)message OKWithTitleOne:(NSString*)OKtitleOne OKWithTitleTwo:(NSString*)OKtitleTwo  CancelWithTitle:(NSString*)Canceltitle withOKDefaultOne:(OKDefault)defaultactionOne withOKDefaultTwo:(OKDefault)defaultactionTwo withCancel:(Cancel)cancelaction;
// 取消-确定-确定 -确定 --居下
-(void)alertActionSheetWithTitle:(NSString*)title message:(NSString*)message OKWithTitleOne:(NSString*)OKtitleOne OKWithTitleTwo:(NSString*)OKtitleTwo OKWithTitleThree:(NSString*)OKtitleThree  CancelWithTitle:(NSString*)Canceltitle withOKDefaultOne:(OKDefault)defaultactionOne withOKDefaultTwo:(OKDefault)defaultactionTwo withOKDefaultThree:(OKDefault)defaultactionThree withCancel:(Cancel)cancelaction;
@end
