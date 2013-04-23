//
//  RecordVideoViewController.m
//  videomodel
//
//  Created by Aaron Waterhouse on 11/14/12.
//
//

#import "RecordVideoViewController.h"

//@interface RecordVideoViewController ()
//
//@end

@implementation RecordVideoViewController




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
   // [self setRecordVideo:nil];
    [super viewDidUnload];
}

-(void)RecordAndPlay:(id)sender
{
    [self startCameraControllerFromViewController:self];
}

-(BOOL)startCameraControllerFromViewController:(UIViewController*)controller
//                                 usingDelegate:(id )delegate
{
    // 1 - Validattions
//    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
//        || (delegate == nil)
//        || (controller == nil)) {
//        return NO;
//    }
    // 2 - Get image picker
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    // Sets the front facing camera to the default
    cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    // Displays a control that allows the user to choose movie capture
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
   // cameraUI.delegate = delegate;
    // 3 - Display image picker
    [controller presentModalViewController: cameraUI animated: YES];
    return YES;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //get video URL
    NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
    
    //Instead of NSData have a SQLite statement to write to user
    NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *tempPath = [documentsDirectory stringByAppendingFormat:@"/vid1.mp4"];
    
    BOOL success = [videoData writeToFile:tempPath atomically:NO];
    
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    [self dismissModalViewControllerAnimated:NO];
    // Handle a movie capture
    if (CFStringCompare ((__bridge_retained CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo)
    {
        NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePath))
        {
            UISaveVideoAtPathToSavedPhotosAlbum(moviePath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}

-(void)video:(NSString*)videoPath didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}
@end
