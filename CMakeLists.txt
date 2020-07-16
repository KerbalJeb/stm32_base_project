cmake_minimum_required(VERSION 3.7)

set(CMAKE_TOOLCHAIN_FILE cmake/arm_none_eabi_gcc_toolchain.cmake)
set(CMAKE_C_COMPILER_WORKS 1)
set(CMAKE_CXX_COMPILER_WORKS 1)

project(executable)
set(ELF ${PROJECT_NAME}.elf)
add_executable(${ELF} src/main.c src/FreeRTOS-openocd.c)

target_compile_definitions(${ELF} PUBLIC -DSTM32F4)

add_custom_command(TARGET ${ELF}
POST_BUILD
COMMAND ${CMAKE_OBJCOPY} ARGS -O binary ${ELF} ${PROJECT_NAME}.bin)

# Configure libopencm3
set(LIBOPENCM3_DIR ${CMAKE_SOURCE_DIR}/system/libopencm3)
include_directories(${LIBOPENCM3_DIR}/include)
find_library(libopencm3_stm32f4 libopencm3_stm32f4.a PATHS ${LIBOPENCM3_DIR}/lib)

if (NOT libopencm3_stm32f4)
    message("Libopencm3 not built, building")
    execute_process(COMMAND make -j8 WORKING_DIRECTORY ${LIBOPENCM3_DIR})
    find_library(libopencm3_stm32f4 libopencm3_stm32f4.a PATHS ${LIBOPENCM3_DIR}/lib)
endif ()
target_link_libraries(${ELF} ${libopencm3_stm32f4})

# Configure Freertos
set(FREERTOS_DIR ${CMAKE_SOURCE_DIR}/system/FreeRTOS/FreeRTOS/Source)
set(FREERTOS_PORT_DIR ${FREERTOS_DIR}/portable/GCC/ARM_CM4F)

include_directories(
    ${CMAKE_SOURCE_DIR}/src
    ${FREERTOS_DIR}/include
    ${FREERTOS_PORT_DIR})

target_sources(${ELF} PRIVATE
    ${FREERTOS_PORT_DIR}/port.c
    ${FREERTOS_DIR}/portable/MemMang/heap_3.c
    ${FREERTOS_DIR}/croutine.c
    ${FREERTOS_DIR}/event_groups.c
    ${FREERTOS_DIR}/list.c
    ${FREERTOS_DIR}/queue.c
    ${FREERTOS_DIR}/stream_buffer.c
    ${FREERTOS_DIR}/tasks.c
    ${FREERTOS_DIR}/timers.c)
