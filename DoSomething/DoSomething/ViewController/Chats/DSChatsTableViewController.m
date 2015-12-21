//
//  DSChatsTableViewController.m
//  DoSomething
//
//  Created by ocsdeveloper9 on 10/28/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import "DSChatsTableViewController.h"
#import "ChatTableViewCell.h"
#import "DSChatDetailViewController.h"
#import "CustomNavigationView.h"
#import "DSConfig.h"
#import "DSWebservice.h"
#import "DSAppCommon.h"

@interface DSChatsTableViewController ()

{
    NSArray *ChatNameArray;
    NSArray *MessageArray;
    NSArray *timeArray;
    NSArray *imageArray;
    NSArray*badgeimage;
    UIButton *navButton;
    NSString * currentLatitude, * currentLongitude;
    DSWebservice *webService;
    NSMutableArray *chatArray;
    NSUInteger isSupportUser;
}

@end

@implementation DSChatsTableViewController
@synthesize ChatTableView,locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    locationManager                 = [[CLLocationManager alloc] init];
    locationManager.delegate        = self;
    chatArray = [[NSMutableArray alloc]init];
    webService = [[DSWebservice alloc]init];
//    ChatNameArray =[[NSArray alloc] initWithObjects:@"Gal Gadot",@"Yuna",@"Taylor",nil];
//    MessageArray =[[NSArray alloc] initWithObjects:@"Haha Sure I'll see you at 7:)",@"Hello?",@"See Ya!",nil];
//    timeArray = [[NSArray alloc] initWithObjects:@"19:58",@"17:20",@"15:30",nil];
//    imageArray =[[NSArray alloc] initWithObjects:@"Galglot.png",@"yuna.png",@"taylor.png",nil];
//    badgeimage=[[NSArray alloc] initWithObjects:@"12-Chats.png",@"18-Chats.png",@" ",nil];
//    badgeimage=[[NSArray alloc] initWithObjects:@"18-Chats.png",@"12-Chats.png",@" ",nil];
    
    if(IS_IPHONE6 || IS_IPHONE6_Plus)
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:ChatTableView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:20.0]];
    
    }




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getUserCurrenLocation];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self setNavigation];
    [COMMON LoadIcon:self.view];
    [self loadChatHistoryAPI];
}

- (void)setNavigation
{
    CustomNavigationView *customNavigation;
    customNavigation = [[CustomNavigationView alloc] initWithNibName:@"CustomNavigationView" bundle:nil];
    customNavigation.view.frame = CGRectMake(0,-20, CGRectGetWidth(self.view.frame), 65);
    if (IS_IPHONE6 ){
        customNavigation.view.frame = CGRectMake(0,-20, 375, 83);
    }
    if(IS_IPHONE6_Plus)
    {
        customNavigation.view.frame = CGRectMake(0,-20, 420, 83);
    }
    [customNavigation.menuBtn setHidden:NO];
    [customNavigation.buttonBack setHidden:YES];
    [customNavigation.saveBtn setHidden:YES];
    [self.navigationController.navigationBar addSubview:customNavigation.view];
    //    [customNavigation.saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    //    [customNavigation.buttonBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark get user CurrentLocation

- (void)getUserCurrenLocation{
    
    if(!locationManager){
        
        
        locationManager.distanceFilter  = kCLLocationAccuracyKilometer;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.activityType    = CLActivityTypeAutomotiveNavigation;
    }
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        [locationManager requestAlwaysAuthorization];
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        [locationManager requestWhenInUseAuthorization];
    
    [locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    
    CLLocation *newLocation = [locations lastObject];
    
    currentLatitude         = [NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:newLocation.coordinate.latitude]];
    
    currentLongitude        = [NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:newLocation.coordinate.longitude]];
    
    [[NSUserDefaults standardUserDefaults] setObject:currentLatitude  forKey:@"currentLatitude"];
    [[NSUserDefaults standardUserDefaults] setObject:currentLongitude forKey:@"currentLongitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Turn off the location manager to save power.
    [locationManager stopUpdatingLocation];
    
    NSLog(@"current latitude & longitude for main view = %@ & %@",currentLatitude,currentLongitude);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self loadLocationUpdateAPI];
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            
        });
        
        
    });
    
    
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    NSLog(@"Cannot find the location for main view.");
}



