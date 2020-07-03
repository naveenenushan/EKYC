//
//  AAILivenessWrapViewController.h
//  AAILivenessDemo
//
//  Created by Advance.ai on 2019/3/2.
//  Copyright © 2019 Advance.ai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAILivenessViewController.h"
#import <AAILivenessSDK/AAILivenessSDK.h>
#import "AAIHUD.h"
#import "AAILivenessResultViewController.h"
#import "AAILivenessUtil.h"
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN

@protocol livenessCallback

- (void)getLivenessId:(NSString *)livenessID;
- (void)getLivenessImage:(UIImage *)livenessImage;
- (void)livenessError;
- (void)onBackBtnAction;

@end

@interface AAILivenessViewController : UIViewController

@property (nonatomic, weak) id<livenessCallback> delegate;

@end

NS_ASSUME_NONNULL_END
