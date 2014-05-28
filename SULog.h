/*
 *  SULog.h
 *  EyeTV
 *
 *  Created by Uli Kusterer on 12/03/2009.
 *  Copyright 2008 Elgato Systems GmbH. All rights reserved.
 *
 */

/*
	Log output for troubleshooting Sparkle failures on end-user machines.
	Your tech support will hug you if you tell them about this.
*/

#pragma once

// -----------------------------------------------------------------------------
//	Headers:
// -----------------------------------------------------------------------------

#include <Foundation/Foundation.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>


#ifdef NDEBUG
#define debug(M, ...)
#else
#define debug(M, ...) fprintf(stderr, "DEBUG %s:%d: " M "\n", __FILE__, __LINE__, ##__VA_ARGS__)
#endif

// @see: http://c.learncodethehardway.org/book/ex20.html
#define clean_errno() (errno == 0 ? "None" : strerror(errno))

#define log_err(M, ...) fprintf(stderr, "[ERROR] (%s:%d: errno: %s) " M "\n", __FILE__, __LINE__, clean_errno(), ##__VA_ARGS__)

#define log_warn(M, ...) fprintf(stderr, "[WARN] (%s:%d: errno: %s) " M "\n", __FILE__, __LINE__, clean_errno(), ##__VA_ARGS__)

#define log_info(M, ...) fprintf(stderr, "[INFO] (%s:%d) " M "\n", __FILE__, __LINE__, ##__VA_ARGS__)
//
// possible redefinition
// #define check(A, M, ...) if(!(A)) { log_err(M, ##__VA_ARGS__); errno=0; goto error; }
//
#define sentinel(M, ...)  { log_err(M, ##__VA_ARGS__); errno=0; goto error; }

#define check_mem(A) check((A), "Out of memory.")

#define check_debug(A, M, ...) if(!(A)) { debug(M, ##__VA_ARGS__); errno=0; goto error; }


// -----------------------------------------------------------------------------
//	Prototypes:
// -----------------------------------------------------------------------------

void	SUClearLog( void );
void	SULog( NSString* format, ... );
BOOL    SUIsDebug();
void    SUSetDebug(BOOL setDebugFlag);

