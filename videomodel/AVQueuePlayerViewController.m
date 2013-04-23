//
//  AVQueuePlayerViewController.m
//  videomodel
//
//  Created by Erick Custodio on 10/13/12.
//
//

#import "AVQueuePlayerViewController.h"
#import "PlayerView.h"
#import "Prompt.h"
#import "NSMutableArray_Shuffling.h"

@implementation AVQueuePlayerViewController

@synthesize instQueuePlayer = mInstQueuePlayer;
@synthesize replyQueuePlayer = mReplyQueuePlayer;
@synthesize playerView = mPlayerView;
@synthesize avPlayerItems;

int instIncrementorOrder = 0;
int instIncrementorId = 0;
int statsIncrementor = 0;

UIImagePickerController *cameraUI;
UIButton *startRecordingButton;
UIButton *switchCameraButton;
UIButton *cancelButton;

//NSString *tempPath = @"/var/mobile/Applications/E52A5E15-E4E5-4699-A8AC-3E28A0E62385/Documents/Rachel001.mp4";

/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

//- (void)setPrePrompt:(BOOL)switchIsOn {
//    if (switchIsOn) {
//        prePromptSettingIsOn = TRUE;
//    } else {
//        prePromptSettingIsOn = FALSE;
//    }
//}
//
//- (void)setPostPrompt:(BOOL)switchIsOn {
//    if (switchIsOn) {
//        postPromptSettingIsOn = TRUE;
//    } else {
//        postPromptSettingIsOn = FALSE;
//    }
//}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
	
    [super viewDidLoad];
        
    //Code to observe if the orientation has changed
//    UIDevice *device = [UIDevice currentDevice];
//    [device beginGeneratingDeviceOrientationNotifications];
//    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//    [nc addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:device];
    
    // Settings.plist code.
	// get paths from root direcory
	NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
	// get documents path
	NSString *documentsPath = [paths objectAtIndex:0];
	// get the path to our Data/plist file
	NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Settings.plist"];
	
	// check to see if Data.plist exists in documents
	if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
	{
		// if not in documents, get property list from main bundle
		plistPath = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
	}
	
	// read property list into memory as an NSData object
	NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
	NSString *errorDesc = nil;
	NSPropertyListFormat format;
	// convert static property liost into dictionary object
	NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
	if (!temp)
	{
		NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
	}
	// assign values
	prePromptSettingIsOn = [[temp objectForKey:@"PrePrompt"]boolValue];
	postPromptSettingIsOn = [[temp objectForKey:@"PostPrompt"]boolValue];

    
    //prePromptSettingIsOn = TRUE;
    //postPromptSettingIsOn = TRUE;
    NSLog(prePromptSettingIsOn ? @"VEC: Pre-Prompt ON" : @"VEC: Pre-Prompt OFF");
    NSLog(postPromptSettingIsOn ? @"VEC: Post-Prompt ON" : @"VEC: Post-Prompt OFF");
    
    NSLog([NSString stringWithFormat:@"VEC: subCategory: %@",_subCategory]);
    NSLog(_isWatchingModel ? @"VEC: Watching Model" : @"VEC: Not Watching Model");
    NSLog(_isPracticing ? @"VEC: Practicing" : @"VEC: Not Practicing");
    NSLog(_isWatchingMe ? @"VEC: Watching Practice" : @"VEC: Not Watching Practice");

    //promptSettingIsOn = FALSE;
    //isPracticing = TRUE;
    //_subCategory = @"generalInterview";
    NSLog(@":%@",_subCategory);
    [self getInstVideos:_subCategory];
    
    if (prePromptSettingIsOn)
    {
        [self getPrePrompts:_subCategory];
    }
    
    if (postPromptSettingIsOn)
    {
        [self getPostPrompts:_subCategory];
    }
    
    if(_isWatchingModel)
    {
        NSLog(@"sub: %@", _subCategory);
        [self getReplyVideos:_subCategory];
        [self setupQueuePlayer];
    }
    else if (_isPracticing)
    {
        if(!self.segmentSelected)
        {
            instIncrementorId = 0;
        }
        NSLog(@"instIncrementorId = %d",instIncrementorId);
        [self setupQueuePlayerWithPractice];
        
        //postPromptSettingIsOn = false;
    }
    else if (_isWatchingMe)
    {
        if (_segmentSelected) {
            if([instVideoNames count] != [recordedVideoNames count])
            {
                cantWatchAllAlert = [[UIAlertView alloc] initWithTitle:@"You have not \n practiced this yet." message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [cantWatchAllAlert show];
            }
            else{
                [self getPracticeVideoSegment:_subCategory];
                [self setupQueuePlayerWatchRecording];
            }
            
        }
        else {
            [self getPracticeVideos:_subCategory];
            NSLog(@"instVideoNames = %lu recordedVideoNames = %d",(unsigned long)[instVideoNames count],[recordedVideoNames count]);
                if([instVideoNames count] != [recordedVideoNames count])
                {
                cantWatchAllAlert = [[UIAlertView alloc] initWithTitle:@"Please practice all first." message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [cantWatchAllAlert show];
                
                }
                else{
                    [self setupQueuePlayerWatchRecording];
                }
            
        }
        
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    //NSLog(@"Popping AVQueuePlayerViewController!");
    if ([self.instQueuePlayer rate] != 0.0) {
        [self.instQueuePlayer pause];
    } else if ([self.replyQueuePlayer rate] != 0.0) {
        [self.replyQueuePlayer pause];
    }

}

//-(IBAction)nextDone:(id)inSender
//{
//	[self.queuePlayer advanceToNextItem];
//	
//	NSInteger remainingItems = [[self.queuePlayer items] count];
//	
//	if (remainingItems < 1)
//	{
//		[inSender setEnabled:NO];
//	}
//}

-(void)getInstVideos:(NSString*)subCategoryParam{
    //this code gets the instruction video names from the database and put them in the array named instVideoNames
    //also creates an NSMutableDictionary to pair key=name, value=order for making sure the videos play in order with the answer videos. 
    
    //TODO: Adjust this function to query DB based on subCategory variable
    

    //Erick's initial hardcoded Sample Instruction Videos
    //instVideoNames = [[NSMutableArray alloc]initWithObjects:@"question1take3",@"question2take2",@"question3take1", nil];

    //Instruction video names array
    instVideoNames = [[NSMutableArray alloc]init];
    
    //NSMutableDictionary of key=name value=order
    segmentQuestionDictionary = [[NSMutableDictionary alloc]init];
    
    //NSMutableDictionary of key=name value=order
    segmentAnswerDictionary = [[NSMutableDictionary alloc]init];
    
    //asda
    segmentRecordedDictionary = [[NSMutableDictionary alloc]init];
   
    NSString *docsDir;
    NSArray *dirPaths;
    
    //to get the documents directory:
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    databasePath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:@"TestDatabase.sqlite"]];
    
    NSLog(@"Getting instruction videos");
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if(sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        //NSLog(@"%s", dbpath);
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT SegmentOrder, Name FROM Segment WHERE CallId = 0 AND SubcategoryId = \"%@\"", subCategoryParam];
        
        const char *query_stmt = [querySQL UTF8String];
        NSLog(@"DATABASE IS OPEN");
       
        if(sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            NSLog(@"STATEMENT FOR INST VIDEOS IS OK");
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                NSInteger segmentOrder =  sqlite3_column_int(statement, 0);
                NSString *segmentName = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                //[instVideoNames addObject: segmentName];
                //[instVideoOrders addObject: [NSNumber numberWithInt:segmentOrder]];
                
                //Add objects to the dictionary
                [segmentQuestionDictionary setObject:[NSNumber numberWithInteger:segmentOrder] forKey:segmentName];
                
                //NSLog(@"Segment name: %@", segmentName);
                //NSLog(@"Segment Order: %i", segmentOrder);
            }
           
        }
        else
        {
            NSLog(@"CAN'T FIND ANYTHING");
        }
        //This prints out the contents of the segmentDictionary
        for (id key in segmentQuestionDictionary) {
            
            //NSLog(@"A+R::key: %@, value: %@", key, [segmentQuestionDictionary objectForKey:key]);
            
        }
    sqlite3_finalize(statement);
        
        //TODO: segmentDictionary initWithObjects:instVideoNames forKeys:instVideoOrders;
    }
    instVideoNames = [NSMutableArray arrayWithArray:[segmentQuestionDictionary keysSortedByValueUsingSelector:@selector(compare:)]];
    
    if (_segmentSelected) {
        NSString *temp = [instVideoNames objectAtIndex:_segmentIndex];
        [instVideoNames removeAllObjects];
        [instVideoNames addObject:temp];
    }
