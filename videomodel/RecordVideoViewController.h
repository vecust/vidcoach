//
//  RecordVideoViewController.h
//  videomodel
//
//  Created by Aaron Waterhouse on 11/14/12.
//
//


#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>


@interface RecordVideoViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

- (IBAction)RecordAndPlay:(id)sender;
- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller;
//                                   usingDelegate: (id <UIImagePickerControllerDelegate,
//                                                   UINavigationControllerDelegate>) delegate;
- (void)video: (NSString *) videoPath didFinishSavingWithError: (NSError *) error contextInfo:(void*)contextInfo;
@end
