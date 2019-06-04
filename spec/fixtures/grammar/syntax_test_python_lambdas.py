# SYNTAX TEST "source.python.legesher"


# my_func2 = {lambda} x, y=2, *z, **kw: x + y + 1
# #        ^ keyword.operator.assignment
# #          ^^^^^^^^^^^^^^^^^^^^^^^^^ meta.function.inline
# #           ^^^^^^^ storage.type.function.inline
# #                   ^^^^^^^^^^^^^^^^ meta.function.inline.parameters
# #                   ^  ^     ^    ^^ variable.parameter.function
# #                    ^    ^   ^ punctuation.separator.parameters
# #                      ^ variable.parameter.function
# #                       ^ keyword.operator.assignment
# #                        ^ constant
# #                           ^   ^^ keyword.operator.unpacking.arguments
# #                            ^ variable.parameter.function
# #                                   ^ punctuation.definition.function.begin
# #

# {lambda} x, z = 4: x * z
# # ^^^^^^^^^^^^^^^ meta.function.inline.python.legesher
# # <- storage.type.function.inline.python.legesher
# #        ^^^^^^^^ meta.function.inline.parameters.python.legesher
# #        ^  ^ variable.parameter.function.python.legesher
# #         ^ punctuation.separator.parameters.python.legesher
# #             ^ keyword.operator.assignment.python.legesher
# #               ^ constant.numeric.integer.decimal.python.legesher
# #                ^ punctuation.definition.function.begin.python.legesher


# {lambda}: {None}
# # ^^^^^^ meta.function.inline.python.legesher
# # <- storage.type.function.inline.python.legesher
# #       ^ punctuation.definition.function.begin.python.legesher


not_a_lambda.foo
# <- ! meta.function.inline.python.legesher


lambda_not.foo
# <- ! meta.function.inline.python.legesher
