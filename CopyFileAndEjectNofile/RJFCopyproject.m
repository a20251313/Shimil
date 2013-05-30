//
//  RJFCopyproject.m
//  CopyFileAndEjectNofile
//
//  Created by ran on 12-12-21.
//  Copyright (c) 2012年 com.o-popo. All rights reserved.
//

#import "RJFCopyproject.h"

#define NOTCOPYARRAY    @"NOTCOPYARRAY"
#define SORCEFILESARRAY    @"SORCEFILESARRAY"
#define DESTFILESARRAY    @"DESTFILESARRAY"
#define SUFFIXSARRAY      @"SUFFIXSARRAY"


@implementation RJFCopyproject


//@".strings"

-(id)init
{
    self = [super init];
    if (self)
    {
        m_arrayStoreDestFiles = [[NSMutableArray alloc] init];
        m_arrayStoreNotCopyFiles = [[NSMutableArray alloc] init];
        m_arrayStoreSoreFiels = [[NSMutableArray alloc] init];
        m_arrayStoreSuffixs = [[NSMutableArray alloc] init];
        m_arrayDifferentFiles = [[NSMutableArray alloc] init];
        [m_arrayStoreNotCopyFiles addObjectsFromArray:[[NSUserDefaults standardUserDefaults] valueForKey:NOTCOPYARRAY]];
        [m_arrayStoreDestFiles addObjectsFromArray:[[NSUserDefaults standardUserDefaults] valueForKey:DESTFILESARRAY]];
        [m_arrayStoreSoreFiels addObjectsFromArray:[[NSUserDefaults standardUserDefaults] valueForKey:SORCEFILESARRAY]];
        [m_arrayStoreSuffixs addObjectsFromArray:[NSArray arrayWithObjects:@".h",@".m",@".mm",@".xib",@".txt",nil]];
        
        NSString   *strFileName = @"/Users/popo/Desktop/Localizable.strings";
        NSFileManager  *defaultManger = [NSFileManager defaultManager];
        
        if ([defaultManger fileExistsAtPath:strFileName])
        {
            NSDictionary  *dicInfo = [defaultManger attributesOfItemAtPath:strFileName error:nil];
            NSLog(@"attributesOfItemAtPath:%@",dicInfo);
            dicInfo = [defaultManger attributesOfFileSystemForPath:strFileName error:nil];
            NSLog(@"attributesOfFileSystemForPath:%@",dicInfo);
        }
        
        
        
    }
    return self;
}

