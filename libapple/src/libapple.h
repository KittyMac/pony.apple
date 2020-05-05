//
//  libapple.h
//  libapple
//
//  Created by Rocco Bowling on 4/25/20.
//  Copyright © 2020 Rocco Bowling. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "atomics.h"
#include "pony.h"

void pony_retain_actor(pony_ctx_t * ctx, void * obj);
void pony_release_actor(pony_ctx_t * ctx, void * obj);
