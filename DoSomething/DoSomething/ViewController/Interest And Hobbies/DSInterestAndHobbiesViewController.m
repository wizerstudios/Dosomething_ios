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
    
    NSMutableArray *interstAndHobbiesArray,*interestArray;
    NSMutableArray *sectionArray;
    NSMutableArray *imageNormalImageArray,*hobbiesNameArray;
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
    flowLayout.headerReferenceSize = CGSizeMake(self.interestAndHobbiesCollectionView.bounds.size.width, 48);
    [self.interestAndHobbiesCollectionView setCollectionViewLayout:flowLayout];
//    UINib *cellNib = [UINib nibWithNibName:@"DSInterestAndHobbiesCollectionViewCell" bundle:nil];
//    [self.interestAndHobbiesCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"InterestAndHobbiesCollectionViewCell"];
//    
//    interestAndHobbiesCollectionView.delegate=self;
//    interestAndHobbiesCollectionView.dataSource=self;
    
    
    // interstAndHobbiesArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"SelectedItem"] mutableCopy];
    [self initializeArray];
    //[self localArray];
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden=NO;
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self.navigationController.navigationBar setTranslucent:YES];
    imageNormalImageArray =[[[NSUserDefaults standardUserDefaults] valueForKey:@"SelectedItemNormal"]mutableCopy];
    hobbiesNameArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"SelectedItemName"]mutableCopy];
    
    if (!hobbiesNameArray) {
        hobbiesNameArray = [[NSMutableArray alloc] init];
    }
    if (!imageNormalImageArray) {
        imageNormalImageArray = [[NSMutableArray alloc] init];
    }

    CustomNavigationView *customNavigation;
    customNavigation = [[CustomNavigationView alloc] initWithNibName:@"CustomNavigationView" bundle:nil];
    customNavigation.view.frame = CGRectMake(0,-20, (self.view.frame.size.width), 65);
    if (IS_IPHONE5 ){
        self.layoutConstraintCollectionviewYPos.constant =35;
        self.layoutConstraintTapLabelYPos.constant = 4;
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
        interstAndHobbiesArray = [[NSMutableArray alloc]init];
         sectionArray=[[NSMutableArray alloc]init];
        
         NSMutableDictionary *loginDict = [[NSMutableDictionary alloc]init];
        NSDictionary *objselectionname=[[NSDictionary alloc]init];
         loginDict = [responseObject valueForKey:@"gethobbies"];
        objselectionname =[loginDict valueForKey:@"list"];
         sectionArray  = [objselectionname valueForKey:@"name"];
         interstAndHobbiesArray=[objselectionname valueForKey:@"hobbieslist"];
         
         NSLog(@"responsesectionArray:%@",interstAndHobbiesArray);
         
         
         [COMMON removeLoading];
        [interestAndHobbiesCollectionView reloadData];
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
    sectionArray = [[NSArray alloc]initWithObjects:@"ARTS",@"FOOD",@"PETS",@"RECREATION",nil];
    
    interestArray = [[NSMutableArray alloc] initWithCapacity: 4];

[interestArray insertObject:[[NSMutableArray alloc]initWithObjects:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"guitar.png",@"imageNormal",@"guitar_active.png",@"imageActive",@"GUITAR",@"name", nil],
                                      [NSMutableDictionary dictionaryWithObjectsAndKeys:@"paint.png",@"imageNormal",@"paint_active.png",@"imageActive",@"PAINTING",@"name", nil],
                             
                                      [NSMutableDictionary dictionaryWithObjectsAndKeys:@"photography.png",@"imageNormal",@"photography_active.png",@"imageActive",@"PHOTOGRAPHY",@"name", nil],
                                      [NSMutableDictionary dictionaryWithObjectsAndKeys:@"piano.png",@"imageNormal",@"piano_active.png",@"imageActive",@"PIANO",@"name", nil],
                                      [NSMutableDictionary dictionaryWithObjectsAndKeys:@"violin.png",@"imageNormal",@"violin_active.png",@"imageActive",@"VIOLIN",@"name", nil]
                                      ,nil]atIndex:0];
