//
//  Prompt.h
//  videomodel
//
//  Created by Erick Custodio on 10/20/12.
//
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface Prompt : NSObject <NSCopying> {
    
    sqlite3 *db; //a data member to store a handle to the database.
    Prompt *myPrompt;
    
}
@property (nonatomic) int rightAns,wrongAns;
@property (nonatomic) NSString *type,*title,*message,*cancel,*button1,*button2,*button3,*answer;
@property (nonatomic) NSMutableArray *otherButtonTitles;
@property (nonatomic) NSDate *created,*updated,*deleted;

@end
