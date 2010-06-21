/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2010 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiUIiOSAdView.h"
#import "TiUtils.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0

#ifdef USE_TI_UIIOSADVIEW

@implementation TiUIiOSAdView

-(void)dealloc
{
	RELEASE_TO_NIL(adview);
	[super dealloc];
}

-(UIView*)adview
{
	if (adview == nil)
	{
		adview = [[ADBannerView alloc] initWithFrame:CGRectZero];
		adview.delegate = self;
		[self addSubview:adview];
	}
	return adview;
}

-(void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
	
	if (!CGRectIsEmpty(bounds))
	{
		[TiUtils setView:[self adview] positionRect:bounds];
	}
}

-(NSString*)size
{
	return [self adview].currentContentSizeIdentifier;
}

-(void)setSize:(id)arg
{
	ENSURE_SINGLE_ARG(arg,NSString);
	[self adview].currentContentSizeIdentifier = arg;
}

#pragma mark Public APIs

-(void)cancelAction:(id)args
{
	if (adview!=nil)
	{
		[adview cancelBannerViewAction];
	}
}

#pragma mark Delegates

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
	if (TI_APPLICATION_ANALYTICS)
	{
		NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:data,@"data",@"ti.iad.load",@"name",@"ti.iad.load",@"type",[banner currentContentSizeIdentifier],@"size",nil];
		[[NSNotificationCenter defaultCenter] postNotificationName:kTiAnalyticsNotification object:nil userInfo:event]; 
	}
	if ([self.proxy _hasListeners:@"load"])
	{
		NSMutableDictionary *event = [NSMutableDictionary dictionary];
		[self.proxy fireEvent:@"load" withObject:event];
	}
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
	if (TI_APPLICATION_ANALYTICS)
	{
		NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:data,@"data",@"ti.iad.action",@"name",@"ti.iad.action",@"type",[banner currentContentSizeIdentifier],@"size",nil];
		[[NSNotificationCenter defaultCenter] postNotificationName:kTiAnalyticsNotification object:nil userInfo:event]; 
	}
	if ([self.proxy _hasListeners:@"action"])
	{
		NSMutableDictionary *event = [NSMutableDictionary dictionary];
		[self.proxy fireEvent:@"action" withObject:event];
	}
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
	return YES;
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	if ([self.proxy _hasListeners:@"error"])
	{
		NSMutableDictionary *event = [NSMutableDictionary dictionary];
		[event setObject:[error description] forKey:@"message"];
		[self.proxy fireEvent:@"error" withObject:event];
	}
}

@end


#endif

#endif