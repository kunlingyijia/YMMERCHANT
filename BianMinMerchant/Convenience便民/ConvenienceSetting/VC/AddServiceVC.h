//
//  AddServiceVC.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/4/18.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface AddServiceVC : BaseViewController
@property (weak, nonatomic) IBOutlet EZTextView *textView;
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak)IBOutlet UIButton *addBtn;
@end
