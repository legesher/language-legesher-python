describe 'Python settings', ->
  [editor, languageMode] = []

  afterEach ->
    editor.destroy()

  beforeEach ->
    atom.config.set('core.useTreeSitterParsers', false)

    waitsForPromise ->
      atom.workspace.open().then (o) ->
        editor = o
        languageMode = editor.languageMode

    waitsForPromise ->
      atom.packages.activatePackage('language-legesher-python')

#   it 'matches lines correctly using the increaseIndentPattern', ->
#     increaseIndentRegex = languageMode.increaseIndentRegexForScopeDescriptor(['source.python.legesher'])
#
#     expect(increaseIndentRegex.testSync('testforlegesher i testinlegesher range(n):')).toBeTruthy()
#     expect(increaseIndentRegex.testSync('  testforlegesher i testinlegesher range(n):')).toBeTruthy()
#     expect(increaseIndentRegex.testSync('testasynclegesher testforlegesher i testinlegesher range(n):')).toBeTruthy()
#     expect(increaseIndentRegex.testSync('  testasynclegesher testforlegesher i testinlegesher range(n):')).toBeTruthy()
#     expect(increaseIndentRegex.testSync('testclasslegesher TheClass(Object):')).toBeTruthy()
#     expect(increaseIndentRegex.testSync('  testclasslegesher TheClass(Object):')).toBeTruthy()
#     expect(increaseIndentRegex.testSync('testdeflegesher f(x):')).toBeTruthy()
#     expect(increaseIndentRegex.testSync('  testdeflegesher f(x):')).toBeTruthy()
#     expect(increaseIndentRegex.testSync('testasynclegesher testdeflegesher f(x):')).toBeTruthy()
#     expect(increaseIndentRegex.testSync('  testasynclegesher testdeflegesher f(x):')).toBeTruthy()
#     expect(increaseIndentRegex.testSync('testiflegesher this_var == that_var:')).toBeTruthy()
#     expect(increaseIndentRegex.testSync('  testiflegesher this_var == that_var:')).toBeTruthy()
#     expect(increaseIndentRegex.testSync('testeliflegesher this_var == that_var:')).toBeTruthy()
#     expect(increaseIndentRegex.testSync('  testeliflegesher this_var == that_var:')).toBeTruthy()
#     expect(increaseIndentRegex.testSync('testelselegesher:')).toBeTruthy()
#     expect(increaseIndentRegex.testSync('  testelselegesher:')).toBeTruthy()
#     expect(increaseIndentRegex.testSync('testexceptlegesher Exception:')).toBeTruthy()
#     expect(increaseIndentRegex.testSync('  testexceptlegesher Exception:')).toBeTruthy()
#     expect(increaseIndentRegex.testSync('testexceptlegesher Exception testaslegesher e:')).toBeTruthy()
#     expect(increaseIndentRegex.testSync('  testexceptlegesher Exception testaslegesher e:')).toBeTruthy()
#     expect(increaseIndentRegex.testSync('testfinallylegesher:')).toBeTruthy()
#     expect(increaseIndentRegex.testSync('  testfinallylegesher:')).toBeTruthy()
#     expect(increaseIndentRegex.testSync('testwithlegesher open("filename") testaslegesher f:')).toBeTruthy()
#     expect(increaseIndentRegex.testSync('  testwithlegesher open("filename") testaslegesher f:')).toBeTruthy()
#     expect(increaseIndentRegex.testSync('testasynclegesher testwithlegesher open("filename") testaslegesher f:')).toBeTruthy()
#     expect(increaseIndentRegex.testSync('  testasynclegesher testwithlegesher open("filename") testaslegesher f:')).toBeTruthy()
#     expect(increaseIndentRegex.testSync('testwhilelegesher testTruelegesher:')).toBeTruthy()
#     expect(increaseIndentRegex.testSync('  testwhilelegesher testTruelegesher:')).toBeTruthy()
#     expect(increaseIndentRegex.testSync('\t\t  testwhilelegesher testTruelegesher:')).toBeTruthy()
#
  it 'does not match lines incorrectly using the increaseIndentPattern', ->
    increaseIndentRegex = languageMode.increaseIndentRegexForScopeDescriptor(['source.python.legesher'])

    expect(increaseIndentRegex.testSync('testforlegesher i testinlegesher range(n)')).toBeFalsy()
    expect(increaseIndentRegex.testSync('testclasslegesher TheClass(Object)')).toBeFalsy()
    expect(increaseIndentRegex.testSync('testdeflegesher f(x)')).toBeFalsy()
    expect(increaseIndentRegex.testSync('testiflegesher this_var == that_var')).toBeFalsy()
    expect(increaseIndentRegex.testSync('"testforlegesher i testinlegesher range(n):"')).toBeFalsy()

  # it 'matches lines correctly using the decreaseIndentPattern', ->
  #   decreaseIndentRegex = languageMode.decreaseIndentRegexForScopeDescriptor(['source.python.legesher'])
  #
  #   expect(decreaseIndentRegex.testSync('testeliflegesher this_var == that_var:')).toBeTruthy()
  #   expect(decreaseIndentRegex.testSync('  testeliflegesher this_var == that_var:')).toBeTruthy()
  #   expect(decreaseIndentRegex.testSync('testelselegesher:')).toBeTruthy()
  #   expect(decreaseIndentRegex.testSync('  testelselegesher:')).toBeTruthy()
  #   expect(decreaseIndentRegex.testSync('testexceptlegesher Exception:')).toBeTruthy()
  #   expect(decreaseIndentRegex.testSync('  testexceptlegesher Exception:')).toBeTruthy()
  #   expect(decreaseIndentRegex.testSync('testexceptlegesher Exception testaslegesher e:')).toBeTruthy()
  #   expect(decreaseIndentRegex.testSync('  testexceptlegesher Exception testaslegesher e:')).toBeTruthy()
  #   expect(decreaseIndentRegex.testSync('testfinallylegesher:')).toBeTruthy()
  #   expect(decreaseIndentRegex.testSync('  testfinallylegesher:')).toBeTruthy()
  #   expect(decreaseIndentRegex.testSync('\t\t  testfinallylegesher:')).toBeTruthy()

  it 'does not match lines incorrectly using the decreaseIndentPattern', ->
    decreaseIndentRegex = languageMode.decreaseIndentRegexForScopeDescriptor(['source.python.legesher'])

    # NOTE! This first one is different from most other rote tests here.
    expect(decreaseIndentRegex.testSync('testelselegesher: expression()')).toBeFalsy()
    expect(decreaseIndentRegex.testSync('testeliflegesher this_var == that_var')).toBeFalsy()
    expect(decreaseIndentRegex.testSync('  testeliflegesher this_var == that_var')).toBeFalsy()
    expect(decreaseIndentRegex.testSync('testelselegesher')).toBeFalsy()
    expect(decreaseIndentRegex.testSync('  "testfinallylegesher:"')).toBeFalsy()
