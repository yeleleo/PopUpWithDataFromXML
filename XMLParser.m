//
//  XMLParser.m
//  XML Parser SDK
//
//  Created by Vladimir Pronin on 2/27/12.
//  Copyright (c) 2012 YELELEO. All rights reserved.
//

#import "XMLParser.h"

@implementation XMLParser
@synthesize delegate;
@synthesize recordedData;
@synthesize customDataConnection;
@synthesize customData;
@synthesize dictPath;

#pragma mark - XMLParser Delegate

- (void)parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict 
{
    
    NSLog(@"ATRR Dictionary %@",attributeDict);
    
	if([elementName isEqualToString:@"Project"]) 
    {		
        
        //save attributes to Documents
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"recordedData"];
        
        [attributeDict writeToFile:filePath atomically:YES];
        if (attributeDict) {
            [self checkForNewInfo:attributeDict];
        }
	}
    
}
#pragma mark - Methods

-(void)downloadCustomData {
   
    static NSString *fileURLString = @"http://YOURLINK/yourfile.xml";  //paste link to TestFile.xml file on your server
    
    NSURLRequest *dataURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:fileURLString]];
    self.customDataConnection = [[[NSURLConnection alloc] initWithRequest:dataURLRequest delegate:self] autorelease];
    
    NSAssert(self.customDataConnection != nil, @"Failure to create URL connection.");
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                                   selector:@selector(parseOperation) 
                                                      name:@"customDataLoaded" object:nil];
}

-(void)checkForNewInfo: (NSDictionary *)newDictionary {
    //Create internal NSDictionary
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                         NSUserDomainMask, YES);
    if ([paths count] > 0)
    {
        // Path to save dictionary
        dictPath = [[paths objectAtIndex:0] 
                    stringByAppendingPathComponent:@"dict.out"];
        
        recordedData = [NSDictionary dictionaryWithContentsOfFile:dictPath];
    }
    
    
    if (![[recordedData objectForKey:@"version"] isEqual:[newDictionary objectForKey:@"version"]]) {
        
        [self.delegate parserDetectNewDataToShow:newDictionary];
    }
    
        
        // Write dictionary
        [newDictionary writeToFile:dictPath atomically:YES];
        
    }


-(void)parseOperation {
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:customData];
    [xmlParser setDelegate:self];
    [xmlParser parse];
    [xmlParser release];
}


#pragma mark - NSURLConnection Delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // check for HTTP status code for proxy authentication failures
    // anything in the 200 to 299 range is considered successful,
    // also make sure the MIMEType is correct:
    //
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ((([httpResponse statusCode]/100) == 2)) {
        self.customData = [NSMutableData data];
        NSLog(@"Connection is just fine.");
    } 
    else 
    {
        NSLog(@"Error");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [customData appendData:data];
    NSLog(@"didReceiveData:%@",customData);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"customDataLoaded" object:nil];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;   
    if ([error code] == kCFURLErrorNotConnectedToInternet) {
        // if we can identify the error, we can present a more precise message to the user.
        self.customDataConnection = nil;
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.customDataConnection = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.customData = nil;
}



-(void)dealloc {
    [dictPath release];
    [customData release];
    [customDataConnection release];
    [recordedData release];
}

@end