# Configures all of the variants of SANDER
# NOTE: must be included after 3rdPartyTools.cmake

option(BUILD_SANDER_LES "Build another version of sander with LES support compiled in" TRUE)

test(SANDERAPI_DEFAULT NOT MPI)
option(BUILD_SANDER_API "Build the Sander API. Not compatible with MPI." ${SANDERAPI_DEFAULT})

# check if user has changed either setting
if(MPI AND BUILD_SANDER_API)
	message(WARNING "The Sander API is enabled, but MPI is also enabled and the API is incompatible with MPI.  The Sander API will be disabled.")
	set(BUILD_SANDER_API FALSE CACHE BOOL "" FORCE)
endif()
	
# -------------------------------------------------------------
# APBS

option(BUILD_SANDER_APBS "Build another version of sander that uses the APBS (Automatic Poisson-Boltzmann Solver) library" ${apbs_ENABLED})

if(BUILD_SANDER_APBS AND apbs_DISABLED)
	message(FATAL_ERROR "You enabled sander's APBS support, but APBS was not found.")
endif()

	
# -------------------------------------------------------------
# PUPIL

option(BUILD_SANDER_PUPIL "Build another version of sander with PUPIL (Program for User Package Interfacing and Linking) support" ${pupil_ENABLED})

if(BUILD_SANDER_PUPIL AND pupil_DISABLED)
	message(FATAL_ERROR "You enabled sander's PUPIL support, but PUPIL was not found.")
endif()

	
#---------------------------------------------------
# make the SANDER report for the build report
set(SANDER_VARIANTS "")

if(MPI)
	list(APPEND SANDER_VARIANTS MPI)
	if(BUILD_SANDER_LES)
		list(APPEND SANDER_VARIANTS LES-MPI)
	endif()
else()
	list(APPEND SANDER_VARIANTS normal)
	
	if(BUILD_SANDER_LES)
		list(APPEND SANDER_VARIANTS LES)
	endif()
	
	if(BUILD_SANDER_APBS)
		list(APPEND SANDER_VARIANTS APBS)
	endif()
	
	if(BUILD_SANDER_APBS)
		list(APPEND SANDER_VARIANTS PUPIL)
	endif()
	
	if(BUILD_SANDER_API)
		list(APPEND SANDER_VARIANTS API)
		if(BUILD_SANDER_LES)
			list(APPEND SANDER_VARIANTS LES-API)
		endif()
	endif()
endif()

list_to_space_separated(SANDER_VARIANTS_STRING ${SANDER_VARIANTS})