//    for (int i=0; i<[instVideoNames count]; i++)
//    {
//        //NSLog(@"A+R::Sorted Question(inst) Array test: %@", instVideoNames [i]);
//    }
   
    //sqlite3_close(contactDB); we need to make sure to close the database connection at the end
//  */
}


-(void)getReplyVideos:(NSString*)subCategoryParam{
    //Instruction reply names array
    replyVideoNames = [[NSMutableArray alloc]init];
    
    //TODO: Adjust this function to query DB based on subCategory variable
    
    //Place code here to get the reply video names from the database and put them in the array named replyVideoNames
    //Sample Reply Videos
    //MUTABLE!!!
    NSLog(@"Getting answer videos!");
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statementForAnswers;
    
    if(sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        //NSLog(@"%s", dbpath);
    {
        NSString *querySQLAnswer = [NSString stringWithFormat:@"SELECT SegmentOrder, Name FROM Segment WHERE CallId = 1 AND SubcategoryId = \"%@\"", subCategoryParam];
        const char *query_stmt = [querySQLAnswer UTF8String];
        //NSLog(@"DATABASE IS OPEN");
        //NSLog(@"%s", query_stmt);
        if(sqlite3_prepare_v2(contactDB, query_stmt, -1, &statementForAnswers, NULL) == SQLITE_OK)
        {
            NSLog(@"STATEMENT FOR ANSWER VIDEOS IS OK");
            while(sqlite3_step(statementForAnswers) == SQLITE_ROW)
            {
                NSInteger segmentOrderAnswer =  sqlite3_column_int(statementForAnswers, 0);
                NSString *segmentNameAnswer = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statementForAnswers, 1)];
                //[instVideoNames addObject: segmentName];
                //[instVideoOrders addObject: [NSNumber numberWithInt:segmentOrder]];
                
                //Add objects to the dictionary
                [segmentAnswerDictionary setObject:[NSNumber numberWithInteger:segmentOrderAnswer] forKey:segmentNameAnswer];
                                
                //NSLog(@"Segment name: %@, Segment order: %i", segmentNameAnswer, segmentOrderAnswer);
               
                //[instVideoNames addObject:allMyData];
            }
        }
        else
        {
            NSLog(@"CAN'T FIND ANYTHING");
        }
        //This prints out the contents of the segmentDictionary
        for (id key in segmentAnswerDictionary) {
            
            //NSLog(@"A+R2::key: %@, value: %@", key, [segmentAnswerDictionary objectForKey:key]);
            
        }        sqlite3_finalize(statementForAnswers);
        
        //TODO: segmentDictionary initWithObjects:instVideoNames forKeys:instVideoOrders;
    }
    //Using keysSortedByValueUsingSelector on the NSMUTDIC, create an Array sorted in the order of their order #
    replyVideoNames = [NSMutableArray arrayWithArray:[segmentAnswerDictionary keysSortedByValueUsingSelector:@selector(compare:)]];
   
    if (_segmentSelected) {
        NSString *temp = [replyVideoNames objectAtIndex:_segmentIndex];
        [replyVideoNames removeAllObjects];
        [replyVideoNames addObject:temp];
    }

    
    for (int i=0; i<[replyVideoNames count]; i++)
    {
        //NSLog(@"A+R::Sorted Answer Array test: %@", replyVideoNames [i]);
    }
   
    //This will have to be not hardcoded
    //replyVideoNames = [[NSMutableArray alloc]initWithObjects:@"answer1take3",@"answer2take1",@"answer3take1", nil];
}

