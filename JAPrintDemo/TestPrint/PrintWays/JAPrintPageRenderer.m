//
//  JAPrintPageRenderer.m
//  TestPrint
//
//  Created by Jacob_Liang on 2018/9/14.
//  Copyright © 2018年 Jacob. All rights reserved.
//

#import "JAPrintPageRenderer.h"

@implementation JAPrintPageRenderer


- (instancetype)init {
    self = [super init];
    if(self) {
        self.headerHeight = 0;
        self.footerHeight = 0;
    }
    return self;
}

//
// Set whatever header, footer and insets you want. It is
// important to set these values to something, so that the print
// formatters can figure out their own pageCounts for whatever
// they contain. Look at the Apple sample App for PrintWebView for
// for more details about these values.
//
- (NSInteger)numberOfPages {
    __block NSUInteger startPage = 0;
    for(UIPrintFormatter *pf in self.printFormatters) {
        pf.perPageContentInsets = UIEdgeInsetsZero;
        pf.maximumContentWidth = self.printableRect.size.width;
        pf.maximumContentHeight = self.printableRect.size.height;

        dispatch_async(dispatch_get_main_queue(), ^{
            pf.startPage = startPage;
            startPage = pf.startPage + pf.pageCount;
        });
    }
    return [super numberOfPages];
}

@end
