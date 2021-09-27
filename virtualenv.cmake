# Copyright Mateusz Stadnik. All rights reserved.
# Licensed under the MIT license. 
# See LICENSE file in the project root for details.
  
function (setup_virtualenv venv_name requirements)
    find_program(virtualenv_exec virtualenv)
    if (NOT virtualenv_exec)
        message (FATAL_ERROR, "Couldn't find virtualenv")
    endif ()

    file (GLOB virtualenv_file_stamp ${CMAKE_CURRENT_BINARY_DIR}/${venv_name}/virtualenv_file.stamp)
    message (STATUS "Using VirtualEnv: ${virtualenv_exec}") 
    if (NOT virtualenv_file_stamp)
        message (STATUS "Configure virtualenv: ${CMAKE_CURRENT_BINARY_DIR}/${venv_name}")
        execute_process(
            COMMAND ${virtualenv_exec} -p python3 ${venv_name} 
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            COMMAND_ERROR_IS_FATAL ANY
        )

        if (EXISTS ${CMAKE_CURRENT_BINARY_DIR}/${venv_name}/bin/pip)
            set (pip_exec ${CMAKE_CURRENT_BINARY_DIR}/${venv_name}/bin/pip)
        elseif (EXISTS ${CMAKE_CURRENT_BINARY_DIR}/${venv_name}/Scripts/pip.exe) 
            set (pip_exec ${CMAKE_CURRENT_BINARY_DIR}/${venv_name}/Scripts/pip.exe) 
        else () 
            message (FATAL_ERROR "Can't find pip executable under: ${CMAKE_CURRENT_BINARY_DIR}/${venv_name}")
        endif ()

        message (STATUS "Found PIP: ${pip_exec}")
        execute_process(
            COMMAND ${pip_exec} install -r ${requirements} --upgrade -q -q -q
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            COMMAND_ERROR_IS_FATAL ANY
        )

        execute_process(
            COMMAND cmake -E touch ${CMAKE_CURRENT_BINARY_DIR}/${venv_name}/virtualenv_file.stamp
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            COMMAND_ERROR_IS_FATAL ANY
        )

        file (GLOB virtualenv_file_stamp ${CMAKE_CURRENT_BINARY_DIR}/${venv_name}/virtualenv_file.stamp)
        message (STATUS "Virtualenv created, stamp file: ${virtualenv_file_stamp}")
    endif ()
endfunction ()

