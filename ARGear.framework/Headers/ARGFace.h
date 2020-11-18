//
//  ARGFace.h
//  ARGear
//
//  Created by Jaecheol Kim on 2019/10/29.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "ARGInference.h"


NS_ASSUME_NONNULL_BEGIN

@class ARGFaceLandmark;
@class ARGFaceMesh;
@class ARGFaceBlendShape;

@interface ARGFace : ARGInference
@property(nonatomic, readonly) ARGFaceLandmark *landmark;
@property(nonatomic, readonly) ARGFaceMesh *mesh;
@property(nonatomic, readonly) ARGFaceBlendShape *blendShape;
@property(nonatomic, readonly) simd_float4x4 centerTransform;
@property(nonatomic, readonly) simd_double3x3 rotation_matrix;
@property(nonatomic, readonly) simd_double3 translation_vector;  
@property(nonatomic, readonly) BOOL isValid;

- (void)convertFaceObject:(id)faceobj;

@end

NS_ASSUME_NONNULL_END
