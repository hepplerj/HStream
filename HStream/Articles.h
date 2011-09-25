//
//  Articles.h
//  HStream
//
//  Created by Jason Heppler on 9/25/11.
//  Copyright 2011 University of Nebraska-Lincoln. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const EMRXMLDownloadCompleteNotification;

@interface Articles : NSObject {
    NSMutableArray *articleArray;
    NSMutableArray *feedData;
    NSSet *tags;
    
    NSMutableDictionary *currentArticle;
    NSString *currentElementName;
    NSString *currentText;
}
@property (nonatomic, retain) NSMutableArray *articleArray;

- (NSUInteger) count;
- (NSMutableArray *) articleAtIndex:(NSUInteger) index;

@end
