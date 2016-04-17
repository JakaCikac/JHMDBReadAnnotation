cmake_minimum_required(VERSION 3.5)
project(ReadJHMDBAnnotations)

# user-defined variables
option(BUILD_EXECUTABLE "Build as executable to test functionality" OFF)
option(BUILD_DOC        "Build documentation with Doxygen"          ON)

find_package(OpenCV REQUIRED)

link_libraries(${OpenCV_LIBS})
include_directories(AFTER ${CMAKE_CURRENT_BINARY_DIR} ${OpenCV_INCLUDE_DIR})
include_directories("include")

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

set(SOURCE_FILES src/ReadJHMDBAnnotations.cpp)
add_executable(ReadJHMDBAnnotations ${SOURCE_FILES})

# build the doxygen documentation
if(BUILD_DOC)
    add_subdirectory(doc)
endif()

# copy the neccessary files to the build directory, to avoid
# absolute long paths
file(COPY data/ DESTINATION data/)