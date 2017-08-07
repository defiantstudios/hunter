# Copyright (c) 2015, Ruslan Baratov, Alexandre Pretyman
# All rights reserved.

# !!! DO NOT PLACE HEADER GUARDS HERE !!!

include(hunter_add_package)
include(hunter_add_version)
include(hunter_cacheable)
include(hunter_cmake_args)
include(hunter_configuration_types)
include(hunter_report_broken_package)

# Use *.7z version.
# Qt 5.5 overview:
#   zip 540M
#   tar.gz 436M (don't have qtbase/configure.exe)
#   7z 297M
#   tar.xz 305M (don't have qtbase/configure.exe)
#
# Qt 5.9.1
#   zip 714M   
#

hunter_add_version(
    PACKAGE_NAME
    Qt
    VERSION
    "5.9.1"
    URL
    "https://download.qt.io/official_releases/qt/5.9/5.9.1/single/qt-everywhere-opensource-src-5.9.1.zip"
    SHAA1
    bdac47fdcf6dd502a123eb403bb4260542f91034
)

hunter_cacheable(Qt)

if(NOT APPLE AND NOT WIN32)
  hunter_configuration_types(Qt CONFIGURATION_TYPES Release)
endif()

if(ANDROID)
  # Static variant is not supported: https://bugreports.qt.io/browse/QTBUG-47455
  hunter_cmake_args(Qt CMAKE_ARGS BUILD_SHARED_LIBS=ON)
endif()

if(IOS)
  list(FIND IPHONEOS_ARCHS "armv7s" _armv7s_index)
  if(NOT _armv7s_index EQUAL -1)
    hunter_report_broken_package(
        "Some parts of Qt can't be built for armv7s."
        "For example Qt Multimedia: https://bugreports.qt.io/browse/QTBUG-48805"
    )
  endif()
endif()

include("${CMAKE_CURRENT_LIST_DIR}/qtbase/hunter.cmake")

hunter_add_package(QtCMakeExtra)
