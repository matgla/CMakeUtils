# Copyright Mateusz Stadnik. All rights reserved.
# Licensed under the MIT license. 
# See LICENSE file in the project root for details.

function (create_virtualenv venv_name requirements working_directory)
    file (GLOB virtualenv_file_stamp ${working_directory}/${venv_name}/virtualenv_file.stamp)
    file (MAKE_DIRECTORY ${working_directory})
    if (NOT virtualenv_file_stamp)
        find_package(PythonInterp REQUIRED)
        find_program(venv_exec virtualenv)
        if (NOT venv_exec)
            message(FATAL_ERROR,"Virtualenv not found in PATH")
        endif ()

        message (STATUS "${venv_exec} -p python3 ${venv_name}")
        execute_process(
            COMMAND ${venv_exec} -p python3 ${venv_name}
            WORKING_DIRECTORY ${working_directory}
            COMMAND_ERROR_IS_FATAL ANY
        )

        if (EXISTS ${working_directory}/${venv_name}/bin/pip)
            set (pip_exec ${working_directory}/${venv_name}/bin/pip)
        elseif (EXISTS ${working_directory}/${venv_name}/Scripts/pip.exe)
            set (pip_exec ${working_directory}/${venv_name}/Scripts/pip.exe)
        else ()
            message (FATAL_ERROR "PIP not found under: ${working_directory}/${venv_name}")
        endif ()

        execute_process(
            COMMAND ${pip_exec} install -r ${requirements} --upgrade -q -q -q
            WORKING_DIRECTORY ${working_directory}
            COMMAND_ERROR_IS_FATAL ANY
        )

        execute_process(
            COMMAND cmake -E touch ${working_directory}/${venv_name}/virtualenv_file.stamp
            WORKING_DIRECTORY ${working_directory}
            COMMAND_ERROR_IS_FATAL ANY
        )

        if (EXISTS ${working_directory}/${venv_name}/bin/python3)
            set (${venv_name}_python_executable ${working_directory}/${venv_name}/bin/python3 CACHE INTERNAL "" FORCE)
        elseif (EXISTS ${working_directory}/${venv_name}/Scripts/python.exe)
            set (${venv_name}_python_executable ${working_directory}/${venv_name}/Scripts/python.exe CACHE INTERNAL "" FORCE)
        else ()
            message (FATAL_ERROR "Python not found under: ${working_directory}/${venv_name}")
        endif ()
    endif()
endfunction ()

