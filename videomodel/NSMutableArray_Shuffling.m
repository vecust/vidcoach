//
//  NSMutableArray_Shuffling.m
//  videomodel
//
//  Created by Erick Custodio on 10/20/12.
//
//

#import "NSMutableArray_Shuffling.h"

@implementation NSMutableArray (Shuffling)

- (void)shuffle
{
    for (uint i = 0; i < self.count; ++i)
    {
        // Select a random element between i and end of array to swap with.
        int nElements = self.count - i;
        int n = arc4random_uniform(nElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

@end
