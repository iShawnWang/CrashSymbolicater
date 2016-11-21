//
//  WindowController.m
//  CrashSymbolicater
//
//  Created by iShawnWang on 2016/11/10.
//  Copyright © 2016年 iShawnWang. All rights reserved.
//

#import "WindowController.h"
#import <INAppStoreWindow.h>

@interface WindowController ()

@end

@implementation WindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    INAppStoreWindow *window = (INAppStoreWindow*) self.window;
    NSView *titleBarView = window.titleBarView;
    titleBarView.layer.backgroundColor=[NSColor colorWithWhite:0.667 alpha:1].CGColor;
    window.titleBarHeight=44;

    NSSegmentedControl *segment=[NSSegmentedControl segmentedControlWithLabels:@[@"6",@"7"] trackingMode:NSSegmentSwitchTrackingSelectOne target:self action:@selector(segmentSelected:)];
    
    segment.frame=NSMakeRect(NSMidX(titleBarView.frame), NSMidY(titleBarView.bounds), NSWidth(segment.bounds) , NSHeight(segment.bounds));
    [window.titleBarView addSubview:segment];
    
    [window setTitleBarDrawingBlock:^(BOOL drawsAsMainWindow, CGRect drawingRect, CGPathRef clippingPath){
        [[NSColor colorWithWhite:0.667 alpha:1]setFill];
        NSRectFill(drawingRect);
    }];
}

-(void)segmentSelected:(id)sender{
    NSLog(@"%@",@"666");
}

@end
