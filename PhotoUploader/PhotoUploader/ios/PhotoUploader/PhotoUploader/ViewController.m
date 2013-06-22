//
//  ViewController.m
//  PhotoUploader
//
//  Created by rahul nagpal on 22/06/13.
//  Copyright (c) 2013 rahul nagpal. All rights reserved.
//

#import "ViewController.h"

int internetWorking;

@interface ViewController ()

@end

@implementation ViewController

@synthesize imageTableView;
@synthesize uploadButton;
@synthesize imageArray;
@synthesize AddPhotoFromCameraButton;
@synthesize AddPhotoFromLibraryButton;
@synthesize showLogButton;
@synthesize processingIndicator;
@synthesize uploadCount;
@synthesize errorArray;

- (void)viewDidLoad
{
    self.title = @"Photo Upload";
    imageArray = [[NSMutableArray alloc] init];
    errorArray = [[NSMutableArray alloc] init];
    imageTableView.delegate = self;
    imageTableView.dataSource = self;
    
    self.processingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.processingIndicator.frame = CGRectMake((self.view.frame.size.width/2)-10, (self.view.frame.size.height/2)-100, 20, 20);
    self.processingIndicator.hidesWhenStopped = YES;
    [self.view addSubview:processingIndicator];


    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void) showLogAction {

    NSString * pathString = [documentDir  stringByAppendingPathComponent:@"PhotoUploader"];
    
    NSString *logPath = [[NSString alloc] initWithFormat:@"%@",[pathString stringByAppendingPathComponent:@"log.txt"]];
    NSString *myString = [[NSString alloc] initWithContentsOfFile:logPath encoding:NSUTF8StringEncoding error:NULL];
    LogViewController *logViewController = [[LogViewController alloc] init];
    logViewController.logText = myString;
    [self.navigationController pushViewController:logViewController animated:YES];
}

- (void) PhotoUploadedComplete  :(NSString *)logString :(NSInteger)tag :(NSError *)error{
    
    //*********callback method when uploading done or error caused during uploading*******//
    uploadCount++;
    if (error != nil) {
        [errorArray addObject:[NSString stringWithFormat:@"%d",tag]];
    }

    NSString * pathString = [documentDir  stringByAppendingPathComponent:@"PhotoUploader"];

    NSString *logPath = [[NSString alloc] initWithFormat:@"%@",[pathString stringByAppendingPathComponent:@"log.txt"]];
    NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:logPath];
    [fileHandler seekToEndOfFile];
    [fileHandler writeData:[logString dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandler closeFile];
    if (uploadCount == [imageArray count]) {
        self.view.userInteractionEnabled = YES;

        if ([errorArray count] == 0) {
            [self showAlert:@"Upload" :@"Upload Completed"];
            [imageArray removeAllObjects];
        }
        else {
            [self showAlert:@"Error" :@"Error in uploading images"];

            for (int i = 0; i < [errorArray count]; i++) {
                NSInteger index = [[errorArray objectAtIndex:i] intValue] - 100;
                if (index < [imageArray count]) {
                    [imageArray removeObjectAtIndex:index];

                }
            }
        }
        [processingIndicator stopAnimating];
        [imageTableView reloadData];
    }
    
}

- (void) showAlert :(NSString *)titleString : (NSString *)messageString {

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleString
                                                    message:messageString
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    }
    
    cell.imageView.image = [imageArray objectAtIndex:indexPath.row];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
    
    
    
	return cell;
	
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	
	return [imageArray count];
    
    
}
- (IBAction) getPhoto: (id)sender {
    
    if((UIButton *) sender == AddPhotoFromCameraButton) {
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [self showAlert:@"Error" :@"Camera not Supported"];
            return;
        }
	}
    else {
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            [self showAlert:@"Error" :@"Library not Supported"];
            return;
        }
    }
    
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        
        if((UIButton *) sender == AddPhotoFromCameraButton) {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;

        } else {
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    [self presentViewController:picker
                       animated:YES completion:nil];}

-(void)imagePickerController:(UIImagePickerController *)picker
      didFinishPickingImage : (UIImage *)image
                 editingInfo:(NSDictionary *)editingInfo
{
    [imageArray addObject:image];
    [imageTableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *) picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction) upload {
 //*******uploading images to server *********//
    uploadCount = 0;
    [errorArray removeAllObjects];
    if ([imageArray count] == 0) {
        [self showAlert:@"Upload" :@"No image available to upload"];
        return;
    }
    [processingIndicator startAnimating];
    self.view.userInteractionEnabled = NO;

    [self performSelector:@selector(uploadPhotoServer) withObject:nil afterDelay:0.1];
    
}

- (void) uploadPhotoServer {

    for (int i = 0; i < [imageArray count]; i++) {
        [[AppDelegate sharedInstance] CheckInternetConnection];
        if (internetWorking == 1) {
            PhotoUpload *photoUpload = [[PhotoUpload alloc] init];
            photoUpload.delegate = self;
            [photoUpload startUploadingPhoto:[imageArray objectAtIndex:i] :i+100];
        }
        else {
            self.view.userInteractionEnabled = YES;

            [self showAlert:@"Error" :@"No Internet Connection"];
            return;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
