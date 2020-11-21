//
//  ARGConfig.h
//  ARGear
//
//  Created by Jaecheol Kim on 2019/10/28.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ARGConfig : NSObject
@property (nonatomic, strong) NSString *_Nonnull apiURL;
@property (nonatomic, strong) NSString *_Nonnull apiKey;
@property (nonatomic, strong) NSString *_Nonnull secretKey;
@property (nonatomic, strong) NSString *_Nonnull authKey;


- (id)initWithApiURL:(NSString *)apiURL apiKey:(NSString *)apiKey secretKey:(NSString *)secretKey authKey:(NSString *)authKey;

@end

NS_ASSUME_NONNULL_END
