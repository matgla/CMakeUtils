# Copyright Mateusz Stadnik. All rights reserved.
# Licensed under the MIT license. 
# See LICENSE file in the project root for details.

function (add_clang_tidy filter_files)
  if (NOT TARGET run_clang_tidy)
    message(STATUS "Clang Tidy is enabled")
    include(virtualenv.cmake)

    setup_virtualenv(clang_tidy_venv ${CMAKE_CURRENT_SOURCE_DIR}/requirements.txt ${CMAKE_CURRENT_BINARY_DIR}/venvs)

    find_program(RUN_CLANG_TIDY_EXE NAMES "run-clang-tidy" REQUIRED)

    add_custom_target(filter_compile_commands
      COMMAND ${CMAKE_CURRENT_BINARY_DIR}/clang_tidy/venv/bin/compile-commands --filter_files=${suppression}
      WORKING_DIRECTORY
        ${CMAKE_CURRENT_BINARY_DIR}
    )

    cmake_host_system_information(RESULT cpus QUERY NUMBER_OF_LOGICAL_CORES)
    add_custom_target(run_clang_tidy
      DEPENDS filter_compile_commands 
      COMMAND ${RUN_CLANG_TIDY_EXE} -j${cpus}
      VERBATIM
    )

    add_custom_command(OUTPUT clang_tidy_report.txt 
      COMMAND ${RUN_CLANG_TIDY_EXE} -j${cpus} > clang_tidy_report.txt
      DEPENDS filter_compile_commands 
      VERBATIM 
    )

    add_custom_target(run_clang_tidy_for_sonar
      DEPENDS clang_tidy_report.txt 
      VERBATIM
    )
  endif ()
endfunction ()

