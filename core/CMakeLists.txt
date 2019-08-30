# Copyright (C) 1995-2019, Rene Brun and Fons Rademakers.
# All rights reserved.
#
# For the licensing terms see $ROOTSYS/LICENSE.
# For the list of contributors see $ROOTSYS/README/CREDITS.

############################################################################
# CMakeLists.txt file for building ROOT (global) core package
############################################################################

file(WRITE ${CMAKE_BINARY_DIR}/etc/gitinfo.txt
  "${GIT_DESCRIBE_ALL}\n${GIT_DESCRIBE_ALWAYS}\n${GIT_TIMESTAMP}\n")

file(WRITE ${CMAKE_BINARY_DIR}/RGitCommit.h.tmp
"#ifndef ROOT_RGITCOMMIT_H
#define ROOT_RGITCOMMIT_H
  #define ROOT_GIT_BRANCH \"${GIT_DESCRIBE_ALL}\"
  #define ROOT_GIT_COMMIT \"${GIT_DESCRIBE_ALWAYS}\"
#endif"
)

add_custom_command(OUTPUT ${CMAKE_BINARY_DIR}/include/RGitCommit.h
  COMMAND
    ${CMAKE_COMMAND} -E copy_if_different
    ${CMAKE_BINARY_DIR}/RGitCommit.h.tmp
    ${CMAKE_BINARY_DIR}/include/RGitCommit.h
  DEPENDS
    ${CMAKE_BINARY_DIR}/RGitCommit.h.tmp
)

add_custom_target(gitcommit ALL DEPENDS ${CMAKE_BINARY_DIR}/RGitCommit.h.tmp)

set_source_files_properties(${CMAKE_BINARY_DIR}/RGitCommit.h.tmp
  PROPERTIES GENERATED TRUE)
set_source_files_properties(${CMAKE_BINARY_DIR}/include/RGitCommit.h
  PROPERTIES GENERATED TRUE HEADER_FILE_ONLY TRUE)

install(FILES ${CMAKE_BINARY_DIR}/include/RGitCommit.h
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

ROOT_LINKER_LIBRARY(Core
  base/src/TROOT.cxx
  ${CMAKE_BINARY_DIR}/include/RGitCommit.h
  BUILTINS
    LZMA
)

add_dependencies(Core CLING gitcommit)

target_link_libraries(Core
  PRIVATE
    xxHash::xxHash
    LZ4::LZ4
    ZLIB::ZLIB
    ${LIBLZMA_LIBRARIES}
    ${CMAKE_DL_LIBS}
    ${CMAKE_THREAD_LIBS_INIT}
)

# This is needed because LinkDef.h includes other LinkDefs
# with paths starting from ${CMAKE_SOURCE_DIR}
target_include_directories(Core PRIVATE ${CMAKE_SOURCE_DIR})

add_subdirectory(rootcling_stage1)

add_subdirectory(base)
add_subdirectory(clib)
add_subdirectory(clingutils)
add_subdirectory(cont)
add_subdirectory(dictgen)
add_subdirectory(foundation)
add_subdirectory(imt)
add_subdirectory(lz4)
add_subdirectory(lzma)
add_subdirectory(meta)
add_subdirectory(metacling)
add_subdirectory(multiproc)
add_subdirectory(newdelete)
add_subdirectory(rint)
add_subdirectory(textinput)
add_subdirectory(thread)
add_subdirectory(zip)

add_subdirectory(macosx)
add_subdirectory(unix)
add_subdirectory(winnt)

target_sources(Core PRIVATE
  $<TARGET_OBJECTS:Cont>
  $<TARGET_OBJECTS:Foundation>
  $<TARGET_OBJECTS:Lzma>
  $<TARGET_OBJECTS:Lz4>
  $<TARGET_OBJECTS:Zip>
  $<TARGET_OBJECTS:Meta>
  $<TARGET_OBJECTS:TextInput>
)

#---G__Core--------------------------------------------------------------------

# libCore is linked against zlib (based on the location returned by find_package or builtin_zlib). The dictionary of
# libCore, G__Core.cxx, should contain the include path to zlib.h in order to keep the symbol and header files in sync.
# The includePath variable of the dictionary is empty, but we do not notice it because, by chance, G__MathMore adds
# the same includePath for GSL. OTOH, if we have a small test case which works only with libCore.so we never give a
# chance MathMore's dictionary to hide the problem and thus we pick up the system zlib.h.
#
# FIXME: Using include_directories is too intrusive as it does much more than what we want, that is, it will add this
# include path not only in the dictionary but as part of the compilation lines. It is harmless but suboptimal: we need a
# mechanism throough which we can express that we only need the path in the dictionary.
#
# NOTE: We cannot use set_property(TARGET G__Core ...) becase this has to happen before registering the target.
include_directories(
  ${ZLIB_INCLUDE_DIR}
  cont/inc
  foundation/inc
  clingutils/inc
  meta/inc
  textinput/inc
)

get_target_property(CORE_DICT_HEADERS Core DICT_HEADERS)

ROOT_GENERATE_DICTIONARY(G__Core
  ${CORE_DICT_HEADERS}
  STAGE1
  MODULE
    Core
  OPTIONS
    -writeEmptyRootPCM
  LINKDEF
    base/inc/LinkDef.h
)
