//
//  FPBulbSound.h
//  FunnyPuzzle
//
//  Created by Stas Volskyi on 27.06.14.
//  Copyright (c) 2014 Mobilez365. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FPBulbSound;

@protocol deleteBlob <NSObject>

- (void) deleteBlobById:(FPBulbSound*)blobID;

@end

@interface FPBulbSound : NSObject

@property (nonatomic) id<deleteBlob> delegate;

- (instancetype)initWithSoundURL:(NSURL *)url;
- (void) play;
@end

