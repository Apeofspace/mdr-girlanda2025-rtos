# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.28

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/local/bin/cmake

# The command to remove a file.
RM = /usr/local/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/v/proj/mdr-rtos-test/lib/FreeRTOS-Kernel/examples/coverity

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/v/proj/mdr-rtos-test/lib/FreeRTOS-Kernel/examples/coverity/build

# Include any dependencies generated for this target.
include CMakeFiles/coverity.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/coverity.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/coverity.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/coverity.dir/flags.make

CMakeFiles/coverity.dir/home/v/proj/mdr-rtos-test/lib/FreeRTOS-Kernel/examples/cmake_example/main.c.o: CMakeFiles/coverity.dir/flags.make
CMakeFiles/coverity.dir/home/v/proj/mdr-rtos-test/lib/FreeRTOS-Kernel/examples/cmake_example/main.c.o: /home/v/proj/mdr-rtos-test/lib/FreeRTOS-Kernel/examples/cmake_example/main.c
CMakeFiles/coverity.dir/home/v/proj/mdr-rtos-test/lib/FreeRTOS-Kernel/examples/cmake_example/main.c.o: CMakeFiles/coverity.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/v/proj/mdr-rtos-test/lib/FreeRTOS-Kernel/examples/coverity/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object CMakeFiles/coverity.dir/home/v/proj/mdr-rtos-test/lib/FreeRTOS-Kernel/examples/cmake_example/main.c.o"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT CMakeFiles/coverity.dir/home/v/proj/mdr-rtos-test/lib/FreeRTOS-Kernel/examples/cmake_example/main.c.o -MF CMakeFiles/coverity.dir/home/v/proj/mdr-rtos-test/lib/FreeRTOS-Kernel/examples/cmake_example/main.c.o.d -o CMakeFiles/coverity.dir/home/v/proj/mdr-rtos-test/lib/FreeRTOS-Kernel/examples/cmake_example/main.c.o -c /home/v/proj/mdr-rtos-test/lib/FreeRTOS-Kernel/examples/cmake_example/main.c

CMakeFiles/coverity.dir/home/v/proj/mdr-rtos-test/lib/FreeRTOS-Kernel/examples/cmake_example/main.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing C source to CMakeFiles/coverity.dir/home/v/proj/mdr-rtos-test/lib/FreeRTOS-Kernel/examples/cmake_example/main.c.i"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/v/proj/mdr-rtos-test/lib/FreeRTOS-Kernel/examples/cmake_example/main.c > CMakeFiles/coverity.dir/home/v/proj/mdr-rtos-test/lib/FreeRTOS-Kernel/examples/cmake_example/main.c.i

CMakeFiles/coverity.dir/home/v/proj/mdr-rtos-test/lib/FreeRTOS-Kernel/examples/cmake_example/main.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling C source to assembly CMakeFiles/coverity.dir/home/v/proj/mdr-rtos-test/lib/FreeRTOS-Kernel/examples/cmake_example/main.c.s"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/v/proj/mdr-rtos-test/lib/FreeRTOS-Kernel/examples/cmake_example/main.c -o CMakeFiles/coverity.dir/home/v/proj/mdr-rtos-test/lib/FreeRTOS-Kernel/examples/cmake_example/main.c.s

# Object files for target coverity
coverity_OBJECTS = \
"CMakeFiles/coverity.dir/home/v/proj/mdr-rtos-test/lib/FreeRTOS-Kernel/examples/cmake_example/main.c.o"

# External object files for target coverity
coverity_EXTERNAL_OBJECTS =

coverity: CMakeFiles/coverity.dir/home/v/proj/mdr-rtos-test/lib/FreeRTOS-Kernel/examples/cmake_example/main.c.o
coverity: CMakeFiles/coverity.dir/build.make
coverity: FreeRTOS-Kernel/libfreertos_kernel.a
coverity: CMakeFiles/coverity.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --bold --progress-dir=/home/v/proj/mdr-rtos-test/lib/FreeRTOS-Kernel/examples/coverity/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C executable coverity"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/coverity.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/coverity.dir/build: coverity
.PHONY : CMakeFiles/coverity.dir/build

CMakeFiles/coverity.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/coverity.dir/cmake_clean.cmake
.PHONY : CMakeFiles/coverity.dir/clean

CMakeFiles/coverity.dir/depend:
	cd /home/v/proj/mdr-rtos-test/lib/FreeRTOS-Kernel/examples/coverity/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/v/proj/mdr-rtos-test/lib/FreeRTOS-Kernel/examples/coverity /home/v/proj/mdr-rtos-test/lib/FreeRTOS-Kernel/examples/coverity /home/v/proj/mdr-rtos-test/lib/FreeRTOS-Kernel/examples/coverity/build /home/v/proj/mdr-rtos-test/lib/FreeRTOS-Kernel/examples/coverity/build /home/v/proj/mdr-rtos-test/lib/FreeRTOS-Kernel/examples/coverity/build/CMakeFiles/coverity.dir/DependInfo.cmake "--color=$(COLOR)"
.PHONY : CMakeFiles/coverity.dir/depend

