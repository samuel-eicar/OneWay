//
//  Location.h
//  OneWay
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import <Foundation/Foundation.h>

@interface Location : NSObject <NSCoding>
{
	int type;
	SecProtocolType protocol;
	NSString *hostname;
	int port;
	NSString *username;
	NSString *password;
	NSString *directory;
	NSString *baseUrl;
	NSString *uid;
	BOOL savePassword;
	BOOL webAccessible;
}

@property(nonatomic, readwrite, assign) int type;
@property(nonatomic, readwrite, assign) SecProtocolType protocol;
@property(nonatomic, readwrite, copy) NSString *hostname;
@property(nonatomic, readwrite, assign) int port;
@property(nonatomic, readwrite, copy) NSString *username;
@property(nonatomic, readwrite, copy) NSString *password;
@property(nonatomic, readwrite, copy) NSString *directory;
@property(nonatomic, readwrite, copy) NSString *baseUrl;
@property(nonatomic, readwrite, copy) NSString *uid;
@property(nonatomic, readwrite, assign) BOOL savePassword;
@property(nonatomic, readwrite, assign) BOOL webAccessible;

- (void)encodeWithCoder:(NSCoder *)encoder;

- (id)initWithCoder:(NSCoder *)decoder;

- (id)initWithType:(int)aType hostname:(NSString *)aHostname username:(NSString *)aUsername password:(NSString *)aPassword directory:(NSString *)aDirectory;

- (void)setProtocolDefaults;

- (void)guessBaseUrl;

- (NSString *)protocolString;

@end
