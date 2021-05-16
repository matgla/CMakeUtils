# This file is part of CMakeUtils.
# Copyright (C) 2021 Mateusz Stadnik
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

function (add_coverage)

    add_library (coverage_flags INTERFACE)

    option (ENABLE_COVERAGE "Enable code coverage measurement" FALSE)

    if (ENABLE_COVERAGE AND CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang") 
        target_compile_options (coverage_flags 
            INTERFACE 
                -O0
                -g 
                --coverage 
        ) 

        target_link_options (coverage_flags 
            INTERFACE 
                --coverage
        )

        message (STATUS "Coverage: enabled")
        find_program (lcov_exe lcov)
        
        add_custom_target (run_lcov 
            COMMAND 
                ${lcov_exe} --capture --directory ${PROJECT_SOURCE_DIR} --output-file ${PROJECT_BINARY_DIR}/coverage/lcov.info
            COMMAND 
            ${lcov_exe} -r ${PROJECT_BINARY_DIR}/lcov.info '*test/*' '/usr/include/*'
        )


    endif ()

endfunction()

