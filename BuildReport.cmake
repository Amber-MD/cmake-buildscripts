# Prints the build report 

function(print_build_report)
	colormsg(HIBLUE "**************************************************************************")
	colormsg("                             " _WHITE_ "Build Report")
    colormsg("                         " _HIMAG_ "3rd Party Libraries")
	       colormsg("---building bundled: -----------------------------------------------------")
	
	foreach(TOOL ${NEEDED_3RDPARTY_TOOLS})
	
		if(${${TOOL}_INTERNAL})
			list(FIND 3RDPARTY_TOOLS ${TOOL} TOOL_INDEX)
			list(GET 3RDPARTY_TOOL_USES ${TOOL_INDEX} TOOL_USE)
		
			colormsg(GREEN "${TOOL}" HIWHITE "- ${TOOL_USE}")
		endif()
	endforeach()
	
	       colormsg("---using installed: ------------------------------------------------------")
	
	foreach(TOOL ${NEEDED_3RDPARTY_TOOLS})
		if(${${TOOL}_EXTERNAL})
			list(FIND 3RDPARTY_TOOLS ${TOOL} TOOL_INDEX)
			list(GET 3RDPARTY_TOOL_USES ${TOOL_INDEX} TOOL_USE)
		
			colormsg(YELLOW "${TOOL}" HIWHITE "- ${TOOL_USE}")
		endif()
	endforeach()
	
			colormsg("---disabled: ------------------------------------------------")
	
	foreach(TOOL ${NEEDED_3RDPARTY_TOOLS})
		if(${${TOOL}_DISABLED})
			list(FIND 3RDPARTY_TOOLS ${TOOL} TOOL_INDEX)
			list(GET 3RDPARTY_TOOL_USES ${TOOL_INDEX} TOOL_USE)
		
			colormsg(HIRED "${TOOL}" HIWHITE "- ${TOOL_USE}")
		endif()
	endforeach()
	
	message("")
    colormsg("                              " _HIMAG_ "Features:")
	# we only want to print these of the corresponding build files have been included
	if(DEFINED MPI)
	color_print_bool("MPI parallelization:   " ${MPI})
	endif()
	
	if(DEFINED OPENMP)
	color_print_bool("OpenMP parallelization:" ${OPENMP})
	endif()
	
	if(DEFINED CUDA)
	color_print_bool("CUDA:                  " ${CUDA})
	endif()
	
	color_print_bool("Build Shared Libraries:" ${SHARED})
	
	if(DEFINED BUILD_GUI)
	color_print_bool("Build GUI Interfaces:  " ${BUILD_GUI})
	endif()
	
	colormsg("Build configuration:   " HIBLUE "${CMAKE_BUILD_TYPE}")
	colormsg("Target Processor:      " YELLOW "${TARGET_ARCH}")
	if(BUILD_DOC)
	colormsg("Build Documentation:   " GREEN "With all, format: ${DOC_FORMAT}")
	elseif(LYX)
	colormsg("Build Documentation:   " YELLOW "As 'make doc' target, format: ${DOC_FORMAT}")
	else()
	colormsg("Build Documentation:   " HIRED "OFF")
	endif()
	if(DEFINED SANDER_VARIANTS_STRING)
	colormsg("Sander Variants:      " HIBLUE "${SANDER_VARIANTS_STRING}")
	endif()
	
	if(DEFINED USE_HOST_TOOLS AND USE_HOST_TOOLS)
	colormsg("Using host tools from " HIBLUE "${HOST_TOOLS_DIR}")
	endif()
	colormsg("Install location:     " HIBLUE "${CMAKE_INSTALL_PREFIX}")
	message("")
	
	#------------------------------------------------------------------------------------------
	colormsg("                             " _HIMAG_ "Compilers:")
	
	# print compiler messages for only the languages that are enabled
	# (thanks to https://stackoverflow.com/questions/32389273/detect-project-language-in-cmake)
	get_property(ENABLED_LANGUAGES GLOBAL PROPERTY ENABLED_LANGUAGES)
	
	if("${ENABLED_LANGUAGES}" MATCHES "C")
	colormsg(CYAN "        C:" YELLOW "${CMAKE_C_COMPILER_ID} ${CMAKE_C_COMPILER_VERSION}" HIRED "(${CMAKE_C_COMPILER})")
	endif()
	
	if("${ENABLED_LANGUAGES}" MATCHES "CXX")
	colormsg(CYAN "      CXX:" YELLOW "${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER_VERSION}" HIRED "(${CMAKE_CXX_COMPILER})")
	endif()
	
	if("${ENABLED_LANGUAGES}" MATCHES "Fortran")
	colormsg(CYAN "  Fortran:" YELLOW "${CMAKE_Fortran_COMPILER_ID} ${CMAKE_Fortran_COMPILER_VERSION}" HIRED "(${CMAKE_Fortran_COMPILER})")
	endif()
		
	# this part is for Amber only
	if(INSIDE_AMBER)
		message("")
		colormsg("                            " _HIMAG_ "Building Tools:")
	
		list_to_space_seperated(BUILDING_TOOLS ${AMBER_TOOLS})
		message("${BUILDING_TOOLS}")
		message("")
		colormsg("                          " _HIMAG_ "NOT Building Tools:")
		foreach(TOOL ${REMOVED_TOOLS})
		
			# get the corresponding reason
			list(FIND REMOVED_TOOLS ${TOOL} TOOL_INDEX)
			list(GET REMOVED_TOOL_REASONS ${TOOL_INDEX} REMOVAL_REASON)
			
			colormsg(HIRED "${TOOL} - ${REMOVAL_REASON}")
		endforeach()
	endif()
	colormsg(HIBLUE "**************************************************************************")
	
	if(DEFINED PRINT_PACKAGING_REPORT AND PRINT_PACKAGING_REPORT)
		print_packaging_report()
	endif()
endfunction(print_build_report)