#pragma mark - TableView Datasources

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [chatArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatTableViewCell *Cell;
    static NSString *identifier = @"Mycell";
    Cell = (ChatTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!Cell)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ChatTableViewCell" owner:nil options:nil];
        Cell = [nib objectAtIndex:0];
        
    }
    NSMutableDictionary *chatDict = [chatArray objectAtIndex:indexPath.row];
    isSupportUser = [[chatDict valueForKey:@"supportuser"]integerValue];
    Cell.ChatName .text = [chatDict valueForKey:@"Name"];
    Cell.Message.text= [chatDict valueForKey:@"LastMessage"];
    
    NSString *timeStr = [chatDict valueForKey:@"LastMessageSentTime"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormat dateFromString:timeStr];
    
    [dateFormat setDateFormat:@"hh:mm"];
    timeStr = [dateFormat stringFromDate:date];
    
    Cell.Time.text = timeStr;
    
    NSString *ProfileName=[NSString stringWithFormat:@"%@",[chatDict valueForKey:@"image1"]];
    downloadImageFromUrl(ProfileName,Cell.profileImageView);
    [Cell.profileImageView setImage:[UIImage imageNamed:ProfileName]];
    [Cell.profileImageView.layer setCornerRadius:29];
    
    NSUInteger msgCount = [[chatDict valueForKey:@"unreadmessage"]integerValue];
    if(msgCount >=1){
        [Cell.msgCountLabel setHidden:NO];
        [Cell.msgCountLabel setText:[NSString stringWithFormat:@"%lu",(unsigned long)msgCount]];
        [Cell.msgCountLabel.layer setCornerRadius:9];
        Cell.msgCountLabel.clipsToBounds = YES;
    }
    else
        [Cell.msgCountLabel setHidden:YES];
    
    if(isSupportUser == 1){
        [Cell.profileImageView.layer setMasksToBounds:YES];
        [Cell.profileImageView.layer setBorderWidth:2.0f];
        [Cell.profileImageView.layer setBorderColor:[[UIColor colorWithRed:229.0f/255.0f green:63.0f/255.0f blue:81.0f/255.0f alpha:1.0f] CGColor]];
        
    }
    
    ChatTableView.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1.0f];
    
    return Cell;
}

#pragma edit TableViewCell

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *chatDict = [chatArray objectAtIndex:indexPath.row];
    isSupportUser = [[chatDict valueForKey:@"supportuser"]integerValue];
    if(isSupportUser == 0)
        return YES;
    else
        return NO;
}
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
       UITableViewRowAction *blockButton = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Block" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                                           
                                           [self.ChatTableView setEditing:YES];
                                             
                                         }];
    
   
        [blockButton.title sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Patron-Regular" size:11.0]}];
        blockButton.backgroundColor =[UIColor colorWithRed:0.465f green:0.465f blue:0.465f alpha:1.0f] ;
        
        UITableViewRowAction *deleteButton = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
           
                [timeArray objectAtIndex:indexPath.row];
                [self.ChatTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        }];
        [deleteButton.title sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Patron-Regular" size:11.0]}];
        deleteButton.backgroundColor =[UIColor colorWithRed:(230/255.0) green:(63/255.0) blue:(82/255.0) alpha:1];
    
         return @[deleteButton,blockButton];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DSChatDetailViewController *ChatDetail =[[DSChatDetailViewController alloc]initWithNibName:nil bundle:nil];
    ChatDetail.activestring  = [ChatNameArray objectAtIndex:indexPath.row];
    ChatDetail.activestring1  = [imageArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:ChatDetail animated:YES];
}

#pragma mark - WebService

-(void)loadLocationUpdateAPI{
    
    [webService locationUpdate:LocationUpdate_API sessionid:[COMMON getSessionID] latitude:currentLatitude longitude:currentLongitude
                       success:^(AFHTTPRequestOperation *operation, id responseObject){
                           NSLog(@"responseObject = %@",responseObject);
                       }
                       failure:^(AFHTTPRequestOperation *operation, id error) {
                           
                       }];
    
    
}

-(void)loadChatHistoryAPI{
    [webService userChatHist:ChatHistory_API sessionid:[COMMON getSessionID]
                    success:^(AFHTTPRequestOperation *operation, id responseObject){
                        
                        NSLog(@"responseObject = %@",responseObject);
                        
                        chatArray = [[responseObject valueForKey:@"getchathistory"]valueForKey:@"converation"];
                        NSLog(@"chatArray = %@",chatArray);
                        [ChatTableView reloadData];
                        
                        [COMMON removeLoading];
                        
                    }
                     failure:^(AFHTTPRequestOperation *operation, id error) {
                         
                     }];
}

@end
