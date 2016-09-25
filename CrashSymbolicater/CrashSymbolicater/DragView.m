//
//  DragView.m
//  CrashSymbolicater
//
//  Created by iShawnWang on 16/9/24.
//  Copyright © 2016年 iShawnWang. All rights reserved.
//

#import "DragView.h"

@implementation DragView

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self registerForDraggedTypes:@[NSFilenamesPboardType]];
    }
    return self;
}


-(NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender{
    return NSDragOperationGeneric;
}

-(BOOL)performDragOperation:(id<NSDraggingInfo>)sender{
    NSPasteboard *pboard= [sender draggingPasteboard];
    if( [[pboard types]containsObject:NSFilenamesPboardType]){
        NSArray *files=[pboard propertyListForType:NSFilenamesPboardType];
        NSInteger count= files.count;
        if(count>0){
            return [self.delegate dragView:self didReceiveFilePaths:files];
        }
    }
    return NO;
}
@end
