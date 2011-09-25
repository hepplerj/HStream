//
//  RootViewController.h
//  HStream
//
//  Created by Jason Heppler on 9/25/11.
//  Copyright 2011 University of Nebraska-Lincoln. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Articles;
@class DetailViewController;

@interface RootViewController : UITableViewController {
    DetailViewController *detailViewController;
    Articles *articles;
}

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (nonatomic, retain) IBOutlet Articles *articles;

@end