-(void)dealloc
{
    [m_arrayDifferentFiles removeAllObjects];
    [m_arrayDifferentFiles release];
    [m_arrayStoreDestFiles removeAllObjects];
    [m_arrayStoreDestFiles release];
    [m_arrayStoreNotCopyFiles removeAllObjects];
    [m_arrayStoreNotCopyFiles release];
    [m_arrayStoreSoreFiels removeAllObjects];
    [m_arrayStoreSoreFiels release];
    [m_arrayStoreSuffixs removeAllObjects];
    [m_arrayStoreSuffixs release];
    
    [super dealloc];
}
-(IBAction)ChooseSourceFiles:(id)sender
{
    
    NSRect  rect = {400,0,400,200};
    NSOpenPanel  *openPanel = [[NSOpenPanel alloc] initWithContentRect:rect
                                                             styleMask:NSTitledWindowMask | NSResizableWindowMask backing:NSBackingStoreBuffered defer:YES];
    
    openPanel.canChooseDirectories = YES;
    openPanel.canChooseFiles = NO;
    [openPanel setTitle:@"选择你的源文件目录"];
    [openPanel setPrompt:@"确定"];
    [openPanel runModal];
    
    
    [m_arrayStoreSoreFiels removeAllObjects];
    NSString  *strFileName = [[openPanel URL] path];
    NSLog(@"path:%@",strFileName);
    
    [m_PathControl setURL:[NSURL URLWithString:strFileName]];
    NSFileManager  *fileManger = [NSFileManager defaultManager];
    BOOL  bISDir = NO;
    if ([fileManger fileExistsAtPath:strFileName
                         isDirectory:&bISDir])
    {
        if (!bISDir)
        {
            for (NSString *strSuff in m_arrayStoreSuffixs)
            {
                if ([strFileName hasSuffix:strSuff])
                {
                    [m_arrayStoreSoreFiels addObject:strFileName];
                    break;
                }
            }
           
        }else
        {
            NSArray  *array = [fileManger subpathsAtPath:strFileName];
            for (NSString *strTemp in array)
            {
                strTemp = [strFileName stringByAppendingFormat:@"/%@",strTemp];
                [fileManger fileExistsAtPath:strTemp isDirectory:&bISDir];
                if (!bISDir)
                {
                    for (NSString *strSuff in m_arrayStoreSuffixs)
                    {
                        if ([strTemp hasSuffix:strSuff])
                        {
                           [m_arrayStoreSoreFiels addObject:strTemp];
                            break;
                        }
                    }
                    
                    
                }
                
                //NSLog(@"")
            }
        }
    }
    
    NSLog(@"source files:%@",m_arrayStoreSoreFiels);
    [self SaveStatus:@"源文件选取成功"];
    
}
-(IBAction)ChooseDestFiles:(id)sender
{
    NSRect  rect = {400,0,400,200};
    NSOpenPanel  *openPanel = [[NSOpenPanel alloc] initWithContentRect:rect
                                                             styleMask:NSTitledWindowMask | NSResizableWindowMask backing:NSBackingStoreBuffered defer:YES];
    
    openPanel.canChooseDirectories = YES;
    openPanel.canChooseFiles = NO;
    [openPanel setTitle:@"选择你目的文件目录"];
    [openPanel setPrompt:@"确定"];
    [openPanel runModal];
    
    
   
    [m_arrayStoreDestFiles removeAllObjects];
    NSString  *strFileName = [[openPanel URL] path];
    NSLog(@"path:%@",strFileName);

    [m_PathDestControl setURL:[NSURL URLWithString:strFileName]];
    
    
    NSFileManager  *fileManger = [NSFileManager defaultManager];
    BOOL  bISDir = NO;
    if ([fileManger fileExistsAtPath:strFileName
                         isDirectory:&bISDir])
    {
        if (!bISDir)
        {
          
            for (NSString *strSuff in m_arrayStoreSuffixs)
            {
                if ([strFileName hasSuffix:strSuff])
                {
                    [m_arrayStoreDestFiles addObject:strFileName];
                    break;
                }
            }
        }else
        {
            NSArray  *array = [fileManger subpathsAtPath:strFileName];
            for (NSString *strTemp in array)
            {
                strTemp = [strFileName stringByAppendingFormat:@"/%@",strTemp];
                [fileManger fileExistsAtPath:strTemp isDirectory:&bISDir];
                if (!bISDir)
                {
                    for (NSString *strSuff in m_arrayStoreSuffixs)
                    {
                        if ([strTemp hasSuffix:strSuff])
                        {
                            [m_arrayStoreDestFiles addObject:strTemp];
                            break;
                        }
                    }
                    
                }
                
                //NSLog(@"")
            }
        }
    }
    
    NSLog(@"source files:%@",m_arrayStoreDestFiles);
    [self SaveStatus:@"目的文件选取成功"];
    
}
-(IBAction)ChooseNotCopyFiles:(id)sender
{
    
    NSRect  rect = {400,0,400,200};
    NSOpenPanel  *openPanel = [[NSOpenPanel alloc] initWithContentRect:rect
                                                             styleMask:NSTitledWindowMask | NSResizableWindowMask backing:NSBackingStoreBuffered defer:YES];
    
    openPanel.canChooseDirectories = NO;
    openPanel.canChooseFiles = YES;
    openPanel.allowsMultipleSelection = YES;
    [openPanel setTitle:@"选择你不想改变的文件"];
    [openPanel setPrompt:@"确定"];
    [openPanel runModal];
    
    

    NSArray  *arrayFileName = [openPanel URLs];
    //  [m_PathNoControl setURL:[NSURL URLWithString:strFileName]];
    NSLog(@"path:%@",arrayFileName);
    
 

    
    for (NSURL *url in arrayFileName)
    {
        NSString *strTemp = [url path];
        
        
        for (NSString *strSuff in m_arrayStoreSuffixs)
        {
            if ([strTemp hasSuffix:strSuff])
            {
                [m_arrayStoreNotCopyFiles addObject:[strTemp lastPathComponent]];
                break;
            }
        }

    }

    
    
    
    [m_tableShowNotCopyFiles reloadData];
     [self SaveStatus:@"不需要复制的文件选取成功"];
    
}
-(IBAction)AddNotCopyFiles:(id)sender
{
    NSString   *strFiles = [textFieldInputNames stringValue];
    if (strFiles != nil && ![strFiles isEqualToString:@""])
    {
        NSArray  *array = [strFiles componentsSeparatedByString:@","];
        for (NSString *strTemp in array)
        {
            if ([strTemp isEqualToString:@""] || [strTemp length] < 1)
            {
                continue;
            }
            [m_arrayStoreNotCopyFiles addObject:[strTemp lastPathComponent]];
            
        }
        
        [m_tableShowNotCopyFiles reloadData];
    }
    
    [self SaveStatus:@"添加不需要复制的文件成功"];
}
-(IBAction)StartCopyFiles:(id)sender
{
    
    if ([m_arrayStoreDestFiles count] == 0 || [m_arrayStoreSoreFiels count] == 0)
    {
        return;
    }
    
    NSLog(@"源文件：%@ \n\n\n  目的文件:%@ 不需要的文件:%@ suffixs:%@",m_arrayStoreSoreFiels,m_arrayStoreDestFiles,m_arrayStoreNotCopyFiles,m_arrayStoreSuffixs);
    [self SaveStatus:@"开始复制文件"];
    
    [NSThread detachNewThreadSelector:@selector(StartCopyThread:)
                             toTarget:self
                           withObject:nil];
}
-(IBAction)CancelNotCopyFiles:(id)sender
{
    NSString *strFiles = [textFieldInputNames stringValue];

    if (strFiles != nil || [m_arrayStoreNotCopyFiles count])
    {
        for (NSString  *strTemp in m_arrayStoreNotCopyFiles)
        {
            if ([strTemp isEqualToString:strFiles])
            {
                [m_arrayStoreNotCopyFiles removeObject:strTemp];
            }
        }
    }
  
    [self SaveStatus:@"删除不需要复制的文件成功"];
      [m_tableShowNotCopyFiles reloadData];
}
-(IBAction)SaveSettingFiles:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:m_arrayStoreNotCopyFiles forKey:NOTCOPYARRAY];
    [[NSUserDefaults standardUserDefaults] setObject:m_arrayStoreDestFiles forKey:DESTFILESARRAY];
    [[NSUserDefaults standardUserDefaults] setObject:m_arrayStoreSoreFiels forKey:SORCEFILESARRAY];
    
    if ([[NSUserDefaults standardUserDefaults] synchronize])
    {
        [self SaveStatus:@"保存设定成功！"];
    }


}

