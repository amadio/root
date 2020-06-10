set(CTEST_PROJECT_NAME "ROOT")

set(CTEST_BUILD_NAME "Debian Package for ${CMAKE_SYSTEM_NAME} ${CMAKE_SYSTEM_VERSION}")

set(CTEST_SOURCE_DIRECTORY "${CTEST_SCRIPT_DIRECTORY}/../..")
set(CTEST_BINARY_DIRECTORY "${CTEST_SCRIPT_DIRECTORY}/build")

set(ENV{LANG} "C")
set(ENV{LC_ALL} "C")
set(ENV{CCACHE_DIR} "${CTEST_SCRIPT_DIRECTORY}/ccache")

site_name(CTEST_SITE)

cmake_host_system_information(RESULT NCORES QUERY NUMBER_OF_PHYSICAL_CORES)

if(NOT DEFINED CTEST_CONFIGURATION_TYPE)
  set(CTEST_CONFIGURATION_TYPE Release)
endif()

if(NOT DEFINED ENV{CMAKE_GENERATOR})
  execute_process(COMMAND ${CMAKE_COMMAND} --system-information
    OUTPUT_VARIABLE CMAKE_SYSTEM_INFORMATION ERROR_VARIABLE ERROR)
  if(ERROR)
    message(FATAL_ERROR "Could not detect default CMake generator")
  endif()
  string(REGEX REPLACE ".+CMAKE_GENERATOR \"([-0-9A-Za-z ]+)\".*$" "\\1"
    CTEST_CMAKE_GENERATOR "${CMAKE_SYSTEM_INFORMATION}")
else()
  set(CTEST_CMAKE_GENERATOR $ENV{CMAKE_GENERATOR})
endif()

if(EXISTS "${CTEST_BINARY_DIRECTORY}/CMakeCache.txt")
  ctest_empty_binary_directory("${CTEST_BINARY_DIRECTORY}")
endif()

# Use Debian convention for CMAKE_INSTALL_LIBDIR
set(LIBDIR lib/${CMAKE_SYSTEM_PROCESSOR}-linux-gnu)

set(CTEST_BUILD_OPTIONS
  -DCMAKE_CXX_STANDARD=17
  -DCMAKE_INSTALL_PREFIX=/usr
  -DCMAKE_INSTALL_BINDIR=bin
  -DCMAKE_INSTALL_CMAKEDIR=${LIBDIR}/cmake/ROOT
  -DCMAKE_INSTALL_DATAROOTDIR=share
  -DCMAKE_INSTALL_DATADIR=share/root
  -DCMAKE_INSTALL_DOCDIR=share/doc/root
  -DCMAKE_INSTALL_ELISPDIR=share/emacs/site-lisp
  -DCMAKE_INSTALL_FONTDIR=share/root/fonts
  -DCMAKE_INSTALL_ICONDIR=share/root/icons
  -DCMAKE_INSTALL_INCLUDEDIR=include/ROOT
  -DCMAKE_INSTALL_JSROOTDIR=share/root/js
  -DCMAKE_INSTALL_LIBDIR=${LIBDIR}
  -DCMAKE_INSTALL_MACRODIR=share/root/macro
  -DCMAKE_INSTALL_MANDIR=share/man
  -DCMAKE_INSTALL_OPENUI5DIR=share/root/ui5
  -DCMAKE_INSTALL_PYTHONDIR=lib/python3/dist-packages
  -DCMAKE_INSTALL_SRCDIR=/dev/null
  -DCMAKE_INSTALL_SYSCONFDIR=/etc/root
  -DCMAKE_INSTALL_TUTDIR=share/root/tutorials
  -DPYTHON_EXECUTABLE=/usr/bin/python3
  -DCLING_BUILD_PLUGINS=OFF
  -Dfail-on-missing=ON
  -Dsoversion=ON
  -Dgnuinstall=ON
  -Dexceptions=ON
  -Dbuiltin_llvm=ON
  -Dbuiltin_clang=ON
  -Dbuiltin_afterimage=OFF
  -Dbuiltin_cfitsio=OFF
  -Dbuiltin_davix=OFF
  -Dbuiltin_fftw3=OFF
  -Dbuiltin_freetype=OFF
  -Dbuiltin_ftgl=OFF
  -Dbuiltin_gl2ps=OFF
  -Dbuiltin_glew=OFF
  -Dbuiltin_gsl=OFF
  -Dbuiltin_lz4=OFF
  -Dbuiltin_lzma=OFF
  -Dbuiltin_openssl=OFF
  -Dbuiltin_pcre=OFF
  -Dbuiltin_tbb=OFF
  -Dbuiltin_unuran=OFF
  -Dbuiltin_vc=OFF
  -Dbuiltin_vdt=OFF
  -Dbuiltin_veccore=OFF
  -Dbuiltin_xrootd=OFF
  -Dbuiltin_xxhash=OFF
  -Dbuiltin_zlib=OFF
  -Dbuiltin_zstd=OFF
  -Dx11=ON
  -Dalien=OFF
  -Darrow=OFF
  -Dasimage=ON
  -Dccache=OFF
  -Dcefweb=OFF
  -Dclad=OFF
  -Dcuda=OFF
  -Dcudnn=OFF
  -Dcxxmodules=OFF
  -Ddavix=ON
  -Ddataframe=ON
  -Ddcache=ON
  -Dfcgi=ON
  -Dfftw3=ON
  -Dfitsio=ON
  -Dfortran=ON
  -Dftgl=ON
  -Dgdml=ON
  -Dgfal=ON
  -Dgl2ps=ON
  -Dgminimal=OFF
  -Dgsl_shared=ON
  -Dgviz=ON
  -Dhttp=ON
  -Dimt=ON
  -Djemalloc=OFF
  -Dmathmore=ON
  -Dmemstat=OFF
  -Dminimal=OFF
  -Dminuit2=ON
  -Dminuit=ON
  -Dmlp=ON
  -Dmonalisa=OFF
  -Dmpi=OFF
  -Dmysql=ON
  -Dodbc=ON
  -Dopengl=ON
  -Doracle=OFF
  -Dpgsql=ON
  -Dpythia6=OFF
  -Dpythia8=ON
  -Dpyroot=ON
  -Dpyroot_legacy=ON # new with 6.22
  -Dpyroot_experimental=OFF # kept for backward compatibility
  -Dqt5web=OFF
  -Droofit=ON
  -Droot7=ON
  -Drootbench=OFF
  -Droottest=OFF
  -Drpath=OFF
  -Druntime_cxxmodules=ON
  -Dr=OFF
  -Dshadowpw=ON
  -Dsqlite=ON
  -Dssl=ON
  -Dtcmalloc=OFF
  -Dtesting=OFF
  -Dtmva=ON
  -Dtmva-cpu=ON
  -Dtmva-gpu=OFF
  -Dtmva-pymva=ON
  -Dtmva-rmva=OFF
  -Dunuran=OFF
  -Dvc=OFF
  -Dvmc=OFF
  -Dvdt=OFF
  -Dveccore=OFF
  -Dvecgeom=OFF
  -Dxml=ON
  -Dxrootd=OFF
  -Dxproofd=OFF
  ${CTEST_BUILD_OPTIONS}
  $ENV{CTEST_BUILD_OPTIONS})

ctest_start(Experimental GROUP Package)
ctest_configure(OPTIONS "${CTEST_BUILD_OPTIONS}")
ctest_build(FLAGS -j${NCORES})
