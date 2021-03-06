SET(EXE_PREFIX "")
SET(LIB_PREFIX ".so")
SET(PATH_SEP ":")
IF(WIN32)
  SET(EXE_PREFIX ".exe")
  SET(LIB_PREFIX ".dll")
  SET(PATH_SEP ";")
ENDIF(WIN32)

SET(ENV{PATH} "${OUTPUT_TOOL_DIR}${PATH_SEP}$ENV{PATH}")


FUNCTION(ADD_GO_EXECUTABLE EXEC_NAME GO_SOURCE TARGET_DIR)
  ADD_CUSTOM_TARGET(${EXEC_NAME})

  ADD_CUSTOM_COMMAND(TARGET ${EXEC_NAME}
    COMMAND env GOPATH=${GOPATH} env GO111MODULE=on ${CMAKE_Go_COMPILER} build
    -o "${CMAKE_CURRENT_BINARY_DIR}/${EXEC_NAME}${EXE_PREFIX}"
    ${CMAKE_GO_FLAGS} ${GO_SOURCE}
    WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
    DEPENDS ${GO_SOURCE}
    COMMENT "Building Go executable ${EXEC_NAME}")

  FOREACH(DEP ${ARGN})
    ADD_DEPENDENCIES(${EXEC_NAME} ${DEP})
  ENDFOREACH()

  INSTALL(PROGRAMS ${CMAKE_CURRENT_BINARY_DIR}/${EXEC_NAME}${EXE_PREFIX} DESTINATION ${TARGET_DIR})
ENDFUNCTION(BUILD_GO_EXECUTABLE)


FUNCTION(ADD_GO_TOOL TOOL_NAME GO_SOURCE TARGET_DIR)
  ADD_CUSTOM_TARGET(${TOOL_NAME})

  ADD_CUSTOM_COMMAND(TARGET ${TOOL_NAME}
    COMMAND env GOPATH=${GOPATH} env GO111MODULE=on ${CMAKE_Go_COMPILER} build
    -o "${TARGET_DIR}/${TOOL_NAME}${EXE_PREFIX}"
    ${CMAKE_GO_FLAGS} ${GO_SOURCE}
    WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
    DEPENDS ${GO_SOURCE}
    COMMENT "Building Go tool ${TOOL_NAME}")

  FOREACH(DEP ${ARGN})
    ADD_DEPENDENCIES(${TOOL_NAME} ${DEP})
  ENDFOREACH()

  INSTALL(PROGRAMS ${CMAKE_CURRENT_BINARY_DIR}/${TOOL_NAME}${EXE_PREFIX} DESTINATION ${TARGET_DIR})
ENDFUNCTION(BUILD_GO_TOOL)


FUNCTION(BUILD_GO_LIBRARY LIB_NAME BUILD_TYPE GO_SOURCE TARGET_DIR)
ADD_CUSTOM_TARGET(${LIB_NAME})

  SET(BUILD_MODE -buildmode=${BUILD_TYPE})
  STRING(TOUPPER ${BUILD_TYPE} BUILD_TYPE_UPPER)
  IF(BUILD_TYPE_UPPER STREQUAL "ARCHIVE" OR "C-ARCHIVE")
    SET(OUT_LIB_NAME "${LIB_NAME}.a")
  ELSEIF(BUILD_TYPE_UPPER STREQUAL "C-SHARED" OR "SHARED")
    SET(OUT_LIB_NAME "${LIB_NAME}${LIB_PREFIX}")
  ENDIF()

  ADD_CUSTOM_COMMAND(TARGET ${LIB_NAME}
    COMMAND env GOPATH=${GOPATH} env GO111MODULE=on ${CMAKE_Go_COMPILER} build ${BUILD_MODE}
    -o "${OUTPUT_DIR}/${OUT_LIB_NAME}"
    ${CMAKE_GO_FLAGS} ${GO_SOURCE}
    WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
    DEPENDS ${GO_SOURCE}
    COMMENT "Building Go library ${LIB_NAME}")

  FOREACH(DEP ${ARGN})
    ADD_DEPENDENCIES(${LIB_NAME} ${DEP})
  ENDFOREACH()

  INSTALL(PROGRAMS ${CMAKE_CURRENT_BINARY_DIR}/${LIB_NAME}${EXE_PREFIX} DESTINATION ${TARGET_DIR})
ENDFUNCTION(BUILD_GO_LIBRARY)
