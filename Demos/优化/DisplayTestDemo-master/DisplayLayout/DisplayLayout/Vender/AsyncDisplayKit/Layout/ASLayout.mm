//
//  ASLayout.mm
//  AsyncDisplayKit
//
//  Copyright (c) 2014-present, Facebook, Inc.  All rights reserved.
//  This source code is licensed under the BSD-style license found in the
//  LICENSE file in the root directory of this source tree. An additional grant
//  of patent rights can be found in the PATENTS file in the same directory.
//

#import "ASLayout.h"

#import "ASDimension.h"
#import "ASInternalHelpers.h"
#import "ASLayoutSpecUtilities.h"

#import <queue>
#import "ASObjectDescriptionHelpers.h"

CGPoint const CGPointNull = {NAN, NAN};

extern BOOL CGPointIsNull(CGPoint point)
{
  return isnan(point.x) && isnan(point.y);
}

/**
 * Creates an defined number of "    |" indent blocks for the recursive description.
 */
static inline NSString * descriptionIndents(NSUInteger indents)
{
  NSMutableString *description = [NSMutableString string];
  for (NSUInteger i = 0; i < indents; i++) {
    [description appendString:@"    |"];
  }
  if (indents > 0) {
    [description appendString:@" "];
  }
  return description;
}

@interface ASLayout () <ASDescriptionProvider>

/**
 * A boolean describing if the current layout has been flattened.
 */
@property (nonatomic, getter=isFlattened) BOOL flattened;

@end

@implementation ASLayout

@dynamic frame, type;

- (instancetype)initWithLayoutable:(id<ASLayoutable>)layoutable
                              size:(CGSize)size
                          position:(CGPoint)position
                        sublayouts:(nullable NSArray<ASLayout *> *)sublayouts
{
  NSParameterAssert(layoutable);
  
  self = [super init];
  if (self) {
#if DEBUG
    for (ASLayout *sublayout in sublayouts) {
      ASDisplayNodeAssert(CGPointIsNull(sublayout.position) == NO, @"Invalid position is not allowed in sublayout.");
    }
#endif
    
    _layoutable = layoutable;
    
    if (!ASIsCGSizeValidForLayout(size)) {
      ASDisplayNodeAssert(NO, @"layoutSize is invalid and unsafe to provide to Core Animation! Release configurations will force to 0, 0.  Size = %@, node = %@", NSStringFromCGSize(size), layoutable);
      size = CGSizeZero;
    } else {
      size = CGSizeMake(ASCeilPixelValue(size.width), ASCeilPixelValue(size.height));
    }
    _size = size;
    
    if (CGPointIsNull(position) == NO) {
      _position = CGPointMake(ASCeilPixelValue(position.x), ASCeilPixelValue(position.y));
    } else {
      _position = position;
    }

    _sublayouts = sublayouts != nil ? [sublayouts copy] : @[];
    _flattened = NO;
  }
  return self;
}

- (instancetype)init
{
  ASDisplayNodeAssert(NO, @"Use the designated initializer");
  return [self init];
}

#pragma mark - Class Constructors

+ (instancetype)layoutWithLayoutable:(id<ASLayoutable>)layoutable
                                size:(CGSize)size
                            position:(CGPoint)position
                          sublayouts:(nullable NSArray<ASLayout *> *)sublayouts
{
  return [[self alloc] initWithLayoutable:layoutable
                                     size:size
                                 position:position
                               sublayouts:sublayouts];
}

+ (instancetype)layoutWithLayoutable:(id<ASLayoutable>)layoutable
                                size:(CGSize)size
                          sublayouts:(nullable NSArray<ASLayout *> *)sublayouts
{
  return [self layoutWithLayoutable:layoutable
                               size:size
                           position:CGPointNull
                         sublayouts:sublayouts];
}

+ (instancetype)layoutWithLayoutable:(id<ASLayoutable>)layoutable size:(CGSize)size
{
  return [self layoutWithLayoutable:layoutable
                               size:size
                           position:CGPointNull
                         sublayouts:nil];
}

+ (instancetype)layoutWithLayout:(ASLayout *)layout position:(CGPoint)position
{
  return [self layoutWithLayoutable:layout.layoutable
                               size:layout.size
                           position:position
                         sublayouts:layout.sublayouts];
}

