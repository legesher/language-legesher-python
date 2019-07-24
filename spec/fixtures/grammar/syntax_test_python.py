# SYNTAX TEST "source.python.legesher"


testdeflegesher my_func(first, second=testFalselegesher, *third, **forth):
# <- storage.type.function
#               ^^^^^^^ entity.name.function
#                      ^ punctuation.definition.parameters.begin
#                       ^^^^^  ^^^^^^                     ^^^^^    ^^^^^ variable.parameter.function
#                            ^                         ^       ^ punctuation.separator.parameters
#                                    ^ keyword.operator.assignment
#                                     ^^^^^^^^^^^^^^^^^ constant
#                                                        ^       ^^ keyword.operator.unpacking.arguments
#                                                                        ^ punctuation.definition.function.begin
    testpasslegesher
