cmake_minimum_required(VERSION 3.5)
project(rclada_examples)

set(${PROJECT_NAME}_MAJOR_VERSION 0)
set(${PROJECT_NAME}_MINOR_VERSION 1)
set(${PROJECT_NAME}_PATCH_VERSION 0)
set(${PROJECT_NAME}_VERSION
        ${${PROJECT_NAME}_MAJOR_VERSION}.${${PROJECT_NAME}_MINOR_VERSION}.${${PROJECT_NAME}_PATCH_VERSION})
set(PROJECT_VERSION ${${PROJECT_NAME}_VERSION})

message(" ")
message("${PROJECT_NAME} version ${PROJECT_VERSION}")


if(BUILD_TESTING)
  # Silence a warning (?)
endif()

find_package(rclada_common REQUIRED)
find_package(rclada REQUIRED)

find_package(sensor_msgs REQUIRED)

ada_import_c_libraries(${sensor_msgs_LIBRARIES})

###########################################################################

ada_add_executable(${PROJECT_SOURCE_DIR} bin
        listener
        talker

        listener_metadata
        talker_metadata)

ada_export_package()

#get_cmake_property(_variableNames VARIABLES)
#list (SORT _variableNames)
#foreach (_variableName ${_variableNames})
#  message(STATUS "${_variableName}=${${_variableName}}")
#endforeach()