cmake_minimum_required(VERSION 3.10)

# TODO: Fill your project's name below.
project()

string(TOLOWER "${PROJECT_NAME}" PROJECT_NAME_LOWERCASE)

set("${PROJECT_NAME}_INCLUDE_DIRECTORY" "include")
include_directories("${${PROJECT_NAME}_INCLUDE_DIRECTORY}")

set(CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH})

include(ProjectUtils)

add_subdirectory(src)

# Configure tests.
option("${PROJECT_NAME}_BUILD_TESTS" "Build tests for this project" ON)
if("${PROJECT_NAME}_BUILD_TESTS")
    enable_testing()
    include(GoogleTest)
    add_subdirectory(tests)
endif()
