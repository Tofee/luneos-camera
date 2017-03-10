project(org.webosports.app.camera)

cmake_minimum_required(VERSION 2.8.8)

# Find includes in corresponding build directories
set(CMAKE_INCLUDE_CURRENT_DIR ON)

# Instruct CMake to run moc automatically when needed.
set(CMAKE_AUTOMOC ON)

# Configure camera output directory
set(CAMERA_OUTPUT_DIR "/media/internal/camera")

if(UNIX)
    # LuneOS version
    include(webOS/webOS)
    webos_modules_init(1 0 0 QUALIFIER RC3)
    webos_component(0 5 0)

    if("${WEBOS_INSTALL_ROOT}" STREQUAL "/usr/local/webos")
        # We are likely on a desktop
        set(WEBOS_INSTALL_WEBOS_APPLICATIONSDIR ${CMAKE_CURRENT_BINARY_DIR})
        set(CAMERA_OUTPUT_DIR "/tmp/luneos-camera")
    endif()
else()
    # Windows, so desktop too
    set(CAMERA_OUTPUT_DIR "C:/temp/luneos-camera")
    set(WEBOS_INSTALL_WEBOS_APPLICATIONSDIR ${CMAKE_CURRENT_BINARY_DIR})
endif()

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fvisibility=hidden -fvisibility-inlines-hidden -Wall -std=c++0x")
add_definitions(-DCAMERA_OUTPUT_DIR="${CAMERA_OUTPUT_DIR}")

# Standard install paths. Needs to be set before finding packages.
include(GNUInstallDirs)

find_package(Qt5Qml)
find_package(Qt5Quick)
find_package(Qt5Multimedia)
find_package(Qt5Gui)

set(APP_DIR ${WEBOS_INSTALL_WEBOS_APPLICATIONSDIR}/org.webosports.app.camera)
set(APP_DATA appinfo.json icon.png icon-256x256.png)
set(PLUGIN_DIR ${APP_DIR}/CameraApp)

message(STATUS "APP_DIR=${APP_DIR}")

install(FILES ${APP_DATA} DESTINATION ${APP_DIR})
install(DIRECTORY qml DESTINATION ${APP_DIR})

# make non compiled files visible in qtcreator
file(GLOB_RECURSE NON_COMPILED_FILES *.qml *.js *.svg *.png *.json *.sci qmldir)
add_custom_target(NON_COMPILED_TARGET ALL SOURCES ${NON_COMPILED_FILES})

add_subdirectory(CameraApp)
