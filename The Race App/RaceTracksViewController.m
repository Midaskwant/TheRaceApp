//
//  RaceTracksViewController.m
//  The Race App
//
//  Created by Sergey Novitsky on 7/9/11.
//  Copyright 2011 Pawn Company Ltd. All rights reserved.
//

#import "RaceTracksViewController.h"
#import "RaceViewController.h"


@implementation RaceTracksViewController
@synthesize tableView;
@synthesize raceTrackEntries;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
        UITabBarItem* raceTracksItem = [[[UITabBarItem alloc] initWithTitle:@"Tracks" 
                                                                      image:nil 
                                                                        tag:0] autorelease];
        
        self.tabBarItem = raceTracksItem;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
#pragma mark - instance methods
-(void)getTracksFromAPI{
    [api getTracks];
}
#pragma mark - api delegate
-(void)gotResponse:(NSArray *)_arr{
    tracks = [_arr retain];
    
    //TODO RELOAD TABLE VIEW AND FEED IT WITH ABOVE DATA :>
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    UIView* ownView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    ownView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    ownView.clipsToBounds = YES;
    
    self.view = ownView;
}

-(void)makeHardcodedTracks
{
    NSMutableArray* raceTrackArray = [NSMutableArray arrayWithCapacity:5];

    for (int i = 0; i < 20; ++i)
    {
        NSMutableDictionary* trackDictionary = [[NSMutableDictionary alloc] initWithCapacity:5];
        [trackDictionary setObject:[NSString stringWithFormat:@"Test Track %d", i] forKey:@"trackName"];
        [raceTrackArray addObject:trackDictionary];
        [trackDictionary release];
    }
    
    self.raceTrackEntries = raceTrackArray;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Race Tracks";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.tabBarItem = self.tabBarItem;
    
    tableView = [[UITableView alloc] initWithFrame:self.view.bounds 
                                             style:UITableViewStylePlain];
    
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    tableView.clipsToBounds = YES;
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
#warning "Implement getting track data from the server!"
    
    // Hardcoded for now - testing.
    [self makeHardcodedTracks];
    
    
    //api
    api = [[RaceApi alloc] init];
    [api setDelegate:self];
    [self getTracksFromAPI];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
    tableView.delegate = nil;
    tableView.dataSource = nil;
    
    self.tableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

-(void)dealloc
{
    if (self.isViewLoaded)
    {
        [self viewDidUnload];
    }

    [raceTrackEntries release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [raceTrackEntries count];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* reuseIdentifier = @"raceTrackCell";
    
    UITableViewCell* cell = [aTableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
    }
    
    cell.textLabel.text = [[raceTrackEntries objectAtIndex:indexPath.row] objectForKey:@"trackName"];
    
    return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [aTableView deselectRowAtIndexPath:indexPath animated:YES];
	MKPointAnnotation *startPointAnnotation = [[[MKPointAnnotation alloc] init] autorelease];
	startPointAnnotation.coordinate = CLLocationCoordinate2DMake(52.376763, 4.922088);
	MKPointAnnotation *checkpointAnnotation = [[[MKPointAnnotation alloc] init] autorelease];
	checkpointAnnotation.coordinate = CLLocationCoordinate2DMake(52.376411, 4.922023);
	MKPointAnnotation *endPointAnnotation = [[[MKPointAnnotation alloc] init] autorelease];
	endPointAnnotation.coordinate = CLLocationCoordinate2DMake(52.376953, 4.922465);
	NSArray *checkpoints = [NSArray arrayWithObjects:
							startPointAnnotation,
							checkpointAnnotation,
							endPointAnnotation, 
							nil];
	
	RaceViewController *raceController = [[[RaceViewController alloc] initWithCheckpoints:checkpoints] autorelease];
	[self.navigationController pushViewController:raceController animated:YES];
}


@end