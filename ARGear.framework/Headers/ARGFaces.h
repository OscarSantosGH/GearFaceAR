//
//  ARGFaces.h
//  ARGear
//
//  Created by Jaecheol Kim on 2019/10/29.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "ARGInference.h"
#define MAX_FACES 5
NS_ASSUME_NONNULL_BEGIN

@class ARGFace;
@interface ARGFaces : ARGInference
@property(nonatomic, readonly) NSArray<ARGFace *> *faceList;
@property(nonatomic, readonly) NSUInteger validFaceCount;

@end

NS_ASSUME_NONNULL_END
