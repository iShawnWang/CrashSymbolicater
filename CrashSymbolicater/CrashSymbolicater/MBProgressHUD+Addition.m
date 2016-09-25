//
//  MBProgressHUD+Addition.m
//  CrashSymbolicater
//
//  Created by iShawnWang on 16/9/25.
//  Copyright © 2016年 iShawnWang. All rights reserved.
//

#import "MBProgressHUD+Addition.h"
#import "MBProgressHUD.h"


@implementation MBProgressHUD (Addition)
+(void)showInView:(NSView*)view withMsg:(NSString*)msg{
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:view];
    [view addSubview:hud];
    hud.labelText=msg;
    [hud show:YES];
}

+(void)hideHUDForView:(NSView*)view{
    [[MBProgressHUD HUDForView:view]hide:YES];
}
@end
