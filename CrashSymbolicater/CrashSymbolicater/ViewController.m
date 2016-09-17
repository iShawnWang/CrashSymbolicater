//
//  ViewController.m
//  CrashSymbolicater
//
//  Created by iShawnWang on 16/9/17.
//  Copyright © 2016年 iShawnWang. All rights reserved.
//

#import "ViewController.h"
#import <Ono.h>
@import AppKit;

@interface ViewController ()
@property (nonatomic, strong) NSPipe *pipe;
@property (nonatomic, strong) NSTask *task;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *str = @"Application received signal SIGSEGV\n(null)\n((\n\t0   CoreFoundation                      0x00000001837aadc8 <redacted> + 148\n\t1   libobjc.A.dylib                     0x0000000182e0ff80 objc_exception_throw + 56\n\t2   CoreFoundation                      0x00000001837aacf8 <redacted> + 0\n\t3   remote                              0x100240bf4 remote + 2362356\n\t4   libsystem_platform.dylib            0x000000018340993c _sigtramp + 52\n\t5   remote                              0x100179018 remote + 1544216\n\t6   remote                              0x100179420 remote + 1545248\n\t7   remote                              0x100174bac remote + 1526700\n\t8   CoreFoundation                      0x0000000183765750 <redacted> + 1096\n\t9   CoreFoundation                      0x000000018376109c <redacted> + 24\n\t10  CoreFoundation                      0x0000000183760b30 <redacted> + 540\n\t11  CoreFoundation                      0x000000018375e830 <redacted> + 724\n\t12  CoreFoundation                      0x0000000183688c50 CFRunLoopRunSpecific + 384\n\t13  GraphicsServices                    0x0000000184f70088 GSEventRunModal + 180\n\t14  UIKit                               0x0000000188976088 UIApplicationMain + 204\n\t15  remote                              0x1000eebb8 remote + 977848\n\t16  libdyld.dylib                       0x00000001832268b8 <redacted> + 4\n)\n\ndSYM UUID: 1CE3C464-1D77-3DB4-8FF5-B9B946A79729\nCPU Type: arm64\nSlide Address: 0x0000000100000000\nBinary Image: remote\nBase Address: 0x00000001000f4000";
    
    NSString *cupType;
    NSString *slideAddress;
    NSString *binaryImage;

    
    NSScanner *scanner= [NSScanner scannerWithString:str];
    [scanner scanUpToString:@"CPU Type: " intoString:nil];
    [scanner scanUpToString:@" " intoString:nil];
    [scanner scanUpToString:@" " intoString:nil];
    [scanner scanUpToString:@"\n" intoString:&cupType];
    [scanner scanUpToString:@"Slide Address: " intoString:nil];
    [scanner scanUpToString:@" " intoString:nil];
    [scanner scanUpToString:@" " intoString:nil];
    [scanner scanUpToString:@"\n" intoString:&slideAddress];
    [scanner scanUpToString:@"Binary Image: " intoString:nil];
    [scanner scanUpToString:@" " intoString:nil];
    [scanner scanUpToString:@" " intoString:nil];
    [scanner scanUpToString:@"\n" intoString:&binaryImage];
    
    
    NSRegularExpression *exp=[NSRegularExpression regularExpressionWithPattern:@"0[xX][0-9a-fA-F]+" options:0 error:nil];
    [str enumerateLinesUsingBlock:^(NSString * _Nonnull line, BOOL * _Nonnull stop) {
        NSTextCheckingResult *result=[exp firstMatchInString:line options:0 range:NSMakeRange(0, line.length)];
        if(result && [line containsString:binaryImage]){
            NSString *resultStr= [line substringWithRange:NSMakeRange(result.range.location, result.range.length)];
            
            NSString *subString= [line substringToIndex:result.range.location];
            
            NSTask *task=[[NSTask alloc]init];
            [task waitUntilExit];
            
            NSPipe *pipe= [NSPipe pipe];
            [task setStandardOutput:pipe];
            
            [task setLaunchPath:@"/bin/sh"];
            NSString *baba=[NSString stringWithFormat:@"atos -arch %@ -o /Users/pi/Desktop/remote  -l %@ %@ ",cupType,slideAddress,resultStr];
            [task setArguments:@[@"-c",baba]];
            [task launch];
            
            
            NSData * data  = [[pipe fileHandleForReading]readDataToEndOfFile];
            NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@%@",subString,str);
            
        }else{
            NSLog(@"%@",line);
        }
        
    }];
    
    
//    self.task= [[NSTask alloc]init];
//    [self.task setLaunchPath:@"/bin/sh"];
//    NSString *baba=[NSString stringWithFormat:@"atos -arch %@ -o /Users/pi/Desktop/remote  -l %@ %@ ",cupType,slideAddress,@"0x100240bf4"];
//    [self.task setArguments:@[ @"-c", baba]];
//    [self.task launch];
//    
//    
//    self.pipe=[NSPipe pipe];
//    self.task.standardOutput=self.pipe;
//    [self.pipe.fileHandleForReading waitForDataInBackgroundAndNotify];
//    
//    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(baba:) name:NSFileHandleDataAvailableNotification object:nil];
    

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
