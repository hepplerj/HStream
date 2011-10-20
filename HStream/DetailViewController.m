//
//  DetailViewController.m
//  HStream
//
//  Created by Jason Heppler on 9/25/11.
//  Copyright 2011 University of Nebraska-Lincoln. All rights reserved.
//

#import "DetailViewController.h"

#import "RootViewController.h"

@interface DetailViewController ()
@property (nonatomic, retain) UIPopoverController *popoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize toolbar = _toolbar;
@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize popoverController = _myPopoverController;
@synthesize webView = _webView;

#pragma mark - Managing the detail item

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        [_detailItem release];
        _detailItem = [newDetailItem retain];
        
        // Update the view.
        [self configureView];
    }

    if (self.popoverController != nil) {
        [self.popoverController dismissPopoverAnimated:YES];
    }        
}

- (void) loadSelectedPage {
    NSString *url;
    if (!_detailItem) {
        url = [NSString stringWithFormat:@"http://digitalhistory.unl.edu"];
    }
    else {
        url = [NSString stringWithFormat:@"%@", [_detailItem objectForKey:@"link"]];
        NSLog(@"Load the detail view from URL: %@", url);
    }
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)configureView
{
    // Update the user interface for the detail item.
    //self.detailDescriptionLabel.text = [self.detailItem description];
    
    if (!_detailItem) {
        _detailDescriptionLabel.text = @"HStream";
    }
    else {
        _detailDescriptionLabel.text = [_detailItem objectForKey:@"title"];
    }
    [self loadSelectedPage];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - Split view support

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController: (UIPopoverController *)pc
{
    barButtonItem.title = @"Stream";
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
}

// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
}

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 
 // Looking into how to add a navigation to the bottom
 
 
- (void)viewDidLoad
{
    [super viewDidLoad];
 
    CGFloat width = self.view.frame.size.width;
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:
                               CGRectMake(0,0,width,52)];
    navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:navBar];
    [navBar release];
    
    UILabel *label = [[UILabel alloc] initWithFrame:
                      CGRectMake(10,2,width-20,14)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.text = @"some text for the title...";
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = UITextAlignmentCenter;
    [navBar addSubview:label];
    [label release];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:
                              CGRectMake(10,19,width-80,26)];
    textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize:17];
    [navBar addSubview:textField];
    [textField release];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(width-60,19,50,26)];
    [button setTitle:@"Go" forState:UIControlStateNormal];
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [navBar addSubview:button];
}
*/

- (void)viewDidUnload
{
	[super viewDidUnload];

	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.popoverController = nil;
}

#pragma mark - Memory management

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [_myPopoverController release];
    [_toolbar release];
    [_detailItem release];
    [_detailDescriptionLabel release];
    [super dealloc];
}

@end
