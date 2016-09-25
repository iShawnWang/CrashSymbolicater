//
//  CrashSymbolicaterViewController.m
//  CrashSymbolicater
//
//  Created by iShawnWang on 16/9/17.
//  Copyright © 2016年 iShawnWang. All rights reserved.
//

#import "CrashSymbolicaterViewController.h"
#import "DragView.h"
#import "MBProgressHUD+Addition.h"
@import AppKit;

@interface CrashSymbolicaterViewController ()<DragViewDelegate>
@property (nonatomic, strong) NSPipe *pipe;
@property (nonatomic, strong) NSTask *task;
@property (nonatomic, strong) DragView *dragView;
@end

@implementation CrashSymbolicaterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dragView=[[DragView alloc]initWithFrame:self.view.bounds];
    self.dragView.delegate =self;
    [self.view addSubview:self.dragView];

    [self.view registerForDraggedTypes:@[NSFilenamesPboardType]];
}

-(void)letUsGo{
    NSString *path= [[NSBundle mainBundle]pathForResource:@"symbolicatecrash" ofType:@""];
    
    NSTask *task=[[NSTask alloc]init];
    NSPipe *pipe= [NSPipe pipe];
    
    [task setLaunchPath:@"/bin/sh"];
    [task waitUntilExit];
    [task setStandardOutput:pipe];

    NSString *symbolicatedFileName=[NSString stringWithFormat:@"%@/%@_symbolicated.crash" ,NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES).firstObject,[self.crashFilePathLabel stringValue].lastPathComponent.stringByDeletingPathExtension];
    
    NSString *baba=[NSString stringWithFormat:@"export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer \n %@ %@ %@ > %@",path,[self.crashFilePathLabel stringValue],[self.appFilePathLabel stringValue],symbolicatedFileName];
    
    [task setArguments:@[@"-c",baba]];
    [task launch];
    
    [MBProgressHUD showInView:self.view withMsg:@"Done"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.225 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[NSWorkspace sharedWorkspace]openFile:symbolicatedFileName];
    });
}

-(BOOL)dragView:(NSView *)dragView didReceiveFilePaths:(NSArray *)paths{
    
    if(paths.count==1){
        NSString *filePath = paths[0];
        return [self receiveAppFile:filePath] || [self receiveCrashFile:filePath];
    }else{
        __block NSInteger countOfValidatePath;
        [paths enumerateObjectsUsingBlock:^(NSString *path, NSUInteger idx, BOOL * _Nonnull stop) {
            if([self receiveCrashFile:path] || [self receiveAppFile:path]){
                countOfValidatePath++;
            }
        }];
        return countOfValidatePath == 2; //我们得到了 *.app 和 *.crash 文件路径
    }
}

-(BOOL)receiveCrashFile:(NSString*)path{
    if([path hasSuffix:@".crash"]){
        [self.crashFilePathLabel setStringValue:path];
        return YES;
    }
    return NO;
}

-(BOOL)receiveAppFile:(NSString*)path{
    if([path hasSuffix:@".app"]){
        [self.appFilePathLabel setStringValue:path];
        return YES;
    }
    return NO;
}

- (IBAction)go:(id)sender {
    [self letUsGo];
}

-(void)baba:(NSNotification*)noti
{
    NSString *str=[[NSString alloc]initWithData:self.pipe.fileHandleForWriting.availableData encoding:NSUTF8StringEncoding] ;
    NSLog(@"%@",str);
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
