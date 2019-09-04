
# Intel C/C++ Compiler

add_compile_options(-fp-model precise)

add_compile_options($<$<COMPILE_LANGUAGE:C>:-restrict>)

foreach(wd 279 597 873 1098 1292 1476 1478 1572 2536 3373)
  add_compile_options(-wd${wd})
endforeach()

set_property(DIRECTORY APPEND LINK_FLAGS -Wl,--no-undefined)

set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--no-undefined")
