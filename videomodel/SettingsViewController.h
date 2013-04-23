//
//  SettingsViewController.h
//  videomodel
//
//  Created by Erick Custodio on 11/30/12.
//
//

#import <UIKit/UIKit.h>


@interface SettingsViewController : UIViewController {
}
@property (readwrite,nonatomic) NSMutableArray *settingsList;
@property (readwrite,nonatomic) BOOL prePromptON;
@property (readwrite,nonatomic) BOOL postPromptON;
-(IBAction)prePromptSetting:(id)sender;
-(IBAction)postPromptSetting:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *prePromptSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *postPromptSwitch;
@end
