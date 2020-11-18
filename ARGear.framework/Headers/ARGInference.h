//
//  ARGInference.h
//  ARGear
//
//  Created by Jaecheol Kim on 2019/10/29.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreVideo/CoreVideo.h>
#import <simd/simd.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, InferenceState) {
    ARGInferenceStateTracking,
    ARGInferenceStatePause,
    ARGInferenceStateStop,
    ARGInferenceStateClean
};

//NS_OPTIONS로 bitmask를 만듬
typedef NS_OPTIONS (NSInteger,ARGInferenceFeature)  {
    ARGInferenceFeatureFaceLowTracking          = 1 << 0,
//    ARGInferenceFeatureFaceHighTracking         = 1 << 1,
//    ARGInferenceFeatureFaceMeshTracking         = 1 << 2,
//    ARGInferenceFeatureFaceBlendShapes          = 1 << 3,
//    ARGInferenceFeatureSegmentationHalf         = 1 << 4,
//    ARGInferenceFeatureSegmentationFull         = 1 << 5,
//    ARGInferenceFeatureHandTracking             = 1 << 6,
//    ARGInferenceFeatureHandLandmark2D           = 1 << 7,
//    ARGInferenceFeatureHandLandmark3D           = 1 << 8,
//    ARGInferenceFeatureBodyTracking             = 1 << 9,
//    ARGInferenceFeatureBodyPose2D               = 1 << 10,
//    ARGInferenceFeatureBodyPose3D               = 1 << 11,
};

typedef NS_OPTIONS (NSInteger,ARGInferenceDebugOption)  {
   ARGInferenceOptionDebugNON                        = 1 << 0,
   ARGInferenceOptionDebugFaceTracking               = 1 << 1,
   ARGInferenceOptionDebugFaceLandmark2D             = 1 << 2
};

@interface ARGInference : NSObject
@property(nonatomic, readonly) InferenceState status;
@property(nonatomic, assign) BOOL debug;

// start inference
- (void)start;

// pause inference
- (void)pause;

// stop inference
- (void)stop;

// clear inference
- (void)clean;

@end

NS_ASSUME_NONNULL_END
