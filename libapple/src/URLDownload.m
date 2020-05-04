//
//  URLDownload.m
//  PonyExpress
//
//  Created by Rocco Bowling on 4/23/20.
//  Copyright © 2020 Rocco Bowling. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "apple.h"

void Apple_URLDownload(String * uuid, String * url, URLDownload * sender) {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithUTF8String:String_val_cstring_o(url)]]];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error == NULL) {
                URLDownload_tag_responseSuccess_ooo__send(sender, uuid, Memory_tag_arrayFromCPointer_oZo(NULL, (char *)[data bytes], [data length]));
            }else{
                NSString * errorString = [error localizedDescription];
                URLDownload_tag_responseFail_ooo__send(sender, uuid, Memory_tag_stringFromCPointer_oZo(NULL, (char *)[errorString UTF8String], [errorString length]));
            }
        });
    }] resume];
}