-(void)getPracticeVideos:(NSString*)subCategoryParam {
    //TODO: Make query to DB to get the practice videos and reuse the replyVideoNames array by populating the practice video names into it. Use subCategory variable.
    
    //Copied and pasted the code from getReplyVideos: (for testing)
    
    //Instruction reply names array
    recordedVideoNames = [[NSMutableArray alloc]init];
    
    
    //Place code here to get the reply video names from the database and put them in the array named replyVideoNames
    //Sample Reply Videos
    //MUTABLE!!!
    NSLog(@"Getting practice videos!");
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statementForRecorded;
    
    if(sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        //NSLog(@"%s", dbpath);
    {
        NSString *querySQLAnswer = [NSString stringWithFormat:@"SELECT SegmentOrder, Name FROM Segment WHERE CallId = 2 AND SubcategoryId = \"%@\"",subCategoryParam];
        const char *query_stmt = [querySQLAnswer UTF8String];
        NSLog(@"DATABASE IS OPEN");
        //NSLog(@"%s", query_stmt);
        if(sqlite3_prepare_v2(contactDB, query_stmt, -1, &statementForRecorded, NULL) == SQLITE_OK)
        {
            NSLog(@"STATEMENT FOR PRACTICE VIDEOS IS OK");
            while(sqlite3_step(statementForRecorded) == SQLITE_ROW)
            {
                NSInteger segmentOrderAnswer =  sqlite3_column_int(statementForRecorded, 0);
                NSString *segmentNameAnswer = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statementForRecorded, 1)];
                //[instVideoNames addObject: segmentName];
                //[instVideoOrders addObject: [NSNumber numberWithInt:segmentOrder]];
                
                //Add objects to the dictionary
                [segmentRecordedDictionary setObject:[NSNumber numberWithInteger:segmentOrderAnswer] forKey:segmentNameAnswer];
                
                NSLog(@"Practice: Segment name: %@, Segment order: %i", segmentNameAnswer, segmentOrderAnswer);
                
                //[instVideoNames addObject:allMyData];
            }
        }
        else
        {
            NSLog(@"CAN'T FIND ANYTHING");
        }
        //This prints out the contents of the segmentDictionary
        for (id key in segmentAnswerDictionary) {
            
            NSLog(@"A+R2:Practice:key: %@, value: %@", key, [segmentAnswerDictionary objectForKey:key]);
            
        }        sqlite3_finalize(statementForRecorded);
        
        //TODO: segmentDictionary initWithObjects:instVideoNames forKeys:instVideoOrders;
    }
    //Using keysSortedByValueUsingSelector on the NSMUTDIC, create an Array sorted in the order of their order #
    recordedVideoNames = [NSMutableArray arrayWithArray:[segmentRecordedDictionary keysSortedByValueUsingSelector:@selector(compare:)]];
    
//    for (int i=0; i<[recordedVideoNames count]; i++)
//    {
//        NSLog(@"A+R:Practice:Sorted Answer Array test: %@", recordedVideoNames [i]);
//    }
}

-(void)getPracticeVideoSegment:(NSString*)subCategoryParam {
    //TODO: Make query to DB to get the practice videos and reuse the replyVideoNames array by populating the practice video names into it. Use subCategory variable.
    
    //Copied and pasted the code from getReplyVideos: (for testing)
    
    //Instruction reply names array
    recordedVideoNames = [[NSMutableArray alloc]init];
    
    
    //Place code here to get the reply video names from the database and put them in the array named replyVideoNames
    //Sample Reply Videos
    //MUTABLE!!!
    NSLog(@"Getting practice videos!");
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statementForRecorded;
    
    if(sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        //NSLog(@"%s", dbpath);
    {
        NSString *querySQLAnswer = [NSString stringWithFormat:@"SELECT SegmentOrder, Name FROM Segment WHERE CallId = 2 AND SubcategoryId = \"%@\"",subCategoryParam];
        const char *query_stmt = [querySQLAnswer UTF8String];
        NSLog(@"DATABASE IS OPEN");
        //NSLog(@"%s", query_stmt);
        if(sqlite3_prepare_v2(contactDB, query_stmt, -1, &statementForRecorded, NULL) == SQLITE_OK)
        {
            NSLog(@"STATEMENT FOR PRACTICE VIDEOS IS OK");
            while(sqlite3_step(statementForRecorded) == SQLITE_ROW)
            {
                NSInteger segmentOrderAnswer =  sqlite3_column_int(statementForRecorded, 0);
                NSString *segmentNameAnswer = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statementForRecorded, 1)];
                //[instVideoNames addObject: segmentName];
                //[instVideoOrders addObject: [NSNumber numberWithInt:segmentOrder]];
                if (segmentOrderAnswer == _segmentIndex) {
                    //Add objects to the dictionary
                    [segmentRecordedDictionary setObject:[NSNumber numberWithInteger:segmentOrderAnswer] forKey:segmentNameAnswer];
                }
                
                NSLog(@"Practice: Segment name: %@, Segment order: %i", segmentNameAnswer, segmentOrderAnswer);
                
                //[instVideoNames addObject:allMyData];
            }
        }
        else
        {
            NSLog(@"CAN'T FIND ANYTHING");
        }
        //This prints out the contents of the segmentDictionary
        for (id key in segmentAnswerDictionary) {
            
            NSLog(@"A+R2:Practice:key: %@, value: %@", key, [segmentAnswerDictionary objectForKey:key]);
            
        }        sqlite3_finalize(statementForRecorded);
        
        //TODO: segmentDictionary initWithObjects:instVideoNames forKeys:instVideoOrders;
    }
    //Using keysSortedByValueUsingSelector on the NSMUTDIC, create an Array sorted in the order of their order #
    recordedVideoNames = [NSMutableArray arrayWithArray:[segmentRecordedDictionary keysSortedByValueUsingSelector:@selector(compare:)]];
    
    //    for (int i=0; i<[recordedVideoNames count]; i++)
    //    {
    //        NSLog(@"A+R:Practice:Sorted Answer Array test: %@", recordedVideoNames [i]);
    //    }
}


-(void)getPrePrompts:(NSString*)subCategoryParam{
    
    prePromptList = [[NSMutableArray alloc]init];
    prePromptDictionary = [[NSMutableDictionary alloc]init];
    
    //TODO: Place code here to get the pre-prompts from the database and put them in the NSMutableArray named prePromptList
    //Use subCategory variable
    
    //Sample Prompt
//    prePromptList = [[NSMutableArray alloc]init];
//    for (int i = 1; i<=[instVideoNames count]; i++) {
//        testPrompt = [[Prompt alloc]init];
//        testPrompt.title = [NSString stringWithFormat:@"Test Instruction %d",i];
//        testPrompt.message = [NSString stringWithFormat:@"Test Intstruction %d",i];
//        [prePromptList addObject:testPrompt];
//   }
    
    NSLog(@"Getting PrePrompts!");
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statementForPrePrompts;
    
    if(sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        //NSLog(@"%s", dbpath);
    {
        //Query statement to get the Preprompts
        NSString *querySQLAnswer = [NSString stringWithFormat:@"SELECT * FROM Prompt WHERE Type = \"Preprompt\" AND SubcategoryId = \"%@\"",subCategoryParam];
        const char *query_stmt = [querySQLAnswer UTF8String];
        //NSLog(@"DATABASE IS OPEN");
        //NSLog(@"%s", query_stmt);
        if(sqlite3_prepare_v2(contactDB, query_stmt, -1, &statementForPrePrompts, NULL) == SQLITE_OK)
        {
            NSLog(@"STATEMENT FOR PREPROMPTS IS OK");
            while(sqlite3_step(statementForPrePrompts) == SQLITE_ROW)
            {
                testPrompt = [[Prompt alloc]init];
                testPrompt.title = @"";
                testPrompt.message = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statementForPrePrompts, 3)];
                NSInteger segmentOrder = sqlite3_column_int(statementForPrePrompts, 14);
                //NSLog(@"%d",sqlite3_column_int(statementForPrePrompts, 14));
                [prePromptDictionary setObject:[NSNumber numberWithInteger:segmentOrder] forKey:testPrompt];
                //[prePromptList addObject: testPrompt];
                NSLog(@"Message!: %@", testPrompt.message);
                
            }
        }
        else
        {
            NSLog(@"CAN'T FIND ANYTHING");
        }
        sqlite3_finalize(statementForPrePrompts);
    }
    
    prePromptList = [NSMutableArray arrayWithArray:[prePromptDictionary keysSortedByValueUsingSelector:@selector(compare:)]];
    
    if (_segmentSelected) {
        Prompt *temp = [prePromptList objectAtIndex:_segmentIndex];
        [prePromptList removeAllObjects];
        [prePromptList addObject:temp];
    }

    
}