#pragma mark - Layout Flattening

- (ASLayout *)filteredNodeLayoutTree
{
  NSMutableArray *flattenedSublayouts = [NSMutableArray array];
  
  struct Context {
    ASLayout *layout;
    CGPoint absolutePosition;
  };
  
  // Queue used to keep track of sublayouts while traversing this layout in a BFS fashion.
  std::queue<Context> queue;
  queue.push({self, CGPointMake(0, 0)});
  
  while (!queue.empty()) {
    Context context = queue.front();
    queue.pop();

    if (self != context.layout && context.layout.type == ASLayoutableTypeDisplayNode) {
      ASLayout *layout = [ASLayout layoutWithLayout:context.layout position:context.absolutePosition];
      layout.flattened = YES;
      [flattenedSublayouts addObject:layout];
    }
    
    for (ASLayout *sublayout in context.layout.sublayouts) {
      if (sublayout.isFlattened == NO) {
        queue.push({sublayout, context.absolutePosition + sublayout.position});
      }
    }
  }

  return [ASLayout layoutWithLayoutable:_layoutable size:_size sublayouts:flattenedSublayouts];
}

#pragma mark - Accessors

- (ASLayoutableType)type
{
  return _layoutable.layoutableType;
}

- (CGRect)frame
{
  CGRect subnodeFrame = CGRectZero;
  CGPoint adjustedOrigin = _position;
  if (isfinite(adjustedOrigin.x) == NO) {
    ASDisplayNodeAssert(0, @"Layout has an invalid position");
    adjustedOrigin.x = 0;
  }
  if (isfinite(adjustedOrigin.y) == NO) {
    ASDisplayNodeAssert(0, @"Layout has an invalid position");
    adjustedOrigin.y = 0;
  }
  subnodeFrame.origin = adjustedOrigin;
  
  CGSize adjustedSize = _size;
  if (isfinite(adjustedSize.width) == NO) {
    ASDisplayNodeAssert(0, @"Layout has an invalid size");
    adjustedSize.width = 0;
  }
  if (isfinite(adjustedSize.height) == NO) {
    ASDisplayNodeAssert(0, @"Layout has an invalid position");
    adjustedSize.height = 0;
  }
  subnodeFrame.size = adjustedSize;
  
  return subnodeFrame;
}

#pragma mark - Description

- (NSMutableArray <NSDictionary *> *)propertiesForDescription
{
  NSMutableArray *result = [NSMutableArray array];
  [result addObject:@{ @"layoutable" : (self.layoutable ?: (id)kCFNull) }];
  [result addObject:@{ @"position" : [NSValue valueWithCGPoint:self.position] }];
  [result addObject:@{ @"size" : [NSValue valueWithCGSize:self.size] }];
  return result;
}

- (NSString *)description
{
  return ASObjectDescriptionMake(self, [self propertiesForDescription]);
}

- (NSString *)recursiveDescription
{
  return [self _recursiveDescriptionForLayout:self level:0];
}

- (NSString *)_recursiveDescriptionForLayout:(ASLayout *)layout level:(NSUInteger)level
{
  NSMutableString *description = [NSMutableString string];
  [description appendString:descriptionIndents(level)];
  [description appendString:[layout description]];
  for (ASLayout *sublayout in layout.sublayouts) {
    [description appendString:@"\n"];
    [description appendString:[self _recursiveDescriptionForLayout:sublayout level:level + 1]];
  }
  return description;
}

@end

ASLayout *ASCalculateLayout(id<ASLayoutable> layoutable, const ASSizeRange sizeRange, const CGSize parentSize)
{
  ASDisplayNodeCAssertNotNil(layoutable, @"Not valid layoutable passed in.");
  
  return [layoutable layoutThatFits:sizeRange parentSize:parentSize];
}

ASLayout *ASCalculateRootLayout(id<ASLayoutable> rootLayoutable, const ASSizeRange sizeRange)
{
  ASLayout *layout = ASCalculateLayout(rootLayoutable, sizeRange, sizeRange.max);
  // Here could specific verfication happen
  return layout;
}

