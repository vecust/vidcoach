//
//  SegmentViewController.m
//  videomodel
//
//  Created by Erick Custodio on 11/30/12.
//
//

#import "SegmentViewController.h"
#import "AVQueuePlayerViewController.h"

@interface SegmentViewController ()

@end

@implementation SegmentViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //Call function to get segments from subCategory
    [self getSegments:_subCategory];
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)getSegments:(NSString *)subCategoryParam {
    //TODO: Implement code to query DB and get segments. Add names of segments to segmentList
    
    segmentsDictionary = [[NSMutableDictionary alloc]init];
    NSString *docsDir;
    NSArray *dirPaths;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    NSString *databasePath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:@"TestDatabase.sqlite"]];
    
    const char* dbPath = [databasePath UTF8String];
    
    sqlite3_stmt *statementForSegments;
    
    if(sqlite3_open(dbPath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT SegmentOrder, DisplayName FROM Segment WHERE CallId = 0 AND SubcategoryId = \"%@\"", subCategoryParam];
        
        const char *query_stmt = [querySQL UTF8String];
        NSLog(@"DATABASE IS OPEN");
        
        if(sqlite3_prepare_v2(contactDB, query_stmt, -1, &statementForSegments, NULL) == SQLITE_OK)
        {
            NSLog(@"STATEMENT FOR INST VIDEOS IS OK");
            while(sqlite3_step(statementForSegments) == SQLITE_ROW)
            {
                NSInteger segmentOrder =  sqlite3_column_int(statementForSegments, 0);
                NSString *segmentName = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statementForSegments, 1)];
          
                //Add objects to the dictionary
                [segmentsDictionary setObject:[NSNumber numberWithInteger:segmentOrder] forKey:segmentName];
                
            }
            
        }
        else
        {
            NSLog(@"CAN'T FIND ANYTHING");
        }
        //This prints out the contents of the segmentDictionary
        for (id key in segmentsDictionary) {
            
            //NSLog(@"A+R::key: %@, value: %@", key, [segmentQuestionDictionary objectForKey:key]);
            
        }
        sqlite3_finalize(statementForSegments);
        
        //TODO: segmentDictionary initWithObjects:instVideoNames forKeys:instVideoOrders;
    }
    _segmentList = [NSMutableArray arrayWithArray:[segmentsDictionary keysSortedByValueUsingSelector:@selector(compare:)]];

    
    //Hard code for testing
    //_segmentList = [[NSMutableArray alloc]initWithObjects:@"Greeting",@"Question 1: Resume",@"Question 2: About Me",@"Question 3: Strengths",@"Question 4: Work Experience",@"Question 5: Company Interest",@"Question 6: Availability",@"End of Interview", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return [_segmentList count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SegmentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    
    // Configure the cell...
    if (indexPath.section == 0) {
        if ([_action isEqualToString:@"practice"]) {
            cell.textLabel.text = @"Practice All";
        } else  {
            cell.textLabel.text = @"Watch All";
        }
    } else if (indexPath.section == 1) {
        cell.textLabel.text = [_segmentList objectAtIndex:indexPath.row];
    }

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if ([segue.identifier isEqualToString:@"ShowQueuePlayer"]) {
        AVQueuePlayerViewController *avQueuePlayerViewController = segue.destinationViewController;
        //TODO: Undo subCategory hard code
        //_subCategory = [_subCategory stringByReplacingOccurrencesOfString:@" " withString:@""];
        //NSLog(@":%@",_subCategory);
        avQueuePlayerViewController.subCategory = _subCategory;
        //avQueuePlayerViewController.subCategory = @"general Interview";
        if (indexPath.section == 1) {
            NSLog(@"Selected Segment");
            avQueuePlayerViewController.segmentSelected = TRUE;
            avQueuePlayerViewController.segmentIndex = indexPath.row;
        }
        if ([_action isEqualToString:@"watchModel"]) {
            avQueuePlayerViewController.isWatchingModel = TRUE;
            avQueuePlayerViewController.isPracticing = FALSE;
            avQueuePlayerViewController.isWatchingMe = FALSE;
        } else if ([_action isEqualToString:@"practice"]) {
            avQueuePlayerViewController.isWatchingModel = FALSE;
            avQueuePlayerViewController.isPracticing = TRUE;
            avQueuePlayerViewController.isWatchingMe = FALSE;
        } else if ([_action isEqualToString:@"watchPractice"]) {
            avQueuePlayerViewController.isWatchingModel = FALSE;
            avQueuePlayerViewController.isPracticing = FALSE;
            avQueuePlayerViewController.isWatchingMe = TRUE;
        }
    }
}


@end
