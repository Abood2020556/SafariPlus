// Copyright (c) 2017-2019 Lars Fröder

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "../SafariPlus.h"
#import "../Defines.h"
#import "../Util.h"

%hook NavigationBar

%property (nonatomic,retain) BrowserToolbar *sp_toolbar;

%group iOS12_2Up
- (BrowserToolbar*)toolbarPlacedOnTop
{
	BrowserToolbar* toolbar = %orig;

	self.sp_toolbar = toolbar;

	return toolbar;
}
%end

%group iOS11_3Up
- (void)_updateNavigationBarTrailingButtonsVisibility
{
	%orig;
	if(activeToolbarForBrowserController(self.delegate)._reloadItem)
	{
		activeToolbarForBrowserController(self.delegate)._reloadItem.enabled = !MSHookIvar<UIButton*>(self, "_reloadButton").hidden;
	}
}
%end

%group iOS9Up
- (void)_updateNavigationBarRightButtonsVisibility
{
	%orig;
	if(activeToolbarForBrowserController(self.delegate)._reloadItem)
	{
		activeToolbarForBrowserController(self.delegate)._reloadItem.enabled = !MSHookIvar<UIButton*>(self, "_reloadButton").hidden;
	}
}
%end

%group iOS8
- (void)_updateStopReloadButtonVisibility
{
	%orig;
	if(activeToolbarForBrowserController(self.delegate)._reloadItem)
	{
		activeToolbarForBrowserController(self.delegate)._reloadItem.enabled = !MSHookIvar<UIButton*>(self, "_reloadButton").hidden;
	}
}
%end

%end

void initNavigationBar()
{
	%init();

	if(kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_12_2)
	{
		%init(iOS12_2Up);
	}

	if(kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_11_3)
	{
		%init(iOS11_3Up);
	}
	else if(kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_9_0)
	{
		%init(iOS9Up);
	}
	else
	{
		%init(iOS8);
	}
}
