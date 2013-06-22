//
//  PhotoUpload.m
//  PhotoUploader
//
//  Created by rahul nagpal on 22/06/13.
//  Copyright (c) 2013 rahul nagpal. All rights reserved.
//

#import "PhotoUpload.h"

@implementation PhotoUpload

@synthesize delegate;

- (NSString *)GetUUID
{
    //********use for generating unique string ****************//
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    return (__bridge NSString *)uuidStringRef;
}

- (NSString *) currentTime {
    //********use for getting the current date and time *********//
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM dd, yyyy HH:mm:ss"];
    return [format stringFromDate:currentDate];
}

- (void) startUploadingPhoto :(UIImage *)image :(NSInteger) tag{
    
    
    NSString *uniqueString = [self GetUUID];
    NSData *imageData = UIImagePNGRepresentation(image);
    int bytes = [imageData length];
    NSString *logString = [NSString stringWithFormat:@"\n~StartDate =%@  ImageName = %@.png, Send Bytes = %d",[self currentTime],uniqueString, bytes];
    // setting up the URL to post to
    
	// setting up the request object now
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:URL_STRING]];
	[request setHTTPMethod:@"POST"];
	/*
	 add some header info now
	 we always need a boundary when we post a file
	 also we need to set the content type
	 
	 You might want to generate a random boundary.. this is just the same
	 as my output from wireshark on a valid html post
	 */
	NSString *boundary = [NSString stringWithFormat:@"---------------------------14737809831466499882746641449"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	/*
	 now lets create the body of the post
	 */
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=%@.png\r\n",uniqueString] dataUsingEncoding:NSUTF8StringEncoding]];

	[body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:imageData]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
	
	// now lets make the connection to the web
    NSError *error = nil;
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    bytes = [returnData length];
    logString = [logString stringByAppendingString:[NSString stringWithFormat:@" Received Bytes = %d", bytes]];
    logString = [logString stringByAppendingString:[NSString stringWithFormat:@" End Date = %@", [self currentTime]]];
	if(![returnString isEqualToString:@"\"TRUE\""]) {
        logString = [logString stringByAppendingString:[error description]];

	}
    [delegate PhotoUploadedComplete :logString :tag :error];

}

@end
