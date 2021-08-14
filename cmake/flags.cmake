INCLUDE(CheckCXXCompilerFlag)
INCLUDE(CheckCCompilerFlag)
INCLUDE(CheckCXXSymbolExists)
INCLUDE(CheckTypeSize)

FUNCTION(CheckCompilerCXX11Flag)
    IF(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        IF(${CMAKE_CXX_COMPILER_VERSION} VERSION_LESS 4.8)
            MESSAGE(FATAL_ERROR "Unsupported GCC version. GCC >= 4.8 required.")
        ENDIF()
    ELSEIF(CMAKE_CXX_COMPILER_ID STREQUAL "AppleClang" OR CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
        # cmake >= 3.0 compiler id "AppleClang" on Mac OS X, otherwise "Clang"
        # Apple Clang is a different compiler than upstream Clang which havs different version numbers.
        # https://gist.github.com/yamaya/2924292
        IF(APPLE)  # cmake < 3.0 compiler id "Clang" on Mac OS X
            IF(${CMAKE_CXX_COMPILER_VERSION} VERSION_LESS 5.1)
                MESSAGE(FATAL_ERROR "Unsupported AppleClang version. AppleClang >= 5.1 required.")
            ENDIF()
        ELSE()
            IF(${CMAKE_CXX_COMPILER_VERSION} VERSION_LESS 3.3)
                MESSAGE(FATAL_ERROR "Unsupported Clang version. Clang >= 3.3 required.")
            ENDIF()
        ENDIF()
    ENDIF()
ENDFUNCTION()

CheckCompilerCXX11Flag()
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
