//
//  libapple.m
//  libapple
//
//  Created by Rocco Bowling on 4/25/20.
//  Copyright © 2020 Rocco Bowling. All rights reserved.
//

#import "libapple.h"

void pony_retain_actor(pony_ctx_t * ctx, void * obj)
{
    pony_gc_acquire(ctx);
    pony_traceactor(ctx, obj);
    pony_acquire_done(ctx);
}

void pony_release_actor(pony_ctx_t * ctx, void * obj)
{
    pony_gc_release(ctx);
    pony_traceactor(ctx, obj);
    pony_release_done(ctx);

}