-(void)getPostPrompts:(NSString*)subCategoryParam {
    //TODO: Place code here to get the post-prompts from the database and put them in the NSMutableArray named postPromptList
    //Use subCategory variable
    postPromptList = [[NSMutableArray alloc]init];
    postPromptDictionary = [[NSMutableDictionary alloc]init];

    
    NSLog(@"Getting PostPrompts!");
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statementForPostPrompts;
    
    if(sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        //NSLog(@"%s", dbpath);
    {
        //Query statement to get the Preprompts
        NSString *querySQLAnswer = [NSString stringWithFormat:@"SELECT * FROM Prompt WHERE Type = \"Postprompt\" AND SubcategoryId = \"%@\"",subCategoryParam];
        const char *query_stmt = [querySQLAnswer UTF8String];
        //NSLog(@"DATABASE IS OPEN");
        //NSLog(@"%s", query_stmt);
        if(sqlite3_prepare_v2(contactDB, query_stmt, -1, &statementForPostPrompts, NULL) == SQLITE_OK)
        {
            NSLog(@"STATEMENT FOR PREPROMPTS IS OK");
            while(sqlite3_step(statementForPostPrompts) == SQLITE_ROW)
            {
                //maybe alloc this later outside of the while loop
                testPrompt = [[Prompt alloc]init];
            
                //This adds the title
                testPrompt.message = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statementForPostPrompts, 3)];;
                //This adds the answer
                testPrompt.button1 = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statementForPostPrompts, 6)];
                //This adds the otherbuttontitle1
                testPrompt.button2 = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statementForPostPrompts, 5)];
                  //This adds the otherbuttontitle2
                testPrompt.button3 = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statementForPostPrompts, 12)];
                
                NSInteger segmentOrder = sqlite3_column_int(statementForPostPrompts, 14);
                [postPromptDictionary setObject:[NSNumber numberWithInteger:segmentOrder] forKey:testPrompt];
                
                //[postPromptList addObject: testPrompt];
            }
        }
        else
        {
            NSLog(@"CAN'T FIND ANYTHING");
        }
        sqlite3_finalize(statementForPostPrompts);
    }
    
    postPromptList = [NSMutableArray arrayWithArray:[postPromptDictionary keysSortedByValueUsingSelector:@selector(compare:)]];

    
    if (_segmentSelected) {
        Prompt *temp = [postPromptList objectAtIndex:_segmentIndex];
        [postPromptList removeAllObjects];
        [postPromptList addObject:temp];
    }
    
}

-(void)setupQueuePlayer {
    if (prePromptSettingIsOn || postPromptSettingIsOn) {
        instList = [[NSMutableArray alloc]init];
        replyList = [[NSMutableArray alloc]init];
        for (int i = 0; i < [instVideoNames count]; i++) {
            NSString *instVideoPath = [[NSBundle mainBundle]pathForResource:[instVideoNames objectAtIndex:i] ofType:@"mp4"];
            AVPlayerItem *instVideoItem = [[AVPlayerItem alloc]initWithURL:[NSURL fileURLWithPath:instVideoPath]];
            //[avPlayerItems addObject:instVideoItem];
            [instList addObject:instVideoItem];
            
//            if (prePromptSettingIsOn) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instPlayerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:instVideoItem];
//            }
            
            NSString *replyVideoPath = [[NSBundle mainBundle]pathForResource:[replyVideoNames objectAtIndex:i] ofType:@"mp4"];
            AVPlayerItem *replyVideoItem = [[AVPlayerItem alloc]initWithURL:[NSURL fileURLWithPath:replyVideoPath]];
            //[avPlayerItems addObject:replyVideoItem];
            [replyList addObject:replyVideoItem];
            
//            if (postPromptSettingIsOn) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replyPlayerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:replyVideoItem];
//            }
        }
        
        self.instQueuePlayer = [AVQueuePlayer queuePlayerWithItems:instList];
        self.replyQueuePlayer = [AVQueuePlayer queuePlayerWithItems:replyList];
        
        [self.playerView setPlayer:self.instQueuePlayer];
        
        [self.instQueuePlayer play];
        
    } else if (!prePromptSettingIsOn && !postPromptSettingIsOn) {
        avPlayerItems = [[NSMutableArray alloc]init];
        for (int i = 0; i < [instVideoNames count]; i++) {
            NSString *instVideoPath = [[NSBundle mainBundle]pathForResource:[instVideoNames objectAtIndex:i] ofType:@"mp4"];
            AVPlayerItem *instVideoItem = [[AVPlayerItem alloc]initWithURL:[NSURL fileURLWithPath:instVideoPath]];
            [avPlayerItems addObject:instVideoItem];
            
            
            NSString *replyVideoPath = [[NSBundle mainBundle]pathForResource:[replyVideoNames objectAtIndex:i] ofType:@"mp4"];
            AVPlayerItem *replyVideoItem = [[AVPlayerItem alloc]initWithURL:[NSURL fileURLWithPath:replyVideoPath]];
            [avPlayerItems addObject:replyVideoItem];
            
            if (i == ([instVideoNames count]-1)) {
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replyPlayerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:replyVideoItem];

            }
        }
        self.replyQueuePlayer = [AVQueuePlayer queuePlayerWithItems:avPlayerItems];
        [self.playerView setPlayer:self.replyQueuePlayer];
        [self.replyQueuePlayer play];
    }
}

