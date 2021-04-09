file( GLOB SRCS *.asm )
foreach(FILE ${SRCS})
    get_filename_component(BASENAME ${FILE} NAME_WLE)
    get_filename_component(FILENAME ${FILE} NAME)
    add_executable(${BASENAME} ${FILENAME})
    target_link_libraries(${BASENAME}
        PRIVATE asminc unit_test reverse)

    add_test(
        NAME run_${BASENAME}
        COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/cx16-test.sh bin/${BASENAME}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR})
endforeach()
