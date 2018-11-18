function(__detect_generator__ generator_str result_str)
    string(REGEX MATCH "^Visual Studio [1-9][0-9]*( .NET)?( [1-9][0-9]*)?( Win64|ARM)?" str ${generator_str})
    if(${str} STREQUAL ${generator_str})
        set(${result_str} "msdev" PARENT_SCOPE)
    else()
        set(${result_str} "other" PARENT_SCOPE)
    endif(${str} STREQUAL ${generator_str})
endfunction(__detect_generator__ generator_str result_str)

#[[
__detect_generator__("Visual Studio 6" gen_str)
message(STATUS ${gen_str})
__detect_generator__("Visual Studio 7" gen_str)
message(STATUS ${gen_str})
__detect_generator__("Visual Studio 7 .NET 2003" gen_str)
message(STATUS ${gen_str})
__detect_generator__("Visual Studio 8 2005" gen_str)
message(STATUS ${gen_str})
__detect_generator__("Visual Studio 9 2008" gen_str)
message(STATUS ${gen_str})
__detect_generator__("Visual Studio 10 2010" gen_str)
message(STATUS ${gen_str})
__detect_generator__("Visual Studio 11 2012" gen_str)
message(STATUS ${gen_str})
__detect_generator__("Visual Studio 12 2013" gen_str)
message(STATUS ${gen_str})
__detect_generator__("Visual Studio 14 2015" gen_str)
message(STATUS ${gen_str})
__detect_generator__("Visual Studio 15 2017" gen_str)
message(STATUS ${gen_str})
]]#

function(detect_generator gen_str)
    __detect_generator__(${CMAKE_GENERATOR} __gen_str__)
    set(${gen_str} ${__gen_str__} PARENT_SCOPE)
endfunction(detect_generator gen_str)

__detect_generator__(${CMAKE_GENERATOR} __gen_str__)
if( ${__gen_str__} STREQUAL "msdev")
    list(APPEND files msdev_configuration_types)
elseif(CMAKE_GENERATOR STREQUAL "MinGW Makefiles")
    list(APPEND files mingw_configuration_types)
    list(APPEND files mingw_multiplatforms)
endif(${__gen_str__} STREQUAL "msdev")
foreach(mkf IN LISTS files)
    find_file(FP ${mkf}.cmake PATHS ${CMAKE_MODULE_PATH})
    include(${FP})
endforeach(mkf IN LISTS files)

function(set_executable_out target_name)
    foreach(CFG ${CMAKE_CONFIGURATION_TYPES})
        string(TOUPPER ${CFG} CFG)
        set_property(TARGET ${target_name} PROPERTY RUNTIME_OUTPUT_DIRECTORY_${CFG} "${CMAKE_SOURCE_DIR}/bin")
    endforeach(CFG CMAKE_CONFIGURATION_TYPES)
endfunction(set_executable_out target)

function(set_library_out target_name)
    foreach(CFG ${CMAKE_CONFIGURATION_TYPES})
        string(TOUPPER ${CFG} CFG)
        set_property(TARGET ${target_name} PROPERTY ARCHIVE_OUTPUT_DIRECTORY_${CFG} "${CMAKE_SOURCE_DIR}/libs")
    endforeach(CFG CMAKE_CONFIGURATION_TYPES)
endfunction(set_library_out target)


function(set_shared_library_out target_name)
foreach(CFG ${CMAKE_CONFIGURATION_TYPES})
    string(TOUPPER ${CFG} CFG)
    set_property(TARGET ${target_name} PROPERTY ARCHIVE_OUTPUT_DIRECTORY_${CFG} "${CMAKE_SOURCE_DIR}/libs")
    set_property(TARGET ${target_name} PROPERTY RUNTIME_OUTPUT_DIRECTORY_${CFG} "${CMAKE_SOURCE_DIR}/bin")
endforeach(CFG CMAKE_CONFIGURATION_TYPES)
endfunction(set_shared_library_out target)