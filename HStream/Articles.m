//
//  Articles.m
//  HStream
//
//  Created by Jason Heppler on 9/25/11.
//  Copyright 2011 University of Nebraska-Lincoln. All rights reserved.
//

#import "Articles.h"

#define INTERESTING_TAG_NAMES @"item", @"title", @"link", nil

//NSString * const EMRXMLDownloadCompleteNotification = @"EMRXMLDownloadCompleteNotification";

@implementation Articles
@synthesize articleArray;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void) parseArticleXML {
    //NSString *newText = [[NSString alloc] initWithData:feedData encoding:NSUTF8StringEncoding];
    //NSLog(@"Got this data: %@", newText);
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:feedData];
    parser.delegate = self;
    [parser parse];
    [parser release];
}

- (void) parserDidStartDocument:(NSXMLParser *)parser 
{
    currentElementName = nil;
    currentText = nil;
}

- (void) parser: (NSXMLParser *)parser  
    didStartElement:(NSString *)elementName 
    namespaceURI:(NSString *)namespaceURI 
    qualifiedName:(NSString *)qName 
    attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"item"]) {
        [currentArticle release];
        currentArticle = [[NSMutableDictionary alloc] initWithCapacity:[tags count]];
    }
    else if ([elementName isEqualToString:@"link"]) {
        NSString *link = [attributeDict objectForKey:@"href"];
        [currentArticle setValue:link forKey:@"link"];
    }
    else if ([tags containsObject:elementName]) { 
        currentElementName  = elementName;
        currentText = [[NSMutableString alloc] init];
    }
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string 
{
    [currentText appendString:string];
}

- (void) parser:(NSXMLParser *)parser
    didEndElement:(NSString *)elementName 
    namespaceURI:(NSString *)namespaceURI 
    qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:currentElementName]) {
        [currentArticle setValue:currentText forKey:currentElementName];
    }
    else if ([elementName isEqualToString:@"item"]) {
        [articleArray addObject:currentArticle];
        NSLog(@"%@", [currentArticle objectForKey:@"title"]);
    }
    [currentText release], currentText = nil;
    
}

- (void) parserDidEndDocument:(NSXMLParser *)parser 
{
    NSLog(@"End of document");
}

- (void) connectToFeed {
    [feedData release];
    feedData = [[NSMutableData alloc] init];
    NSURL *url = [NSURL URLWithString:@"http://feeds.feedburner.com/DigitalHumanitiesNow?format=xml"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection release];
    [request release];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [feedData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    [self parseArticleXML];
    //NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    //[nc postNotification:EMRXMLDownloadCompleteNotification object:self];
}

- (NSUInteger) count {
    return [articleArray count];
}

- (NSMutableDictionary *)articleAtIndex:(NSUInteger)index {
    return [articleArray objectAtIndex:index];
}

- (void) awakeFromNib {
    articleArray = [[NSMutableArray alloc] init];
    tags = [[NSSet alloc] initWithObjects:INTERESTING_TAG_NAMES, nil];
    [self connectToFeed];
}

- (void) dealloc {
    [articleArray release], articleArray = nil;
    [tags release], tags = nil;
    [feedData release], feedData = nil;
    [currentArticle release], currentArticle = nil;
    [super dealloc];
}

@end
