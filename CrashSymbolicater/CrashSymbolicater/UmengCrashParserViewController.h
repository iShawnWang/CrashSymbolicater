//
//  UmengCrashParserViewController.h
//  CrashSymbolicater
//
//  Created by iShawnWang on 16/9/25.
//  Copyright © 2016年 iShawnWang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface UmengCrashParserViewController : NSViewController
@property (unsafe_unretained) IBOutlet NSTextView *textView;
@property (weak) IBOutlet NSTextField *dysmFilePathLabel;
@end
