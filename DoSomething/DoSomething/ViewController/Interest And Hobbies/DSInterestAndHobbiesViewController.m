//
//  DSInterestAndHobbiesViewController.m
//  DoSomething
//
//  Created by OCSDEV2 on 17/10/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import "DSInterestAndHobbiesViewController.h"
#import "DSInterestAndHobbiesCollectionViewCell.h"
#import "CustomNavigationView.h"
#import "DSConfig.h"
#import "DSWebservice.h"
#import "DSAppCommon.h"
#import "OpenUDID.h"
#import "UIImageView+AFNetworking.h"

@interface DSInterestAndHobbiesViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray*sectionNameArray;
    NSMutableArray * hobbiesArry;
    NSMutableArray *interstAndHobbiesArray,*interestArray;
    NSArray *sectionArray;
    NSMutableArray *imageNormalImageArray,*hobbiesNameArray,*hobbiesCategoryID;
    DSWebservice * objWebservice;
    NSString                * deviceUdid;
    BOOL   iscollectiviewreload;
}
@end

@implementation DSInterestAndHobbiesViewController
@synthesize interestAndHobbiesCollectionView, profileDetailsArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    objWebservice =[[DSWebservice alloc]init];
        deviceUdid = [OpenUDID value];
    
    
    [self.interestAndHobbiesCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.headerReferenceSize = CGSizeMake(self.interestAndHobbiesCollectionView.bounds.size.width,40);
    [self.interestAndHobbiesCollectionView setCollectionViewLayout:flowLayout];
//    UINib *cellNib = [UINib nibWithNibName:@"DSInterestAndHobbiesCollectionViewCell" bundle:nil];
//    [self.interestAndHobbiesCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"InterestAndHobbiesCollectionViewCell"];
//    
//    interestAndHobbiesCollectionView.delegate=self;
//    interestAndHobbiesCollectionView.dataSource=self;
    
    
    // interstAndHobbiesArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"SelectedItem"] mutableCopy];
    [self initializeArray];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self.navigationController.navigationBar setTranslucent:YES];
    imageNormalImageArray =[[[NSUserDefaults standardUserDefaults] valueForKey:@"SelectedItemNormal"]mutableCopy];
    hobbiesNameArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"SelectedItemName"]mutableCopy];
    hobbiesCategoryID =[[[NSUserDefaults standardUserDefaults]valueForKey:@"SelectedItemCategoryID"]mutableCopy];
    
    if (!hobbiesNameArray) {
        hobbiesNameArray = [[NSMutableArray alloc] init];
    }
    if (!imageNormalImageArray) {
        imageNormalImageArray = [[NSMutableArray alloc] init];
    }
    if (!hobbiesCategoryID) {
        hobbiesCategoryID = [[NSMutableArray alloc] init];
    }

    CustomNavigationView *customNavigation;
    customNavigation = [[CustomNavigationView alloc] initWithNibName:@"CustomNavigationView" bundle:nil];
    customNavigation.view.frame = CGRectMake(0,-20, (self.view.frame.size.width), 65);
    if (IS_IPHONE5 ){
        self.layoutConstraintinterestAndHobbiesLabelYPos.constant =68;
        self.layoutConstraintCollectionviewYPos.constant =25;
        self.layoutConstraintTapLabelYPos.constant =0;
    }
    if (IS_IPHONE6 ){
        customNavigation.view.frame = CGRectMake(0,-20, 375, 83);
        self.layoutConstraintinterestAndHobbiesLabelYPos.constant =98;
        self.layoutConstraintCollectionviewYPos.constant =65;
        self.layoutConstraintTapLabelYPos.constant = 6;
    }
    if(IS_IPHONE6_Plus)
    {
        customNavigation.view.frame = CGRectMake(0,-20, 420, 83);
        self.layoutConstraintinterestAndHobbiesLabelYPos.constant =98;
        self.layoutConstraintCollectionviewYPos.constant =65;
        self.layoutConstraintTapLabelYPos.constant = 6;
    }
    [self.navigationController.navigationBar addSubview:customNavigation.view];
    [customNavigation.buttonBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [customNavigation.saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [customNavigation.menuBtn setHidden:YES];
    [customNavigation.buttonBack setHidden:NO];
    [customNavigation.saveBtn setHidden:NO];
    

}
-(void)loadHobbiesWebserviceMethod
{
    [objWebservice getHobbies:GetHobbies_API sessionid:deviceUdid success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"response:%@",responseObject);
        
        hobbiesArry=[[NSMutableArray alloc]init];
        sectionNameArray=[[NSMutableArray alloc]init];
        
         NSMutableDictionary *loginDict = [[NSMutableDictionary alloc]init];
        NSDictionary *objselectionname=[[NSDictionary alloc]init];
         loginDict = [responseObject valueForKey:@"gethobbies"];
        objselectionname =[loginDict valueForKey:@"list"];
         sectionNameArray  = [objselectionname valueForKey:@"name"];
         hobbiesArry=[objselectionname valueForKey:@"hobbieslist"];
         
        // NSLog(@"responsesectionArray:%@",interstAndHobbiesArray);
         
         
         [COMMON removeLoading];
        [interestAndHobbiesCollectionView reloadData];
         [self localArray];

    } failure:^(AFHTTPRequestOperation *operation, id error) {

    }];
}
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveAction
{
    DSProfileTableViewController *profile = [[DSProfileTableViewController alloc]init];
    profile.placeHolderArray = profileDetailsArray;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)localArray
{
    sectionArray =[[NSArray alloc]init];
    sectionArray=sectionNameArray;
    interestArray = [[NSMutableArray alloc] initWithCapacity: 4];
    interestArray =[hobbiesArry mutableCopy];
    NSLog(@"interestArray:%@",interestArray);
   
    if(interstAndHobbiesArray== nil)
    {
    interstAndHobbiesArray = [[NSMutableArray alloc] initWithCapacity: 4];
    interstAndHobbiesArray=[interestArray mutableCopy];
    }
}

