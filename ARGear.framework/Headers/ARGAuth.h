//
//  ARGAuth.h
//  ARGEARSDK
//
//  Created by Jihye on 13/11/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARGSession.h"

NS_ASSUME_NONNULL_BEGIN

typedef __strong void (^ARGAuthCallback)(NSString * _Nullable url, ARGStatusCode code);

@interface ARGAuth : NSObject

- (BOOL)isValid;
- (void)requestSignedUrlWithUrl:(NSString *)url itemTitle:(NSString *)title itemType:(NSString *)type completion:(ARGAuthCallback)completion;

@end

NS_ASSUME_NONNULL_END
