//
//  CategoryViewController.m
//  videomodel
//
//  Created by Erick Custodio on 11/29/12.
//
//

#import "CategoryViewController.h"
#import "SubCategoryViewController.h"
#import "SettingsViewController.h"

@interface CategoryViewController ()

@end

@implementation CategoryViewController
@synthesize categoryList;

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
    categoryList = [NSMutableArray arrayWithObjects:@"Work",@"Home",@"School", nil];
    
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
//    if (section == 0) {
//        return [categoryList count];
//    } else if (section == 1) {
//        return 1;
//    }
//    return 0;
    return [categoryList count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    switch (section) {
//        case 0:
//            return @"Categories";
//            break;
//        case 1:
//            return @"";
//            break;
//        default:
//            break;
//    }
//    return nil;
    return @"Categories";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CategoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [self.categoryList objectAtIndex:indexPath.row];
//    if (indexPath.section == 0) {
//        cell.textLabel.text = [self.categoryList objectAtIndex:indexPath.row];
//    } else if (indexPath.section == 1) {
//        cell.textLabel.text = @"Settings";
//    }
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
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    if ([cell.textLabel.text isEqualToString:@"Settings"]) {
//        [self performSegueWithIdentifier:@"ShowSettings" sender:self];
//    } else if (indexPath.section == 0) {
//        [self performSegueWithIdentifier:@"ShowSubCategory" sender:self];
//    }
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(IBAction)done:(UIStoryboardSegue *)segue {
    if ([[segue identifier] isEqualToString:@"SaveSettings"]) {
        NSLog(@"Saving Settings");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if ([identifier isEqualToString:@"ShowSubCategory"] && [[categoryList objectAtIndex:indexPath.row] isEqualToString:@"Work"]) {
        return YES;
    } else {
        UIAlertView *comingSoon = [[UIAlertView alloc]initWithTitle:@"Coming Soon!" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [comingSoon show];
        return NO;
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if ([segue.identifier isEqualToString:@"ShowSubCategory"] && [[categoryList objectAtIndex:indexPath.row] isEqualToString:@"Work"]) {
            SubCategoryViewController *subCategoryViewController = segue.destinationViewController;
            subCategoryViewController.title = [categoryList objectAtIndex:indexPath.row];

    } else {

    }
}

@end
