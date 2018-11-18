if( NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "" FORCE)
endif(NOT CMAKE_CONFIGURATION_TYPES)

function(set_target_regular_postfix target_name)
    if(MINGW)
        set_target_properties(${target_name} PROPERTIES 
            DEBUG_POSTFIX "[gw_${BUILD_PLATFORM}_dbg]"
            RELEASE_POSTFIX "[gw_${BUILD_PLATFORM}_rel]"
        )
    endif(MINGW)
endfunction(set_target_regular_postfix target_name)

function(target_link_regular_libraries target_name)
    if(MINGW)
        set(postfix_expr "[gw_${BUILD_PLATFORM}_$<$<CONFIG:Debug>:dbg>$<$<CONFIG:Release>:rel>]")
    endif(MINGW)
    set(link_libs "")
    foreach(lib IN LISTS ARGV)
        if(NOT ${lib} STREQUAL ${target_name})
            string(APPEND link_libs "${CMAKE_STATIC_LIBRARY_PREFIX}${lib}${postfix_expr}${CMAKE_STATIC_LIBRARY_SUFFIX};")
        endif(NOT ${lib} STREQUAL ${target_name})
    endforeach(lib IN LISTS ARGV)
    target_link_libraries(${target_name} ${link_libs})
endfunction(target_link_regular_libraries) 


