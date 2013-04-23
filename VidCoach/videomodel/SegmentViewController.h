//
//  SegmentViewController.h
//  videomodel
//
//  Created by Erick Custodio on 11/30/12.
//
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface SegmentViewController : UITableViewController
{
    sqlite3 *contactDB;
    NSMutableDictionary *segmentsDictionary;
}
@property (readwrite,nonatomic) NSString *action;
@property (readwrite,nonatomic) NSString *subCategory;
@property (readwrite,nonatomic) NSMutableArray *segmentList;
-(void)getSegments:(NSString *)subCategory;
@end