-(void)initializeArray{
    UINib *cellNib = [UINib nibWithNibName:@"DSInterestAndHobbiesCollectionViewCell" bundle:nil];
    [self.interestAndHobbiesCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"InterestAndHobbiesCollectionViewCell"];
    
    interestAndHobbiesCollectionView.delegate=self;
    interestAndHobbiesCollectionView.dataSource=self;
    
    imageNormalImageArray =[[NSMutableArray alloc]init];

    interstAndHobbiesArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"SelectedItem"] mutableCopy];

    sectionArray = sectionNameArray;  //[[NSArray alloc]initWithObjects:@"ARTS",@"FOOD",@"PETS",@"RECREATION",nil];

    
    if(interstAndHobbiesArray == nil){
    
         [self loadHobbiesWebserviceMethod];
        
        }
   
    [interestAndHobbiesCollectionView reloadData];
     if (interestArray==nil)
    {
        [self loadHobbiesWebserviceMethod];
    }

   }


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return [interstAndHobbiesArray count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [interstAndHobbiesArray[section] count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader)
    {
        
        UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        if (reusableview==nil) {
            reusableview=[[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, (self.view.frame.size.width), 40)];
        }
        
        for (UIView* view in reusableview.subviews) {
            if ([view isKindOfClass:[UILabel class]]) {
                [view removeFromSuperview];
            }
        }
        
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 26, (self.view.frame.size.width), 10)];
    
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor =[UIColor colorWithRed:(float)231.0/255 green:(float)90.0/255 blue:(float)102.0/255 alpha:1.0f];
        [label setFont:[UIFont fontWithName:@"Patron-Bold" size:9]];

        
        NSString *cellData = [sectionArray objectAtIndex:indexPath.section];
        NSLog(@"headervalue =%@",cellData);
        
        label.text=cellData;
        [reusableview addSubview:label];
        return reusableview;
    }
    return nil;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    NSInteger cellCount = [collectionView.dataSource collectionView:collectionView numberOfItemsInSection:section];
    if( cellCount < 3 )
    {
        CGFloat cellWidth = ((UICollectionViewFlowLayout*)collectionViewLayout).itemSize.width+((UICollectionViewFlowLayout*)collectionViewLayout).minimumInteritemSpacing;
        CGFloat totalCellWidth = cellWidth*cellCount;
        CGFloat contentWidth = collectionView.frame.size.width-collectionView.contentInset.left-collectionView.contentInset.right;
        if( totalCellWidth<contentWidth )
        {
            CGFloat padding = (contentWidth - totalCellWidth) / 2.0;
            return UIEdgeInsetsMake(0, padding, 0, padding);
        }
    }
    if( cellCount > 5 )
    {
        CGFloat cellWidth = ((UICollectionViewFlowLayout*)collectionViewLayout).itemSize.width+((UICollectionViewFlowLayout*)collectionViewLayout).minimumInteritemSpacing;
        CGFloat totalCellWidth = cellWidth*cellCount;
        CGFloat contentWidth = collectionView.frame.size.width-collectionView.contentInset.left-collectionView.contentInset.right;
        if( totalCellWidth>contentWidth )
        {
            CGFloat padding = (totalCellWidth - contentWidth) / 8.0;
            return UIEdgeInsetsMake(0, padding, 0, padding);
           
        }
        
    }
    
    return UIEdgeInsetsZero;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DSInterestAndHobbiesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"InterestAndHobbiesCollectionViewCell" forIndexPath:indexPath];
    
        [cell.nameLabel setText:[[[interstAndHobbiesArray valueForKey:@"name"]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]];
        NSString *image =[[[interstAndHobbiesArray valueForKey:@"image"]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    
        image= [image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
        [cell.interestAndHobbiesImageView setImageWithURL:[NSURL URLWithString:image]];
    

    return cell;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat collectionCellWidth;
    CGFloat finalWidthWithPadding;
    if ( indexPath.section ==1 ) {
        
        if(IS_IPHONE6_Plus)
        {
        int numberOfCellInRow = 6;
        int padding = 1;
        collectionCellWidth =  [[UIScreen mainScreen] bounds].size.width/numberOfCellInRow;
        finalWidthWithPadding = collectionCellWidth - (padding);
        return CGSizeMake(finalWidthWithPadding , finalWidthWithPadding);
        }
         else if(IS_IPHONE6)
        {
            int numberOfCellInRow = 5;
            int padding = 1;
            collectionCellWidth =  [[UIScreen mainScreen] bounds].size.width/numberOfCellInRow;
            finalWidthWithPadding = collectionCellWidth - (padding);
            return CGSizeMake(finalWidthWithPadding , finalWidthWithPadding);

        }
        
             else if(IS_IPHONE5)
        {
            int numberOfCellInRow = 6.5;
            int padding = 1;
            collectionCellWidth =  [[UIScreen mainScreen] bounds].size.width/numberOfCellInRow;
            finalWidthWithPadding = collectionCellWidth - (padding);
            return CGSizeMake(finalWidthWithPadding , finalWidthWithPadding);
            
        }

    }
    
      if (indexPath.section == 0 || indexPath.section ==3 )
      {
          
          if(IS_IPHONE6_Plus)
          {
              int numberOfCellInRow = 6;
              int padding = 1;
              collectionCellWidth =  [[UIScreen mainScreen] bounds].size.width/numberOfCellInRow;
              finalWidthWithPadding = collectionCellWidth - (padding);
              return CGSizeMake(finalWidthWithPadding , finalWidthWithPadding);
          }
          else if(IS_IPHONE6)
          {
              int numberOfCellInRow = 6;
              int padding = 1;
              collectionCellWidth =  [[UIScreen mainScreen] bounds].size.width/numberOfCellInRow;
              finalWidthWithPadding = collectionCellWidth - (padding);
              return CGSizeMake(finalWidthWithPadding , finalWidthWithPadding);
              
          }
          else if(IS_IPHONE5)
          {
              int numberOfCellInRow = 6;
              int padding = 2;
              collectionCellWidth =  [[UIScreen mainScreen] bounds].size.width/numberOfCellInRow;
              finalWidthWithPadding = collectionCellWidth - (padding);
              return CGSizeMake(finalWidthWithPadding , finalWidthWithPadding);
              
          }

          
      }

    
    if (indexPath.section ==2) {
        
        if(IS_IPHONE6_Plus)
        {
            int numberOfCellInRow =8;
            int padding = 1;
            collectionCellWidth =  [[UIScreen mainScreen] bounds].size.width/numberOfCellInRow;
            finalWidthWithPadding = collectionCellWidth - (padding);
            return CGSizeMake(finalWidthWithPadding , finalWidthWithPadding);
        }
        else if(IS_IPHONE6)

        {
            int numberOfCellInRow = 7;
            int padding = 1;
            collectionCellWidth =  [[UIScreen mainScreen] bounds].size.width/numberOfCellInRow;
            finalWidthWithPadding = collectionCellWidth - (padding);
            return CGSizeMake(finalWidthWithPadding , finalWidthWithPadding);
        }
        else if(IS_IPHONE5)
        {
            int numberOfCellInRow = 6;
            int padding = 1;
            collectionCellWidth =  [[UIScreen mainScreen] bounds].size.width/numberOfCellInRow;
            finalWidthWithPadding = collectionCellWidth - (padding);
            return CGSizeMake(finalWidthWithPadding , finalWidthWithPadding);
            
        }
        

    }
    return CGSizeMake(finalWidthWithPadding , finalWidthWithPadding);

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 25.0;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

{
    
    NSLog(@"interstAndHobbiesArray:%@",interstAndHobbiesArray);
    
    DSInterestAndHobbiesCollectionViewCell *dataselCell = (DSInterestAndHobbiesCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    
    
    NSString *imageActive =[[[interstAndHobbiesArray valueForKey:@"image_active"]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    
    NSString *imageNormal =[[[interstAndHobbiesArray valueForKey:@"image"]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    
    NSString *name =[[[interstAndHobbiesArray valueForKey:@"name"]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    
    NSString *categoryID =[[[interstAndHobbiesArray valueForKey:@"hobbies_id"]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    
    if (imageActive != imageNormal) {
        
        [imageNormalImageArray addObject:imageNormal];
        
        [hobbiesNameArray addObject:name];
        
        [hobbiesCategoryID addObject:categoryID]
        ;
        [[NSUserDefaults standardUserDefaults] setObject:imageNormalImageArray forKey:@"SelectedItemNormal"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        imageActive= [imageActive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dataselCell.interestAndHobbiesImageView setImageWithURL:[NSURL URLWithString:imageActive]];
        
    
        NSMutableArray *tempselectedSection = [[interstAndHobbiesArray objectAtIndex:indexPath.section] mutableCopy];
        
        NSMutableDictionary *tempselectedDict = [[tempselectedSection objectAtIndex:indexPath.row] mutableCopy];
        
        [tempselectedDict setObject:imageActive forKey:@"image"];
        
       
        [tempselectedSection replaceObjectAtIndex:indexPath.row withObject:tempselectedDict];
        
        [interstAndHobbiesArray replaceObjectAtIndex:indexPath.section withObject:tempselectedSection];
        
        
        dataselCell.nameLabel.textColor=[UIColor colorWithRed:(224.0f/255) green:(62.0f/255) blue:(79.0f/255) alpha:1.0f];
        
        
        [[NSUserDefaults standardUserDefaults] setObject:hobbiesNameArray forKey:@"SelectedItemName"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults]setObject:hobbiesCategoryID forKey:@"SelectedItemCategoryID"];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        NSMutableArray *tempselectedSection1 = [[interstAndHobbiesArray objectAtIndex:indexPath.section] mutableCopy];
        
        NSMutableDictionary *tempselectedDict1 = [[tempselectedSection1 objectAtIndex:indexPath.row] mutableCopy];
        
        [tempselectedDict1 setObject:name forKey:@"name"];
        
        [tempselectedSection1 replaceObjectAtIndex:indexPath.row withObject:tempselectedDict1];
        
        [interstAndHobbiesArray replaceObjectAtIndex:indexPath.section withObject:tempselectedSection1];
        
        
        
        dataselCell.nameLabel.textColor=[UIColor colorWithRed:(224.0f/255) green:(62.0f/255) blue:(79.0f/255) alpha:1.0f];
        
        [[NSUserDefaults standardUserDefaults] setObject:interstAndHobbiesArray forKey:@"SelectedItem"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    }
    
    
    
    if (imageActive == imageNormal) {
        
        NSString *image =[[[interestArray valueForKey:@"image"]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        
        NSString *name =[[[interstAndHobbiesArray valueForKey:@"name"]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        
        NSString *categoryID =[[[interstAndHobbiesArray valueForKey:@"hobbies_id"]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        
        [imageNormalImageArray removeObject:image];
        
        [hobbiesNameArray removeObject:name];
        
        [hobbiesCategoryID removeObject:categoryID];
        
        NSMutableArray *tempselectedSection1 = [[interstAndHobbiesArray objectAtIndex:indexPath.section] mutableCopy];
        
        NSMutableDictionary *tempselectedDict1 = [[tempselectedSection1 objectAtIndex:indexPath.row] mutableCopy];
        
        [tempselectedDict1 setObject:name forKey:@"name"];
        
        [tempselectedSection1 replaceObjectAtIndex:indexPath.row withObject:tempselectedDict1];
        
        [interstAndHobbiesArray replaceObjectAtIndex:indexPath.section withObject:tempselectedSection1];
        
        
        
        [[NSUserDefaults standardUserDefaults] setObject:hobbiesNameArray forKey:@"SelectedItemName"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults]setObject:hobbiesCategoryID forKey:@"SelectedItemCategoryID"];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        imageActive= [imageActive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dataselCell.interestAndHobbiesImageView setImageWithURL:[NSURL URLWithString:image]];
        
        NSMutableArray *tempselectedSection = [[interstAndHobbiesArray objectAtIndex:indexPath.section] mutableCopy];
        
        NSMutableDictionary *tempselectedDict = [[tempselectedSection objectAtIndex:indexPath.row] mutableCopy];
        
        [tempselectedDict setObject:image forKey:@"image"];
        
        
        [tempselectedSection replaceObjectAtIndex:indexPath.row withObject:tempselectedDict];
        
        [interstAndHobbiesArray replaceObjectAtIndex:indexPath.section withObject:tempselectedSection];
        
        [[NSUserDefaults standardUserDefaults] setObject:imageNormalImageArray forKey:@"SelectedItemNormal"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        
        dataselCell.nameLabel.textColor=[UIColor colorWithRed:(135.0f/255) green:(135.0f/255) blue:(135.0f/255) alpha:1.0f];
        
        [[NSUserDefaults standardUserDefaults] setObject:interstAndHobbiesArray forKey:@"SelectedItem"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    
        
    }
    

    }
    

@end
