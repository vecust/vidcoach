//
//  Prompt.m
//  videomodel
//
//  Created by Erick Custodio on 10/20/12.
//
//

#import "Prompt.h"

@implementation Prompt

-(id)copyWithZone:(NSZone *)zone
{
    Prompt *promptCopy = [[Prompt allocWithZone:zone]init];
    
    promptCopy.rightAns = self.rightAns;
    promptCopy.wrongAns = self.wrongAns;
    promptCopy.title = self.title;
    promptCopy.message = self.message;
    promptCopy.cancel = self.cancel;
    promptCopy.button1 = self.button1;
    promptCopy.button2 = self.button2;
    promptCopy.button3 = self.button3;
    promptCopy.answer = self.answer;
    
    
    return promptCopy;
}


@end
