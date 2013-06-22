

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

typedef enum {
	NotReachable = 0,
	ReachableViaWiFi,
	ReachableViaWWAN
} NetworkStatus;
#define kReachabilityChangedNotification @"kNetworkReachabilityChangedNotification"

@interface ReachabilityNew: NSObject
{
	BOOL localWiFiRef;
	SCNetworkReachabilityRef reachabilityRef;
}

//reachabilityWithHostName- Use to check the reachability of a particular host name. 
+ (ReachabilityNew*) reachabilityWithHostName: (NSString*) hostName;

//reachabilityWithAddress- Use to check the reachability of a particular IP address. 
+ (ReachabilityNew*) reachabilityWithAddress: (const struct sockaddr_in*) hostAddress;

//reachabilityForInternetConnection- checks whether the default route is available.  
//  Should be used by applications that do not connect to a particular host
+ (ReachabilityNew*) reachabilityForInternetConnection;

//reachabilityForLocalWiFi- checks whether a local wifi connection is available.
+ (ReachabilityNew*) reachabilityForLocalWiFi;

//Start listening for reachability notifications on the current run loop
- (BOOL) startNotifer;
- (void) stopNotifer;

- (NetworkStatus) currentReachabilityStatus;
//WWAN may be available, but not active until a connection has been established.
//WiFi may require a connection for VPN on Demand.
- (BOOL) connectionRequired;
@end


