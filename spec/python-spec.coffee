path = require 'path'
grammarTest = require 'atom-grammar-test'

describe "Python grammar", ->
  grammar = null

  beforeEach ->
    atom.config.set('core.useTreeSitterParsers', false)

    waitsForPromise ->
      atom.packages.activatePackage("language-legesher-python")

    runs ->
      grammar = atom.grammars.grammarForScopeName("source.python.legesher")

  it "recognises shebang on firstline", ->
    expect(grammar.firstLineRegex.scanner.findNextMatchSync("#!/usr/bin/env python")).not.toBeNull()
    expect(grammar.firstLineRegex.scanner.findNextMatchSync("#! /usr/bin/env python")).not.toBeNull()

  it "parses the grammar", ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe "source.python.legesher"

  # it "tokenizes `{yield}`", ->
  #   {tokens} = grammar.tokenizeLine '{{yield}} v'
  #
  #   expect(tokens[0]).toEqual value: '{yield}', scopes: ['source.python.legesher', 'keyword.control.statement.python.legesher']
  #
  # it "tokenizes `{yield} {from}`", ->
  #   {tokens} = grammar.tokenizeLine '{yield} {from} v'
  #
  #   expect(tokens[0]).toEqual value: '{yield} {from}', scopes: ['source.python.legesher', 'keyword.control.statement.python.legesher']
  #
  it "tokenizes multi-line strings", ->
    tokens = grammar.tokenizeLines('"1\\\n2"')

    # Line 0
    expect(tokens[0][0].value).toBe '"'
    expect(tokens[0][0].scopes).toEqual ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.begin.python.legesher']

    expect(tokens[0][1].value).toBe '1'
    expect(tokens[0][1].scopes).toEqual ['source.python.legesher', 'string.quoted.double.single-line.python.legesher']

    expect(tokens[0][2].value).toBe '\\'
    expect(tokens[0][2].scopes).toEqual ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.character.escape.newline.python.legesher']

    expect(tokens[0][3]).not.toBeDefined()

    # Line 1
    expect(tokens[1][0].value).toBe '2'
    expect(tokens[1][0].scopes).toEqual ['source.python.legesher', 'string.quoted.double.single-line.python.legesher']

    expect(tokens[1][1].value).toBe '"'
    expect(tokens[1][1].scopes).toEqual ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.end.python.legesher']

    expect(tokens[1][2]).not.toBeDefined()

  it "terminates a single-quoted raw string containing opening parenthesis at closing quote", ->
    tokens = grammar.tokenizeLines("r'%d(' #foo")

    expect(tokens[0][0].value).toBe 'r'
    expect(tokens[0][0].scopes).toEqual ['source.python.legesher', 'string.quoted.single.single-line.raw-regex.python.legesher', 'storage.type.string.python.legesher']
    expect(tokens[0][1].value).toBe "'"
    expect(tokens[0][1].scopes).toEqual ['source.python.legesher', 'string.quoted.single.single-line.raw-regex.python.legesher', 'punctuation.definition.string.begin.python.legesher']
    expect(tokens[0][2].value).toBe '%d'
    expect(tokens[0][2].scopes).toEqual ['source.python.legesher', 'string.quoted.single.single-line.raw-regex.python.legesher', 'constant.other.placeholder.python.legesher']
    expect(tokens[0][3].value).toBe '('
    expect(tokens[0][3].scopes).toEqual ['source.python.legesher', 'string.quoted.single.single-line.raw-regex.python.legesher', 'meta.group.regexp', 'punctuation.definition.group.regexp']
    expect(tokens[0][4].value).toBe "'"
    expect(tokens[0][4].scopes).toEqual ['source.python.legesher', 'string.quoted.single.single-line.raw-regex.python.legesher', 'punctuation.definition.string.end.python.legesher']
    expect(tokens[0][5].value).toBe ' '
    expect(tokens[0][5].scopes).toEqual ['source.python.legesher']
    expect(tokens[0][6].value).toBe '#'
    expect(tokens[0][6].scopes).toEqual ['source.python.legesher', 'comment.line.number-sign.python.legesher', 'punctuation.definition.comment.python.legesher']
    expect(tokens[0][7].value).toBe 'foo'
    expect(tokens[0][7].scopes).toEqual ['source.python.legesher', 'comment.line.number-sign.python.legesher']

  it "terminates a single-quoted raw string containing opening bracket at closing quote", ->
    tokens = grammar.tokenizeLines("r'%d[' #foo")

    expect(tokens[0][0].value).toBe 'r'
    expect(tokens[0][0].scopes).toEqual ['source.python.legesher', 'string.quoted.single.single-line.raw-regex.python.legesher', 'storage.type.string.python.legesher']
    expect(tokens[0][1].value).toBe "'"
    expect(tokens[0][1].scopes).toEqual ['source.python.legesher', 'string.quoted.single.single-line.raw-regex.python.legesher', 'punctuation.definition.string.begin.python.legesher']
    expect(tokens[0][2].value).toBe '%d'
    expect(tokens[0][2].scopes).toEqual ['source.python.legesher', 'string.quoted.single.single-line.raw-regex.python.legesher', 'constant.other.placeholder.python.legesher']
    expect(tokens[0][3].value).toBe '['
    expect(tokens[0][3].scopes).toEqual ['source.python.legesher', 'string.quoted.single.single-line.raw-regex.python.legesher', 'constant.other.character-class.set.regexp', 'punctuation.definition.character-class.begin.regexp']
    expect(tokens[0][4].value).toBe "'"
    expect(tokens[0][4].scopes).toEqual ['source.python.legesher', 'string.quoted.single.single-line.raw-regex.python.legesher', 'punctuation.definition.string.end.python.legesher']
    expect(tokens[0][5].value).toBe ' '
    expect(tokens[0][5].scopes).toEqual ['source.python.legesher']
    expect(tokens[0][6].value).toBe '#'
    expect(tokens[0][6].scopes).toEqual ['source.python.legesher', 'comment.line.number-sign.python.legesher', 'punctuation.definition.comment.python.legesher']
    expect(tokens[0][7].value).toBe 'foo'
    expect(tokens[0][7].scopes).toEqual ['source.python.legesher', 'comment.line.number-sign.python.legesher']

  it "terminates a double-quoted raw string containing opening parenthesis at closing quote", ->
    tokens = grammar.tokenizeLines('r"%d(" #foo')

    expect(tokens[0][0].value).toBe 'r'
    expect(tokens[0][0].scopes).toEqual ['source.python.legesher', 'string.quoted.double.single-line.raw-regex.python.legesher', 'storage.type.string.python.legesher']
    expect(tokens[0][1].value).toBe '"'
    expect(tokens[0][1].scopes).toEqual ['source.python.legesher', 'string.quoted.double.single-line.raw-regex.python.legesher', 'punctuation.definition.string.begin.python.legesher']
    expect(tokens[0][2].value).toBe '%d'
    expect(tokens[0][2].scopes).toEqual ['source.python.legesher', 'string.quoted.double.single-line.raw-regex.python.legesher', 'constant.other.placeholder.python.legesher']
    expect(tokens[0][3].value).toBe '('
    expect(tokens[0][3].scopes).toEqual ['source.python.legesher', 'string.quoted.double.single-line.raw-regex.python.legesher', 'meta.group.regexp', 'punctuation.definition.group.regexp']
    expect(tokens[0][4].value).toBe '"'
    expect(tokens[0][4].scopes).toEqual ['source.python.legesher', 'string.quoted.double.single-line.raw-regex.python.legesher', 'punctuation.definition.string.end.python.legesher']
    expect(tokens[0][5].value).toBe ' '
    expect(tokens[0][5].scopes).toEqual ['source.python.legesher']
    expect(tokens[0][6].value).toBe '#'
    expect(tokens[0][6].scopes).toEqual ['source.python.legesher', 'comment.line.number-sign.python.legesher', 'punctuation.definition.comment.python.legesher']
    expect(tokens[0][7].value).toBe 'foo'
    expect(tokens[0][7].scopes).toEqual ['source.python.legesher', 'comment.line.number-sign.python.legesher']

  it "terminates a double-quoted raw string containing opening bracket at closing quote", ->
    tokens = grammar.tokenizeLines('r"%d[" #foo')

    expect(tokens[0][0].value).toBe 'r'
    expect(tokens[0][0].scopes).toEqual ['source.python.legesher', 'string.quoted.double.single-line.raw-regex.python.legesher', 'storage.type.string.python.legesher']
    expect(tokens[0][1].value).toBe '"'
    expect(tokens[0][1].scopes).toEqual ['source.python.legesher', 'string.quoted.double.single-line.raw-regex.python.legesher', 'punctuation.definition.string.begin.python.legesher']
    expect(tokens[0][2].value).toBe '%d'
    expect(tokens[0][2].scopes).toEqual ['source.python.legesher', 'string.quoted.double.single-line.raw-regex.python.legesher', 'constant.other.placeholder.python.legesher']
    expect(tokens[0][3].value).toBe '['
    expect(tokens[0][3].scopes).toEqual ['source.python.legesher', 'string.quoted.double.single-line.raw-regex.python.legesher', 'constant.other.character-class.set.regexp', 'punctuation.definition.character-class.begin.regexp']
    expect(tokens[0][4].value).toBe '"'
    expect(tokens[0][4].scopes).toEqual ['source.python.legesher', 'string.quoted.double.single-line.raw-regex.python.legesher', 'punctuation.definition.string.end.python.legesher']
    expect(tokens[0][5].value).toBe ' '
    expect(tokens[0][5].scopes).toEqual ['source.python.legesher']
    expect(tokens[0][6].value).toBe '#'
    expect(tokens[0][6].scopes).toEqual ['source.python.legesher', 'comment.line.number-sign.python.legesher', 'punctuation.definition.comment.python.legesher']
    expect(tokens[0][7].value).toBe 'foo'
    expect(tokens[0][7].scopes).toEqual ['source.python.legesher', 'comment.line.number-sign.python.legesher']

  it "terminates a unicode single-quoted raw string containing opening parenthesis at closing quote", ->
    tokens = grammar.tokenizeLines("ur'%d(' #foo")

    expect(tokens[0][0].value).toBe 'ur'
    expect(tokens[0][0].scopes).toEqual ['source.python.legesher', 'string.quoted.single.single-line.unicode-raw-regex.python.legesher', 'storage.type.string.python.legesher']
    expect(tokens[0][1].value).toBe "'"
    expect(tokens[0][1].scopes).toEqual ['source.python.legesher', 'string.quoted.single.single-line.unicode-raw-regex.python.legesher', 'punctuation.definition.string.begin.python.legesher']
    expect(tokens[0][2].value).toBe '%d'
    expect(tokens[0][2].scopes).toEqual ['source.python.legesher', 'string.quoted.single.single-line.unicode-raw-regex.python.legesher', 'constant.other.placeholder.python.legesher']
    expect(tokens[0][3].value).toBe '('
    expect(tokens[0][3].scopes).toEqual ['source.python.legesher', 'string.quoted.single.single-line.unicode-raw-regex.python.legesher', 'meta.group.regexp', 'punctuation.definition.group.regexp']
    expect(tokens[0][4].value).toBe "'"
    expect(tokens[0][4].scopes).toEqual ['source.python.legesher', 'string.quoted.single.single-line.unicode-raw-regex.python.legesher', 'punctuation.definition.string.end.python.legesher']
    expect(tokens[0][5].value).toBe ' '
    expect(tokens[0][5].scopes).toEqual ['source.python.legesher']
    expect(tokens[0][6].value).toBe '#'
    expect(tokens[0][6].scopes).toEqual ['source.python.legesher', 'comment.line.number-sign.python.legesher', 'punctuation.definition.comment.python.legesher']
    expect(tokens[0][7].value).toBe 'foo'
    expect(tokens[0][7].scopes).toEqual ['source.python.legesher', 'comment.line.number-sign.python.legesher']

  it "terminates a unicode single-quoted raw string containing opening bracket at closing quote", ->
    tokens = grammar.tokenizeLines("ur'%d[' #foo")

    expect(tokens[0][0].value).toBe 'ur'
    expect(tokens[0][0].scopes).toEqual ['source.python.legesher', 'string.quoted.single.single-line.unicode-raw-regex.python.legesher', 'storage.type.string.python.legesher']
    expect(tokens[0][1].value).toBe "'"
    expect(tokens[0][1].scopes).toEqual ['source.python.legesher', 'string.quoted.single.single-line.unicode-raw-regex.python.legesher', 'punctuation.definition.string.begin.python.legesher']
    expect(tokens[0][2].value).toBe '%d'
    expect(tokens[0][2].scopes).toEqual ['source.python.legesher', 'string.quoted.single.single-line.unicode-raw-regex.python.legesher', 'constant.other.placeholder.python.legesher']
    expect(tokens[0][3].value).toBe '['
    expect(tokens[0][3].scopes).toEqual ['source.python.legesher', 'string.quoted.single.single-line.unicode-raw-regex.python.legesher', 'constant.other.character-class.set.regexp', 'punctuation.definition.character-class.begin.regexp']
    expect(tokens[0][4].value).toBe "'"
    expect(tokens[0][4].scopes).toEqual ['source.python.legesher', 'string.quoted.single.single-line.unicode-raw-regex.python.legesher', 'punctuation.definition.string.end.python.legesher']
    expect(tokens[0][5].value).toBe ' '
    expect(tokens[0][5].scopes).toEqual ['source.python.legesher']
    expect(tokens[0][6].value).toBe '#'
    expect(tokens[0][6].scopes).toEqual ['source.python.legesher', 'comment.line.number-sign.python.legesher', 'punctuation.definition.comment.python.legesher']
    expect(tokens[0][7].value).toBe 'foo'
    expect(tokens[0][7].scopes).toEqual ['source.python.legesher', 'comment.line.number-sign.python.legesher']

  it "terminates a unicode double-quoted raw string containing opening parenthesis at closing quote", ->
    tokens = grammar.tokenizeLines('ur"%d(" #foo')

    expect(tokens[0][0].value).toBe 'ur'
    expect(tokens[0][0].scopes).toEqual ['source.python.legesher', 'string.quoted.double.single-line.unicode-raw-regex.python.legesher', 'storage.type.string.python.legesher']
    expect(tokens[0][1].value).toBe '"'
    expect(tokens[0][1].scopes).toEqual ['source.python.legesher', 'string.quoted.double.single-line.unicode-raw-regex.python.legesher', 'punctuation.definition.string.begin.python.legesher']
    expect(tokens[0][2].value).toBe '%d'
    expect(tokens[0][2].scopes).toEqual ['source.python.legesher', 'string.quoted.double.single-line.unicode-raw-regex.python.legesher', 'constant.other.placeholder.python.legesher']
    expect(tokens[0][3].value).toBe '('
    expect(tokens[0][3].scopes).toEqual ['source.python.legesher', 'string.quoted.double.single-line.unicode-raw-regex.python.legesher', 'meta.group.regexp', 'punctuation.definition.group.regexp']
    expect(tokens[0][4].value).toBe '"'
    expect(tokens[0][4].scopes).toEqual ['source.python.legesher', 'string.quoted.double.single-line.unicode-raw-regex.python.legesher', 'punctuation.definition.string.end.python.legesher']
    expect(tokens[0][5].value).toBe ' '
    expect(tokens[0][5].scopes).toEqual ['source.python.legesher']
    expect(tokens[0][6].value).toBe '#'
    expect(tokens[0][6].scopes).toEqual ['source.python.legesher', 'comment.line.number-sign.python.legesher', 'punctuation.definition.comment.python.legesher']
    expect(tokens[0][7].value).toBe 'foo'
    expect(tokens[0][7].scopes).toEqual ['source.python.legesher', 'comment.line.number-sign.python.legesher']

  it "terminates a unicode double-quoted raw string containing opening bracket at closing quote", ->
    tokens = grammar.tokenizeLines('ur"%d[" #foo')

    expect(tokens[0][0].value).toBe 'ur'
    expect(tokens[0][0].scopes).toEqual ['source.python.legesher', 'string.quoted.double.single-line.unicode-raw-regex.python.legesher', 'storage.type.string.python.legesher']
    expect(tokens[0][1].value).toBe '"'
    expect(tokens[0][1].scopes).toEqual ['source.python.legesher', 'string.quoted.double.single-line.unicode-raw-regex.python.legesher', 'punctuation.definition.string.begin.python.legesher']
    expect(tokens[0][2].value).toBe '%d'
    expect(tokens[0][2].scopes).toEqual ['source.python.legesher', 'string.quoted.double.single-line.unicode-raw-regex.python.legesher', 'constant.other.placeholder.python.legesher']
    expect(tokens[0][3].value).toBe '['
    expect(tokens[0][3].scopes).toEqual ['source.python.legesher', 'string.quoted.double.single-line.unicode-raw-regex.python.legesher', 'constant.other.character-class.set.regexp', 'punctuation.definition.character-class.begin.regexp']
    expect(tokens[0][4].value).toBe '"'
    expect(tokens[0][4].scopes).toEqual ['source.python.legesher', 'string.quoted.double.single-line.unicode-raw-regex.python.legesher', 'punctuation.definition.string.end.python.legesher']
    expect(tokens[0][5].value).toBe ' '
    expect(tokens[0][5].scopes).toEqual ['source.python.legesher']
    expect(tokens[0][6].value).toBe '#'
    expect(tokens[0][6].scopes).toEqual ['source.python.legesher', 'comment.line.number-sign.python.legesher', 'punctuation.definition.comment.python.legesher']
    expect(tokens[0][7].value).toBe 'foo'
    expect(tokens[0][7].scopes).toEqual ['source.python.legesher', 'comment.line.number-sign.python.legesher']

  it "terminates referencing an item in a list variable after a sequence of a closing and opening bracket", ->
    tokens = grammar.tokenizeLines('foo[i[0]][j[0]]')

    expect(tokens[0][0].value).toBe 'foo'
    expect(tokens[0][0].scopes).toEqual ['source.python.legesher', 'meta.item-access.python.legesher']
    expect(tokens[0][1].value).toBe '['
    expect(tokens[0][1].scopes).toEqual ['source.python.legesher', 'meta.item-access.python.legesher', 'punctuation.definition.arguments.begin.python.legesher']
    expect(tokens[0][2].value).toBe 'i'
    expect(tokens[0][2].scopes).toEqual ['source.python.legesher', 'meta.item-access.python.legesher', 'meta.item-access.arguments.python.legesher', 'meta.item-access.python.legesher']
    expect(tokens[0][3].value).toBe '['
    expect(tokens[0][3].scopes).toEqual ['source.python.legesher', 'meta.item-access.python.legesher', 'meta.item-access.arguments.python.legesher', 'meta.item-access.python.legesher', 'punctuation.definition.arguments.begin.python.legesher']
    expect(tokens[0][4].value).toBe '0'
    expect(tokens[0][4].scopes).toEqual ['source.python.legesher', 'meta.item-access.python.legesher', 'meta.item-access.arguments.python.legesher', 'meta.item-access.python.legesher', 'meta.item-access.arguments.python.legesher', 'constant.numeric.integer.decimal.python.legesher']
    expect(tokens[0][5].value).toBe ']'
    expect(tokens[0][5].scopes).toEqual ['source.python.legesher', 'meta.item-access.python.legesher', 'meta.item-access.arguments.python.legesher', 'meta.item-access.python.legesher', 'punctuation.definition.arguments.end.python.legesher']
    expect(tokens[0][6].value).toBe ']'
    expect(tokens[0][6].scopes).toEqual ['source.python.legesher', 'meta.item-access.python.legesher', 'punctuation.definition.arguments.end.python.legesher']
    expect(tokens[0][7].value).toBe '['
    expect(tokens[0][7].scopes).toEqual ['source.python.legesher', 'meta.structure.list.python.legesher', 'punctuation.definition.list.begin.python.legesher']
    expect(tokens[0][8].value).toBe 'j'
    expect(tokens[0][8].scopes).toEqual ['source.python.legesher', 'meta.structure.list.python.legesher', 'meta.structure.list.item.python.legesher', 'meta.item-access.python.legesher']
    expect(tokens[0][9].value).toBe '['
    expect(tokens[0][9].scopes).toEqual ['source.python.legesher', 'meta.structure.list.python.legesher', 'meta.structure.list.item.python.legesher', 'meta.item-access.python.legesher', 'punctuation.definition.arguments.begin.python.legesher']
    expect(tokens[0][10].value).toBe '0'
    expect(tokens[0][10].scopes).toEqual ['source.python.legesher', 'meta.structure.list.python.legesher', 'meta.structure.list.item.python.legesher', 'meta.item-access.python.legesher', 'meta.item-access.arguments.python.legesher', 'constant.numeric.integer.decimal.python.legesher']
    expect(tokens[0][11].value).toBe ']'
    expect(tokens[0][11].scopes).toEqual ['source.python.legesher', 'meta.structure.list.python.legesher', 'meta.structure.list.item.python.legesher', 'meta.item-access.python.legesher', 'punctuation.definition.arguments.end.python.legesher']
    expect(tokens[0][12].value).toBe ']'
    expect(tokens[0][12].scopes).toEqual ['source.python.legesher', 'meta.structure.list.python.legesher', 'punctuation.definition.list.end.python.legesher']

  it "tokenizes a hex escape inside a string", ->
    tokens = grammar.tokenizeLines('"\\x5A"')

    expect(tokens[0][0].value).toBe '"'
    expect(tokens[0][0].scopes).toEqual ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.begin.python.legesher']
    expect(tokens[0][1].value).toBe '\\x5A'
    expect(tokens[0][1].scopes).toEqual ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.character.escape.hex.python.legesher']

    tokens = grammar.tokenizeLines('"\\x9f"')

    expect(tokens[0][0].value).toBe '"'
    expect(tokens[0][0].scopes).toEqual ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.begin.python.legesher']
    expect(tokens[0][1].value).toBe '\\x9f'
    expect(tokens[0][1].scopes).toEqual ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.character.escape.hex.python.legesher']

  describe "f-strings", ->
    it "tokenizes them", ->
      {tokens} = grammar.tokenizeLine "f'hello'"

      expect(tokens[0]).toEqual value: 'f', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'storage.type.string.python.legesher']
      expect(tokens[1]).toEqual value: "'", scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'punctuation.definition.string.begin.python.legesher']
      expect(tokens[2]).toEqual value: 'hello', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher"]
      expect(tokens[3]).toEqual value: "'", scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'punctuation.definition.string.end.python.legesher']

    it "tokenizes {{ and }} as escape characters", ->
      {tokens} = grammar.tokenizeLine "f'he}}l{{lo'"

      expect(tokens[0]).toEqual value: 'f', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'storage.type.string.python.legesher']
      expect(tokens[1]).toEqual value: "'", scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'punctuation.definition.string.begin.python.legesher']
      expect(tokens[2]).toEqual value: 'he', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher"]
      expect(tokens[3]).toEqual value: '}}', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'constant.character.escape.curly-bracket.python.legesher']
      expect(tokens[4]).toEqual value: 'l', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher"]
      expect(tokens[5]).toEqual value: '{{', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'constant.character.escape.curly-bracket.python.legesher']
      expect(tokens[6]).toEqual value: 'lo', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher"]
      expect(tokens[7]).toEqual value: "'", scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'punctuation.definition.string.end.python.legesher']

    it "tokenizes unmatched closing curly brackets as invalid", ->
      {tokens} = grammar.tokenizeLine "f'he}llo'"

      expect(tokens[0]).toEqual value: 'f', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'storage.type.string.python.legesher']
      expect(tokens[1]).toEqual value: "'", scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'punctuation.definition.string.begin.python.legesher']
      expect(tokens[2]).toEqual value: 'he', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher"]
      expect(tokens[3]).toEqual value: '}', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'invalid.illegal.closing-curly-bracket.python.legesher']
      expect(tokens[4]).toEqual value: 'llo', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher"]
      expect(tokens[5]).toEqual value: "'", scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'punctuation.definition.string.end.python.legesher']

    describe "in expressions", ->
      it "tokenizes variables", ->
        {tokens} = grammar.tokenizeLine "f'{abc}'"

        expect(tokens[2]).toEqual value: '{', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'punctuation.definition.interpolation.begin.bracket.curly.python.legesher']
        expect(tokens[3]).toEqual value: 'abc', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'meta.embedded.python.legesher']
        expect(tokens[4]).toEqual value: '}', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'punctuation.definition.interpolation.end.bracket.curly.python.legesher']

      it "tokenizes arithmetic", ->
        {tokens} = grammar.tokenizeLine "f'{5 - 3}'"

        expect(tokens[2]).toEqual value: '{', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'punctuation.definition.interpolation.begin.bracket.curly.python.legesher']
        expect(tokens[3]).toEqual value: '5', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'meta.embedded.python.legesher', 'constant.numeric.integer.decimal.python.legesher']
        expect(tokens[5]).toEqual value: '-', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'meta.embedded.python.legesher', 'keyword.operator.arithmetic.python.legesher']
        expect(tokens[7]).toEqual value: '3', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'meta.embedded.python.legesher', 'constant.numeric.integer.decimal.python.legesher']
        expect(tokens[8]).toEqual value: '}', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'punctuation.definition.interpolation.end.bracket.curly.python.legesher']

      it "tokenizes function and method calls", ->
        {tokens} = grammar.tokenizeLine "f'{name.decode(\"utf-8\").lower()}'"

        expect(tokens[2]).toEqual value: '{', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'punctuation.definition.interpolation.begin.bracket.curly.python.legesher']
        expect(tokens[3]).toEqual value: 'name', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'meta.embedded.python.legesher', 'variable.other.object.python.legesher']
        expect(tokens[4]).toEqual value: '.', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'meta.embedded.python.legesher', 'meta.method-call.python.legesher', 'punctuation.separator.method.period.python.legesher']
        expect(tokens[5]).toEqual value: 'decode', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'meta.embedded.python.legesher', 'meta.method-call.python.legesher', 'entity.name.function.python.legesher']
        expect(tokens[6]).toEqual value: '(', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'meta.embedded.python.legesher', 'meta.method-call.python.legesher', 'punctuation.definition.arguments.begin.bracket.round.python.legesher']
        expect(tokens[7]).toEqual value: '"', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'meta.embedded.python.legesher', 'meta.method-call.python.legesher', 'meta.method-call.arguments.python.legesher', "string.quoted.double.single-line.python.legesher", 'punctuation.definition.string.begin.python.legesher']
        expect(tokens[8]).toEqual value: 'utf-8', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'meta.embedded.python.legesher', 'meta.method-call.python.legesher', 'meta.method-call.arguments.python.legesher', "string.quoted.double.single-line.python.legesher"]
        expect(tokens[9]).toEqual value: '"', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'meta.embedded.python.legesher', 'meta.method-call.python.legesher', 'meta.method-call.arguments.python.legesher', "string.quoted.double.single-line.python.legesher", 'punctuation.definition.string.end.python.legesher']
        expect(tokens[10]).toEqual value: ')', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'meta.embedded.python.legesher', 'meta.method-call.python.legesher', 'punctuation.definition.arguments.end.bracket.round.python.legesher']
        expect(tokens[11]).toEqual value: '.', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'meta.embedded.python.legesher', 'meta.method-call.python.legesher', 'punctuation.separator.method.period.python.legesher']
        expect(tokens[12]).toEqual value: 'lower', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'meta.embedded.python.legesher', 'meta.method-call.python.legesher', 'entity.name.function.python.legesher']
        expect(tokens[13]).toEqual value: '(', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'meta.embedded.python.legesher', 'meta.method-call.python.legesher', 'punctuation.definition.arguments.begin.bracket.round.python.legesher']
        expect(tokens[14]).toEqual value: ')', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'meta.embedded.python.legesher', 'meta.method-call.python.legesher', 'punctuation.definition.arguments.end.bracket.round.python.legesher']
        expect(tokens[15]).toEqual value: '}', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'punctuation.definition.interpolation.end.bracket.curly.python.legesher']

      it "tokenizes conversion flags", ->
        {tokens} = grammar.tokenizeLine "f'{abc!r}'"

        expect(tokens[2]).toEqual value: '{', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'punctuation.definition.interpolation.begin.bracket.curly.python.legesher']
        expect(tokens[3]).toEqual value: 'abc', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'meta.embedded.python.legesher']
        expect(tokens[4]).toEqual value: '!r', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'constant.other.placeholder.python.legesher']
        expect(tokens[5]).toEqual value: '}', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'punctuation.definition.interpolation.end.bracket.curly.python.legesher']

      it "tokenizes format specifiers", ->
        {tokens} = grammar.tokenizeLine "f'{abc:^d}'"

        expect(tokens[2]).toEqual value: '{', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'punctuation.definition.interpolation.begin.bracket.curly.python.legesher']
        expect(tokens[3]).toEqual value: 'abc', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'meta.embedded.python.legesher']
        expect(tokens[4]).toEqual value: ':^d', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'constant.other.placeholder.python.legesher']
        expect(tokens[5]).toEqual value: '}', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'punctuation.definition.interpolation.end.bracket.curly.python.legesher']

      it "tokenizes nested replacement fields in top-level format specifiers", ->
        {tokens} = grammar.tokenizeLine "f'{abc:{align}d}'"

        expect(tokens[2]).toEqual value: '{', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'punctuation.definition.interpolation.begin.bracket.curly.python.legesher']
        expect(tokens[3]).toEqual value: 'abc', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'meta.embedded.python.legesher']
        expect(tokens[4]).toEqual value: ':', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'constant.other.placeholder.python.legesher']
        expect(tokens[5]).toEqual value: '{align}', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'constant.other.placeholder.python.legesher', 'constant.other.placeholder.python.legesher']
        expect(tokens[6]).toEqual value: 'd', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'constant.other.placeholder.python.legesher']
        expect(tokens[7]).toEqual value: '}', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'punctuation.definition.interpolation.end.bracket.curly.python.legesher']

      it "tokenizes backslashes as invalid", ->
        {tokens} = grammar.tokenizeLine "f'{ab\\n}'"

        expect(tokens[2]).toEqual value: '{', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'punctuation.definition.interpolation.begin.bracket.curly.python.legesher']
        expect(tokens[3]).toEqual value: 'ab', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'meta.embedded.python.legesher']
        expect(tokens[4]).toEqual value: '\\', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'meta.embedded.python.legesher', 'invalid.illegal.backslash.python.legesher']
        expect(tokens[6]).toEqual value: '}', scopes: ['source.python.legesher', "string.quoted.single.single-line.format.python.legesher", 'meta.interpolation.python.legesher', 'punctuation.definition.interpolation.end.bracket.curly.python.legesher']

  describe "binary strings", ->
    it "tokenizes them", ->
      {tokens} = grammar.tokenizeLine "b'test'"

      expect(tokens[0]).toEqual value: 'b', scopes: ['source.python.legesher', "string.quoted.single.single-line.binary.python.legesher", 'storage.type.string.python.legesher']
      expect(tokens[1]).toEqual value: "'", scopes: ['source.python.legesher', "string.quoted.single.single-line.binary.python.legesher", 'punctuation.definition.string.begin.python.legesher']
      expect(tokens[2]).toEqual value: 'test', scopes: ['source.python.legesher', "string.quoted.single.single-line.binary.python.legesher"]
      expect(tokens[3]).toEqual value: "'", scopes: ['source.python.legesher', "string.quoted.single.single-line.binary.python.legesher", 'punctuation.definition.string.end.python.legesher']

    it "tokenizes invalid characters", ->
      {tokens} = grammar.tokenizeLine "b'tést'"

      expect(tokens[0]).toEqual value: 'b', scopes: ['source.python.legesher', "string.quoted.single.single-line.binary.python.legesher", 'storage.type.string.python.legesher']
      expect(tokens[1]).toEqual value: "'", scopes: ['source.python.legesher', "string.quoted.single.single-line.binary.python.legesher", 'punctuation.definition.string.begin.python.legesher']
      expect(tokens[2]).toEqual value: 't', scopes: ['source.python.legesher', "string.quoted.single.single-line.binary.python.legesher"]
      expect(tokens[3]).toEqual value: 'é', scopes: ['source.python.legesher', "string.quoted.single.single-line.binary.python.legesher", 'invalid.illegal.character-out-of-range.python.legesher']
      expect(tokens[4]).toEqual value: 'st', scopes: ['source.python.legesher', "string.quoted.single.single-line.binary.python.legesher"]
      expect(tokens[5]).toEqual value: "'", scopes: ['source.python.legesher', "string.quoted.single.single-line.binary.python.legesher", 'punctuation.definition.string.end.python.legesher']

  describe "docstrings", ->
    it "tokenizes them", ->
      lines = grammar.tokenizeLines '''
        """
          Bla bla bla "wow" what's this?
        """
      '''

      expect(lines[0][0]).toEqual value: '"""', scopes: ['source.python.legesher', 'string.quoted.double.block.python.legesher', 'punctuation.definition.string.begin.python.legesher']
      expect(lines[1][0]).toEqual value: '  Bla bla bla "wow" what\'s this?', scopes: ['source.python.legesher', 'string.quoted.double.block.python.legesher']
      expect(lines[2][0]).toEqual value: '"""', scopes: ['source.python.legesher', 'string.quoted.double.block.python.legesher', 'punctuation.definition.string.end.python.legesher']

      lines = grammar.tokenizeLines """
        '''
          Bla bla bla "wow" what's this?
        '''
      """

      expect(lines[0][0]).toEqual value: "'''", scopes: ['source.python.legesher', 'string.quoted.single.block.python.legesher', 'punctuation.definition.string.begin.python.legesher']
      expect(lines[1][0]).toEqual value: '  Bla bla bla "wow" what\'s this?', scopes: ['source.python.legesher', 'string.quoted.single.block.python.legesher']
      expect(lines[2][0]).toEqual value: "'''", scopes: ['source.python.legesher', 'string.quoted.single.block.python.legesher', 'punctuation.definition.string.end.python.legesher']


  describe "string formatting", ->
    describe "%-style formatting", ->
      it "tokenizes the conversion type", ->
        {tokens} = grammar.tokenizeLine '"%d"'

        expect(tokens[0]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.begin.python.legesher']
        expect(tokens[1]).toEqual value: '%d', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.other.placeholder.python.legesher']
        expect(tokens[2]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.end.python.legesher']

      it "tokenizes an optional mapping key", ->
        {tokens} = grammar.tokenizeLine '"%(key)x"'

        expect(tokens[0]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.begin.python.legesher']
        expect(tokens[1]).toEqual value: '%(key)x', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.other.placeholder.python.legesher']
        expect(tokens[2]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.end.python.legesher']

      it "tokenizes an optional conversion flag", ->
        {tokens} = grammar.tokenizeLine '"% F"'

        expect(tokens[0]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.begin.python.legesher']
        expect(tokens[1]).toEqual value: '% F', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.other.placeholder.python.legesher']
        expect(tokens[2]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.end.python.legesher']

      it "tokenizes an optional field width", ->
        {tokens} = grammar.tokenizeLine '"%11s"'

        expect(tokens[0]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.begin.python.legesher']
        expect(tokens[1]).toEqual value: '%11s', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.other.placeholder.python.legesher']
        expect(tokens[2]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.end.python.legesher']

      it "tokenizes * as the optional field width", ->
        {tokens} = grammar.tokenizeLine '"%*g"'

        expect(tokens[0]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.begin.python.legesher']
        expect(tokens[1]).toEqual value: '%*g', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.other.placeholder.python.legesher']
        expect(tokens[2]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.end.python.legesher']

      it "tokenizes an optional precision", ->
        {tokens} = grammar.tokenizeLine '"%.4r"'

        expect(tokens[0]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.begin.python.legesher']
        expect(tokens[1]).toEqual value: '%.4r', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.other.placeholder.python.legesher']
        expect(tokens[2]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.end.python.legesher']

      it "tokenizes * as the optional precision", ->
        {tokens} = grammar.tokenizeLine '"%.*%"'

        expect(tokens[0]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.begin.python.legesher']
        expect(tokens[1]).toEqual value: '%.*%', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.other.placeholder.python.legesher']
        expect(tokens[2]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.end.python.legesher']

      it "tokenizes an optional length modifier", ->
        {tokens} = grammar.tokenizeLine '"%Lo"'

        expect(tokens[0]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.begin.python.legesher']
        expect(tokens[1]).toEqual value: '%Lo', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.other.placeholder.python.legesher']
        expect(tokens[2]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.end.python.legesher']

      it "tokenizes complex formats", ->
        {tokens} = grammar.tokenizeLine '"%(key)#5.*hc"'

        expect(tokens[0]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.begin.python.legesher']
        expect(tokens[1]).toEqual value: '%(key)#5.*hc', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.other.placeholder.python.legesher']
        expect(tokens[2]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.end.python.legesher']

    describe "{}-style formatting", ->
      it "tokenizes the empty replacement field", ->
        {tokens} = grammar.tokenizeLine '"{}"'

        expect(tokens[0]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.begin.python.legesher']
        expect(tokens[1]).toEqual value: '{}', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.other.placeholder.python.legesher']
        expect(tokens[2]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.end.python.legesher']

      it "tokenizes a number as the field name", ->
        {tokens} = grammar.tokenizeLine '"{1}"'

        expect(tokens[0]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.begin.python.legesher']
        expect(tokens[1]).toEqual value: '{1}', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.other.placeholder.python.legesher']
        expect(tokens[2]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.end.python.legesher']

      it "tokenizes a variable name as the field name", ->
        {tokens} = grammar.tokenizeLine '"{key}"'

        expect(tokens[0]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.begin.python.legesher']
        expect(tokens[1]).toEqual value: '{key}', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.other.placeholder.python.legesher']
        expect(tokens[2]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.end.python.legesher']

      it "tokenizes field name attributes", ->
        {tokens} = grammar.tokenizeLine '"{key.length}"'

        expect(tokens[0]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.begin.python.legesher']
        expect(tokens[1]).toEqual value: '{key.length}', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.other.placeholder.python.legesher']
        expect(tokens[2]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.end.python.legesher']

        {tokens} = grammar.tokenizeLine '"{4.width}"'

        expect(tokens[0]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.begin.python.legesher']
        expect(tokens[1]).toEqual value: '{4.width}', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.other.placeholder.python.legesher']
        expect(tokens[2]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.end.python.legesher']

        {tokens} = grammar.tokenizeLine '"{python2[\'3\']}"'

        expect(tokens[0]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.begin.python.legesher']
        expect(tokens[1]).toEqual value: '{python2[\'3\']}', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.other.placeholder.python.legesher']
        expect(tokens[2]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.end.python.legesher']

        {tokens} = grammar.tokenizeLine '"{2[4]}"'

        expect(tokens[0]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.begin.python.legesher']
        expect(tokens[1]).toEqual value: '{2[4]}', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.other.placeholder.python.legesher']
        expect(tokens[2]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.end.python.legesher']

      it "tokenizes multiple field name attributes", ->
        {tokens} = grammar.tokenizeLine '"{nested.a[2][\'val\'].value}"'

        expect(tokens[0]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.begin.python.legesher']
        expect(tokens[1]).toEqual value: '{nested.a[2][\'val\'].value}', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.other.placeholder.python.legesher']
        expect(tokens[2]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.end.python.legesher']

      it "tokenizes conversions", ->
        {tokens} = grammar.tokenizeLine '"{!r}"'

        expect(tokens[0]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.begin.python.legesher']
        expect(tokens[1]).toEqual value: '{!r}', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.other.placeholder.python.legesher']
        expect(tokens[2]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.end.python.legesher']

      describe "format specifiers", ->
        it "tokenizes alignment", ->
          {tokens} = grammar.tokenizeLine '"{:<}"'

          expect(tokens[0]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.begin.python.legesher']
          expect(tokens[1]).toEqual value: '{:<}', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.other.placeholder.python.legesher']
          expect(tokens[2]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.end.python.legesher']

          {tokens} = grammar.tokenizeLine '"{:a^}"'

          expect(tokens[0]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.begin.python.legesher']
          expect(tokens[1]).toEqual value: '{:a^}', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.other.placeholder.python.legesher']
          expect(tokens[2]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.end.python.legesher']

        it "tokenizes signs", ->
          {tokens} = grammar.tokenizeLine '"{:+}"'

          expect(tokens[0]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.begin.python.legesher']
          expect(tokens[1]).toEqual value: '{:+}', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.other.placeholder.python.legesher']
          expect(tokens[2]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.end.python.legesher']

          {tokens} = grammar.tokenizeLine '"{: }"'

          expect(tokens[0]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.begin.python.legesher']
          expect(tokens[1]).toEqual value: '{: }', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.other.placeholder.python.legesher']
          expect(tokens[2]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.end.python.legesher']

        it "tokenizes the alternate form indicator", ->
          {tokens} = grammar.tokenizeLine '"{:#}"'

          expect(tokens[0]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.begin.python.legesher']
          expect(tokens[1]).toEqual value: '{:#}', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.other.placeholder.python.legesher']
          expect(tokens[2]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.end.python.legesher']

        it "tokenizes 0", ->
          {tokens} = grammar.tokenizeLine '"{:0}"'

          expect(tokens[0]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.begin.python.legesher']
          expect(tokens[1]).toEqual value: '{:0}', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.other.placeholder.python.legesher']
          expect(tokens[2]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.end.python.legesher']

        it "tokenizes the width", ->
          {tokens} = grammar.tokenizeLine '"{:34}"'

          expect(tokens[0]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.begin.python.legesher']
          expect(tokens[1]).toEqual value: '{:34}', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.other.placeholder.python.legesher']
          expect(tokens[2]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.end.python.legesher']

        it "tokenizes the grouping option", ->
          {tokens} = grammar.tokenizeLine '"{:,}"'

          expect(tokens[0]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.begin.python.legesher']
          expect(tokens[1]).toEqual value: '{:,}', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.other.placeholder.python.legesher']
          expect(tokens[2]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.end.python.legesher']

        it "tokenizes the precision", ->
          {tokens} = grammar.tokenizeLine '"{:.5}"'

          expect(tokens[0]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.begin.python.legesher']
          expect(tokens[1]).toEqual value: '{:.5}', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.other.placeholder.python.legesher']
          expect(tokens[2]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.end.python.legesher']

        it "tokenizes the type", ->
          {tokens} = grammar.tokenizeLine '"{:b}"'

          expect(tokens[0]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.begin.python.legesher']
          expect(tokens[1]).toEqual value: '{:b}', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.other.placeholder.python.legesher']
          expect(tokens[2]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.end.python.legesher']

        it "tokenizes nested replacement fields", ->
          {tokens} = grammar.tokenizeLine '"{:{align}-.{precision}%}"'

          expect(tokens[0]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.begin.python.legesher']
          expect(tokens[1]).toEqual value: '{:', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.other.placeholder.python.legesher']
          expect(tokens[2]).toEqual value: '{align}', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.other.placeholder.python.legesher', 'constant.other.placeholder.python.legesher']
          expect(tokens[3]).toEqual value: '-.', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.other.placeholder.python.legesher']
          expect(tokens[4]).toEqual value: '{precision}', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.other.placeholder.python.legesher', 'constant.other.placeholder.python.legesher']
          expect(tokens[5]).toEqual value: '%}', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.other.placeholder.python.legesher']
          expect(tokens[6]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.end.python.legesher']

      it "tokenizes complex formats", ->
        {tokens} = grammar.tokenizeLine '"{0.players[2]!a:2>-#01_.3d}"'

        expect(tokens[0]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.begin.python.legesher']
        expect(tokens[1]).toEqual value: '{0.players[2]!a:2>-#01_.3d}', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.other.placeholder.python.legesher']
        expect(tokens[2]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.end.python.legesher']

      it "tokenizes {{ and }} as escape characters and not formatters", ->
        {tokens} = grammar.tokenizeLine '"{{hello}}"'

        expect(tokens[0]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.begin.python.legesher']
        expect(tokens[1]).toEqual value: '{{', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.character.escape.curly-bracket.python.legesher']
        expect(tokens[2]).toEqual value: 'hello', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher']
        expect(tokens[3]).toEqual value: '}}', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'constant.character.escape.curly-bracket.python.legesher']
        expect(tokens[4]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.python.legesher', 'punctuation.definition.string.end.python.legesher']

  it "tokenizes properties of self as self-type variables", ->
    tokens = grammar.tokenizeLines('self.foo')

    expect(tokens[0][0]).toEqual value: 'self', scopes: ['source.python.legesher', 'variable.language.self.python.legesher']
    expect(tokens[0][1]).toEqual value: '.', scopes: ['source.python.legesher', 'punctuation.separator.property.period.python.legesher']
    expect(tokens[0][2]).toEqual value: 'foo', scopes: ['source.python.legesher', 'variable.other.property.python.legesher']

  it "tokenizes cls as a self-type variable", ->
    tokens = grammar.tokenizeLines('cls.foo')

    expect(tokens[0][0]).toEqual value: 'cls', scopes: ['source.python.legesher', 'variable.language.self.python.legesher']
    expect(tokens[0][1]).toEqual value: '.', scopes: ['source.python.legesher', 'punctuation.separator.property.period.python.legesher']
    expect(tokens[0][2]).toEqual value: 'foo', scopes: ['source.python.legesher', 'variable.other.property.python.legesher']

  it "tokenizes properties of a variable as variables", ->
    tokens = grammar.tokenizeLines('bar.foo')

    expect(tokens[0][0]).toEqual value: 'bar', scopes: ['source.python.legesher', 'variable.other.object.python.legesher']
    expect(tokens[0][1]).toEqual value: '.', scopes: ['source.python.legesher', 'punctuation.separator.property.period.python.legesher']
    expect(tokens[0][2]).toEqual value: 'foo', scopes: ['source.python.legesher', 'variable.other.property.python.legesher']

  # Add the grammar test fixtures
  grammarTest path.join(__dirname, 'fixtures/grammar/syntax_test_python.py')
  grammarTest path.join(__dirname, 'fixtures/grammar/syntax_test_python_functions.py')
  grammarTest path.join(__dirname, 'fixtures/grammar/syntax_test_python_lambdas.py')
  grammarTest path.join(__dirname, 'fixtures/grammar/syntax_test_python_typing.py')

  describe "SQL highlighting", ->
    beforeEach ->
      waitsForPromise ->
        atom.packages.activatePackage('language-sql')

    it "tokenizes SQL inline highlighting on blocks", ->
      delimsByScope =
        "string.quoted.double.block.sql.python.legesher": '"""'
        "string.quoted.single.block.sql.python.legesher": "'''"

      for scope, delim in delimsByScope
        tokens = grammar.tokenizeLines(
          delim +
          'SELECT bar
          FROM foo'
          + delim
        )

        expect(tokens[0][0]).toEqual value: delim, scopes: ['source.python.legesher', scope, 'punctuation.definition.string.begin.python.legesher']
        expect(tokens[1][0]).toEqual value: 'SELECT', scopes: ['source.python.legesher', scope, 'meta.embedded.sql', 'keyword.other.DML.sql']
        expect(tokens[1][1]).toEqual value: ' bar', scopes: ['source.python.legesher', scope, 'meta.embedded.sql']
        expect(tokens[2][0]).toEqual value: 'FROM', scopes: ['source.python.legesher', scope, 'meta.embedded.sql', 'keyword.other.DML.sql']
        expect(tokens[2][1]).toEqual value ' foo', scopes: ['source.python.legesher', scope, 'meta.embedded.sql']
        expect(tokens[3][0]).toEqual value: delim, scopes: ['source.python.legesher', scope, 'punctuation.definition.string.end.python.legesher']

    it "tokenizes SQL inline highlighting on blocks with a CTE", ->
      # Note that these scopes do not contain .sql because we can't definitively tell
      # if the string contains SQL or not
      delimsByScope =
        "string.quoted.double.block.python.legesher": '"""'
        "string.quoted.single.block.python.legesher": "'''"

      for scope, delim of delimsByScope
        tokens = grammar.tokenizeLines("""
          #{delim}
          WITH example_cte AS (
          SELECT bar
          FROM foo
          GROUP BY bar
          )

          SELECT COUNT(*)
          FROM example_cte
          #{delim}
        """)

        expect(tokens[0][0]).toEqual value: delim, scopes: ['source.python.legesher', scope, 'punctuation.definition.string.begin.python.legesher']
        expect(tokens[1][0]).toEqual value: 'WITH', scopes: ['source.python.legesher', scope, 'meta.embedded.sql', 'keyword.other.DML.sql']
        expect(tokens[1][1]).toEqual value: ' example_cte ', scopes: ['source.python.legesher', scope, 'meta.embedded.sql']
        expect(tokens[1][2]).toEqual value: 'AS', scopes: ['source.python.legesher', scope, 'meta.embedded.sql', 'keyword.other.alias.sql']
        expect(tokens[1][3]).toEqual value: ' ', scopes: ['source.python.legesher', scope, 'meta.embedded.sql']
        expect(tokens[1][4]).toEqual value: '(', scopes: ['source.python.legesher', scope, 'meta.embedded.sql', 'punctuation.definition.section.bracket.round.begin.sql']
        expect(tokens[2][0]).toEqual value: 'SELECT', scopes: ['source.python.legesher', scope, 'meta.embedded.sql', 'keyword.other.DML.sql']
        expect(tokens[2][1]).toEqual value: ' bar', scopes: ['source.python.legesher', scope, 'meta.embedded.sql']
        expect(tokens[3][0]).toEqual value: 'FROM', scopes: ['source.python.legesher', scope, 'meta.embedded.sql', 'keyword.other.DML.sql']
        expect(tokens[3][1]).toEqual value: ' foo', scopes: ['source.python.legesher', scope, 'meta.embedded.sql']
        expect(tokens[4][0]).toEqual value: 'GROUP BY', scopes: ['source.python.legesher', scope, 'meta.embedded.sql', 'keyword.other.DML.sql']
        expect(tokens[4][1]).toEqual value: ' bar', scopes: ['source.python.legesher', scope, 'meta.embedded.sql']
        expect(tokens[5][0]).toEqual value: ')', scopes: ['source.python.legesher', scope, 'meta.embedded.sql', 'punctuation.definition.section.bracket.round.end.sql']
        expect(tokens[7][0]).toEqual value: 'SELECT', scopes: ['source.python.legesher', scope, 'meta.embedded.sql', 'keyword.other.DML.sql']
        expect(tokens[8][0]).toEqual value: 'FROM', scopes: ['source.python.legesher', scope, 'meta.embedded.sql', 'keyword.other.DML.sql']
        expect(tokens[9][0]).toEqual value: delim, scopes: ['source.python.legesher', scope, 'punctuation.definition.string.end.python.legesher']

    it "tokenizes SQL inline highlighting on single line with a CTE", ->
      {tokens} = grammar.tokenizeLine('\'WITH example_cte AS (SELECT bar FROM foo) SELECT COUNT(*) FROM example_cte\'')

      expect(tokens[0]).toEqual value: '\'', scopes: ['source.python.legesher', 'string.quoted.single.single-line.sql.python.legesher', 'punctuation.definition.string.begin.python.legesher']
      expect(tokens[1]).toEqual value: 'WITH', scopes: ['source.python.legesher', 'string.quoted.single.single-line.sql.python.legesher', 'meta.embedded.sql', 'keyword.other.DML.sql']
      expect(tokens[2]).toEqual value: ' example_cte ', scopes: ['source.python.legesher', 'string.quoted.single.single-line.sql.python.legesher', 'meta.embedded.sql']
      expect(tokens[3]).toEqual value: 'AS', scopes: ['source.python.legesher', 'string.quoted.single.single-line.sql.python.legesher', 'meta.embedded.sql', 'keyword.other.alias.sql']
      expect(tokens[4]).toEqual value: ' ', scopes: ['source.python.legesher', 'string.quoted.single.single-line.sql.python.legesher', 'meta.embedded.sql']
      expect(tokens[5]).toEqual value: '(', scopes: ['source.python.legesher', 'string.quoted.single.single-line.sql.python.legesher', 'meta.embedded.sql', 'punctuation.definition.section.bracket.round.begin.sql']
      expect(tokens[6]).toEqual value: 'SELECT', scopes: ['source.python.legesher', 'string.quoted.single.single-line.sql.python.legesher', 'meta.embedded.sql', 'keyword.other.DML.sql']
      expect(tokens[7]).toEqual value: ' bar ', scopes: ['source.python.legesher', 'string.quoted.single.single-line.sql.python.legesher', 'meta.embedded.sql']
      expect(tokens[8]).toEqual value: 'FROM', scopes: ['source.python.legesher', 'string.quoted.single.single-line.sql.python.legesher', 'meta.embedded.sql', 'keyword.other.DML.sql']
      expect(tokens[9]).toEqual value: ' foo', scopes: ['source.python.legesher', 'string.quoted.single.single-line.sql.python.legesher', 'meta.embedded.sql']
      expect(tokens[10]).toEqual value: ')', scopes: ['source.python.legesher', 'string.quoted.single.single-line.sql.python.legesher', 'meta.embedded.sql', 'punctuation.definition.section.bracket.round.end.sql']
      expect(tokens[11]).toEqual value: ' ', scopes: ['source.python.legesher', 'string.quoted.single.single-line.sql.python.legesher', 'meta.embedded.sql']
      expect(tokens[12]).toEqual value: 'SELECT', scopes: ['source.python.legesher', 'string.quoted.single.single-line.sql.python.legesher', 'meta.embedded.sql', 'keyword.other.DML.sql']
      expect(tokens[13]).toEqual value: ' ', scopes: ['source.python.legesher', 'string.quoted.single.single-line.sql.python.legesher', 'meta.embedded.sql']
      expect(tokens[14]).toEqual value: 'COUNT', scopes: ['source.python.legesher', 'string.quoted.single.single-line.sql.python.legesher', 'meta.embedded.sql', 'support.function.aggregate.sql']
      expect(tokens[15]).toEqual value: '(', scopes: ['source.python.legesher', 'string.quoted.single.single-line.sql.python.legesher', 'meta.embedded.sql', 'punctuation.definition.section.bracket.round.begin.sql']
      expect(tokens[16]).toEqual value: '*', scopes: ['source.python.legesher', 'string.quoted.single.single-line.sql.python.legesher', 'meta.embedded.sql', 'keyword.operator.star.sql']
      expect(tokens[17]).toEqual value: ')', scopes: ['source.python.legesher', 'string.quoted.single.single-line.sql.python.legesher', 'meta.embedded.sql', 'punctuation.definition.section.bracket.round.end.sql']
      expect(tokens[18]).toEqual value: ' ', scopes: ['source.python.legesher', 'string.quoted.single.single-line.sql.python.legesher', 'meta.embedded.sql']
      expect(tokens[19]).toEqual value: 'FROM', scopes: ['source.python.legesher', 'string.quoted.single.single-line.sql.python.legesher', 'meta.embedded.sql', 'keyword.other.DML.sql']
      expect(tokens[20]).toEqual value: ' example_cte', scopes: ['source.python.legesher', 'string.quoted.single.single-line.sql.python.legesher', 'meta.embedded.sql']
      expect(tokens[21]).toEqual value: '\'', scopes: ['source.python.legesher', 'string.quoted.single.single-line.sql.python.legesher', 'punctuation.definition.string.end.python.legesher']

    it "tokenizes Python escape characters and formatting specifiers in SQL strings", ->
      {tokens} = grammar.tokenizeLine('"INSERT INTO url (image_uri) VALUES (\\\'%s\\\');" % values')

      expect(tokens[0]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.sql.python.legesher', 'punctuation.definition.string.begin.python.legesher']
      expect(tokens[10]).toEqual value: '\\\'', scopes: ['source.python.legesher', 'string.quoted.double.single-line.sql.python.legesher', 'meta.embedded.sql', 'constant.character.escape.single-quote.python.legesher']
      expect(tokens[11]).toEqual value: '%s', scopes: ['source.python.legesher', 'string.quoted.double.single-line.sql.python.legesher', 'meta.embedded.sql', 'constant.other.placeholder.python.legesher']
      expect(tokens[12]).toEqual value: '\\\'', scopes: ['source.python.legesher', 'string.quoted.double.single-line.sql.python.legesher', 'meta.embedded.sql', 'constant.character.escape.single-quote.python.legesher']
      expect(tokens[13]).toEqual value: ')', scopes: ['source.python.legesher', 'string.quoted.double.single-line.sql.python.legesher', 'meta.embedded.sql', 'punctuation.definition.section.bracket.round.end.sql']
      expect(tokens[15]).toEqual value: '"', scopes: ['source.python.legesher', 'string.quoted.double.single-line.sql.python.legesher', 'punctuation.definition.string.end.python.legesher']
      expect(tokens[17]).toEqual value: '%', scopes: ['source.python.legesher', 'keyword.operator.arithmetic.python.legesher']
