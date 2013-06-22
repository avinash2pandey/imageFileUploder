//
//  PhotoUpload.h
//  PhotoUploader
//
//  Created by rahul nagpal on 22/06/13.
//  Copyright (c) 2013 rahul nagpal. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PhotoUploadDelegate;

@interface PhotoUpload : NSObject

@property (nonatomic, assign) id<PhotoUploadDelegate> delegate;

- (void) startUploadingPhoto :(UIImage *)image  :(NSInteger) tag;

@end

@protocol PhotoUploadDelegate <NSObject>

- (void) PhotoUploadedComplete :(NSString *)logString :(NSInteger)tag :(NSError *)error;

@end