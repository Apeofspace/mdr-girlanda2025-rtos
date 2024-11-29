cmake_minimum_required(VERSION 3.7...3.28)
if(${CMAKE_VERSION} VERSION_LESS 3.12)
  cmake_policy(VERSION ${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION})
endif()

file(GLOB_RECURSE C_SRC CONFIGURE_DEPENDS *.c)

add_library(girlanda STATIC ${C_SRC})
target_include_directories(girlanda PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
