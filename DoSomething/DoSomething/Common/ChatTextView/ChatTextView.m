//
//  ChatTextView.m
//  Social_Events
//
//  Created by Ocsmobi-5 on 18/10/14.
//  Copyright (c) 2014 Social_Events. All rights reserved.
//

#import "ChatTextView.h"
#import "DSAppCommon.h"

@implementation ChatTextView
@synthesize textView,postButton,delegate,backGroundImageView,placeHolderLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

- (void) awakeFromNib {
   
    [self composeView];
}

- (void) composeView{
    
    textView = [[UITextView alloc]init];
    backGroundImageView  = [[UIImageView alloc]init];
    placeHolderLabel = [[UILabel alloc] init];
    postButton = [[UIButton alloc]init];
    
    if(IS_IPHONE6_Plus)
    {
        [backGroundImageView setFrame:CGRectMake(0,0,self.frame.size.width+95, self.frame.size.height+5)];
        [textView setFrame:CGRectMake(10,11, 320, 25)];
        [placeHolderLabel setFrame:CGRectMake(13,8,textView.frame.size.width - 10.0, 26)];
        [postButton setFrame:CGRectMake(backGroundImageView.frame.size.width-60,6, 50, 34)];

    }
    else if(IS_IPHONE6){
        
        [backGroundImageView setFrame:CGRectMake(0,0,self.frame.size.width+95, self.frame.size.height+5)];
        [textView setFrame:CGRectMake(10, 11, 315, 25)];
        [placeHolderLabel setFrame:CGRectMake(13,9,textView.frame.size.width - 10.0,26)];
        [postButton setFrame:CGRectMake(backGroundImageView.frame.size.width-95,6, 50, 34)];

    }
        
    else
    {
        [backGroundImageView setFrame:CGRectMake(0,0,self.frame.size.width, self.frame.size.height+5)];
        [textView setFrame:CGRectMake(10,11, 255,25)];
        [placeHolderLabel setFrame:CGRectMake(13.0,8,textView.frame.size.width - 10.0, 26.0)];
        [postButton setFrame:CGRectMake(backGroundImageView.frame.size.width-60,6, 50,34)];
    }
    
    backGroundImageView.backgroundColor = [UIColor colorWithRed:246.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
   
    [self addSubview:backGroundImageView];
    
    textView.delegate = delegate;
    
    textView.backgroundColor = [UIColor clearColor];
    
    textView.textAlignment = NSTextAlignmentJustified;
    
    [self addSubview:textView];
    
    
    [placeHolderLabel setText:@"Message"];
    
    [placeHolderLabel setBackgroundColor:[UIColor clearColor]];
    
    placeHolderLabel.font= [UIFont systemFontOfSize:14];
    
    [placeHolderLabel setTextColor:[UIColor lightGrayColor]];
    
    [self addSubview:placeHolderLabel];
    
    
    
    
    postButton.layer.cornerRadius = 6;
    
    postButton.clipsToBounds = YES;
    
    postButton.titleLabel.font= [UIFont systemFontOfSize:14];
    
    [postButton setTitleColor:[UIColor colorWithRed:120.0f/255.0f green:127.0f/255.0f blue:137.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    
    [postButton setTitle:@"Send" forState:UIControlStateNormal];
    
    [self addSubview:postButton];
    
    
}

@end
