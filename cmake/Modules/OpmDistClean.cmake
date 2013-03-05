# - Cleanup configuration files
#
# Remove files generated by the configuration (not by the build); the
# purpose is to get back a clean directory with no build artifacts
# (some empty directories may be left behind, though)
#
# The following suffices are supported:
# _NAME                 Name of the project
# _STYLESHEET_COPIED    Stylesheet that was copied for the documentation
# _LIBTOOL_ARCHIVE      Libtool archive file generated for library
# _DEBUG                Debug information extracted from library

macro (opm_dist_clean opm)

  set (DISTCLEAN_FILES
	CMakeCache.txt
	cmake_install.cmake
	Makefile
	config.h
	config.h.tmp
	${${opm}_NAME}-config.cmake
	${${opm}_NAME}-config-version.cmake
	${${opm}_NAME}-install.cmake
	${${opm}_NAME}.pc
	${${opm}_NAME}-install.pc
	${doxy_dir}/Doxyfile
	${doxy_dir}/Doxyfile.in
	CTestTestfile.cmake
	DartConfiguration.tcl
	lib/${${opm}_LIBTOOL_ARCHIVE}
	${${opm}_DEBUG}
	${tests_DEBUG}
	${examples_DEBUG}
	${tutorial_DEBUG}
	install_manifest.txt
	${${opm}_STYLESHEET_COPIED}
	${tests_INPUT_FILES}
	)
  # only remove these files if they were actually copied
  if (NOT PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
	list (APPEND DISTCLEAN_FILES
	  GNUmakefile
	  )
  endif (NOT PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
  # script to remove empty directories (can't believe this isn't included!)
  set (rmdir "${PROJECT_SOURCE_DIR}/cmake/Scripts/RemoveEmptyDir.cmake")
  add_custom_target (distclean
	COMMAND ${CMAKE_COMMAND} -E remove -f ${DISTCLEAN_FILES}
	COMMAND ${CMAKE_COMMAND} -E remove_directory CMakeFiles/
	COMMAND ${CMAKE_COMMAND} -E remove_directory Testing/
	COMMAND ${CMAKE_COMMAND} -DDIR=${CMAKE_LIBRARY_OUTPUT_DIRECTORY} -P ${rmdir}
	COMMAND ${CMAKE_COMMAND} -DDIR=${CMAKE_RUNTIME_OUTPUT_DIRECTORY} -P ${rmdir}
	COMMAND ${CMAKE_COMMAND} -DDIR:LOCATION=${doxy_dir} -P ${rmdir}
	COMMAND ${CMAKE_COMMAND} -DDIR:LOCATION=${tests_DIR} -P ${rmdir}
# cannot depend on clean because it is only defined in the master Makefile
# not in CMakeFiles/Makefile where this target will end up
#	DEPENDS clean
	WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
	COMMENT Removing CMake-generated files
	VERBATIM
	)
  
endmacro (opm_dist_clean opm)
