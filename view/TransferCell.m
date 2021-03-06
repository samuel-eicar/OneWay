//
//  TransferCell.m
//		
//
//  Copyright 2010 Nick Jensen <http://goto11.net>
//

#import "TransferCell.h"
#import "ProgressGradients.h"
#import "ProgressMeter.h"


@implementation TransferCell


- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	[super drawWithFrame:cellFrame inView:controlView];
	
	Upload *record = (Upload *)[self objectValue];
	
	// Make attributes for our strings
	NSMutableParagraphStyle *paragraphStyle = [[[NSMutableParagraphStyle alloc] init] autorelease];
	
	[paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
	
	// Title attributes: system font, 14pt, black, truncate tail
	NSMutableDictionary *titleAttributes = [[[NSMutableDictionary alloc] initWithObjectsAndKeys:
											 [NSColor blackColor], NSForegroundColorAttributeName,
											 [NSFont systemFontOfSize:11.0], NSFontAttributeName, 
											 paragraphStyle, NSParagraphStyleAttributeName, nil] autorelease];
	
	
	// Subtitle attributes: system font, 10pt, gray, truncate tail
	NSMutableDictionary * statusAttributes = [[[NSMutableDictionary alloc] initWithObjectsAndKeys:
											   [NSColor grayColor], NSForegroundColorAttributeName,
											   [NSFont systemFontOfSize:10.0],NSFontAttributeName,
											   paragraphStyle, NSParagraphStyleAttributeName, nil] autorelease];
	
	
	// Text will be white if selected 
	if(	[self isHighlighted] )
	{		
		[titleAttributes setValue:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
		[statusAttributes setValue:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
	}
	else
	{
		[titleAttributes setValue:[NSColor blackColor] forKey:NSForegroundColorAttributeName];
		[statusAttributes setValue:[NSColor grayColor] forKey:NSForegroundColorAttributeName];
	}
	
	
	const int HORIZONTAL_PADDING = 10;
	const int VERTICAL_PADDING = 3;
	
	
	// Outter most rectangle
	NSRect outterRect = NSInsetRect([self drawingRectForBounds:cellFrame], 10.5, 7.5);
	NSString *imageName = nil;
	// Make the icon
	switch ([record status]) {

		default:
		case TRANSFER_STATUS_UPLOADING:
			imageName = @"uploading";
			break;
			
		case TRANSFER_STATUS_COMPLETE:
			imageName = @"finished";
			break;
			
		case TRANSFER_STATUS_FAILED:
		case TRANSFER_STATUS_LOGIN_DENIED:
		case TRANSFER_STATUS_CANCELLED:
			imageName = @"warning";			
	}
	
	NSImage *icon = [NSImage imageNamed:imageName];
	
	NSSize iconSize = NSMakeSize(32, 32);
	[icon setSize:iconSize];
	[icon setFlipped:YES];
	
	NSRect iconRect = NSMakeRect(outterRect.origin.x, 
								 outterRect.origin.y + ((outterRect.size.height / 2) - (iconSize.height / 2)),
								 iconSize.width, 
								 iconSize.height);
	
	[icon drawInRect:iconRect 
			fromRect:NSZeroRect 
		   operation:NSCompositeSourceOver 
			fraction:1.0];
	

	int fullWidth = outterRect.size.width - iconSize.width - HORIZONTAL_PADDING;
	
	
	// Make the title
	NSString *title = [record name] ? [NSString stringWithString:[record name]] : @"";
	
	NSSize titleSize = [title sizeWithAttributes:titleAttributes];
	NSRect titleRect = NSMakeRect(outterRect.origin.x + iconSize.width + HORIZONTAL_PADDING, 
								  outterRect.origin.y,
								  fullWidth,
								  titleSize.height);
	
	[title drawInRect:titleRect withAttributes:titleAttributes];	
	
	// Make the status
	NSString *status = [record statusMessage] ? [NSString stringWithString:[record statusMessage]] : @"";		
	NSSize statusSize = [status sizeWithAttributes:statusAttributes];
	
	NSRect statusRect = NSMakeRect(titleRect.origin.x,
								   titleRect.origin.y + statusSize.height + VERTICAL_PADDING,
								   fullWidth,
								   statusSize.height);
	
	[status drawInRect:statusRect withAttributes:statusAttributes];

	
	// Make the progress bar
	NSRect progressOutline = NSMakeRect(statusRect.origin.x,
										statusRect.origin.y + statusSize.height + 1.5, 
										fullWidth, 
										NSProgressIndicatorPreferredSmallThickness + .5);
	
	[[ProgressGradients progressLightGrayGradient] drawInRect:progressOutline angle:90];
	
	double progress = [record progress] * progressOutline.size.width / 100 - 1;
	
	if (progress > 0)
	{
		NSRect progressFill = NSMakeRect(progressOutline.origin.x, 
										 progressOutline.origin.y + 0.5,
										 progress, NSProgressIndicatorPreferredSmallThickness - .5);
		
		if ([record status] == TRANSFER_STATUS_CANCELLED || [record status] == TRANSFER_STATUS_FAILED)
		{
			[[ProgressGradients progressRedGradient] drawInRect:progressFill angle:90];
		}
		else if ([record status] == TRANSFER_STATUS_COMPLETE)
		{
			[[ProgressGradients progressLightGreenGradient] drawInRect:progressFill angle:90];
		}
		else
		{
			[[ProgressGradients progressBlueGradient] drawInRect:progressFill angle:90];
		}
	}
	
	NSRect substatusRect = NSMakeRect(progressOutline.origin.x,
									  progressOutline.origin.y + statusSize.height + .5,
									  fullWidth,
									  statusSize.height);
	

	if ([record status] == TRANSFER_STATUS_UPLOADING || [record status] == TRANSFER_STATUS_COMPLETE || [record status] == TRANSFER_STATUS_CANCELLED)
	{
		NSString *substatus;
		
		if ([record isActive] && [record bytesPerSecond] > 0 && [record secondsRemaining] > 0)
		{
			substatus = [NSString stringWithFormat:@"%@ - %@ remaining", 
							[ProgressMeter uploadedAmount:record], [ProgressMeter uploadTimeRemaining:record]];
		}
		else
		{
			substatus = [ProgressMeter uploadedAmount:record];
			
		}
		
		[substatus drawInRect:substatusRect withAttributes:statusAttributes];
	}
	
} 


@end