-(void)setupQueuePlayerWithPractice {
//    if (prePromptSettingIsOn) {
//        instList = [[NSMutableArray alloc]init];
//
//        for (int i = 0; i < [instVideoNames count]; i++) {
//            NSString *instVideoPath = [[NSBundle mainBundle]pathForResource:[instVideoNames objectAtIndex:i] ofType:@"mp4"];
//            AVPlayerItem *instVideoItem = [[AVPlayerItem alloc]initWithURL:[NSURL fileURLWithPath:instVideoPath]];
//            //[avPlayerItems addObject:instVideoItem];
//            [instList addObject:instVideoItem];
//            
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instPlayerItemDidReachEndWithPractice:) name:AVPlayerItemDidPlayToEndTimeNotification object:instVideoItem];
//            
//                        
//        }
//        
//        self.instQueuePlayer = [AVQueuePlayer queuePlayerWithItems:instList];
//        self.replyQueuePlayer = [AVQueuePlayer queuePlayerWithItems:replyList];
//        
//        [self.playerView setPlayer:self.instQueuePlayer];
//        
//        [self.instQueuePlayer play];
//    } else if (!prePromptSettingIsOn) {
        instList = [[NSMutableArray alloc]init];
        for (int i = 0; i < [instVideoNames count]; i++) {
            NSString *instVideoPath = [[NSBundle mainBundle]pathForResource:[instVideoNames objectAtIndex:i] ofType:@"mp4"];
            //NSString *instVideoPath = [[NSBundle mainBundle]pathForResource:@"Rachel001" ofType:@"mp4"];
            //NSLog(@"inst path: %@", tempPath);
            AVPlayerItem *instVideoItem = [[AVPlayerItem alloc]initWithURL:[NSURL fileURLWithPath:instVideoPath]];
            [instList addObject:instVideoItem];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instPlayerItemDidReachEndWithPractice:) name:AVPlayerItemDidPlayToEndTimeNotification object:instVideoItem];
                        
//            if (i == ([instVideoNames count]-1)) {
//                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replyPlayerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:replyVideoItem];
//                
//            }
//        }
       
    }
    self.instQueuePlayer = [AVQueuePlayer queuePlayerWithItems:instList];
    [self.playerView setPlayer:self.instQueuePlayer];
    [self.instQueuePlayer play];
}

-(void)setupQueuePlayerWatchRecording {
    if (prePromptSettingIsOn || postPromptSettingIsOn) {
        instList = [[NSMutableArray alloc]init];
        replyList = [[NSMutableArray alloc]init];
        for (int i = 0; i < [recordedVideoNames count]; i++) {
            NSString *instVideoPath = [[NSBundle mainBundle]pathForResource:[instVideoNames objectAtIndex:i] ofType:@"mp4"];
            AVPlayerItem *instVideoItem = [[AVPlayerItem alloc]initWithURL:[NSURL fileURLWithPath:instVideoPath]];
            //[avPlayerItems addObject:instVideoItem];
            [instList addObject:instVideoItem];
            
            //            if (prePromptSettingIsOn) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instPlayerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:instVideoItem];
            //            }
            
            //NSString *replyVideoPath = [[NSBundle mainBundle]pathForResource:[recordedVideoNames objectAtIndex:i] ofType:@"mp4"];
            AVPlayerItem *replyVideoItem = [[AVPlayerItem alloc]initWithURL:[NSURL fileURLWithPath:[recordedVideoNames objectAtIndex:i]]];
            //[avPlayerItems addObject:replyVideoItem];
            [replyList addObject:replyVideoItem];
            
            //            if (postPromptSettingIsOn) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replyPlayerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:replyVideoItem];
            //            }
        }
        
        self.instQueuePlayer = [AVQueuePlayer queuePlayerWithItems:instList];
        self.replyQueuePlayer = [AVQueuePlayer queuePlayerWithItems:replyList];
        
        [self.playerView setPlayer:self.instQueuePlayer];
        
        [self.instQueuePlayer play];
        
    } else if (!prePromptSettingIsOn && !postPromptSettingIsOn) {
        avPlayerItems = [[NSMutableArray alloc]init];
        for (int i = 0; i < [recordedVideoNames count]; i++) {
            NSString *instVideoPath = [[NSBundle mainBundle]pathForResource:[instVideoNames objectAtIndex:i] ofType:@"mp4"];
            AVPlayerItem *instVideoItem = [[AVPlayerItem alloc]initWithURL:[NSURL fileURLWithPath:instVideoPath]];
            [avPlayerItems addObject:instVideoItem];
            
            
            //NSString *replyVideoPath = [[NSBundle mainBundle]pathForResource:[recordedVideoNames objectAtIndex:i] ofType:@"mp4"];
            AVPlayerItem *replyVideoItem = [[AVPlayerItem alloc]initWithURL:[NSURL fileURLWithPath:[recordedVideoNames objectAtIndex:i]]];
            
            [avPlayerItems addObject:replyVideoItem];
            
            if (i == ([instVideoNames count]-1)) {
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replyPlayerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:replyVideoItem];
            }
        }
        self.replyQueuePlayer = [AVQueuePlayer queuePlayerWithItems:avPlayerItems];
        [self.playerView setPlayer:self.replyQueuePlayer];
        [self.replyQueuePlayer play];
    }
}

