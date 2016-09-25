//
//  DragView.h
//  CrashSymbolicater
//
//  Created by iShawnWang on 16/9/24.
//  Copyright © 2016年 iShawnWang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol DragViewDelegate <NSObject>


/**
 @return 返回是否能处理 paths 中的文件
 */
-(BOOL)dragView:(NSView*)dragView didReceiveFilePaths:(NSArray*)paths;

@end

@interface DragView : NSView
@property (nonatomic, weak) IBOutlet id<DragViewDelegate> delegate;
@end
