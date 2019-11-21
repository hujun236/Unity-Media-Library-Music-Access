//
//  LocalMediaHelper.h
//  JFunGameSDKDemo
//
//  Created by yons on 2019/7/31.
//  Copyright © 2019 jfungame. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocalMediaHelper : NSObject
+(NSString*)GetAllMusicReturnJson;
+(void)GetPathByID:(NSString*)ID;
@end


NS_ASSUME_NONNULL_END
