// pch.h: This is a precompiled header file.
// Files listed below are compiled only once, improving build performance for future builds.
// This also affects IntelliSense performance, including code completion and many code browsing features.
// However, files listed here are ALL re-compiled if any one of them is updated between builds.
// Do not add files here that you will be updating frequently as this negates the performance advantage.

#ifndef PCH_H
#define PCH_H

// add headers that you want to pre-compile here

#pragma warning(push)
#pragma warning(disable: 4244)
#pragma warning(disable: 4267)

#include <iostream>
#include <cassert>

#include "SDL.h"

#include "SDL_opengles2.h"

#include "include/gpu/GrBackendSurface.h"
#include "include/gpu/GrDirectContext.h"
#include "include/gpu/gl/GrGLInterface.h"
#include "include/core/SkCanvas.h"
#include "include/core/SkFont.h"
#include "include/core/SkSurface.h"
#include "include/utils/SkRandom.h"

#include "src/gpu/gl/GrGLUtil.h"

#if defined(SK_BUILD_FOR_WASM)
#include <emscripten.h>
#include <emscripten/html5.h>
#include <GL/gl.h>
#elif defined(SK_BUILD_FOR_ANDROID)
#include <GLES/gl.h>
#elif defined(SK_BUILD_FOR_UNIX)
#include <GL/gl.h>
#elif defined(SK_BUILD_FOR_MAC)
#include <OpenGL/gl.h>
#elif defined(SK_BUILD_FOR_IOS)
#include <OpenGLES/ES2/gl.h>
#endif

#undef main

#pragma warning(pop)

#endif //PCH_H
