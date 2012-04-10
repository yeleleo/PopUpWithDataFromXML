//
//  InfoViewController.h
//  Innovation
//
//  Created by Vladimir Pronin on 2/27/12.
//  Copyright (c) 2012 YELELEO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoViewController : UIViewController <UIWebViewDelegate> {
    @private
    IBOutlet UIWebView *webViewInfo;
}
-(id)initWithURL:(NSURL *)url;

@end
