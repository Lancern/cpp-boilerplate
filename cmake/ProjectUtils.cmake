# Slice expected section from the given list.
#
# The input list is assumed to contain several "sections". Each section starts by some keyword.
# For example, the following list contains three sections, "SOURCE", "DEPENDS" and
# "EXTERNAL_DEPENDS":
#
#     SOURCE main.cpp hello.cpp DEPENDS Support Core EXTERNAL_DEPENDS boost
#
# The content of the "SOURCE" section is "main.cpp" and "hello.cpp", the content of the "DEPENDS"
# section is "Support", "Core", etc.
#
# This function can extract section contents from an input list.
#
# Usage:
#     slice_section(<list> <section_name> <all_section_names_list> <output_list>)
#
# where:
#     * <list> is the input list;
#     * <section_name> is the name of the section to slice;
#     * <all_section_names_list> is a list of all section names, they are used as separators between
#       sections;
#     * <output_list> is the content of the selected section.
#
# This function will set output_list to an empty list if the desired section is not found in the
# input list.
function(slice_section input_list section_name section_names_list output_list)
    if(NOT section_name IN_LIST section_names_list)
        message(WARNING "Section name \"${section_name}\" is not in section_names_list.")
    endif()

    list(FIND input_list "${section_name}" section_name_index)
    if(section_name_index EQUAL -1)
        set("${output_list}" "" PARENT_SCOPE)
        return()
    endif()

    math(EXPR start_index "${section_name_index} + 1")
    set(i "${start_index}")

    list(LENGTH input_list input_len)
    while(i LESS input_len)
        list(GET input_list "${i}" current)
        if(current IN_LIST section_names_list)
            break()
        endif()
        math(EXPR i "${i} + 1")
    endwhile()

    math(EXPR slice_len "${i} - ${start_index}")
    list(SUBLIST input_list "${start_index}" "${slice_len}" slice_list)
    set("${output_list}" "${slice_list}" PARENT_SCOPE)
endfunction()
