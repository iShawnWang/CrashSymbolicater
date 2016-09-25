//
//  MBProgressHUD+Addition.h
//  CrashSymbolicater
//
//  Created by iShawnWang on 16/9/25.
//  Copyright © 2016年 iShawnWang. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Addition)
+(void)showInView:(NSView*)view withMsg:(NSString*)msg;
+(void)hideHUDForView:(NSView*)view;
@end