-(IBAction)CancelSettingFiles:(id)sender
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:NOTCOPYARRAY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:DESTFILESARRAY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SORCEFILESARRAY];
    
    [m_arrayStoreNotCopyFiles removeAllObjects];
    [m_arrayStoreDestFiles removeAllObjects];
    [m_arrayStoreSoreFiels removeAllObjects];
    [m_tableShowNotCopyFiles reloadData];
    
    //[m_PathControl setURL:nil];
    //[m_PathDestControl setURL:nil];
    if ([[NSUserDefaults standardUserDefaults] synchronize])
    {
        [self SaveStatus:@"删除设定成功！"];
    }
    
}



-(void)SaveStatus:(id)Message
{
    
    NSDate  *date = [NSDate date];
    NSDateFormatter   *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm:ss"];
    
   // NSTimeInterval  timeZoneOffset=[[NSTimeZone systemTimeZone] secondsFromGMT];
 //   NSDate  *newDate=[date dateByAddingTimeInterval:timeZoneOffset];

    NSString  *strInfo = [NSString stringWithFormat:@"%@  %@\n",[dateFormat stringFromDate:date],Message];
   
    [textViewStatus performSelector:@selector(insertText:)
                           onThread:[NSThread mainThread]
                         withObject:strInfo
                      waitUntilDone:YES];
    [dateFormat release];
    
}
#pragma mark tableViewdelegate


- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [m_arrayStoreNotCopyFiles count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    
    NSString   *strInfo = [m_arrayStoreNotCopyFiles objectAtIndex:rowIndex];
    
    return strInfo;
}


-(void)StartCopyThread:(id)Thread
{
    for (NSString *strFile in m_arrayStoreSoreFiels)
    {
        BOOL   bNeedIngore = NO;
        NSString *strLastCom = [strFile lastPathComponent];
        for (NSString *strInfo in m_arrayStoreNotCopyFiles)
        {
            if ([strLastCom rangeOfString:strInfo].location != NSNotFound)
            {
                bNeedIngore = YES;
                break;
            }
        }
        
        if (bNeedIngore)
        {
            continue;
        }
        
        NSFileManager  *defaultMan = [NSFileManager defaultManager];
        for (NSString *strDestFile in m_arrayStoreDestFiles)
        {
            
            if (![strLastCom  isEqualToString:[strDestFile lastPathComponent]])
            {
                continue;
            }
            
             NSError  *error = nil;
            if ([defaultMan fileExistsAtPath:strFile] && [defaultMan fileExistsAtPath:strDestFile])
            {
               
            
                if ([defaultMan contentsEqualAtPath:strFile andPath:strDestFile])
                {
                    continue;
                }
                if ([defaultMan removeItemAtPath:strDestFile error:&error])
                {
                    if ([defaultMan copyItemAtPath:strFile toPath:strDestFile error:&error])
                    {
                        NSLog(@"files:%@ copy to %@ success",strFile,strDestFile);
                    }else
                    {
                         NSLog(@"--------------files:%@ copy to %@ fail error:%@-----------",strFile,strDestFile,error);
                    }
                }
            }else
            {
                NSLog(@"--------------removeFile %@ fail error:%@-----------",strDestFile,error);  
            }
            
        }
        
        
    }
    [self SaveStatus:@"文件复制完成"];
}


-(void)startFindDifference
{
    [self SaveStatus:@"开始寻找不同文件"];
    [textDifferentView setString:@""];
    [m_arrayDifferentFiles removeAllObjects];
    for (NSString *strFile in m_arrayStoreSoreFiels)
    {
       
        NSString *strLastCom = [strFile lastPathComponent];
        NSFileManager  *defaultMan = [NSFileManager defaultManager];
        for (NSString *strDestFile in m_arrayStoreDestFiles)
        {
            
            if (![strLastCom  isEqualToString:[strDestFile lastPathComponent]])
            {
                continue;
            }
            

            if ([defaultMan fileExistsAtPath:strFile] && [defaultMan fileExistsAtPath:strDestFile])
            {
                
                if ([defaultMan contentsEqualAtPath:strFile andPath:strDestFile])
                {
                    continue;
                }else
                {
                    [m_arrayDifferentFiles addObject:strLastCom];
                    strLastCom = [strLastCom stringByAppendingString:@"\n"];
                    [textDifferentView performSelector:@selector(insertText:)
                                           onThread:[NSThread mainThread]
                                         withObject:strLastCom
                                      waitUntilDone:YES];
                   // [textDifferentView insertNewline:strLastCom];
                }
                
            }
            
        
        }
        
        
    }
    NSLog(@"m_arrayDifferentFiles:%@",m_arrayDifferentFiles);
    [self SaveStatus:@"寻找不同文件任务完成"];
    
}

-(IBAction)StartFindDifference:(id)sender
{
    [NSThread detachNewThreadSelector:@selector(startFindDifference)
                             toTarget:self
                           withObject:nil];
}
@end
