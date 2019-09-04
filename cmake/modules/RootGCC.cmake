
#---Obtain the major and minor version of the GNU compiler-------------------------------------------
if (CMAKE_COMPILER_IS_GNUCXX)
  string(REGEX REPLACE "^([0-9]+).*$"                   "\\1" GCC_MAJOR ${CMAKE_CXX_COMPILER_VERSION})
  string(REGEX REPLACE "^[0-9]+\\.([0-9]+).*$"          "\\1" GCC_MINOR ${CMAKE_CXX_COMPILER_VERSION})
  string(REGEX REPLACE "^[0-9]+\\.[0-9]+\\.([0-9]+).*$" "\\1" GCC_PATCH ${CMAKE_CXX_COMPILER_VERSION})

  if(GCC_PATCH MATCHES "\\.+")
    set(GCC_PATCH "")
  endif()
  if(GCC_MINOR MATCHES "\\.+")
    set(GCC_MINOR "")
  endif()
  if(GCC_MAJOR MATCHES "\\.+")
    set(GCC_MAJOR "")
  endif()
  message(STATUS "Found GCC. Major version ${GCC_MAJOR}, minor version ${GCC_MINOR}")
else()
  set(GCC_MAJOR 0)
  set(GCC_MINOR 0)
endif()

if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 7)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-implicit-fallthrough -Wno-noexcept-type")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-implicit-fallthrough")
endif()

# Linux
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pipe ${FP_MATH_FLAGS} -Wshadow -Wall -W -Woverloaded-virtual -fsigned-char")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -pipe -Wall -W")
  set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -std=legacy")

  set(CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS "${CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS}")
  set(CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS "${CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS}")
  set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--no-undefined -Wl,--hash-style=\"both\"")

  # Select flags.
  set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O3 -g -DNDEBUG"  CACHE STRING "Flags for release build with debug info")
  set(CMAKE_CXX_FLAGS_RELEASE        "-O3 -DNDEBUG"     CACHE STRING "Flags for release build")
  set(CMAKE_CXX_FLAGS_DEBUG          "-g"               CACHE STRING "Flags for a debug build")
  set(CMAKE_C_FLAGS_RELWITHDEBINFO   "-O3 -g -DNDEBUG"  CACHE STRING "Flags for release build with debug info")
  set(CMAKE_C_FLAGS_RELEASE          "-O3 -DNDEBUG"     CACHE STRING "Flags for release build")
  set(CMAKE_C_FLAGS_DEBUG            "-g"               CACHE STRING "Flags for a debug build")

# MacOS
     message(STATUS "Found GNU compiler collection")

     SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pipe -W -Wshadow -Wall -Woverloaded-virtual -fsigned-char -fno-common")
     SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -pipe -W -Wall -fsigned-char -fno-common")
     SET(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -std=legacy")

     SET(CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS "${CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS} -single_module -Wl,-dead_strip_dylibs")
     SET(CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS "${CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS} -single_module -Wl,-dead_strip_dylibs")

     set(CMAKE_C_LINK_FLAGS "${CMAKE_C_LINK_FLAGS} -bind_at_load -m64")
     set(CMAKE_CXX_LINK_FLAGS "${CMAKE_CXX_LINK_FLAGS} -bind_at_load -m64")

     # Select flags.
     set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O2 -g -DNDEBUG")
     set(CMAKE_CXX_FLAGS_RELEASE        "-O2 -DNDEBUG")
     set(CMAKE_CXX_FLAGS_DEBUG          "-g")
     set(CMAKE_C_FLAGS_RELWITHDEBINFO   "-O2 -g -DNDEBUG")
     set(CMAKE_C_FLAGS_RELEASE          "-O2 -DNDEBUG")
     set(CMAKE_C_FLAGS_DEBUG            "-g")

# Windows
