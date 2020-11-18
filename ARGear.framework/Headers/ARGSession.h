//
//  ARGSession.h
//  ARGear
//
//  Created by Jaecheol Kim on 2019/10/28.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "ARGInference.h"

@class ARGConfig;
@class ARGFrame;
@class ARGContents;
@class ARGAuth;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ARGStatusCode) {
    // success
    ARGStatusCode_SUCCESS,

    // network
    ARGStatusCode_NETWORK_OFFLINE,          // offline
    ARGStatusCode_NETWORK_TIMEOUT,          // timeout
    ARGStatusCode_NETWORK_ERROR,            // error

    // auth
    ARGStatusCode_VALID_AUTH,               // default offline valid license, online valid license
    ARGStatusCode_INVALID_AUTH,             // default offline invalid license, online invalid session key, expired license

    // signed url
    ARGStatusCode_VALID_SIGNEDURL,          // valid signed url
    ARGStatusCode_INVALID_SIGNEDURL,        // signed url expired
};

typedef CGPoint (^ARGSessionProjectPointHandler) (simd_float3, UIInterfaceOrientation, CGSize);

#define ARGearSession [ARGSession sharedInstance]

@protocol ARGSessionDelegate <NSObject>
@required
- (void)didUpdateFrame:(ARGFrame *)frame;
@end

@interface ARGSession : NSObject
@property(nonatomic, readonly, nullable) ARGFrame *frame;
@property(nonatomic, readonly, nullable) ARGContents *contents;
@property(nonatomic, readonly, nullable) ARGAuth *auth;
@property(nonatomic, readonly) ARGInferenceFeature inferenceFeature;
@property(nonatomic, assign) ARGInferenceDebugOption inferenceDebugOption;
@property(nonatomic, assign, nullable) id<ARGSessionDelegate> delegate;
@property(nonatomic, nullable) dispatch_queue_t delegateQueue;

- (instancetype _Nullable)initWithARGConfig:(ARGConfig*)argconfig error:(NSError **)error;
- (instancetype _Nullable)initWithARGConfig:(ARGConfig*)argconfig feature:(ARGInferenceFeature)feature error:(NSError **)error;
- (void)destroy;

- (void)inferenceConfig:(ARGInferenceFeature) inferenceConfig;
- (void)runWithInferenceConfig:(ARGInferenceFeature)inferenceConfig;

- (void)run;
- (void)pause;

- (BOOL)updateSampleBuffer:(CMSampleBufferRef)sampleBuffer
                fromConnection:(AVCaptureConnection* __nullable)connection;

- (BOOL)updatePixelBuffer:(CVPixelBufferRef)pixelbuffer;

- (BOOL)updateMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects
                  fromConnection:(AVCaptureConnection *)connection;

- (void)feedPixelbuffer:(CVPixelBufferRef)pixelbuffer;

- (BOOL)applyAdditionalFaceInfoWithPixelbuffer:(CVPixelBufferRef)pixelbuffer
                                     transform:(simd_float4x4)transform
                                      vertices:(const simd_float3 *)vertices
                                  viewportSize:(CGSize)viewportSize
                                       convert:(ARGSessionProjectPointHandler)convertHandler;

- (id<MTLTexture>)getMetalTextureFromCVPixelBuffer:(CVPixelBufferRef)pixelbuffer
                                 metalTextureCache:(CVMetalTextureCacheRef)textureCache;

- (int)getGLTextureFromCVPixelBuffer:(CVPixelBufferRef)pixelbuffer
                      glTextureCache:(CVOpenGLESTextureCacheRef)textureCache;

- (void)setCVPixelBufferFromMTLTexture:(id<MTLTexture>)idY
                           textureCbCr:(id<MTLTexture>)idCbCr
                                 width:(int)width
                                height:(int)height
                      inoutPixelBuffer:(CVPixelBufferRef)pixelBuffer;

@end



NS_ASSUME_NONNULL_END
