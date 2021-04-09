cmake_minimum_required(VERSION 3.16.3)

enable_testing()

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib) 
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib) 

project(x16-utils VERSION 1.0.0 LANGUAGES ASM)

set(CMAKE_CROSSCOMPILING ON)
set(CMAKE_CROSSCOMPILING_EMULATOR "x16emu")

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

find_package(cc65 REQUIRED)

add_subdirectory(asminc)
add_subdirectory(utils)

add_subdirectory(test)
