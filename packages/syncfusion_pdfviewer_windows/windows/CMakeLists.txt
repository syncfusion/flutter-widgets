cmake_minimum_required(VERSION 3.14)
set(PROJECT_NAME "syncfusion_pdfviewer_windows")
project(${PROJECT_NAME} LANGUAGES CXX)

include(FindPackageHandleStandardArgs)

find_path(PDFium_INCLUDE_DIR
    NAMES "fpdfview.h"
    PATHS "${CMAKE_CURRENT_LIST_DIR}"
    PATH_SUFFIXES "include/pdfium"
)

set(PDFium_ARCH x64)

find_file(PDFium_LIBRARY
    NAMES "pdfium.dll"
    PATHS "${CMAKE_CURRENT_LIST_DIR}"
    PATH_SUFFIXES "include/pdfium/${PDFium_ARCH}/bin")

find_file(PDFium_IMPLIB
    NAMES "pdfium.dll.lib"
    PATHS "${CMAKE_CURRENT_LIST_DIR}"
    PATH_SUFFIXES "include/pdfium/${PDFium_ARCH}/lib")

add_library(pdfium SHARED IMPORTED)
set_target_properties(pdfium
PROPERTIES
IMPORTED_LOCATION             "${PDFium_LIBRARY}"
IMPORTED_IMPLIB               "${PDFium_IMPLIB}"
INTERFACE_INCLUDE_DIRECTORIES "${PDFium_INCLUDE_DIR};${PDFium_INCLUDE_DIR}/cpp"
)

find_package_handle_standard_args(PDFium
REQUIRED_VARS PDFium_LIBRARY PDFium_IMPLIB PDFium_INCLUDE_DIR
)

set(PLUGIN_NAME "syncfusion_pdfviewer_windows_plugin")

add_library(${PLUGIN_NAME} SHARED
"pdfviewer.cpp"
"pdfviewer.h"
"syncfusion_pdfviewer_windows_plugin.cpp"
)
apply_standard_settings(${PLUGIN_NAME})
set_target_properties(${PLUGIN_NAME} PROPERTIES
  CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)
target_include_directories(${PLUGIN_NAME} INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_link_libraries(${PLUGIN_NAME} PRIVATE pdfium flutter flutter_wrapper_plugin)

# List of absolute paths to libraries that should be bundled with the plugin
set(syncfusion_pdfviewer_windows_bundled_libraries
  "${PDFium_LIBRARY}"
  PARENT_SCOPE
)