-(void)instPlayerItemDidReachEnd:(NSNotification *)notification {
    //NSLog(@"End of item!");
    
    if (!prePromptSettingIsOn) {
//        self.playerView.hidden = YES;
        [self.instQueuePlayer advanceToNextItem];
        [self.instQueuePlayer pause];
        [self.playerView setPlayer:self.replyQueuePlayer];
//        self.playerView.hidden = NO;
        [self.replyQueuePlayer play];
        
    } else {
        self.playerView.hidden = YES;
        int index = [instList indexOfObject:[self.instQueuePlayer currentItem]];
        [self.instQueuePlayer advanceToNextItem];
        [self.instQueuePlayer pause];
        [self.playerView setPlayer:self.replyQueuePlayer];
//        NSLog(@"This is an instVideoItem");
        testPrompt = prePromptList[index];
        prePromptAlert = [[UIAlertView alloc]initWithTitle:testPrompt.title message:testPrompt.message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        NSLog([NSString stringWithFormat:@"VEC: instList index: %i",index]);
        [prePromptAlert show];
    }
    
    [self writeWatchedVideoStatsToDatabase];
    
AVPlayerItem *currentItem = [self.instQueuePlayer currentItem];
NSArray *metaDataList = [currentItem.asset commonMetadata];

}

-(void)instPlayerItemDidReachEndWithPractice:(NSNotification *)notification {
    //NSLog(@"End of item!");
    [self.navigationController setToolbarHidden:YES];

    if (!prePromptSettingIsOn) {
        if (_isPracticing && [[self.instQueuePlayer items]count] == 0) {
            GreenCustomAlertView *doneRecording = [[GreenCustomAlertView alloc]initWithTitle:@"Good Job!" message:@"Go to Watch Practice to watch yourself" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [doneRecording show];
        }
        self.playerView.hidden = YES;
        [self.instQueuePlayer advanceToNextItem];
        [self.instQueuePlayer pause];
        
        [self startCameraControllerFromViewController:self];
        
    } else {
        self.playerView.hidden = YES;
        int index = [instList indexOfObject:[self.instQueuePlayer currentItem]];
        [self.instQueuePlayer advanceToNextItem];
        [self.instQueuePlayer pause];
        //[self.playerView setPlayer:self.replyQueuePlayer];
        //        NSLog(@"This is an instVideoItem");
        testPrompt = prePromptList[index];
        prePromptAlert = [[UIAlertView alloc]initWithTitle:testPrompt.title message:testPrompt.message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        NSLog([NSString stringWithFormat:@"VEC: instList index: %i",index]);
        [prePromptAlert show];
    }
}

-(void)replyPlayerItemDidReachEnd:(NSNotification *)notification {
    //NSLog(@"End of item!");
    if ([postPromptList count] == 0) { 
//        self.playerView.hidden = YES;
        [self.replyQueuePlayer advanceToNextItem];
        [self.replyQueuePlayer pause];
        NSLog(@"postPromptList count == 0");
        NSLog(@"Number of enqueued items: %i",[[self.replyQueuePlayer items]count]);
        if ([[self.replyQueuePlayer items]count] == 0) {
            replayAlert = [[UIAlertView alloc]initWithTitle:@"Replay Video?" message:nil delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
            [replayAlert show];
        } else {
        [self.playerView setPlayer:self.instQueuePlayer];
//        self.playerView.hidden = NO;
        [self.instQueuePlayer play];
        }
    } else {
        if (postPromptSettingIsOn) {
            self.playerView.hidden = YES;
            int index = [replyList indexOfObject:[self.replyQueuePlayer currentItem]];
            [self.replyQueuePlayer advanceToNextItem];
            [self.replyQueuePlayer pause];
            [self.playerView setPlayer:self.instQueuePlayer];
            NSLog(@"This is a replyVideoItem");
            testPrompt = postPromptList[index];
            correct = testPrompt.button1;
//            postPromptAlert = [[UIAlertView alloc]initWithTitle:testPrompt.title message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            postPromptAlert = [[TSAlertView alloc]initWithTitle:testPrompt.message message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            
            NSMutableArray *testArray = [[NSMutableArray alloc]init];
            if (testPrompt.button3 == (id)[NSNull null] || testPrompt.button3.length == 0) {
                testArray = [[NSMutableArray alloc]initWithObjects:testPrompt.button1,testPrompt.button2,nil];
            } else {
                testArray = [[NSMutableArray alloc]initWithObjects:testPrompt.button1,testPrompt.button2,testPrompt.button3, nil];
            }
            [testArray shuffle];
            for (int i = 0; i<[testArray count]; i++) {
                [postPromptAlert addButtonWithTitle:testArray[i]];
            }
            //    [postPromptAlert addButtonWithTitle:@""];
            //    UIButton *blank = [postPromptAlert.subviews lastObject];
            //    [blank setHidden:YES];
            NSLog([NSString stringWithFormat:@"VEC: replyList index: %i",index]);
            //[self showWithCutCancelButton:postPromptAlert];
            
            [postPromptAlert show];
        } else if (!postPromptSettingIsOn) {
            [self.instQueuePlayer play];
        }
    }
}

//-(void)willPresentAlertView:(UIAlertView *)alertView {
//    if (alertView == postPromptAlert) {
//        if (alertView.cancelButtonIndex == -1 || alertView.numberOfButtons < 2) return;
//        alertView.clipsToBounds = YES; // or else cancel button will still be visible
//        //[alertView show];
//        // Shrink height to leave cancel button outside
//        alertView.bounds = CGRectMake(0, 0, alertView.bounds.size.width, alertView.bounds.size.height - 64);
//        
//    }
//    //TODO: Fix Rotation!!!
//}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if(alertView == prePromptAlert){
        if (_isPracticing) {
            [self startCameraControllerFromViewController:self];
        } else {
        //[self.queuePlayer advanceToNextItem];
        self.playerView.hidden = NO;
        [self.replyQueuePlayer play];
        }
    } else if (alertView == postPromptAlert) {
        if ([title isEqualToString:correct]) {
            NSLog(@"Correct Answer!");
            correctAlert = [[GreenCustomAlertView alloc]initWithTitle:@"Good Job!" message:@"Correct answer!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [correctAlert show];
        } else {
            NSLog(@"Wrong Answer!");
            wrongAlert = [[RedCustomAlertView alloc]initWithTitle:@"Nice Try" message:[NSString stringWithFormat:@"The correct answer is: %@",correct] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [wrongAlert show];

        }
    } else if (alertView == correctAlert || alertView == wrongAlert) {
        NSLog(@"Number of enqueued items: %i",[[self.replyQueuePlayer items]count]);
        if ([[self.replyQueuePlayer items]count] == 0) {
            replayAlert = [[UIAlertView alloc]initWithTitle:@"Replay Video?" message:nil delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
            [replayAlert show];
        }
        self.playerView.hidden = NO;
        [self.instQueuePlayer play];
    } else if (alertView == replayAlert) {
        if ([title isEqualToString:@"YES"]) {
            NSLog(@"Chose to replay!");
            self.playerView.hidden = NO;
            if(_isWatchingMe)
            {
                [self setupQueuePlayerWatchRecording];
            }
            else{
                [self setupQueuePlayer];
            }
        } else {
            [self.navigationController popViewControllerAnimated:YES];
            NSLog(@"Here!");
        }
    } else if (alertView == cantWatchAllAlert) {
        if ([title isEqualToString:@"OK"]) {
        
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
//    if (!postPromptAlert.hidden) {
//        return NO;
//    }
    return YES;
    //(interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)orientationChanged:(NSNotification *)note {
//    NSLog(@"Orientation has changed: %d", [[note object]orientation]);
//    if (!postPromptAlert.hidden && [[note object]orientation] != 5) {
//        postPromptAlert.bounds = CGRectMake(0, 0, postPromptAlert.bounds.size.width, postPromptAlert.bounds.size.height - 64);
//    }
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
    self.instQueuePlayer = nil;
    self.replyQueuePlayer = nil;
}

- (void)writeWatchedVideoStatsToDatabase{
    
    //Stuff for timestamp string
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss--MM-dd-yyyy"];
    NSDate *currentDate = [NSDate date];
    NSString *formattedDate = [formatter stringFromDate:currentDate];
    
    //DB stuff
    NSString *docsDir;
    NSArray *dirPaths;
    
    //to get the documents directory:
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    databasePath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:@"TestDatabase.sqlite"]];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;

        
    NSString *currentSegmentandIndex = [NSString stringWithFormat:@"%@%d", _subCategory, _segmentIndex];
    NSString *currentSegmentandIncrementor = [NSString stringWithFormat:@"%@%d", _subCategory, statsIncrementor];
    NSLog(@"%d",_segmentIndex);

    if(sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        NSLog(@"%s", dbpath);
    {
        NSString *querySQL;
        if(_segmentSelected){
            querySQL = [NSString stringWithFormat:@"INSERT INTO WatchVideosCount (VideoTitle, TimeStamp) VALUES (\"%@\", \"%@\")", currentSegmentandIndex, formattedDate];
            NSLog(@"%@",querySQL);
        }
        else{
            querySQL = [NSString stringWithFormat:@"INSERT INTO WatchVideosCount (VideoTitle, TimeStamp) VALUES (\"%@\", \"%@\")", currentSegmentandIncrementor, formattedDate];
            statsIncrementor++;
        }
        const char *query_stmt = [querySQL UTF8String];
        
        NSLog(@"query: %s", query_stmt);
        NSLog(@"DATABASE IS OPEN");
        
        if(sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            NSLog(@"STATEMENT FOR Video Stats IS OK");
            //            while(sqlite3_step(statement) == SQLITE_ROW)
            //            {
            //                NSInteger segmentOrder =  sqlite3_column_int(statement, 0);
            //                NSString *segmentName = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
            //                //[instVideoNames addObject: segmentName];
            //                //[instVideoOrders addObject: [NSNumber numberWithInt:segmentOrder]];
            //
            //                //Add objects to the dictionary
            //                [segmentQuestionDictionary setObject:[NSNumber numberWithInteger:segmentOrder] forKey:segmentName];
            //
            //                //NSLog(@"Segment name: %@", segmentName);
            //                //NSLog(@"Segment Order: %i", segmentOrder);
            //            }
//            for (int i=0; i<[instVideoNames count]; i++)
//            {
//                //NSLog(@"Array: %@", instVideoNames [i]);
//            }
        }
        else
        {
            NSLog(@"Didn't execute write statement correctly for video watch statistics");
        }
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Its Done!");
        }
        else
        {
            NSLog(@"Failed to update row %s", sqlite3_errmsg(contactDB));
            NSLog(@"Not Done!");
        }
        sqlite3_finalize(statement);

    }
    
}

-(BOOL)checkForVideoWithIdenticalSegmentOrder{
    
    BOOL returnBool = FALSE;
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    //to get the documents directory:
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    databasePath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:@"TestDatabase.sqlite"]];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
     NSString *querySQL;
    
    if(sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        if(_segmentSelected){
            querySQL = [NSString stringWithFormat:@"SELECT * FROM Segment WHERE SegmentOrder = %d AND CallId = 2", _segmentIndex];
        }
        else{
            querySQL = [NSString stringWithFormat:@"SELECT * FROM Segment WHERE SegmentOrder = %d AND CallId = 2", instIncrementorId];

        }
    }
        
        const char *query_stmt = [querySQL UTF8String];
        
        NSLog(@"DATABASE IS OPEN");
        
        if(sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
            returnBool = TRUE;
            }
        }
        else
        {
            NSLog(@"CAN'T FIND ANYTHING");
        }
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Its Done!");
        }
        else
        {
            //NSLog(@"Failed to update row %s", sqlite3_errmsg(contactDB));
            //NSLog(@"Not Done!");
            
        }
        sqlite3_finalize(statement);
    
    return returnBool;
}

- (void)writeSelfRecordedVideoPathToDatabase:(NSString*) pathToWrite {
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    //to get the documents directory:
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    databasePath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:@"TestDatabase.sqlite"]];
    
    NSLog(@"Getting instruction videos");
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    sqlite3_stmt *deleteStatement;
    
    if(sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        NSLog(@"%s", dbpath);
    {
        NSString *deleteSQL;
        if([self checkForVideoWithIdenticalSegmentOrder] == TRUE)
        {
            if(self.segmentSelected)
            {
                deleteSQL = [NSString stringWithFormat:@"DELETE FROM Segment WHERE CallID = 2 AND SegmentOrder = %u", _segmentIndex];
            }
            else
            {
                deleteSQL = [NSString stringWithFormat:@"DELETE FROM Segment WHERE CallID = 2 AND SegmentOrder = %u", instIncrementorId];
            }
            const char *query_stmt2 = [deleteSQL UTF8String];
            if(sqlite3_prepare_v2(contactDB, query_stmt2, -1, &statement, NULL) == SQLITE_OK)
            {
                
            }
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Its Done!");
            }
            else 
            {
                NSLog(@"Failed to update row %s", sqlite3_errmsg(contactDB));
                
                NSLog(@"Not Done!");
                
            }
            sqlite3_finalize(deleteStatement);
        }
        
        
        NSString *querySQL;
        //RU + VC: these insert statements eventually need to be variable dependent upon which subcategoryId is being used.
        if (_segmentSelected) {
            
            querySQL = [NSString stringWithFormat:@"INSERT INTO Segment (Name,UserId,Filepath,CategoryId,SubcategoryId,SegmentOrder,PrepromptId,PostpromptId,NumberViews,CallId,Created,Updated,Deleted) VALUES (\"%@\",0,'',0,\"%@\",\"%d\",0,0,0,2,null,null,null)", pathToWrite, _subCategory ,_segmentIndex];
            NSLog(@"%@",querySQL);
        } else {
        querySQL = [NSString stringWithFormat:@"INSERT INTO Segment (Name,UserId,Filepath,CategoryId,SubcategoryId,SegmentOrder,PrepromptId,PostpromptId,NumberViews,CallId,Created,Updated,Deleted) VALUES (\"%@\",0,'',0,\"%@\",\"%d\",0,0,0,2,null,null,null)", pathToWrite, _subCategory ,instIncrementorId];
             
        }
       
        NSLog(@"NUM:%d",instIncrementorId);

        
        const char *query_stmt = [querySQL UTF8String];
        
//        NSLog(@"query: %s", query_stmt);
        NSLog(@"DATABASE IS OPEN");
        
        if(sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            NSLog(@"STATEMENT FOR INST VIDEOS IS OK");
//            while(sqlite3_step(statement) == SQLITE_ROW)
//            {
//                NSInteger segmentOrder =  sqlite3_column_int(statement, 0);
//                NSString *segmentName = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
//                //[instVideoNames addObject: segmentName];
//                //[instVideoOrders addObject: [NSNumber numberWithInt:segmentOrder]];
//                
//                //Add objects to the dictionary
//                [segmentQuestionDictionary setObject:[NSNumber numberWithInteger:segmentOrder] forKey:segmentName];
//                
//                //NSLog(@"Segment name: %@", segmentName);
//                //NSLog(@"Segment Order: %i", segmentOrder);
//            }
           
        }
        else
        {
            NSLog(@"CAN'T FIND ANYTHING");
        }

        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Its Done!");
        }
        else
        {
            NSLog(@"Failed to update row %s", sqlite3_errmsg(contactDB));
            
            NSLog(@"Not Done!");
            
        }
        sqlite3_finalize(statement);
    }
}

