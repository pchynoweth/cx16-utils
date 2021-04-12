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

make_test(test_div
    SOURCES test_div.asm
    LIBS div)

make_test(test_reverse
    SOURCES test_reverse.asm
    LIBS reverse)