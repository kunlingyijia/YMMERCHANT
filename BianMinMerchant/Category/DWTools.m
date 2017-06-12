
//
//  DWTools.m
//  BianMin
//
//  Created by z on 16/5/3.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "DWTools.h"

@implementation DWTools


+ (NSString *)getXKVersion{
    NSDictionary *info= [[NSBundle mainBundle] infoDictionary];
    return info[@"CFBundleShortVersionString"];
}

+ (NSString *)getXKBuildVersion{
    NSDictionary *info= [[NSBundle mainBundle] infoDictionary];
    return info[@"CFBundleVersion"];
}

+ (BOOL)compareHasNewVersion:(NSString *)compareVerion{
    NSString *localVersion = [DWTools getXKVersion];
    NSInteger localMajorVersion = 0;
    NSInteger localMinorVersion = 0;
    NSInteger localTinyVersion = 0;
    
    NSInteger compareMajorVersion = 0;
    NSInteger compareMinorVersion = 0;
    NSInteger compareTinyVersion = 0;
    
    NSArray *localVersions = [localVersion componentsSeparatedByString:@"."];
    if (localVersions.count >= 1) {
        localMajorVersion = [[localVersions objectAtIndex:0] integerValue];
    }
    if (localVersions.count >= 2) {
        localMinorVersion = [[localVersions objectAtIndex:1] integerValue];
    }
    if (localVersions.count >= 3) {
        localTinyVersion = [[localVersions objectAtIndex:2] integerValue];
    }
    
    NSArray *compareVersions = [compareVerion componentsSeparatedByString:@"."];
    if (compareVersions.count >= 1) {
        compareMajorVersion = [[compareVersions objectAtIndex:0] integerValue];
    }
    if (compareVersions.count >= 2) {
        compareMinorVersion = [[compareVersions objectAtIndex:1] integerValue];
    }
    if (compareVersions.count >= 3) {
        compareTinyVersion = [[compareVersions objectAtIndex:2] integerValue];
    }
    
    if (compareMajorVersion > localMajorVersion) {
        return YES;
    }
    if (compareMinorVersion > localMinorVersion) {
        return YES;
    }
    if (compareTinyVersion > localTinyVersion) {
        return YES;
    }
    return NO;
}

@end
