//
//  RJFCopyproject.h
//  CopyFileAndEjectNofile
//
//  Created by ran on 12-12-21.
//  Copyright (c) 2012年 com.o-popo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RJFCopyproject : NSObject<NSTableViewDataSource,NSTableViewDelegate>
{
    IBOutlet    NSPathControl   *m_PathControl;
    IBOutlet    NSPathControl   *m_PathDestControl;
    IBOutlet    NSPathControl   *m_PathNoControl;
    IBOutlet    NSTextField     *textFieldInputNames;
    IBOutlet    NSTableView     *m_tableShowNotCopyFiles;
    IBOutlet    NSButton        *btnAddfiles;
    IBOutlet    NSButton        *btnStartCopy;
    IBOutlet    NSButton        *btCancelSetting;
    IBOutlet    NSTextView      *textViewStatus;
    
    IBOutlet    NSTextView      *textDifferentView;;
    IBOutlet    NSButton        *btnStattFind;
    
    
    NSMutableArray              *m_arrayStoreSoreFiels;
    NSMutableArray              *m_arrayStoreDestFiles;
    NSMutableArray              *m_arrayStoreNotCopyFiles;
    NSMutableArray              *m_arrayStoreSuffixs;
    NSMutableArray              *m_arrayDifferentFiles;
}


-(IBAction)ChooseSourceFiles:(id)sender;
-(IBAction)ChooseDestFiles:(id)sender;
-(IBAction)ChooseNotCopyFiles:(id)sender;
-(IBAction)AddNotCopyFiles:(id)sender;
-(IBAction)CancelNotCopyFiles:(id)sender;
-(IBAction)StartCopyFiles:(id)sender;
-(IBAction)SaveSettingFiles:(id)sender;
-(IBAction)CancelSettingFiles:(id)sender;
-(IBAction)StartFindDifference:(id)sender;

@end
