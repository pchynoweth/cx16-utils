project(test)

function(make_test NAME)
    cmake_parse_arguments(MAKE_TEST
        "" # options
        "" # single value keywords
        "SOURCES;LIBS" # multi-value keywords
        ${ARGN}
    )

    add_executable(${NAME} ${MAKE_TEST_SOURCES})
    target_link_libraries(${NAME}
        PRIVATE asminc unit_test ${MAKE_TEST_LIBS})

    add_test(
        NAME run_${NAME}
        COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/cx16-test.sh bin/${NAME}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR})
endfunction()

file(GLOB TEST_FILES test_*.asm)

foreach(TEST_FILE ${TEST_FILES})
    get_filename_component(FILE ${TEST_FILE} NAME)
    get_filename_component(BASENAME ${TEST_FILE} NAME_WE)
    string(REGEX REPLACE "^test_" "" LIB ${BASENAME})

    make_test(${BASENAME}
        SOURCES ${FILE}
        LIBS ${LIB})
endforeach()