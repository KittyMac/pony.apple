//
//  URLDownload.m
//  PonyExpress
//
//  Created by Rocco Bowling on 4/23/20.
//  Copyright © 2020 Rocco Bowling. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "apple.h"
#include "libapple.h"

void Apple_URLDownload(String * uuid, String * url, apple_URLDownload * sender) {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithUTF8String:String_val_cstring_o(url)]]];
    
    pony_ctx_t * ctx = pony_ctx();
    
    pony_retain_actor(ctx, sender);
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error == NULL) {
                apple_URLDownload_tag_responseSuccess_ooo__send(sender, uuid, apple_Memory_tag_arrayFromCPointer_oZo(NULL, (char *)[data bytes], [data length]));
            }else{
                NSString * errorString = [error localizedDescription];
                apple_URLDownload_tag_responseFail_ooo__send(sender, uuid, apple_Memory_tag_stringFromCPointer_oZo(NULL, (char *)[errorString UTF8String], [errorString length]));
            }
            
            pony_release_actor(ctx, sender);
        });
    }] resume];
}
