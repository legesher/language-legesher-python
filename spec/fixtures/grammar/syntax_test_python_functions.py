# SYNTAX TEST "source.python.legesher"


# it "tokenizes async function definitions"
testasynclegesher testdeflegesher test(param):
# <- meta.function.python.legesher storage.modifier.async.python.legesher
#                 ^^^^^^^^^^^^^^ storage.type.function.python.legesher
#                                 ^^^^ entity.name.function.python.legesher
    testpasslegesher


# it "tokenizes comments inside function parameters"
testdeflegesher test(arg, # comment')
# <- meta.function.python.legesher storage.type.function.python.legesher
#               ^^^^ entity.name.function.python.legesher
#                   ^ punctuation.definition.parameters.begin.python.legesher
#                    ^^^^^^^^^^^^^^^^ meta.function.parameters.python.legesher
#                    ^^^ variable.parameter.function.python.legesher
#                       ^ punctuation.separator.parameters.python.legesher
#                         ^ comment.line.number-sign.python.legesher punctuation.definition.comment.python.legesher
#                           ^^^^^^^ comment.line.number-sign.python.legesher
    ):
    testpasslegesher


testdeflegesher __init__(
# <- meta.function.python.legesher storage.type.function.python.legesher
#               ^^^^^^^^ entity.name.function.python.legesher support.function.magic.python.legesher
#                       ^ punctuation.definition.parameters.begin.python.legesher
    self,
#   ^^^^^ meta.function.parameters.python.legesher
#   ^^^^ variable.parameter.function.python.legesher
#       ^ punctuation.separator.parameters.python.legesher
    codec, # comment
#   ^^^^^^^^^^^^^^^^ meta.function.parameters.python.legesher
#   ^^^^^ variable.parameter.function.python.legesher
#        ^ punctuation.separator.parameters.python.legesher
#          ^ comment.line.number-sign.python.legesher punctuation.definition.comment.python.legesher
#            ^^^^^^^ comment.line.number-sign.python.legesher
    config
#   ^^^^^^ meta.function.parameters.python.legesher variable.parameter.function.python.legesher
# >> meta.function.python.legesher
):
# <- punctuation.definition.parameters.end.python.legesher
#^ punctuation.definition.function.begin.python.legesher
    testpasslegesher


# it "tokenizes a function definition with annotations"
testdeflegesher f(a: testNonelegesher, b: testintlegesher = 3) -> testintlegesher:
# <- meta.function.python.legesher storage.type.function.python.legesher
#               ^ entity.name.function.python.legesher
#                ^ punctuation.definition.parameters.begin.python.legesher
#                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.function.parameters.python.legesher
#                 ^ variable.parameter.function.python.legesher
#                  ^ punctuation.separator.python.legesher
#                    ^^^^^^^^^^^^^^^^ storage.type.python.legesher
#                                    ^ punctuation.separator.parameters.python.legesher
#                                      ^ variable.parameter.function.python.legesher
#                                       ^ punctuation.separator.python.legesher
#                                         ^^^^^^^^^^^^^^^ storage.type.python.legesher
#                                                         ^ keyword.operator.assignment.python.legesher
#                                                           ^ constant.numeric.integer.decimal.python.legesher
#                                                            ^ punctuation.definition.parameters.end.python.legesher
#                                                              ^^ keyword.operator.function-annotation.python.legesher
#                                                                 ^^^^^^^^^^^^^^^ storage.type.python.legesher
#                                                                                ^ punctuation.definition.function.begin.python.legesher
    testpasslegesher


# it "tokenizes complex function calls"
torch.nn.BCELoss()(Variable(bayes_optimal_prob, 1, requires_grad=testFalselegesher), Yvar).data[0]
#        ^^^^^^^^^ meta.method-call.python.legesher
#        ^^^^^^^ entity.name.function.python.legesher
#               ^ punctuation.definition.arguments.begin.bracket.round.python.legesher
#                ^ punctuation.definition.arguments.end.bracket.round.python.legesher
#                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.function-call.python.legesher
#                 ^ punctuation.definition.arguments.begin.bracket.round.python.legesher
#                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.function-call.arguments.python.legesher
#                  ^^^^^^^^ entity.name.function.python.legesher
#                          ^ punctuation.definition.arguments.begin.bracket.round.python.legesher
#                           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.function-call.arguments.python.legesher
#                                                  ^^^^^^^^^^^^^ variable.parameter.function.python.legesher
#                                                                ^^^^^^^^^^^^^^^^^ constant.language.python.legesher
#                                                                                 ^ punctuation.definition.arguments.end.bracket.round.python.legesher
#                                                                                  ^ punctuation.separator.arguments.python.legesher
#                                                                                        ^ punctuation.definition.arguments.end.bracket.round.python.legesher
#                                                                                         ^ punctuation.separator.property.period.python.legesher
