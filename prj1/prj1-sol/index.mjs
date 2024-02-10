#!/usr/bin/env node

import fs from 'fs'

/**
 * @param {string} str
 */
const scan = (str = '') => {
  const tokens = []
  let m
  for (let s = str; s.length > 0; s = s.slice(m[0].length)) {
    if ((m = s.match(/^[\s\t]+/))) {
      // s starts with linear whitespace
      continue
    } else if ((m = s.match(/^#.*$/m))) {
      // skip comment
      continue
    } else if ((m = s.match(/^true|false/))) {
      tokens.push(new Token('boolean', m[0]))
    } else if ((m = s.match(/^\d+(_\d+)*/))) {
      // integer (with internal underscore)
      tokens.push(new Token('integer', m[0]))
    } else if ((m = s.match(/^:[a-zA-Z]+[_a-zA-Z0-9]*/))) {
      tokens.push(new Token('atom', m[0]))
    } else if ((m = s.match(/^[a-zA-Z]+[_a-zA-Z0-9]*:/))) {
      tokens.push(new Token('key', m[0]))
    } else if ((m = s.match(/^%?{|^[\[\]}]|^=>*|,/))) {
      // map or tuple bracket, =>, comma
      // TODO handle error when not found closing bracket
      tokens.push(new Token(m[0], m[0]))
    }
  }
  return tokens
}

class Parser {
  constructor(tokens) {
    this._tokens = tokens
    this._index = 0
    this.token = this._nextToken() // lookahead
  }

  // wrapper used for crude  error recovery
  parse() {
    try {
      let result = this.parseLo()
      if (!this.peek('EOF')) {
        const msg = `expecting end-of-input at "${this.token.lexeme}"`
        throw new SyntaxError(msg)
      }
      return result
    } catch (err) {
      return err
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
    // TODO
    if (this.peek('[')) {
      let l = this.list()
      return l
    } else if (this.peek('{')) {
      let t = this.tuple()
      return t
    } else if (this.peek('%{')) {
      let m = this.map()
      return m
    } else if (this.peek('integer')) {
      let i = this.integer()
      return i
    } else if (this.peek('atom')) {
      let a = this.atom()
      return a
    } else if (this.peek('boolean')) {
      let b = this.boolean()
      return b
    }
  }

  list() {
    this.consume('[')
    const items = []

    while (!this.peek(']')) {
      const dl = this.dataLiteral()
      items.push(dl)
      if (this.peek(',')) {
        this.consume(',')
      }
    }

    this.consume(']')

    return {
      '%k': 'list',
      '%v': items,
    }
  }

  tuple() {
    // TODO
  }

  map() {
    // TODO
  }

  primitive() {
    // TODO
  }

  integer() {
    const token = this.token
    this.consume('integer')
    return token
  }

  atom() {
    const token = this.token
    this.consume('atom')
    return token
  }

  boolean() {
    // TODO
  }

  keyPair() {
    // TODO
  }

  key() {
    // TODO
  }

  peek(kind) {
    return this.token.kind === kind
  }

  consume(kind) {
    if (this.peek(kind)) {
      this.token = this._nextToken()
    } else {
      const msg = `expecting ${kind} at "${this.token.lexeme}"`
      throw new SyntaxError(msg)
    }
  }

  _nextToken() {
    if (this._index < this._tokens.length) {
      return this._tokens[this._index++]
    } else {
      return new Token('EOF', '<EOF>')
    }
  }
} //Parser

class Token {
  constructor(kind, lexeme) {
    Object.assign(this, { kind, lexeme })
  }
  toString() {
    return `Token { kind: ${this.name}, lexeme: ${this.age} }`
  }
}

const main = () => {
  const tests = {
    1: '%{a: 22, [33] => 44, c: {55, :d, []}}',
    2: `# this file contains no data

    #but it contains multiple comments`,
    3: `# single atom

    :atom

    `,
    4: `
    [ :a, 22, :b ][]

    [
      :some_atom12,
      # 99
      12
    ]
    `,
  }

  // const [, , input] = process.argv
  const input = tests[4]
  console.log('input', input)
  const tokens = scan(input)
  console.log('tokens', tokens)

  const p = new Parser(tokens)
  const res = p.parse()
  console.log(JSON.stringify(res))
}

main()
