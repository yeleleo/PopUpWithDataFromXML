//
//  XMLParser.h
//  XML Parser SDK
//
//  Created by Vladimir Pronin on 2/27/12.
//  Copyright (c) 2012 YELELEO. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XMLParser;
@protocol XMLParserDelegate <NSObject>
@optional
// Called by the parser when parsing is finished and we have new data on server.
- (void)parserDetectNewDataToShow:(NSDictionary *)data;
@end


@interface XMLParser : NSObject <NSXMLParserDelegate, UIApplicationDelegate> 

{   
    id <XMLParserDelegate> delegate;
    NSURLConnection *customDataConnection;
    NSMutableData *customData;
}

@property (retain) id <XMLParserDelegate> delegate;
@property (nonatomic, retain) NSDictionary *recordedData;
@property (nonatomic, retain) NSString  *dictPath;
@property (nonatomic, retain) NSURLConnection *customDataConnection;
@property (nonatomic, retain) NSMutableData *customData;

-(void)downloadCustomData;
-(void)checkForNewInfo:(NSDictionary *)newDictionary;
-(void)parseOperation;
@end
