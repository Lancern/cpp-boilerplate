# Add a project library target.
#
# Usage:
# "add_${PROJECT_NAME_LOWERCASE}_library"(<name> <type>
#     SOURCES <sources> ...
#     [ DEPENDS <project_dependencies> ... ]
#     [ EXTERNAL_DEPENDS <external_dependencies> ... ])
#
# where:
#     * <name> is the name of the project library. When calling add_library, this function will
#       prefix the name with the project's name as the target name. For example, if <name> is
#       "Support" and the project's name is "MyProject", then the target name will be
#       "MyProjectSupport".
#     * <type> is the type of the library. Its possible values are "STATIC", "SHARED", "MODULE" and
#       "INTERFACE".
#     * <sources> ... is the list of source files included in this target.
#     * <project_dependencies> ... is the list of project library targets the new target depends on.
#     * <external_dependencies> ... is the list of non-project target the new target depends on.
#
# Please note that all dependencies, including project dependencies and non-project dependencies,
# will be populated as public dependencies of the new target. If you want to add private or interface
# dependencies, please invoke target_link_libraries manually on the new target.
#
function("add_${PROJECT_NAME_LOWERCASE}_library" name type)
    string(CONCAT target_name "${PROJECT_NAME}" "${name}")

    slice_section("${ARGN}" "SOURCES" "SOURCES;DEPENDS;EXTERNAL_DEPENDS" sources)
    slice_section("${ARGN}" "DEPENDS" "SOURCES;DEPENDS;EXTERNAL_DEPENDS" depends)
    slice_section("${ARGN}" "EXTERNAL_DEPENDS" "SOURCES;DEPENDS;EXTERNAL_DEPENDS" external_depends)

    if(NOT sources)
        message(FATAL_ERROR "No sources given for project library \"${name}\".")
    endif()

    if(type MATCHES "STATIC|SHARED|MODULE")
        add_library("${target_name}" "${type}" ${sources})
    elseif(type STREQUAL "INTERFACE")
        add_library("${target_name}" INTERFACE)
        target_sources("${target_name}" INTERFACE ${sources})
    else()
        message(FATAL_ERROR "Unknown project library type ${type}.")
    endif()

    if(depends OR external_depends)
        list(TRANSFORM depends PREPEND "${PROJECT_NAME}")
        target_link_libraries("${name}"
                PUBLIC ${depends} ${external_depends})
    endif()

    message(VERBOSE "Project library target ${target_name} has been added.")
endfunction()
