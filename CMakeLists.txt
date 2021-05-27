cmake_minimum_required(VERSION 3.5)
project(rclada_examples VERSION 0.1.0)

find_package(rclada_common REQUIRED)
ada_begin_package()

find_package(example_interfaces)
find_package(rclada REQUIRED)
find_package(rosidl_generator_ada REQUIRED)
find_package(sensor_msgs REQUIRED)

ada_import_c_libraries(${sensor_msgs_LIBRARIES})
ada_import_interfaces(example_interfaces)

ada_add_executables(
        rclada_examples
        ${PROJECT_SOURCE_DIR} bin

        add_two_ints_client_async
        add_two_ints_client
        add_two_ints_server

        graph_info

        listener
        talker

        listener_metadata
        talker_metadata

        pong_class
        pong_generic)

ada_end_package()