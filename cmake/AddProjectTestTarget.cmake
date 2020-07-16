# Add a new test target for the current project.
#
# Usage:
#     ${PROJECT_NAME}_add_test(<name>
#         SOURCES <sources> ...
#         DEPENDS <project_dependencies> ...
#         EXTERNAL_DEPENDS <external_dependencies> ...)
#
# where:
#     * <name> is the name of the test, the target name will be prefixed with "${PROJECT_NAME}" and
#       "Test". For example, if <name> is "Support" and the project's name is "MyProject", then the
#       created target name will be "MyProjectTestSupport".
#     * <sources> ... is the list of source files of the test target;
#     * <project_dependencies> ... is the list of project library targets the new test target
#       depends on;
#     * <external_dependencies> ... is the list of non-project targets the new test target depends
#       on.
function("${PROJECT_NAME_LOWERCASE}_add_test" name)
    slice_section("${ARGN}" "SOURCES" "SOURCES;DEPENDS;EXTERNAL_DEPENDS" sources)
    slice_section("${ARGN}" "DEPENDS" "SOURCES;DEPENDS;EXTERNAL_DEPENDS" depends)
    slice_section("${ARGN}" "EXTERNAL_DEPENDS" "SOURCES;DEPENDS;EXTERNAL_DEPENDS" external_depends)

    if(NOT sources)
        message(FATAL_ERROR "No sources given for test target \"${name}\".")
    endif()

    string(CONCAT target_name "${PROJECT_NAME}Test" "${name}")
    list(TRANSFORM depends PREPEND "${PROJECT_NAME}Test")

    add_executable("${target_name}" ${sources})
    target_link_libraries("${target_name}"
            PRIVATE gtest gmock gtest_main ${depends} ${external_depends})
    gtest_discover_tests("${target_name}"
            WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
            PROPERTIES VS_DEBUGGER_WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}")
    set_target_properties("${target_name}" PROPERTIES FOLDER tests)

    message(VERBOSE "Project test target ${target_name} has been added.")
endfunction()