-(void)changeCameraDevice:(UIImagePickerController*)currentPicker{
    currentPicker = cameraUI;
    if(currentPicker.cameraDevice == UIImagePickerControllerCameraDeviceFront)
    {
        currentPicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
    else{
        currentPicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
}
-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [cameraUI dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) startRecordingEffects
{
    [startRecordingButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [startRecordingButton setBackgroundColor:[UIColor blackColor]];
    //startRecordingButton.enabled = NO;
    //switchCameraButton.enabled = NO;
    [switchCameraButton setTitleColor:[UIColor grayColor]forState:UIControlStateNormal];
    //cancelButton.enabled = NO;
    [switchCameraButton setBackgroundColor:[UIColor grayColor]];
    
}



#pragma mark -practice functions
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
    cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.delegate = self;
    
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    // Sets the front facing camera to the default
    cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    // Displays a control that allows the user to choose movie capture
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    // Hides the default button overlays on the camera UI
    cameraUI.showsCameraControls = YES;
    cameraUI.navigationBarHidden = YES;
    cameraUI.toolbarHidden = YES;
    
    //START CUSTOM OVERLAY
//    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
//    
//    startRecordingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    switchCameraButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    
//    [startRecordingButton setFrame:CGRectMake(240, 430, 72, 40)];
//    [startRecordingButton setTitle:@"REC" forState:UIControlStateNormal];
//    [switchCameraButton setFrame:CGRectMake(10, 10, 72, 40)];
//    [switchCameraButton setTitle:@"Switch" forState:UIControlStateNormal];
//    [cancelButton setFrame:CGRectMake(10, 430, 72, 40)];
//    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
//    
//    [startRecordingButton addTarget:cameraUI action:@selector(startVideoCapture) forControlEvents:UIControlEventTouchUpInside];
//    [startRecordingButton addTarget:self action:@selector(startRecordingEffects) forControlEvents:UIControlEventTouchUpInside];
//    [switchCameraButton addTarget:self action:@selector(changeCameraDevice:) forControlEvents:UIControlEventTouchUpInside];
//    [cancelButton addTarget:self action:@selector(imagePickerControllerDidCancel:) forControlEvents:UIControlEventTouchUpInside];
//
//    
//    [customView addSubview:startRecordingButton];
//    [customView addSubview:switchCameraButton];
//    [customView addSubview:cancelButton];
//
//    
//    [cameraUI setCameraOverlayView:customView];    
    
    // 3 - Display image picker
    //[controller presentModalViewController: cameraUI animated: YES];
    [controller presentViewController:cameraUI animated:YES completion:nil];
    return YES;
}




-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //NSLog(@"VEC: didFinishPickingMediaWithInfo!");
    
    NSLog(@"CURRENT: %@", _subCategory);
    
    //Play the next instruction video
    self.playerView.hidden = NO;
    
    //get video URL
    NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
    //NSLog(@"Video URL: %@", videoURL);
    //Instead of NSData have a SQLite statement to write to user
    NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* tempPath;
    if(_segmentSelected){
        tempPath = [documentsDirectory stringByAppendingFormat:@"/%@%d.mp4", _subCategory,_segmentIndex];
    }
    else{
       tempPath = [documentsDirectory stringByAppendingFormat:@"/%@%d.mp4", _subCategory,instIncrementorId];

    }
    
    [self writeSelfRecordedVideoPathToDatabase:tempPath];
    
    
    
    
    //Backup storage of video to the documents folder
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss--MM-dd-yyyy"];
    
    NSDate *currentDate = [NSDate date];
    
    NSString *formattedDate = [formatter stringFromDate:currentDate];
   
    NSString *timeStampandCategoryName;
    if(_segmentSelected){
        timeStampandCategoryName = [documentsDirectory stringByAppendingFormat:@"/%@%d-%@.mp4",_subCategory,_segmentIndex ,formattedDate];
    }
    else{
        timeStampandCategoryName = [documentsDirectory stringByAppendingFormat:@"/%@%d-%@.mp4",_subCategory,instIncrementorId ,formattedDate];
    }
    
    NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
    
    NSString *appendPart = [NSString stringWithFormat:@"/%@.mp4", _currentSegmentTitle];
    
    NSString *appendedString = [bundleRoot stringByAppendingString:appendPart];
    //NSLog(@"movie Path: %@", appendedString);
    NSLog(@"temp Path: %@: ", tempPath);
    
    //If this BOOL is eventually unused we might want to just remove the evaluation of writeToFile to a variable
    //instIncrementorId++;
    instIncrementorOrder++;
    
//    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    spinner.center = CGPointMake(160, 240);
//    spinner.hidesWhenStopped = YES;
//    [self.view addSubview:spinner];
//    [spinner startAnimating];
    
    //dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
    //dispatch_async(downloadQueue, ^{
        
        // do our long running process here
        [videoData writeToFile:tempPath atomically:NO];
        [videoData writeToFile:timeStampandCategoryName atomically:NO];
        
        // do any UI stuff on the main UI thread
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [spinner stopAnimating];
        //});
        
    //});
    
    
    instIncrementorId++;
    
    [self.instQueuePlayer play];
    
    
    //NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    [self dismissModalViewControllerAnimated:NO];
    // Handle a movie capture
//    if (CFStringCompare ((__bridge_retained CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo)
//    {
//        NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
//        
//        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePath))
//        {
//            UISaveVideoAtPathToSavedPhotosAlbum(moviePath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
//        }
//    }
    if ([[self.instQueuePlayer items]count]==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)video:(NSString*)videoPath didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
    if (error) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"
//                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
    } else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"
//                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
        NSLog(@"VEC: video not saved!");
    }
}


@end
