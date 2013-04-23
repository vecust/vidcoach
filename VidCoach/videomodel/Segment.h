//
//  Segment.h
//  videomodel
//
//  Created by Rachel Rose Ulgado on 10/31/12.
//
//

#import <Foundation/Foundation.h>

@interface Segment : NSObject
{
    NSString *name, *filepath;
    int *id, *userId, *categoryId, *subcategoryId, *segmentOrder, *prepromptId, *postpromptId, *numberViews, *callId;
    NSDate *created,*updated,*deleted;
}

@property (nonatomic) NSDate *created,*updated,*deleted;
@property (nonatomic) int *id, *userId, *categoryId, *subcategoryId, *segmentOrder, *prepromptId, *postpromptId, *numberViews, *callId;
@property (nonatomic) NSString *name, *filepath; 

@end