[interestArray insertObject:[[NSMutableArray alloc]initWithObjects:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"bbq.png",@"imageNormal",@"bbq_active.png",@"imageActive",@"BBQ",@"name", nil],
                                      [NSMutableDictionary dictionaryWithObjectsAndKeys:@"cooking.png",@"imageNormal",@"cooking_active.png",@"imageActive",@"COOKING",@"name", nil],
                                      [NSMutableDictionary dictionaryWithObjectsAndKeys:@"fastfood.png",@"imageNormal",@"fastfood_active.png",@"imageActive",@"FASTFOOD",@"name", nil],
                                      [NSMutableDictionary dictionaryWithObjectsAndKeys:@"italianfood.png",@"imageNormal",@"italianfood_active.png",@"imageActive",@"ITALIANFOOD",@"name", nil],
                                      [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"imageNormal",@"",@"imageActive",@"",@"name", nil],
                                      [NSMutableDictionary dictionaryWithObjectsAndKeys:@"japanesefood.png",@"imageNormal",@"japanesefood_active.png",@"imageActive",@"JAPANESEFOOD",@"name", nil],
                                      [NSMutableDictionary dictionaryWithObjectsAndKeys:@"food.png",@"imageNormal",@"food_active.png",@"imageActive",@"KOREANFOOD",@"name", nil]
                                      
                                      ,nil]atIndex:1];
[interestArray insertObject:[[NSMutableArray alloc]initWithObjects:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"cat.png",@"imageNormal",@"cat_active.png",@"imageActive",@"CAT",@"name", nil],
                                      [NSMutableDictionary dictionaryWithObjectsAndKeys:@"dog.png",@"imageNormal",@"dog_active.png",@"imageActive",@"DOG",@"name", nil],
                                      nil]atIndex:2];
[interestArray insertObject:[[NSMutableArray alloc]initWithObjects:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Boardgames.png",@"imageNormal",@"Boardgames_active.png",@"imageActive",@"BOARDGAMES",@"name", nil],
                                      [NSMutableDictionary dictionaryWithObjectsAndKeys:@"fishing.png",@"imageNormal",@"fishing_active.png",@"imageActive",@"FISHING",@"name", nil],
                                      [NSMutableDictionary dictionaryWithObjectsAndKeys:@"game.png",@"imageNormal",@"game_active.png",@"imageActive",@"GAMING",@"name", nil],
                                      [NSMutableDictionary dictionaryWithObjectsAndKeys:@"gardening.png",@"imageNormal",@"gardening_active.png",@"imageActive",@"GARDENING",@"name", nil],
                                      [NSMutableDictionary dictionaryWithObjectsAndKeys:@"finance.png",@"imageNormal",@"finance_active.png",@"imageActive",@"FINANCE",@"name", nil]
                                      
                                      ,nil]atIndex:3];
}

