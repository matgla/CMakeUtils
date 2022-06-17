# Copyright Mateusz Stadnik. All rights reserved.
# Licensed under the MIT license. 
# See LICENSE file in the project root for details.
 
function (add_coverage)

    add_library (coverage_flags INTERFACE)

    option (ENABLE_COVERAGE "Enable code coverage measurement" FALSE)

    if (ENABLE_COVERAGE AND CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang") 
        target_compile_options (coverage_flags 
            INTERFACE 
                -O0
                -g 
                --coverage 
                -fno-exceptions 
                -fno-inline
        ) 

        target_link_options (coverage_flags 
            INTERFACE 
                --coverage
        )

        message (STATUS "Coverage: enabled")
        find_program (lcov_exe lcov)
        
        add_custom_target (run_lcov 
            COMMAND 
                ${lcov_exe} --capture --directory ${PROJECT_SOURCE_DIR} --output-file ${PROJECT_BINARY_DIR}/lcov.info
            COMMAND 
            ${lcov_exe} -r ${PROJECT_BINARY_DIR}/lcov.info '*test/*' '/usr/include/*'
        )


    endif ()

endfunction()

