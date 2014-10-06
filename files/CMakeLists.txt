#
# Copyright (C) 2014 Andrei Datcu <datcuandrei@gmail.com>
#
# This is free software, licensed under the GNU General Public License v2.
# 


cmake_minimum_required(VERSION 2.8.9)
project(updatetacho)

# Tell CMake to run moc when necessary:
set(CMAKE_AUTOMOC ON)
# As moc files are generated in the binary dir, tell CMake
# to always look for includes there:
set(CMAKE_INCLUDE_CURRENT_DIR ON)

find_package ( Qt5Core REQUIRED)
find_package ( Qt5Concurrent REQUIRED)
find_package ( Qt5Sql REQUIRED)
find_package ( Qt5Network REQUIRED)

include_directories( "./src")
                     
include_directories(${CMAKE_FIND_ROOT_PATH}/usr/include/QtConcurrent 
                    ${CMAKE_FIND_ROOT_PATH}/usr/include/QtCore 
                    ${CMAKE_FIND_ROOT_PATH}/usr/include/QtNetwork
                    ${CMAKE_FIND_ROOT_PATH}/usr/include/QtSql
                    ${CMAKE_FIND_ROOT_PATH}/usr/include )


add_definitions(${Qt5Core_DEFINITIONS} ${Qt5Network_DEFINITIONS} ${Qt5Concurrent_DEFINITIONS} ${Qt5Sql_DEFINITIONS})
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${Qt5Core_EXECUTABLE_COMPILE_FLAGS}" )

MESSAGE ( ${CMAKE_CXX_FLAGS} ${Qt5Core_EXECUTABLE_COMPILE_FLAGS} )

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${Qt5Core_EXECUTABLE_COMPILE_FLAGS} ${Qt5Network_EXECUTABLE_COMPILE_FLAGS} ${Qt5Concurrent_EXECUTABLE_COMPILE_FLAGS} ${Qt5Sql_EXECUTABLE_COMPILE_FLAGS}")

file( GLOB src "./src/*.cpp" )

add_executable( updatetacho ${src} )

MESSAGE (status "path=" ${CMAKE_FIND_ROOT_PATH})

target_link_libraries( updatetacho ${CMAKE_FIND_ROOT_PATH}/usr/lib/libQt5Core.so.5.0.2 )
target_link_libraries( updatetacho ${CMAKE_FIND_ROOT_PATH}/usr/lib/libQt5Network.so.5.0.2 )
target_link_libraries( updatetacho ${CMAKE_FIND_ROOT_PATH}/usr/lib/libQt5Concurrent.so.5.0.2 )
target_link_libraries( updatetacho ${CMAKE_FIND_ROOT_PATH}/usr/lib/libQt5Sql.so.5.0.2 )