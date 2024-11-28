cmake_minimum_required(VERSION 3.7...3.28)
if(${CMAKE_VERSION} VERSION_LESS 3.12)
  cmake_policy(VERSION ${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION})
endif()

# -----PROJECT NAME-----
# this hack puts dir name as project name
cmake_path(GET CMAKE_CURRENT_SOURCE_DIR FILENAME ProjectName)
string(REPLACE " " "_" ProjectId ${ProjectName})
project(${ProjectName})
set(OUTPUT_NAME ${OUTPUT_BIN_NAME})

# -----MCU-----
set(MCPU cortex-m3)
set(MCU_MODEL MDR1986VE9x)

# ----COMPILER SETTINGS----
enable_language(C CXX ASM)
set(CMAKE_C_STANDARD 23)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ON)
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_VERSION 1)
set(CMAKE_EXPORT_COMPILE_COMMANDS 1)
set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER arm-none-eabi-g++)
set(CMAKE_ASM_COMPILER arm-none-eabi-gcc)
set(CMAKE_AR arm-none-eabi-ar)
set(CMAKE_OBJCOPY arm-none-eabi-objcopy)
set(CMAKE_OBJDUMP arm-none-eabi-objdump)
set(SIZE arm-none-eabi-size)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# ----SOURCES----
file(GLOB_RECURSE C_SRC CONFIGURE_DEPENDS src/*.c)
file(GLOB_RECURSE C_LIBS CONFIGURE_DEPENDS lib/CMSIS/*.c
     lib/MDR32F9Qx_StdPeriph_Driver/*.c)

set(INCLUDE_DIRS
    src
    src/freertos
    lib
    lib/Config
    lib/CMSIS/CM3/DeviceSupport/MDR32F9Qx/inc
    lib/MDR32F9Qx_StdPeriph_Driver/inc
    lib/MDR32F9Qx_StdPeriph_Driver/inc/USB_Library
    lib/CMSIS/CM3/CoreSupport
    lib/CMSIS/CM3/DeviceSupport/MDR32F9Qx/inc
    lib/CMSIS/CM3/DeviceSupport/MDR32F9Qx/startup/gcc)

set(LINKER_SCRIPT ${CMAKE_SOURCE_DIR}/lib/CMSIS/CM3/DeviceSupport/MDR32F9Qx/startup/gcc/MDR32F9Qx.ld)
set(STARTUP_SCRIPT ${CMAKE_SOURCE_DIR}/lib/CMSIS/CM3/DeviceSupport/MDR32F9Qx/startup/gcc/startup_MDR32F9Qx.s)

# -----COMPILE OPTIONS-----
set(COMP_DEFS USE_${MCU_MODEL})
set(COMP_OPTS
  -mcpu=${MCPU}
  -mthumb
  -mfloat-abi=soft
  -ffunction-sections
  -fdata-sections
  -flto
  -fmessage-length=0
  -Wextra
  -Wshadow
  -Wredundant-decls
  -Wno-missing-field-initializers
  -Wno-cpp
  # -Wconversion
  -Wno-packed-bitfield-compat
  -pipe
  -MMD
  -MP)

set(LINK_OPTS
  -T
  ${LINKER_SCRIPT}
  -mcpu=${MCPU}
  -mthumb
  # -lm --specs=nano.specs
  -lm
  -lnosys
  --specs=nosys.specs
  -Wl,-Map=${PROJECT_BINARY_DIR}/${PROJECT_NAME}.map,--cref
  -Wl,--gc-sections)

# target_compile_definitions(${OUTPUT_NAME}.elf PRIVATE ${COMP_DEFS})
add_compile_definitions(${COMP_DEFS})
add_compile_options(${COMP_OPTS})
add_link_options(${LINK_OPTS})

# -----FREERTOS------------
set(FREERTOS_KERNEL_PATH lib/FreeRTOS-Kernel)
set(FREERTOS_COMP_DEFS projCOVERAGE_TEST=0)
set(FREERTOS_HEAP "4" CACHE STRING "" FORCE) # Select the native compile PORT
set(FREERTOS_PORT "GCC_ARM_CM3" CACHE STRING "" FORCE) # Adding the FreeRTOS-Kernel subdirectory
# target_include_directories(freertos_config INTERFACE src/freertos)
add_library(freertos_config INTERFACE)
include_directories(${INCLUDE_DIRS})
include_directories(src/freertos)
target_compile_definitions(freertos_config INTERFACE ${FREERTOS_COMP_DEFS})
add_subdirectory(${FREERTOS_KERNEL_PATH} lib/FreeRTOS-Kernel)

# -----BUILD TYPE-----
if("${CMAKE_BUILD_TYPE}" STREQUAL "Release")
  message(STATUS "Maximum optimization for speed")
  add_compile_options(-O3)
elseif("${CMAKE_BUILD_TYPE}" STREQUAL "RelWithDebInfo")
  message(STATUS "Maximum optimization for speed, debug info included")
  add_compile_options(-O3 -g)
elseif("${CMAKE_BUILD_TYPE}" STREQUAL "MinSizeRel")
  message(STATUS "Maximum optimization for size")
  add_compile_options(-Os)
else()
  message(STATUS "Minimal optimization, debug info included")
  add_compile_options(-Og -g)
endif()

# -----BUILD COMMANDS-----
add_executable(${OUTPUT_NAME}.elf ${C_SRC} ${C_LIBS} ${STARTUP_SCRIPT} ${LINKER_SCRIPT})
set(HEX_FILE ${PROJECT_BINARY_DIR}/${OUTPUT_NAME}.hex)
set(BIN_FILE ${PROJECT_BINARY_DIR}/${OUTPUT_NAME}.bin)

# target_include_directories(${OUTPUT_NAME}.elf PRIVATE ${INCLUDE_DIRS})
target_link_libraries(${OUTPUT_NAME}.elf m) # link math.h
target_link_libraries(${OUTPUT_NAME}.elf freertos_kernel freertos_config)

add_custom_command(
  TARGET ${OUTPUT_NAME}.elf
  POST_BUILD
  COMMAND ${CMAKE_OBJCOPY} -Oihex $<TARGET_FILE:${OUTPUT_NAME}.elf> ${HEX_FILE}
  COMMAND ${CMAKE_OBJCOPY} -Obinary $<TARGET_FILE:${OUTPUT_NAME}.elf>
          ${BIN_FILE}
  COMMENT "Building ${HEX_FILE}
    Building ${BIN_FILE}")
