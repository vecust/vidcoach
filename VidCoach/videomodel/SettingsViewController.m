//
//  SettingsViewController.m
//  videomodel
//
//  Created by Erick Custodio on 11/30/12.
//
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _settingsList = [[NSMutableArray alloc]initWithObjects:@"Pre-Prompts",@"Post-Prompts", nil];
    
    // Settings.plist code.
	// get paths from root direcory
	NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
	// get documents path
	NSString *documentsPath = [paths objectAtIndex:0];
	// get the path to our Data/plist file
	NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Settings.plist"];
	
	// check to see if Data.plist exists in documents
	if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
	{
		// if not in documents, get property list from main bundle
		plistPath = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
	}
	
	// read property list into memory as an NSData object
	NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
	NSString *errorDesc = nil;
	NSPropertyListFormat format;
	// convert static property liost into dictionary object
	NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
	if (!temp)
	{
		NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
	}
	// assign values
	_prePromptON = [[temp objectForKey:@"PrePrompt"]boolValue];
	_postPromptON = [[temp objectForKey:@"PostPrompt"]boolValue];
    
    if (_prePromptON) {
        [self.prePromptSwitch setOn:YES];
    } else {
        [self.prePromptSwitch setOn:NO];
    }

    if (_postPromptON) {
        [self.postPromptSwitch setOn:YES];
    } else {
        [self.postPromptSwitch setOn:NO];
    }
    
//    _prePromptON = TRUE;
//    _postPromptON = TRUE;
    
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

-(IBAction)prePromptSetting:(id)sender {
    UISwitch *switchControl = sender;
    NSLog(@"VEC: The prePrompt switch is %@",switchControl.on ? @"ON" :@"OFF");
    if (switchControl.on) {
        _prePromptON = TRUE;
    } else {
        _prePromptON = FALSE;
    }
}

-(IBAction)postPromptSetting:(id)sender {
    UISwitch *switchControl = sender;
    NSLog(@"VEC: The postPrompt switch is %@",switchControl.on ? @"ON" :@"OFF");
    if (switchControl.on) {
        _postPromptON = TRUE;
    } else {
        _postPromptON = FALSE;
    }
    
}

/*
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SettingsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [_settingsList objectAtIndex:indexPath.row];
    UISwitch *switchView = [[UISwitch alloc]initWithFrame:CGRectZero];
    cell.accessoryView = switchView;
    [switchView setOn:YES animated:NO];
    [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    return cell;
}

-(void)switchChanged:(id)sender {
    UISwitch *switchControl = sender;
    NSLog(@"VEC: The switch is %@",switchControl.on ? @"ON" :@"OFF");
    NSIndexPath *indexPath =  [self.tableView indexPathForSelectedRow];
    NSLog(@"VEC: setting button: %@",[_settingsList objectAtIndex:indexPath.row]);
    NSString *buttonName = [[NSString alloc]initWithString:[_settingsList objectAtIndex:indexPath.row]];
    if ([buttonName isEqualToString:@"Pre-Prompts"]) {
        if (switchControl.on) {
            [delegate setPrePrompt:TRUE];
        } else {
            [delegate setPrePrompt:FALSE];
        }
    }
    if ([buttonName isEqualToString:@"Post-Prompts"]) {
        if (switchControl.on) {
            [delegate setPostPrompt:TRUE];
        } else {
            [delegate setPostPrompt:FALSE];
        }
    }
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
/*
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
//}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier]isEqualToString:@"SaveSettings"]) {
        //Save settings to settings.plist
        // get paths from root direcory
        NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
        // get documents path
        NSString *documentsPath = [paths objectAtIndex:0];
        // get the path to our Data/plist file
        NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Settings.plist"];
        
        //Create dictionary with setting values
        NSNumber *prePromptNumber = [NSNumber numberWithBool:_prePromptON];
        NSNumber *postPromptNumber = [NSNumber numberWithBool:_postPromptON];
        NSDictionary *plistDict = [NSDictionary dictionaryWithObjectsAndKeys:prePromptNumber,@"PrePrompt",postPromptNumber,@"PostPrompt", nil];
        
        NSString *error = nil;
        // create NSData from dictionary
        NSData *plistSetting = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
        
        // check is plistSetting exists
        if(plistSetting)
        {
            // write plistData to our Setting.plist file
            [plistSetting writeToFile:plistPath atomically:YES];
        }
        else
        {
            NSLog(@"Error in saveData: %@", error);
            //[error release];
        }

    }
}

-(void)viewWillDisappear:(BOOL)animated {
    NSLog(@"Saving Settings");
    //Save settings to settings.plist
    // get paths from root direcory
	NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
	// get documents path
	NSString *documentsPath = [paths objectAtIndex:0];
	// get the path to our Data/plist file
	NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Settings.plist"];
	
    //Create dictionary with setting values
    NSNumber *prePromptNumber = [NSNumber numberWithBool:_prePromptON];
    NSNumber *postPromptNumber = [NSNumber numberWithBool:_postPromptON];
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjectsAndKeys:prePromptNumber,@"PrePrompt",postPromptNumber,@"PostPrompt", nil];
    
	NSString *error = nil;
	// create NSData from dictionary
    NSData *plistSetting = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
	
    // check is plistSetting exists
	if(plistSetting)
	{
		// write plistData to our Setting.plist file
        [plistSetting writeToFile:plistPath atomically:YES];
    }
    else
	{
        NSLog(@"Error in saveData: %@", error);
        //[error release];
    }

}

@end
