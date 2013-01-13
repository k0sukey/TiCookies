/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "BeK0sukeTicookiesModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation BeK0sukeTicookiesModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"40424ff9-e894-49ef-a8e0-2c6ee8816805";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"be.k0suke.ticookies";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added 
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma Public APIs
-(void)createCookie:(id)args
{
	ENSURE_SINGLE_ARG_OR_NIL(args, NSDictionary);

	[[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];

	NSDictionary *properties = [[NSMutableDictionary alloc] init];

	[properties setValue:[args objectForKey:@"domain"] forKey:NSHTTPCookieDomain];
	[properties setValue:[args objectForKey:@"name"] forKey:NSHTTPCookieName];
	[properties setValue:[[args objectForKey:@"value"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:NSHTTPCookieValue];
	[properties setValue:[TiUtils stringValue:@"path" properties:args def:@"/"] forKey:NSHTTPCookiePath];
	[properties setValue:[TiUtils stringValue:@"expires" properties:args def:@"0"] forKey:NSHTTPCookieExpires];
	NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:properties];
	[properties release];

	NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	[storage setCookie:cookie];
	[cookie release];
}

-(NSArray*)listedCookies:(id)args
{
	ENSURE_SINGLE_ARG_OR_NIL(args, NSDictionary);
	NSString *domain = [TiUtils stringValue:@"domain" properties:args def:@"*"];
	NSString *name = [args objectForKey:@"name"];

	NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];

	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];

	NSMutableArray *cookies = [NSMutableArray array];

	NSHTTPCookie *cookie;
	for (cookie in storage.cookies) {
		if (([domain isEqualToString:@"*"] && name == NULL)
		 || ([domain isEqualToString:cookie.domain] && name == NULL)
		 || ([domain isEqualToString:cookie.domain] && [name isEqualToString:cookie.name])) {
			NSDictionary *properties = [[NSMutableDictionary alloc] init];

			[properties setValue:cookie.domain forKey:@"domain"];
			[properties setValue:cookie.name forKey:@"name"];
			[properties setValue:cookie.value forKey:@"value"];
			[properties setValue:cookie.path forKey:@"path"];
			[properties setValue:[formatter stringFromDate:cookie.expiresDate] forKey:@"expires"];

			[cookies addObject:properties];
		}
	}

	[formatter release];

	return cookies;
}

-(void)removeCookies:(id)args
{
	ENSURE_SINGLE_ARG_OR_NIL(args, NSDictionary);
	NSString *domain = [TiUtils stringValue:@"domain" properties:args def:@"*"];
	NSString *name = [args objectForKey:@"name"];

	NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];

	NSHTTPCookie *cookie;
	for (cookie in storage.cookies) {
		if (([domain isEqualToString:@"*"] && name == NULL)
		 || ([domain isEqualToString:cookie.domain] && name == NULL)
		 || ([domain isEqualToString:cookie.domain] && [name isEqualToString:cookie.name])) {
			NSDictionary *properties = [cookie properties];
			[properties setValue:[NSDate dateWithTimeIntervalSinceNow:-3600] forKey:NSHTTPCookieExpires];
			NSHTTPCookie *newCookie = [[NSHTTPCookie alloc] initWithProperties:properties];

			[storage deleteCookie:cookie];
			[storage setCookie:newCookie];
			[newCookie release];
		}
	}
}

@end
