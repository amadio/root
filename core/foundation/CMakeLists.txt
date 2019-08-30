# Copyright (C) 1995-2019, Rene Brun and Fons Rademakers.
# All rights reserved.
#
# For the licensing terms see $ROOTSYS/LICENSE.
# For the list of contributors see $ROOTSYS/README/CREDITS.

############################################################################
# CMakeLists.txt file for building ROOT core/foundation package
############################################################################

set_property(TARGET Core APPEND PROPERTY DICT_HEADERS
  ESTLType.h
  RStringView.h
  TClassEdit.h
  ROOT/RIntegerSequence.hxx
  ROOT/RMakeUnique.hxx
  ROOT/RNotFn.hxx
  ROOT/RSpan.hxx
  ROOT/RStringView.hxx
  ROOT/span.hxx
  ROOT/TypeTraits.hxx
)

set(FOUNDATION_SOURCES
  src/FoundationUtils.cxx
  src/RConversionRuleParser.cxx
  src/TClassEdit.cxx
)

target_sources(Core PRIVATE ${FOUNDATION_SOURCES})

target_include_directories(Core PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc>
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/res>
)

ROOT_OBJECT_LIBRARY(Foundation_Stage1 ${FOUNDATION_SOURCES}) # used by rootcling_stage1
target_include_directories(Foundation_Stage1 PRIVATE ../base/inc res)
set_target_properties(Foundation_Stage1 PROPERTIES COMPILE_FLAGS "${COMPILE_FLAGS} ${CLING_CXXFLAGS}")

ROOT_INSTALL_HEADERS()
ROOT_ADD_TEST_SUBDIRECTORY(test)
