# Copyright Mateusz Stadnik. All rights reserved.
# Licensed under the MIT license. 
# See LICENSE file in the project root for details.

set (current_source_dir ${CMAKE_CURRENT_LIST_DIR})

function (add_clang_tidy filter_files)
  if (NOT TARGET run_clang_tidy)
    message(STATUS "Clang Tidy is enabled")
    include(${current_source_dir}/virtualenv.cmake)

    create_virtualenv(clang_tidy ${current_source_dir}/requirements.txt ${CMAKE_CURRENT_BINARY_DIR}/venvs)

    find_program(RUN_CLANG_TIDY_EXE NAMES "run-clang-tidy" REQUIRED)

    set (filtering_command ${clang_tidy_binary_dir}/compile-commands -v --filter_files='${filter_files}' --files ${PROJECT_BINARY_DIR}/compile_commands.json)

    message(STATUS "Filtering command: ${filtering_command}")
    add_custom_target(filter_compile_commands
      COMMAND ${filtering_command}
      COMMAND cp -u ${PROJECT_BINARY_DIR}/compile_commands.json ${PROJECT_SOURCE_DIR}/compile_commands.json || (exit 0)
      WORKING_DIRECTORY
        ${CMAKE_CURRENT_BINARY_DIR}
    )

    cmake_host_system_information(RESULT cpus QUERY NUMBER_OF_LOGICAL_CORES)
    add_custom_target(run_clang_tidy
      DEPENDS filter_compile_commands 
      COMMAND ${RUN_CLANG_TIDY_EXE} -p ${PROJECT_SOURCE_DIR} -j${cpus}
      VERBATIM
    )

    add_custom_target(run_clang_tidy_for_sonar
      COMMAND ${RUN_CLANG_TIDY_EXE} -p ${PROJECT_SOURCE_DIR} -j${cpus} > clang_tidy_report.txt
      DEPENDS filter_compile_commands 
      VERBATIM
    )
  endif ()
endfunction ()

