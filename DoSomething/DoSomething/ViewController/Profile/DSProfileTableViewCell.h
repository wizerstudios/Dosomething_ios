//
//  DSProfileTableViewCell.h
//  DoSomething
//
//  Created by Sha on 10/13/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSProfileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *textFieldPlaceHolder;
@property (weak, nonatomic) IBOutlet UILabel *labelTitleText;
@property (weak, nonatomic) IBOutlet UILabel *labelDPTitleText;
@property (weak, nonatomic) IBOutlet UITextField *textFieldDPPlaceHolder;
@property (weak, nonatomic) IBOutlet UIButton *buttonPushHobbies;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintDatePickerViewYPos;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintDatePickerViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintTermsOfUseBtnDependViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintAccLabelYPos;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintEmailPassViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintNotificationViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintNotificationLabelYPos;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintProfileImageWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintProfileImageHeight;
@property (weak, nonatomic) IBOutlet UIImageView *hobbiesImageView;
@property (weak, nonatomic) IBOutlet UILabel *hobbiesNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *plusIconImageView;




@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintRadioButtonYPos;
@property (weak, nonatomic) IBOutlet UIButton *maleButton;
@property (weak, nonatomic) IBOutlet UIButton *femaleButton;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end
