XMLParser class check xml file on server, download it, parse xml and present alert view with parameters from xml. If user press “YES” button in alert view, web link will be open in Safari. 

To implement it you must:
1. Copy PopUpWithDataFromXML folder into your project folder.
2. In your RootViewController.h include header: #import "XMLParser.h" 
3. In your RootViewController.h include:
@interface RootViewController : UIViewController <UIAlertViewDelegate,XMLParserDelegate> {
    XMLParser *parser;
NSURL *url;
}
4. In your RootViewController.m include:
#import "InfoViewController.h"

@implementation RootViewController
#pragma mark - Lazily instantiating 
-(XMLParser *)parser {
    if (!parser) {
        parser = [[XMLParser alloc] init];
        parser.delegate = self;
    }
    return parser;
}

- (void)viewDidLoad {
//start downloading and parsing data from server
    [[self parser] downloadCustomData];
}
#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
        
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"NO"])
    {
        NSLog(@"NO");
    }
    else if([title isEqualToString:@"YES"])
    {
        NSLog(@"YES");
        //Or you can open Safari and show link
        // [[UIApplication sharedApplication] openURL:url];
       
       //create controller and show data
        
        InfoViewController *infoController = [[InfoViewController alloc] initWithURL:url];
        [url release];
        [self.navigationController pushViewController:infoController animated:YES];
        [infoController release];
    } 
}
#pragma mark - XMLParser Delegate

-(void)parserDetectNewDataToShow:(NSDictionary *)data {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[data objectForKey:@"title"] message:[data objectForKey:@"message"] delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
    url = [[NSURL alloc] initWithString:[data objectForKey:@"url"]];
    if (alert) {
        [alert show];
    }
    [alert release];
}
@end
5. In InfoViewController.m in viewDidLoad customize your views.
6. Place your information in TestFile.xml.
7. Place TestFile.xml on your server. 
7. In XMLParser.m in downloadCustomData method paste link to TestFile.xml file on your server.
8. Change version key to show alert view once.
