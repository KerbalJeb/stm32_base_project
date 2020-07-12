set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(CMAKE_SYSTEM_VERSION 1)
set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER arm-none-eabi-g++)
set(AS arm-none-eabi-as)
set(AR arm-none-eabi-ar)
set(OBJCOPY arm-none-eabi-objcopy)
set(OBJDUMP arm-none-eabi-objdump)
set(SIZE arm-none-eabi-size)

set(CMAKE_EXE_LINKER_FLAGS   
    "-T${PROJECT_SOURCE_DIR}/src/linker_file.ld\
    -mthumb -mcpu=cortex-m4\
    --specs=nosys.specs -Wl,-Map=${ProjName}.map\
    -Wl,--gc-sections\
    -static --specs=nano.specs\
    -mfpu=fpv4-sp-d16 -mfloat-abi=hard\
    -Wl,--start-group\
    -lc -lm -lstdc++\
    -lsupc++ -Wl,--end-group\
    -Wl,--print-memory-usage")

# set(CMAKE_CXX_FLAGS 
#     -mcpu=cortex-m4
#     -g3
#     -O3
#     -ffunction-sections
#     -fdata-sections
#     -fno-exceptions
#     -fno-rtti
#     -fno-threadsafe-statics
#     -fno-use-cxa-atexit
#     -Wall
#     -Wno-unused-but-set-variable
#     -std=c++17
#     -fstack-usage
#     --specs=nano.specs
#     -mfpu=fpv4-sp-d16
#     -mfloat-abi=hard
#     -mthumb)

set(CMAKE_C_FLAGS 
    "-mcpu=cortex-m4\
    -g3\
    -O3\
    -ffunction-sections\
    -fdata-sections\
    -Wall\
    -Wno-unused-but-set-variable\
    -fstack-usage\
    -mfpu=fpv4-sp-d16\
    -mfloat-abi=hard\
    -mthumb\
    -nostartfiles")
