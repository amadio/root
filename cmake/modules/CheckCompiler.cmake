# Copyright (C) 1995-2019, Rene Brun and Fons Rademakers.
# All rights reserved.
#
# For the licensing terms see $ROOTSYS/LICENSE.
# For the list of contributors see $ROOTSYS/README/CREDITS.

#---------------------------------------------------------------------------------------------------
#  CheckCompiler.cmake
#---------------------------------------------------------------------------------------------------

if(NOT GENERATOR_IS_MULTI_CONFIG AND NOT CMAKE_BUILD_TYPE)
  if(NOT CMAKE_C_FLAGS AND NOT CMAKE_CXX_FLAGS AND NOT CMAKE_Fortran_FLAGS)
    set(CMAKE_BUILD_TYPE Release CACHE STRING
      "Specifies the build type on single-configuration generators" FORCE)
  endif()
endif()

include(CheckLanguage)
#---Enable FORTRAN (unfortunatelly is not not possible in all cases)-------------------------------
if(fortran)
  #--Work-around for CMake issue 0009220
  if(DEFINED CMAKE_Fortran_COMPILER AND CMAKE_Fortran_COMPILER MATCHES "^$")
    set(CMAKE_Fortran_COMPILER CMAKE_Fortran_COMPILER-NOTFOUND)
  endif()
  if(CMAKE_Fortran_COMPILER)
    # CMAKE_Fortran_COMPILER has already been defined somewhere else, so
    # just check whether it contains a valid compiler
    enable_language(Fortran)
  else()
    # CMAKE_Fortran_COMPILER has not been defined, so first check whether
    # there is a Fortran compiler at all
    check_language(Fortran)
    if(CMAKE_Fortran_COMPILER)
      # Fortran compiler found, however as 'check_language' was executed
      # in a separate process, the result might not be compatible with
      # the C++ compiler, so reset the variable, ...
      unset(CMAKE_Fortran_COMPILER CACHE)
      # ..., and enable Fortran again, this time prefering compilers
      # compatible to the C++ compiler
      enable_language(Fortran)
    endif()
  endif()
else()
  set(CMAKE_Fortran_COMPILER CMAKE_Fortran_COMPILER-NOTFOUND)
endif()

include(CheckCXXCompilerFlag)
include(CheckCCompilerFlag)

#---C++ standard----------------------------------------------------------------------

set(CMAKE_CXX_STANDARD 11 CACHE STRING "")
set(CMAKE_CXX_STANDARD_REQUIRED TRUE)
set(CMAKE_CXX_EXTENSIONS FALSE CACHE BOOL "")

if(cxx11 OR cxx14 OR cxx17)
  message(DEPRECATION "Options cxx11/14/17 are deprecated. Please use CMAKE_CXX_STANDARD instead.")

  # for backward compatibility
  if(cxx17)
    set(CMAKE_CXX_STANDARD 17 CACHE STRING "" FORCE)
  elseif(cxx14)
    set(CMAKE_CXX_STANDARD 14 CACHE STRING "" FORCE)
  elseif(cxx11)
    set(CMAKE_CXX_STANDARD 11 CACHE STRING "" FORCE)
  endif()

  unset(cxx17 CACHE)
  unset(cxx14 CACHE)
  unset(cxx11 CACHE)
endif()

if(NOT CMAKE_CXX_STANDARD MATCHES "11|14|17")
  message(FATAL_ERROR "Unsupported C++ standard: ${CMAKE_CXX_STANDARD}")
endif()

# needed by roottest, to be removed once roottest is fixed
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CMAKE_CXX${CMAKE_CXX_STANDARD}_STANDARD_COMPILE_OPTION}")

#---Check for libcxx option------------------------------------------------------------
if(libcxx)
  CHECK_CXX_COMPILER_FLAG("-stdlib=libc++" HAS_LIBCXX11)
  if(NOT HAS_LIBCXX11)
    message(STATUS "Current compiler does not suppport -stdlib=libc++ option. Switching OFF libcxx option")
    set(libcxx OFF CACHE BOOL "" FORCE)
  endif()
endif()

#---Need to locate thead libraries and options to set properly some compilation flags----------------

set(THREADS_PREFER_PTHREAD_FLAG TRUE)
find_package(Threads REQUIRED)

if(CMAKE_USE_PTHREADS_INIT)
  set(CMAKE_THREAD_FLAG ${CMAKE_THREAD_LIBS_INIT})
endif()

#---Setup details depending on the major platform type----------------------------------------------
if(CMAKE_SYSTEM_NAME MATCHES Linux)
  include(SetUpLinux)
elseif(APPLE)
  include(SetUpMacOS)
elseif(WIN32)
  include(SetupWindows)
endif()

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CMAKE_THREAD_FLAG}")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${CMAKE_THREAD_FLAG}")

if(libcxx)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++")
endif()

if(gcctoolchain)
  CHECK_CXX_COMPILER_FLAG("--gcc-toolchain=${gcctoolchain}" HAS_GCCTOOLCHAIN)
  if(HAS_GCCTOOLCHAIN)
     set(CMAKE_CXX_FLAGS "--gcc-toolchain=${gcctoolchain} ${CMAKE_CXX_FLAGS}")
  endif()
endif()

if(gnuinstall)
  set(R__HAVE_CONFIG 1)
endif()

#---Check if we use the new libstdc++ CXX11 ABI-----------------------------------------------------
# Necessary to compile check_cxx_source_compiles this early
include(CheckCXXSourceCompiles)
check_cxx_source_compiles(
"
#include <string>
#if _GLIBCXX_USE_CXX11_ABI == 0
  #error NOCXX11
#endif
int main() {}
" GLIBCXX_USE_CXX11_ABI)

foreach(LANG C CXX Fortran)
  foreach(BUILD_TYPE DEBUG RELEASE RELWITHDEBINFO)
    set(CMAKE_${LANG}_FLAGS_${BUILD_TYPE} ${ROOT_FLAGS_${BUILD_TYPE}}
      CACHE STRING "Default ${LANG} flags for ${BUILD_TYPE} build")
  endforeach()
endforeach()

#---Print the final compiler flags--------------------------------------------------------------------
string(TOUPPER "${CMAKE_BUILD_TYPE}" BUILD_TYPE)
message(STATUS "ROOT Platform: ${ROOT_PLATFORM}")
message(STATUS "ROOT Architecture: ${ROOT_ARCHITECTURE}")
message(STATUS "Build Type: '${CMAKE_BUILD_TYPE}' (flags = '${CMAKE_CXX_FLAGS_${BUILD_TYPE}}')")
message(STATUS "Compiler Flags: ${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_${BUILD_TYPE}}")
