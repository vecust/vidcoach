//
//  NSMutableArray_Shuffling.h
//  videomodel
//
//  Created by Erick Custodio on 10/20/12.
//
//

/** This category enhances NSMutableArray by providing methods to randomly
 * shuffle the elements using the Fisher-Yates algorithm.
 */
@interface NSMutableArray (Shuffling)
- (void)shuffle;
@end
