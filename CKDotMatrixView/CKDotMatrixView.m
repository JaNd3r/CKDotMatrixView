//
//  CKDotMatrixView.m
//  CKDotMatrixView
//
//  Created by Christian Klaproth on 02.12.14.
//  Copyright (c) 2014 Christian Klaproth. All rights reserved.
//

#import "CKDotMatrixView.h"

@interface CKDotMatrixView()

@property (nonatomic) BOOL horizontalDotCountSpecified;
@property (nonatomic) BOOL verticalDotCountSpecified;
@property (nonatomic) BOOL matrixInitialized;
@property (nonatomic) UIColor* dotOffColor;
@property (nonatomic) UIColor* dotGlowColor;
@property (nonatomic) NSMutableDictionary* textMatrix;

@property (nonatomic) NSUInteger animationOffset;
@property (nonatomic) NSUInteger animationStep;
@property (nonatomic) CGFloat animationDelay;

@end

@implementation CKDotMatrixView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self internalInitialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self internalInitialize];
    }
    return self;
}

- (void)prepareForInterfaceBuilder
{
    [super prepareForInterfaceBuilder];
    [self internalInitialize];
    if (self.text) {
        [self internalShowText];
    }
}

- (void)internalInitialize
{
    self.fontMapping = [CKDotMatrixFontMapping new];
    self.textMatrix = [NSMutableDictionary new];
    self.opaque = YES;
    self.horizontalDotCountSpecified = NO;
    self.verticalDotCountSpecified = NO;
    self.matrixInitialized = NO;
    CGFloat tRed = 0.0;
    CGFloat tGreen = 0.0;
    CGFloat tBlue = 0.0;
    CGFloat tAlpha = 0.0;
    [self.backgroundColor getRed:&tRed green:&tGreen blue:&tBlue alpha:&tAlpha];
    self.dotOffColor = [[UIColor alloc] initWithRed:tRed+0.12 green:tGreen+0.12 blue:tBlue+0.12 alpha:tAlpha];
    
    [self.tintColor getRed:&tRed green:&tGreen blue:&tBlue alpha:&tAlpha];
    self.dotGlowColor = [[UIColor alloc] initWithRed:MAX(tRed+0.05, 1.0) green:MAX(tGreen+0.05, 1.0) blue:MAX(tBlue+0.05, 1.0) alpha:0.90];
    
    self.animationStep = 2;
    self.animationDelay = 0.05;
    self.animationOffset = 0;
}

- (void)setHorizontalDotCount:(NSUInteger)horizontalDotCount
{
    _horizontalDotCount = horizontalDotCount;
    self.horizontalDotCountSpecified = YES;
}

- (void)setVerticalDotCount:(NSUInteger)verticalDotCount
{
    _verticalDotCount = verticalDotCount;
    self.verticalDotCountSpecified = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (self.horizontalDotCountSpecified && self.verticalDotCountSpecified) {
        [self initializeMatrix];
    }
}

- (void)initializeMatrix
{
    for (int y=0; y<self.verticalDotCount; y++) {
        for (int x=0; x<self.horizontalDotCount; x++) {
            NSString* tKey = [NSString stringWithFormat:@"%i", (y+1) * 1000 + (x+1)];
            [self.textMatrix setValue:@"0" forKey:tKey];
        }
    }
    
    self.matrixInitialized = YES;
    
    if (self.text) {
        [self internalShowText];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef tContext = UIGraphicsGetCurrentContext();
    CGSize tSize = self.bounds.size;
    CGFloat tDotWidth = tSize.width / self.horizontalDotCount;
    CGFloat tDotHeight = tSize.height / self.verticalDotCount;
    CGContextSetShadow(tContext, CGSizeMake(0.0, 0.0), 0.0);
    CGContextSetFillColorWithColor(tContext, self.dotOffColor.CGColor);
    for (int y=0; y<self.verticalDotCount; y++) {
        for (int x=0; x<self.horizontalDotCount; x++) {
            CGRect tDotRect = CGRectMake(x * tDotWidth, y * tDotHeight, tDotWidth-1, tDotHeight-1);
            CGContextFillRect(tContext, tDotRect);
        }
    }
    [self drawIlluminatedDots];
}

- (void)drawIlluminatedDots
{
    BOOL tInitialDot = YES;
    CGContextRef tContext = UIGraphicsGetCurrentContext();
    CGSize tSize = self.bounds.size;
    CGFloat tDotWidth = tSize.width / self.horizontalDotCount;
    CGFloat tDotHeight = tSize.height / self.verticalDotCount;
    for (int y=0; y<self.verticalDotCount; y++) {
        for (unsigned long x=self.animationOffset; x<self.horizontalDotCount; x++) {
            CGRect tDotRect = CGRectMake(x * tDotWidth, y * tDotHeight, tDotWidth-1, tDotHeight-1);
            NSString* tKey = [NSString stringWithFormat:@"%li", (y+1) * 1000 + (x+1) - self.animationOffset];
            if ([[self.textMatrix valueForKey:tKey] integerValue] == 1) {
                if (tInitialDot) {
                    CGContextSetFillColorWithColor(tContext, self.tintColor.CGColor);
                    CGContextSetShadowWithColor(tContext, CGSizeMake(0.0, 0.0), 4, self.dotGlowColor.CGColor);
                    tInitialDot = NO;
                }
                CGContextMoveToPoint(tContext, x, y);
                CGContextFillRect(tContext, tDotRect);
            }
        }
    }
    
#if TARGET_INTERFACE_BUILDER
    self.animationOffset = 0;
#endif

    if (self.animationOffset > 0) {
        if (self.animationStep > self.animationOffset) {
            self.animationOffset = 0;
        } else {
            self.animationOffset = self.animationOffset - self.animationStep;
        }
        [self performSelector:@selector(setNeedsDisplay) withObject:nil afterDelay:self.animationDelay];
    }
}

- (void)setText:(NSString *)text
{
    _text = text;
    if (self.matrixInitialized) {
        [self internalShowText];
    }
}

- (void)internalShowText
{
#if !TARGET_INTERFACE_BUILDER
    if (self.animated) {
        self.animationOffset = self.horizontalDotCount;
    }
#endif
    
    int tCurrentPosition = 0;
    int tCurrentWidth = 0;
    for (int i=0; i<self.text.length; i++) {
        NSString* tCharacter = [self.text substringWithRange:NSMakeRange(i, 1)];
        NSArray* tCharacterMatrix = [self.fontMapping.defaultMapping valueForKey:tCharacter];
        
        for (int tRow=0; tRow<tCharacterMatrix.count; tRow++) {
            NSString* tMatrixRow = tCharacterMatrix[tRow];
            tCurrentWidth = (int)tMatrixRow.length;
            for (int j=0; j<tMatrixRow.length; j++) {
                NSString* tOnOrOff = [tMatrixRow substringWithRange:NSMakeRange(j, 1)];
                NSString* tKey = [NSString stringWithFormat:@"%i", (tRow+1) * 1000 + (j+1) + tCurrentPosition];
                [self.textMatrix setValue:tOnOrOff forKey:tKey];
            }
        }
        tCurrentPosition += tCurrentWidth;
    }
    
#if !TARGET_INTERFACE_BUILDER
    [self setNeedsDisplay];
#endif
    
}

@end
