//
//  SubCategoryViewController.h
//  videomodel
//
//  Created by Erick Custodio on 11/30/12.
//
//

#import <UIKit/UIKit.h>

@interface SubCategoryViewController : UITableViewController
@property (readwrite,nonatomic) NSString *category;
@property (readwrite,nonatomic) NSMutableArray *subCategoryList;

-(void)getSubCategories:(NSString *)category;
@end
