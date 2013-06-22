//
//  ViewController.h
//  PhotoUploader
//
//  Created by rahul nagpal on 22/06/13.
//  Copyright (c) 2013 rahul nagpal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoUpload.h"
#import "LogViewController.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,PhotoUploadDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) IBOutlet UITableView *imageTableView;
@property (nonatomic, strong) IBOutlet UIButton *AddPhotoFromCameraButton;
@property (nonatomic, strong) IBOutlet UIButton *AddPhotoFromLibraryButton;
@property (nonatomic, strong) IBOutlet UIButton *uploadButton;
@property (nonatomic, strong) IBOutlet UIButton *showLogButton;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UIActivityIndicatorView *processingIndicator;
@property (nonatomic, readwrite) NSInteger uploadCount;
@property (nonatomic, strong) NSMutableArray *errorArray;



- (IBAction) getPhoto: (id)sender;
- (IBAction) upload;
- (IBAction) showLogAction;

@end
