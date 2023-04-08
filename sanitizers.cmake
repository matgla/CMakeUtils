# Copyright Mateusz Stadnik. All rights reserved.
# Licensed under the MIT license. 
# See LICENSE file in the project root for details.

function (add_sanitizers)
  if (NOT enable_sanitizers)
    add_library(enable_sanitizers INTERFACE) 

    if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
        option (ENABLE_COVERAGE "Enable coverage measurement" FALSE) 

        set (SANITIZERS "")

        option (ENABLE_ASAN "Enable address sanitizer" FALSE)
        option (ENABLE_LSAN "Enable leak sanitizer" FALSE)
        option (ENABLE_MSAN "Enable memory sanitizer" FALSE)
        option (ENABLE_UBSAN "Enable undefined behaviour sanitizer" FALSE) 
        option (ENABLE_TSAN "Enable thread sanitizer" FALSE)

        if (ENABLE_ASAN)
            set (address_sanitizer_flags 
                -fsanitize=address 
                -fno-optimize-sibling-calls 
                -fsanitize-address-use-after-scope
                -fno-omit-frame-pointer 
                -g 
                -O0
            )

            target_compile_options(enable_sanitizers 
                INTERFACE ${address_sanitizer_flags}
            )

            target_link_options(enable_sanitizers 
                INTERFACE ${address_sanitizer_flags}
            )

            message (STATUS "Address sanitizer: enabled")
        endif()

        if (ENABLE_LSAN)
            set (leak_sanitizer_flags
                -fsanitize=leak 
                -fno-omit-frame-pointer 
                -g 
                -O0
            )

            target_compile_options(enable_sanitizers 
                INTERFACE ${leak_sanitizer_flags}
            )

            target_link_options(enable_sanitizers 
                INTERFACE ${leak_sanitizer_flags}
            )

            message (STATUS "Leak sanitizer: enabled")
        endif ()

        if (ENABLE_UBSAN)
            set (undefined_sanitizer_flags
                -fsanitize=undefined
            )

            target_compile_options(enable_sanitizers 
                INTERFACE ${undefined_sanitizer_flags}
            )

            target_link_options(enable_sanitizers 
                INTERFACE ${undefined_sanitizer_flags}
            )

            message (STATUS "Undefined behaviour sanitizer: enabled")
        endif ()

        if (ENABLE_TSAN)
            if (ENABLE_ASAN OR ENABLE_LSAN)
                message (FATAL_ERROR "Can't enable thread sanitizer together with address or leak")
            endif ()
            set (thread_sanitizer_flags
                -fsanitize=thread
            )

            target_compile_options(enable_sanitizers 
                INTERFACE ${thread_sanitizer_flags}
            )

            target_link_options(enable_sanitizers 
                INTERFACE ${thread_sanitizer_flags}
            )

            message (STATUS "Thread sanitizer: enabled")
        endif ()

        if (ENABLE_MSAN)
            if (NOT CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
                message (FATAL_ERROR "MemorySanitizer is supported only under Clang")
            endif()
            if (ENABLE_LSAN OR ENABLE_ASAN OR ENABLE_TSAN)
                message (FATAL_ERROR "Can't enable memory sanitizer together with address or thread or leak sanitizer") 
            endif ()
            set (memory_sanitizer_flags
                -fsanitize=memory
                -fno-optimize-sibling-calls 
                -fsanitize-memory-track-origins=2
                -fno-omit-frame-pointer 
                -g 
                -O0
            )

            target_compile_options(enable_sanitizers 
                INTERFACE ${memory_sanitizer_flags}
            )

            target_link_options(enable_sanitizers 
                INTERFACE ${memory_sanitizer_flags}
            )
            
            message (STATUS "Memory sanitizer: enabled")
        endif()
    endif ()
  endif ()
endfunction ()

