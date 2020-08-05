function (add_asan_build_type)
    message (STATUS "Adding build type: ASAN")
    set(CMAKE_CXX_FLAGS_ASAN
        "-fsanitize=address -fno-optimize-sibling-calls -fsanitize-address-use-after-scope -fno-omit-frame-pointer -g -O1"
        CACHE STRING "Flags used by the C++ compiler during AddressSanitizer builds."
        FORCE
    )

    set (CMAKE_C_FLAGS_ASAN
        "-fsanitize=address -fno-optimize-sibling-calls -fsanitize-address-use-after-scope -fno-omit-frame-pointer -g -O1"
        CACHE STRING "Flags used by the C compiler during AddressSanitizer builds."
        FORCE
    )
endfunction ()

function (add_lsan_build_type)
    message (STATUS "Adding build type: LSAN")
    set(CMAKE_C_FLAGS_LSAN
        "-fsanitize=leak -fno-omit-frame-pointer -g -O1"
        CACHE STRING "Flags used by the C compiler during LeakSanitizer builds."
        FORCE
    )

    set(CMAKE_CXX_FLAGS_LSAN
        "-fsanitize=leak -fno-omit-frame-pointer -g -O1"
        CACHE STRING "Flags used by the C++ compiler during LeakSanitizer builds."
        FORCE
    )
endfunction ()

function (add_msan_build_type)
    message (STATUS "Adding build type: MSAN")
    set(CMAKE_C_FLAGS_MSAN
        "-fsanitize=memory -fno-optimize-sibling-calls -fsanitize-memory-track-origins=2 -fno-omit-frame-pointer -g -O2"
        CACHE STRING "Flags used by the C compiler during MemorySanitizer builds."
        FORCE
    )

    set(CMAKE_CXX_FLAGS_MSAN
        "-fsanitize=memory -fno-optimize-sibling-calls -fsanitize-memory-track-origins=2 -fno-omit-frame-pointer -g -O2"
        CACHE STRING "Flags used by the C++ compiler during MemorySanitizer builds."
        FORCE
    )
endfunction ()

function (add_ubsan_build_type)
    message (STATUS "Adding build type: UBSAN")
    set(CMAKE_C_FLAGS_UBSAN
        "-fsanitize=undefined"
        CACHE STRING "Flags used by the C compiler during UndefinedBehaviourSanitizer builds."
        FORCE
    )

    set(CMAKE_CXX_FLAGS_UBSAN
        "-fsanitize=undefined"
        CACHE STRING "Flags used by the C++ compiler during UndefinedBehaviourSanitizer builds."
        FORCE
    )
endfunction ()
