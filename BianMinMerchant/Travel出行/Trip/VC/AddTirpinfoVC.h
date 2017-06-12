//
//  AddTirpinfoVC.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/15.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^ReturnAddTirpinfoVC)(NSString*str);
@interface AddTirpinfoVC : BaseViewController
///Block属性 传值一
@property(nonatomic,copy) ReturnAddTirpinfoVC returnAddTirpinfoVC;
//block 传值 二  block 作为方法参数传值

-(void)ReturnAddTirpinfoVC:(ReturnAddTirpinfoVC)block;

///属性传值
@property (nonatomic, strong) NSString  *titleStr ;
///
///RightTFStr
@property (nonatomic, strong) NSString  *RightTFStr ;



@end
