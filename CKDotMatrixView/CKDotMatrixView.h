//
//  CKDotMatrixView.h
//  CKDotMatrixView
//
//  Created by Christian Klaproth on 02.12.14.
//  Copyright (c) 2014 Christian Klaproth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKDotMatrixFontMapping.h"

IB_DESIGNABLE

@interface CKDotMatrixView : UIView

@property (nonatomic) IBInspectable NSUInteger horizontalDotCount;
@property (nonatomic) IBInspectable NSUInteger verticalDotCount;
@property (nonatomic) CKDotMatrixFontMapping* fontMapping;
@property (nonatomic) IBInspectable NSString* text;
@property (nonatomic) IBInspectable BOOL animated;

@end
