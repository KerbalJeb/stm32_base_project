cmake_minimum_required(VERSION 3.7)

set(CMAKE_TOOLCHAIN_FILE cmake/arm_none_eabi_gcc_toolchain.cmake)

project(CMakeSTM32_Test)
set(ELF ${PROJECT_NAME}.elf)
add_executable(${ELF} src/main.c)
target_compile_definitions(${ELF} PUBLIC -DSTM32F4)

add_custom_command(TARGET ${ELF}
POST_BUILD
COMMAND ${CMAKE_OBJCOPY} ARGS -O binary ${ELF} ${PROJECT_NAME}.bin)

# Configure libopencm3
set(LIBOPENCM3_DIR ${CMAKE_SOURCE_DIR}/system/libopencm3)
include_directories(${LIBOPENCM3_DIR}/include)
add_custom_target(libopencm3 COMMAND make -j8 WORKING_DIRECTORY ${LIBOPENCM3_DIR})
find_library(libopencm3_stm32f4 libopencm3_stm32f4.a PATHS ${LIBOPENCM3_DIR}/lib)
target_link_libraries(${ELF} ${libopencm3_stm32f4})

# Configure Freertos
set(FREERTOS_DIR ${CMAKE_SOURCE_DIR}/system/FreeRTOS/FreeRTOS/Source)
set(FREERTOS_PORT_DIR ${FREERTOS_DIR}/portable/GCC/ARM_CM4F)

include_directories(
    ${CMAKE_SOURCE_DIR}/src
    ${FREERTOS_DIR}/include
    ${FREERTOS_PORT_DIR})
set(FREERTOS_LIB_SRC
    ${FREERTOS_PORT_DIR}//port.c
    ${FREERTOS_DIR}/portable/MemMang/heap_1.c
    ${FREERTOS_DIR}/portable/MemMang/heap_2.c
    ${FREERTOS_DIR}/portable/MemMang/heap_3.c
    ${FREERTOS_DIR}/portable/MemMang/heap_4.c
    ${FREERTOS_DIR}/portable/MemMang/heap_5.c
    ${FREERTOS_DIR}/croutine.c
    ${FREERTOS_DIR}/event_groups.c
    ${FREERTOS_DIR}/list.c
    ${FREERTOS_DIR}/queue.c
    ${FREERTOS_DIR}/stream_buffer.c
    ${FREERTOS_DIR}/tasks.c
    ${FREERTOS_DIR}/timers.c)
add_library(freertos STATIC ${FREERTOS_LIB_SRC})
target_link_libraries(${ELF} ${freertos})
