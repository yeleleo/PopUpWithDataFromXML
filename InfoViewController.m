//
//  InfoViewController.m
//  Innovation
//
//  Created by Vladimir Pronin on 2/27/12.
//  Copyright (c) 2012 YELELEO. All rights reserved.
//

#import "InfoViewController.h"
@interface InfoViewController()
@property (nonatomic, retain) NSURLRequest *request;
@end

@implementation InfoViewController
@synthesize request;

- (void)dealloc {
    self.request = nil;
    [webViewInfo release];
    [super dealloc];
}

-(id)initWithURL:(NSURL *)url {
    if (self = [super init]) {
         self.request = [NSURLRequest requestWithURL:url];
    }
    return self;
}

-(void)viewDidLoad {
    
    self.view.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height);
    
    webViewInfo = [[UIWebView alloc] initWithFrame:CGRectMake(0, topBar.image.size.height,[UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].applicationFrame.size.height-self.navigationController.navigationBar.bounds.size.height)];
    webViewInfo.delegate = self;
    webViewInfo.scalesPageToFit = YES;
    [webViewInfo loadRequest:self.request];
	webViewInfo.backgroundColor = [UIColor grayColor];
    [self.view addSubview:webViewInfo];
	
    [self.navigationController setNavigationBarHidden:NO animated:YES];

     [super viewDidLoad];
     
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - WebView Delegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Sorry! There is no internet connection available!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release];
}


#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
