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

void Apple_URLDownload(apple_URLDownload * sender, String * uuid, String * method, String * body, String * url) {
    NSString * urlString = [NSString stringWithUTF8String:String_val_cstring_o(url)];
    NSString * methodString = [NSString stringWithUTF8String:String_val_cstring_o(method)];
    NSString * bodyString = [NSString stringWithUTF8String:String_val_cstring_o(body)];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                              cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                          timeoutInterval:30];

    NSString *charset = (NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    [request setValue:[NSString stringWithFormat:@"application/json; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"0" forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    [request setValue:@"" forHTTPHeaderField:@"Accept"];
    [request setValue:@"" forHTTPHeaderField:@"Accept-Language"];
    
    [request setHTTPMethod:methodString];
    
    if ([bodyString length] > 0) {
        [request setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
        [request setValue:[NSString stringWithFormat:@"%lu", [bodyString length]] forHTTPHeaderField:@"Content-Length"];
    }
        
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

