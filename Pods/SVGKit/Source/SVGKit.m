//
//  SVGKit.m
//  SVGKit-iOS
//
//  Created by Devon Blandin on 5/13/13.
//  Copyright (c) 2013 na. All rights reserved.
//

#import "SVGKit.h"
#import "CocoaLumberjack/DDTTYLogger.h"
#import "CocoaLumberjack/DDASLLogger.h"

@implementation SVGKit : NSObject

+ (void) enableLogging {
    [DDLog addLogger:[DDOSLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
}

@end
