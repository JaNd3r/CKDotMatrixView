//
//  CKDotMatrixView.h
//  CKDotMatrixView
//
//  Created by Christian Klaproth on 02.12.14.
//  Copyright (c) 2014 Christian Klaproth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKDotMatrixFontMapping.h"

@interface CKDotMatrixView : UIView

@property (nonatomic) NSUInteger horizontalDotCount;
@property (nonatomic) NSUInteger verticalDotCount;
@property (nonatomic) CKDotMatrixFontMapping* fontMapping;
@property (nonatomic) NSString* text;
@property (nonatomic) BOOL animated;

@end
