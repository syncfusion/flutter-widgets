cmake_minimum_required(VERSION 3.14)
project(syncfusion_pdfviewer_android)

add_library(pdfium_wrapper SHARED
    src/main/cpp/pdfium_wrapper_jni.cpp
)

add_library(pdfium SHARED IMPORTED)
set_target_properties(pdfium PROPERTIES IMPORTED_LOCATION
    ${CMAKE_SOURCE_DIR}/src/main/jniLibs/pdfium/${ANDROID_ABI}/libpdfium.so
)

target_include_directories(pdfium_wrapper PRIVATE
    src/main/cpp
    ${CMAKE_SOURCE_DIR}/src/main/cpp/pdfium/include
)

target_link_libraries(
    pdfium_wrapper
    pdfium
)