-(void)initializeArray{
    UINib *cellNib = [UINib nibWithNibName:@"DSInterestAndHobbiesCollectionViewCell" bundle:nil];
    [self.interestAndHobbiesCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"InterestAndHobbiesCollectionViewCell"];
    
    interestAndHobbiesCollectionView.delegate=self;
    interestAndHobbiesCollectionView.dataSource=self;
    
    imageNormalImageArray =[[NSMutableArray alloc]init];

    interstAndHobbiesArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"SelectedItem"] mutableCopy];
     //interstAndHobbiesArray =[[[NSUserDefaults standardUserDefaults] valueForKey:@"SelectedItemNormal"]mutableCopy];
    //sectionArray = [[NSArray alloc]initWithObjects:@"ARTS",@"FOOD",@"PETS",@"RECREATION",nil];

    
    if(interstAndHobbiesArray == nil){
    
    [self loadHobbiesWebserviceMethod];
    
//    interstAndHobbiesArray = [[NSMutableArray alloc] initWithCapacity: 4];
//    
//
       
        
//    [interstAndHobbiesArray insertObject:[[NSMutableArray alloc]initWithObjects:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"guitar.png",@"imageNormal",@"guitar_active.png",@"imageActive",@"GUITAR",@"name", nil],
//                                          [NSMutableDictionary dictionaryWithObjectsAndKeys:@"paint.png",@"imageNormal",@"paint_active.png",@"imageActive",@"PAINTING",@"name", nil],
//
//                                          [NSMutableDictionary dictionaryWithObjectsAndKeys:@"photography.png",@"imageNormal",@"photography_active.png",@"imageActive",@"PHOTOGRAPHY",@"name", nil],
//                             [NSMutableDictionary dictionaryWithObjectsAndKeys:@"piano.png",@"imageNormal",@"piano_active.png",@"imageActive",@"PIANO",@"name", nil],
//                                          [NSMutableDictionary dictionaryWithObjectsAndKeys:@"violin.png",@"imageNormal",@"violin_active.png",@"imageActive",@"VIOLIN",@"name", nil]
//                            ,nil]atIndex:0];
//    [interstAndHobbiesArray insertObject:[[NSMutableArray alloc]initWithObjects:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"bbq.png",@"imageNormal",@"bbq_active.png",@"imageActive",@"BBQ",@"name", nil],
//                                          [NSMutableDictionary dictionaryWithObjectsAndKeys:@"cooking.png",@"imageNormal",@"cooking_active.png",@"imageActive",@"COOKING",@"name", nil],
//                                          [NSMutableDictionary dictionaryWithObjectsAndKeys:@"fastfood.png",@"imageNormal",@"fastfood_active.png",@"imageActive",@"FASTFOOD",@"name", nil],
//                                          [NSMutableDictionary dictionaryWithObjectsAndKeys:@"italianfood.png",@"imageNormal",@"italianfood_active.png",@"imageActive",@"ITALIANFOOD",@"name", nil],
//                                          [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"imageNormal",@"",@"imageActive",@"",@"name", nil],
//                                          [NSMutableDictionary dictionaryWithObjectsAndKeys:@"japanesefood.png",@"imageNormal",@"japanesefood_active.png",@"imageActive",@"JAPANESEFOOD",@"name", nil],
//                                          [NSMutableDictionary dictionaryWithObjectsAndKeys:@"food.png",@"imageNormal",@"food_active.png",@"imageActive",@"KOREANFOOD",@"name", nil]
//
//                                          ,nil]atIndex:1];
//    [interstAndHobbiesArray insertObject:[[NSMutableArray alloc]initWithObjects:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"cat.png",@"imageNormal",@"cat_active.png",@"imageActive",@"CAT",@"name", nil],
//                                          [NSMutableDictionary dictionaryWithObjectsAndKeys:@"dog.png",@"imageNormal",@"dog_active.png",@"imageActive",@"DOG",@"name", nil],
//                                          nil]atIndex:2];
//    [interstAndHobbiesArray insertObject:[[NSMutableArray alloc]initWithObjects:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Boardgames.png",@"imageNormal",@"Boardgames_active.png",@"imageActive",@"BOARDGAMES",@"name", nil],
//                                          [NSMutableDictionary dictionaryWithObjectsAndKeys:@"fishing.png",@"imageNormal",@"fishing_active.png",@"imageActive",@"FISHING",@"name", nil],
//                                          [NSMutableDictionary dictionaryWithObjectsAndKeys:@"game.png",@"imageNormal",@"game_active.png",@"imageActive",@"GAMING",@"name", nil],
//                                          [NSMutableDictionary dictionaryWithObjectsAndKeys:@"gardening.png",@"imageNormal",@"gardening_active.png",@"imageActive",@"GARDENING",@"name", nil],
//                                          [NSMutableDictionary dictionaryWithObjectsAndKeys:@"finance.png",@"imageNormal",@"finance_active.png",@"imageActive",@"FINANCE",@"name", nil]
//
//                                          ,nil]atIndex:3];
    }
    //[interestAndHobbiesCollectionView reloadData];
    
    
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
        int numberOfCellInRow = 5;
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
            int numberOfCellInRow = 6;
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
            int numberOfCellInRow = 8;
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
    //iscollectiviewreload=YES;
    

    
    DSInterestAndHobbiesCollectionViewCell *dataselCell = (DSInterestAndHobbiesCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];    

    NSString *imageActive =[[[interstAndHobbiesArray valueForKey:@"image_active"]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    NSString *imageNormal =[[[interstAndHobbiesArray valueForKey:@"image"]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    NSString *name =[[[interstAndHobbiesArray valueForKey:@"name"]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    NSString * hobbies =[[[interstAndHobbiesArray valueForKey:@"hobbies_id"]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
   
    
    if (imageNormalImageArray.count == 0)                //(imageActive != imageNormal)
    {
        if (imageActive != imageNormal)
        {
        [imageNormalImageArray addObject:imageNormal];
        [hobbiesNameArray addObject:name];
        
       
        imageActive= [imageActive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [dataselCell.interestAndHobbiesImageView setImageWithURL:[NSURL URLWithString:imageActive]];
         NSMutableArray *tempselectedSection = [[interstAndHobbiesArray objectAtIndex:indexPath.section] mutableCopy];
         NSMutableDictionary *tempselectedDict = [[tempselectedSection objectAtIndex:indexPath.row] mutableCopy];
        [tempselectedDict setObject:imageActive forKey:@"image"];
        [imageNormalImageArray addObject:[tempselectedDict valueForKey:@"image_active"]];
        [[NSUserDefaults standardUserDefaults] setObject:imageNormalImageArray forKey:@"SelectedItemNormal"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //[tempselectedSection replaceObjectAtIndex:indexPath.row withObject:tempselectedDict];
        //[interstAndHobbiesArray[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:tempselectedSection];
         dataselCell.nameLabel.textColor=[UIColor colorWithRed:(float)224.0/255 green:(float)62.0/255 blue:(float)79.0/255 alpha:1.0f];
        
        
        
        [[NSUserDefaults standardUserDefaults] setObject:hobbiesNameArray forKey:@"SelectedItemName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
         NSMutableArray *tempselectedSection1 = [[interstAndHobbiesArray objectAtIndex:indexPath.section] mutableCopy];
         NSMutableDictionary *tempselectedDict1 = [[tempselectedSection1 objectAtIndex:indexPath.row] mutableCopy];
        [tempselectedDict1 setObject:name forKey:@"name"];
        //[tempselectedSection1 replaceObjectAtIndex:indexPath.row withObject:tempselectedDict1];
        //[interstAndHobbiesArray replaceObjectAtIndex:indexPath.section withObject:tempselectedSection1];
        
         dataselCell.nameLabel.textColor=[UIColor colorWithRed:(float)224.0/255 green:(float)62.0/255 blue:(float)79.0/255 alpha:1.0f];
        [[NSUserDefaults standardUserDefaults] setObject:interstAndHobbiesArray forKey:@"SelectedItem"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        
    }
   else
    {
       
        NSArray *selectArray = [[NSArray alloc]init];
        NSMutableArray *tempselectedSection1 = [[interstAndHobbiesArray objectAtIndex:indexPath.section] mutableCopy];
        NSMutableDictionary *tempselectedDict1 = [[tempselectedSection1 objectAtIndex:indexPath.row] mutableCopy];

        
        selectArray = [imageNormalImageArray copy];
        for(NSString *strDeselect in selectArray)
            
        {
            
            if([tempselectedDict1 valueForKey:@"image_active"] == strDeselect)
                
            {
                
                [imageNormalImageArray removeObject:strDeselect];
                [tempselectedDict1 setObject:name forKey:@"name"];
                [[NSUserDefaults standardUserDefaults] setObject:hobbiesNameArray forKey:@"SelectedItemName"];
                [[NSUserDefaults standardUserDefaults] synchronize];

                dataselCell.nameLabel.textColor = [UIColor colorWithRed:(164/255.0f) green:(164/255.0f) blue:(164/255.0f) alpha:1.0f];
                
                NSString * objstr = [NSString stringWithFormat:@"%@",[tempselectedDict1 valueForKey:@"image"]];
                objstr= [objstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [dataselCell.interestAndHobbiesImageView setImageWithURL:[NSURL URLWithString:objstr]];
               // [[NSUserDefaults standardUserDefaults] setObject:imageNormalImageArray forKey:@"SelectedItemNormal"];
                 //[[NSUserDefaults standardUserDefaults] synchronize];
                
            }
            else if ([tempselectedDict1 valueForKey:@"image_active"] != strDeselect) {
                
                imageActive= [imageActive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [dataselCell.interestAndHobbiesImageView setImageWithURL:[NSURL URLWithString:imageActive]];
                NSMutableArray *tempselectedSection = [[interstAndHobbiesArray objectAtIndex:indexPath.section] mutableCopy];
                NSMutableDictionary *tempselectedDict = [[tempselectedSection objectAtIndex:indexPath.row] mutableCopy];
               // [tempselectedDict setObject:imageActive forKey:@"image"];
                [imageNormalImageArray addObject:[tempselectedDict valueForKey:@"image_active"]];
                [[NSUserDefaults standardUserDefaults] setObject:imageNormalImageArray forKey:@"SelectedItemNormal"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                // [tempselectedSection replaceObjectAtIndex:indexPath.row withObject:tempselectedDict];
                //[interstAndHobbiesArray replaceObjectAtIndex:indexPath.section withObject:tempselectedSection];
                dataselCell.nameLabel.textColor=[UIColor colorWithRed:(float)224.0/255 green:(float)62.0/255 blue:(float)79.0/255 alpha:1.0f];
                
                
                
                [[NSUserDefaults standardUserDefaults] setObject:hobbiesNameArray forKey:@"SelectedItemName"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSMutableArray *tempselectedSection1 = [[interstAndHobbiesArray objectAtIndex:indexPath.section] mutableCopy];
                NSMutableDictionary *tempselectedDict1 = [[tempselectedSection1 objectAtIndex:indexPath.row] mutableCopy];
                [tempselectedDict1 setObject:name forKey:@"name"];
                //[tempselectedSection1 replaceObjectAtIndex:indexPath.row withObject:tempselectedDict1];
                //[interstAndHobbiesArray replaceObjectAtIndex:indexPath.section withObject:tempselectedSection1];
                
                dataselCell.nameLabel.textColor=[UIColor colorWithRed:(float)224.0/255 green:(float)62.0/255 blue:(float)79.0/255 alpha:1.0f];
//                NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
//              [userDefaults setObject:interstAndHobbiesArray forKey:@"SelectedItem"];
                //[[NSUserDefaults standardUserDefaults] synchronize];
                // NSLog(@"userdefault:%@",userDefaults);
               }

            
            
        }

    }
    
   
    
    
    
//     if (imageActive == imageNormal) {
//     NSString *image =[[[interestArray valueForKey:@"image"]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
//     NSString *name =[[[interstAndHobbiesArray valueForKey:@"name"]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
//
//     [imageNormalImageArray removeObject:image];
//     [hobbiesNameArray removeObject:name];
//         
//         
//         
//         
//         
//         NSMutableArray *tempselectedSection1 = [[interstAndHobbiesArray objectAtIndex:indexPath.section] mutableCopy];
//         NSMutableDictionary *tempselectedDict1 = [[tempselectedSection1 objectAtIndex:indexPath.row] mutableCopy];
//         [tempselectedDict1 setObject:name forKey:@"name"];
//         [tempselectedSection1 replaceObjectAtIndex:indexPath.row withObject:tempselectedDict1];
//         [interstAndHobbiesArray replaceObjectAtIndex:indexPath.section withObject:tempselectedSection1];
//
//         [[NSUserDefaults standardUserDefaults] setObject:hobbiesNameArray forKey:@"SelectedItemName"];
//         [[NSUserDefaults standardUserDefaults] synchronize];
//
//         
//         
//         image= [image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//         [dataselCell.interestAndHobbiesImageView setImageWithURL:[NSURL URLWithString:image]];
//    //[dataselCell.interestAndHobbiesImageView setImage:[UIImage imageNamed:image]];
//    NSMutableArray *tempselectedSection = [[interstAndHobbiesArray objectAtIndex:indexPath.section] mutableCopy];
//    NSMutableDictionary *tempselectedDict = [[tempselectedSection objectAtIndex:indexPath.row] mutableCopy];
//    
//   [tempselectedDict setObject:image forKey:@"image"];
//   [tempselectedSection replaceObjectAtIndex:indexPath.row withObject:tempselectedDict];
//   [interstAndHobbiesArray replaceObjectAtIndex:indexPath.section withObject:tempselectedSection];
//   [[NSUserDefaults standardUserDefaults] setObject:imageNormalImageArray forKey:@"SelectedItemNormal"];
//   [[NSUserDefaults standardUserDefaults] synchronize];
//         
//   dataselCell.nameLabel.textColor=[UIColor colorWithRed:(float)135.0/255 green:(float)135.0/255 blue:(float)135.0/255 alpha:1.0f];
//  [[NSUserDefaults standardUserDefaults] setObject:interstAndHobbiesArray forKey:@"SelectedItem"];
//  [[NSUserDefaults standardUserDefaults] synchronize];
    
         
    // }
}


@end
