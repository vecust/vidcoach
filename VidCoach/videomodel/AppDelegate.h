//
//  AppDelegate.h
//  videomodel
//
//  Created by Erick Custodio on 10/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    sqlite3 *contactDB;
    NSString *databasePath;
}
@property (strong, nonatomic) UIWindow *window;


@end
