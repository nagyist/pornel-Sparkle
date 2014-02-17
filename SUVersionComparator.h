//
//  SUVersionComparator.h
//  Sparkle
//
//  Created by macdeveloper on 2014.02.17..
//
//
#import <Foundation/Foundation.h>

#ifndef SUVERSIONCOMPARATOR_H
#define SUVERSIONCOMPARATOR_H


@interface SUVersionComparator : NSObject

+ (BOOL)isVersion:(NSString *)versionA greaterThanVersion:(NSString *)versionB;
+ (BOOL)isVersion:(NSString *)versionA greaterThanOrEqualToVersion:(NSString *)versionB;
+ (NSArray *)normaliseValuesFromArray:(NSArray *)array;

@end

#endif
