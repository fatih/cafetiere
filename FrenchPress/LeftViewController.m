#import "LeftViewController.h"
#import "IIViewDeckController.h"
#import "FrenchpressViewController.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>



@implementation LeftViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.methods = [[NSMutableArray array] init];
    
    [[self methods] addObject:@"French Press"];
    [[self methods] addObject:@"AeroPress"];
    
    NSIndexPath* index = [NSIndexPath indexPathForRow:self.methods.count-1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    self.tableView.scrollsToTop = YES;
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundView = nil;
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundPSD.png"]]];
    [self.tableView setSeparatorColor:[UIColor colorWithWhite:1.0 alpha:0.2]];
    self.tableView.sectionIndexColor = [UIColor whiteColor];
    [self addHeaderAndFooter]; // To clear other separators

}

- (void) addHeaderAndFooter
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    v.backgroundColor = [UIColor clearColor];
    [self.tableView setTableHeaderView:v];
    [self.tableView setTableFooterView:v];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self methods] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Brew methods"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 25.0)];
    UIView* customView = [[UIView alloc] init];
    
    // create the button object
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor colorWithRed:180.0/255.0
                                          green:23.0/255.0
                                           blue:2.0/255.0
                                          alpha:0.6];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.textAlignment = UITextAlignmentCenter;
    headerLabel.highlightedTextColor = [UIColor whiteColor];
//    headerLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20];
    headerLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:23];
    headerLabel.shadowColor = [UIColor blackColor];
    headerLabel.shadowOffset = CGSizeMake(-1, 0);
    
    
    headerLabel.frame = CGRectMake(0.0, 0.0, 320.0, 44.0);
    headerLabel.text = @"Brew methods";
    [customView addSubview:headerLabel];
    
    return customView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:20];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
//    cell.imageView.image = [UIImage imageNamed: [NSString stringWithFormat:@"icon%d.png",indexPath.row]];

    cell.textLabel.text = [self.methods objectAtIndex:indexPath.row];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        if ([controller.centerController isKindOfClass:[UINavigationController class]]) {
            UITableViewController* cc = (UITableViewController*)((UINavigationController*)controller.centerController).topViewController;
            cc.navigationItem.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
            
            FrenchpressViewController *ff = (FrenchpressViewController *)((UINavigationController*)controller.centerController).topViewController;
            BrewMethod brewMethod;
            
            [ff selectBrewMethod:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
            brewMethod = [ff getBrewMethod];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            BOOL enabled = [defaults boolForKey:kStartAtLaunch];

            if (enabled) {
                [ff startCoffee];
            } else {
                [ff cleanForNewStart];
                
//                switch (brewMethod) {
//                    case FrenchPress:
//                        {
//                            ff.infoLabel.text = @"Put grounds into the pot";
//                            ff.coffeeImageView.image = [UIImage imageNamed:@"animBegin25"];
//                            CATransition *animation = [CATransition animation];
//                            [animation setDuration:1.0];
//                            [animation setType:kCATransitionPush];
//                            [animation setSubtype:kCATransitionFromBottom];
//                            [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//                            [[ff.coffeeImageView layer] addAnimation:animation forKey:@"SlideOutandInImagekCup"];
//                            
//                        }
//                        break;
//                    case AeroPress:
//                        {
//                            ff.infoLabel.text = @"Put grounds into chamber";
//                            ff.coffeeImageView.image = [UIImage imageNamed:@"aeroPressChamber.png"];
//                            CATransition *animation = [CATransition animation];
//                            [animation setDuration:1.0];
//                            [animation setType:kCATransitionPush];
//                            [animation setSubtype:kCATransitionFromBottom];
//                            [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//                            [[ff.coffeeImageView layer] addAnimation:animation forKey:@"SlideOutandInImagekCup"];
//                        }
//                        break;
//                    default:
//                        break;
//                }
            }
            
            if ([cc respondsToSelector:@selector(tableView)]) {
                [cc.tableView deselectRowAtIndexPath:[cc.tableView indexPathForSelectedRow] animated:NO];    
            }
        }
        [NSThread sleepForTimeInterval:(300+arc4random()%700)/1000000.0]; // mimic delay... not really necessary
    }];
}

@end
