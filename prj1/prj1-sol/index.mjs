#!/usr/bin/env node

import fs from 'fs'

/**
 * @param {string} str
 */
const tokenize = (str = '') => {
  const tokens = []
  let m
  let col = 0
  let row = 0
  for (let s = str; s.length > 0; s = s.slice(m[0].length)) {
    let errorMessage
    let newLine = false
    let skip = false
    let kind
    let lexeme
    if ((m = s.match(/^\n/))) {
      newLine = true
    } else if ((m = s.match(/^[\s\t]+/))) {
      // s starts with linear whitespace
      skip = true
    } else if ((m = s.match(/^#.*$/m))) {
      // skip comment
      newLine = true
    } else if ((m = s.match(/^(?:true|false)\b/))) {
      kind = 'bool'
      lexeme = JSON.parse(m[0])
    } else if ((m = s.match(/^\d+(?:_\d+)*(?=\W|$|\Z)/))) {
      // integer (with internal underscore)
      kind = 'int'
      lexeme = parseInt(m[0].replace(/_/g, ''))
    } else if ((m = s.match(/^:[a-zA-Z]+[_a-zA-Z0-9]*/))) {
      kind = 'atom'
      lexeme = m[0]
    } else if ((m = s.match(/^[a-zA-Z]+[_a-zA-Z0-9]*:/))) {
      kind = 'key'
      lexeme = m[0]
    } else if ((m = s.match(/^%?{|^\[|^=>|^\,|^[\]\}]/))) {
      // brackets, =>, comma
      kind = m[0]
      lexeme = m[0]
    } else if ((m = s.match(/.*\b/))) {
      errorMessage = `error: unexpected '${m[0]}' token`
    }

    if (newLine) {
      row++
      col = 0
    } else {
      col += m[0].length

      if (errorMessage) {
        throw errorMessage
      }

      if (!skip) {
        tokens.push(new Token(kind, lexeme, col, row))
      }
    }
  }
  return tokens
}

class Token {
  constructor(kind, lexeme, col, row) {
    /** @type {string} */
    this.kind = kind
    /** @type {string} */
    this.lexeme = lexeme
    this.col = col
    this.row = row
  }
  getMap() {
    const k = this.kind === 'key' ? 'atom' : this.kind
    const v = this.kind === 'key' ? `:${this.lexeme.slice(0, -1)}` : this.lexeme
    return {
      '%k': k,
      '%v': v,
    }
  }
  toString() {
    return `Token { %k: ${this.kind}, %v: ${this.lexeme} }`
  }
}

class Parser {
  /**
   * @param {string[]} tokens
   * @param {string[]} input
   */
  constructor(tokens, input) {
    /** @type {string} */
    this._input = input
    /** @type {string[]} */
    this._tokens = tokens
    /** @type {number} */
    this._index = 0
    /** @type {Token} */
    this.token = this._nextToken() // lookahead
  }

  // wrapper used for crude  error recovery
  parse() {
    try {
      let result = this.parseLo()
      if (!this.peek('EOF')) {
        this._handleError({ kind: 'end-of-input' })
      }
      return result
    } catch (err) {
      throw err
    }
  }

  parseLo() {
    return this.sentence()
  }

  sentence() {
    let s = []
    while (!this.peek('EOF')) {
      let dl = this.dataLiteral()
      s.push(dl)
    }
    return s
  }

  dataLiteral() {
    if (this.peek('[')) {
      let l = this.list()
      return l
    } else if (this.peek('{')) {
      let t = this.tuple()
      return t
    } else if (this.peek('%{')) {
      let m = this.map()
      return m
    } else if (this.peek('int') | this.peek('atom') | this.peek('bool')) {
      let primitive = this.primitive()
      return primitive
    } else {
      this._handleError({ kind: 'data-literal' })
    }
  }

  list() {
    this.consume('[')
    const items = []
    while (!this.peek(']')) {
      if (items.length !== 0) {
        if (this.peek(',')) {
          this.consume(',')
        } else {
          this._handleError({ kind: ',' })
        }
      }

      const dl = this.dataLiteral()
      items.push(dl)
    }
    this.consume(']')
    return {
      '%k': 'list',
      '%v': items,
    }
  }

  tuple() {
    this.consume('{')
    const items = []
    while (!this.peek('}')) {
      const dl = this.dataLiteral()
      items.push(dl)
      if (this.peek(',')) {
        this.consume(',')
      }
    }
    this.consume('}')
    return {
      '%k': 'tuple',
      '%v': items,
    }
  }

  map() {
    this.consume('%{')
    const items = []
    while (!this.peek('}')) {
      const pair = this.keyPair()
      items.push(pair)
      if (this.peek(',')) {
        this.consume(',')
      }
    }
    this.consume('}')
    return {
      '%k': 'map',
      '%v': items,
    }
  }

  primitive() {
    const token = this.token
    this.consume(token.kind)
    return token.getMap()
  }

  keyPair() {
    const pair = []
    if (this.peek('key')) {
      pair.push(this.key())
      pair.push(this.dataLiteral())
    } else {
      pair.push(this.dataLiteral())
      this.consume('=>')
      pair.push(this.dataLiteral())
    }
    return pair
  }

  key() {
    const token = this.token
    this.consume(token.kind)
    return token.getMap()
  }

  peek(kind) {
    return this.token.kind === kind
  }

  consume(kind) {
    if (this.peek(kind)) {
      this.token = this._nextToken()
    } else {
      const msg = `expecting ${kind} at "${this.token.lexeme}"`
      this._handleError({ kind })
    }
  }

  _handleError({ kind, message }) {
    const lines = this._input.split('\n')
    const line = lines[this.token.row]
    const spaces = Array(this.token.col - 1)
      .fill(' ')
      .join('')
    const mess = kind
      ? `expecting ${kind} at "${this.token.lexeme}"`
      : message ?? ''
    let errorMessage = `error: ${mess}
    ${line}
    ${spaces}^`

    throw errorMessage
  }

  _nextToken() {
    if (this._index < this._tokens.length) {
      return this._tokens[this._index++]
    } else {
      return new Token('EOF', '<EOF>')
    }
  }
} // Parser

const main = () => {
  try {
    // read test file path from argument (if present) for development purpose
    const testPath = process.argv[2] ?? 0

    const input = fs.readFileSync(testPath, 'utf8')

    const tokens = tokenize(input)

    const p = new Parser(tokens, input)
    const res = p.parse()
    console.log(JSON.stringify(res, undefined, 2))
  } catch (error) {
    console.error(error)
    process.exit(1)
  }
}

main()
