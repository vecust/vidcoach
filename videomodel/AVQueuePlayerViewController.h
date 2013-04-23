//
//  AVQueuePlayerViewController.h
//  videomodel
//
//  Created by Erick Custodio on 10/13/12.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Prompt.h"
#import <sqlite3.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "SettingsViewController.h"
#import "TSAlertView.h"
#import "GreenCustomAlertView.h"
#import "RedCustomAlertView.h"

@class PlayerView;
@interface AVQueuePlayerViewController : UIViewController <UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
	AVQueuePlayer *mInstQueuePlayer,*mReplyQueuePlayer;
	PlayerView *mPlayerView;
    NSMutableArray *avPlayerItems,*instList,*replyList;
    NSMutableArray *instVideoNames,*replyVideoNames, *recordedVideoNames;
    NSMutableArray *prePromptList,*postPromptList;
    Prompt *testPrompt;
    UIAlertView *prePromptAlert,/*postPromptAlert,*correctAlert,*/*replayAlert, *cantWatchAllAlert;
    TSAlertView *postPromptAlert;
    GreenCustomAlertView *correctAlert;
    RedCustomAlertView *wrongAlert;
    BOOL prePromptSettingIsOn,postPromptSettingIsOn,isWatchingModel,isWatchingMe,isPracticing;
    NSString *correct;
    NSMutableDictionary *segmentQuestionDictionary;
    NSMutableDictionary *segmentAnswerDictionary;
    NSMutableDictionary *segmentRecordedDictionary;
    NSMutableDictionary *prePromptDictionary, *postPromptDictionary;
    
    NSString *databasePath;
    sqlite3 *contactDB;
    
    UIView *overlayView;
    
    
    
}

@property(nonatomic) AVQueuePlayer *instQueuePlayer,*replyQueuePlayer;
@property(nonatomic) IBOutlet PlayerView *playerView;
@property(nonatomic) NSMutableArray *avPlayerItems;
@property(readwrite,nonatomic) BOOL isWatchingModel;
@property(readwrite,nonatomic) BOOL isWatchingMe;
@property(readwrite,nonatomic) BOOL isPracticing;
@property(readwrite,nonatomic) NSString *subCategory;
@property(readwrite,nonatomic) BOOL segmentSelected;
@property(readwrite,nonatomic) NSUInteger segmentIndex;



//this string gets set to what segment is currently being played/viewed
@property(readwrite, nonatomic) NSString *currentSegmentTitle;

//-(IBAction)nextDone:(id)inSender;
-(void)setupQueuePlayer;
-(void)setupQueuePlayerWithPractice;
-(void)setupQueuePlayerWatchRecording;
-(void)getInstVideos;
-(void)getReplyVideos;
-(void)getPracticeVideos;
-(void)getPrePrompts;
-(void)getPostPrompts;
-(void)getPracticeVideoSegment;


//Stuff for record video
- (IBAction)RecordAndPlay:(id)sender;
- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller;
- (void)video: (NSString *) videoPath didFinishSavingWithError: (NSError *) error contextInfo:(void*)contextInfo;
- (void)writeSelfRecordedVideoPathToDatabase: (NSString*) pathToWrite;
- (void)changeCameraDevice:(UIImagePickerController*) currentPicker;
@end
