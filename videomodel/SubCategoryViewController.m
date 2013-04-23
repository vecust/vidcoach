//
//  SubCategoryViewController.m
//  videomodel
//
//  Created by Erick Custodio on 11/30/12.
//
//

#import "SubCategoryViewController.h"
#import "ActionViewController.h"

@interface SubCategoryViewController ()

@end

@implementation SubCategoryViewController

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

    //Call function to get subcategories of category
    [self getSubCategories:_category];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getSubCategories:(NSString *)category {
    //TODO: Make query to DB to get subCategories
    
    //Hard Code for testing
    _subCategoryList = [[NSMutableArray alloc]initWithObjects:@"General",@"Retail with Experience",@"Retail without Experience",@"Food Service",@"Healthcare",@"Hospitality", nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_subCategoryList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SubCategoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [_subCategoryList objectAtIndex:indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Interviews";
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

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
//    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//    if ([identifier isEqualToString:@"ShowActions"] && [[_subCategoryList objectAtIndex:indexPath.row] isEqualToString:@"General"]) {
//        return YES;
//    } else {
//        UIAlertView *comingSoon = [[UIAlertView alloc]initWithTitle:@"Coming Soon!" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [comingSoon show];
//        return NO;
//    }
    return YES;
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if ([segue.identifier isEqualToString:@"ShowActions"] && [[_subCategoryList objectAtIndex:indexPath.row] isEqualToString:@"General"]) {
        ActionViewController *actionViewController = segue.destinationViewController;
        actionViewController.title = [_subCategoryList objectAtIndex:indexPath.row];
        actionViewController.subCategory = @"GeneralInterview";//[_subCategoryList objectAtIndex:indexPath.row];
    }
    else if ([segue.identifier isEqualToString:@"ShowActions"] && [[_subCategoryList objectAtIndex:indexPath.row] isEqualToString:@"Retail with Experience"]){
        ActionViewController *actionViewController = segue.destinationViewController;
        actionViewController.title = [_subCategoryList objectAtIndex:indexPath.row];
        actionViewController.subCategory = @"RetailwExp";//[_subCategoryList objectAtIndex:indexPath.row];

    }
    else if ([segue.identifier isEqualToString:@"ShowActions"] && [[_subCategoryList objectAtIndex:indexPath.row] isEqualToString:@"Retail without Experience"]){
        ActionViewController *actionViewController = segue.destinationViewController;
        actionViewController.title = [_subCategoryList objectAtIndex:indexPath.row];
        actionViewController.subCategory = @"RetailwoExp";//[_subCategoryList objectAtIndex:indexPath.row];

    }
    else if ([segue.identifier isEqualToString:@"ShowActions"] && [[_subCategoryList objectAtIndex:indexPath.row] isEqualToString:@"Food Service"]){
        ActionViewController *actionViewController = segue.destinationViewController;
        actionViewController.title = [_subCategoryList objectAtIndex:indexPath.row];
        actionViewController.subCategory = @"FoodService";//[_subCategoryList objectAtIndex:indexPath.row];

        
    }
    else if ([segue.identifier isEqualToString:@"ShowActions"] && [[_subCategoryList objectAtIndex:indexPath.row] isEqualToString:@"Healthcare"]){
        ActionViewController *actionViewController = segue.destinationViewController;
        actionViewController.title = [_subCategoryList objectAtIndex:indexPath.row];
        actionViewController.subCategory = @"Healthcare";//[_subCategoryList objectAtIndex:indexPath.row];

    }
    else if ([segue.identifier isEqualToString:@"ShowActions"] && [[_subCategoryList objectAtIndex:indexPath.row] isEqualToString:@"Hospitality"]){
        ActionViewController *actionViewController = segue.destinationViewController;
        actionViewController.title = [_subCategoryList objectAtIndex:indexPath.row];
        actionViewController.subCategory = @"Hospitality";//[_subCategoryList objectAtIndex:indexPath.row];
        
    }
}


@end
