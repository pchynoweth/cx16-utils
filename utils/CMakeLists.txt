project(utils)
file( GLOB SRCS *.asm )
foreach(FILE ${SRCS})
    get_filename_component(BASENAME ${FILE} NAME_WLE)
    get_filename_component(FILENAME ${FILE} NAME)
    set(NAME ${BASENAME})
    add_library(${NAME} STATIC ${FILENAME})
    target_link_libraries(${NAME} PUBLIC asminc)
endforeach()

target_link_libraries(unit_test
    INTERFACE bzero sysout puts putint16 puthex16)

target_link_libraries(puthex16
    INTERFACE puthex)