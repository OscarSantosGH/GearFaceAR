//
//  ARGFrame.h
//  ARGear
//
//  Created by Jaecheol Kim on 2019/10/28.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreVideo/CoreVideo.h>
#import <UIKit/UIKit.h>
#import <simd/simd.h>

@class ARGFaces;
@class ARGSegmentation;

NS_ASSUME_NONNULL_BEGIN

@interface ARGFrame : NSObject

@property(nonatomic, readonly) ARGFaces *faces;
@property(nonatomic, readonly, nullable) ARGSegmentation *segmentation;
@property(nonatomic, readonly, nullable) CVPixelBufferRef capturedPixelBuffer;
@property(nonatomic, readonly, nullable) CVPixelBufferRef renderedPixelBuffer;
@property(nonatomic, readonly) NSTimeInterval timestamp;
@property(nonatomic, readonly) NSUInteger deviceRotation;

- (CGAffineTransform)displayTransform;

- (CGAffineTransform)displayTransformForFrameSize:(CGSize)frameSize
presentationOrientation:(UIDeviceOrientation)presentationOrientation
               mirrored:(BOOL)mirrored;

@end

NS_ASSUME_NONNULL_END
