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
      tokens.push(new Token('int', parseInt(m[0])))
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

class Token {
  constructor(kind, lexeme) {
    /** @type {string} */
    this.kind = kind
    /** @type {string} */
    this.lexeme = lexeme
  }
  getMap() {
    const k = (this.kind === 'key' ? 'atom' : this.kind)
    const v = (this.kind === 'key' ? `:${this.lexeme.slice(0, -1)}` : this.lexeme)
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
   */
  constructor(tokens) {
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
    if (this.peek('[')) {
      let l = this.list()
      return l
    } else if (this.peek('{')) {
      let t = this.tuple()
      return t
    } else if (this.peek('%{')) {
      let m = this.map()
      return m
    } else if (this.peek('int') | this.peek('atom') | this.peek('boolean')) {
      let primitive = this.primitive()
      return primitive
    }
    else {
      throw Error('unexpected data literal')
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
    5: `{ :a, 22 }

    {:x, :y, :z}{}

    {
    33
    } #{55}`,
    6: `%{ [:a, 22] => { [1, 2, 3], :x },
    x: [99, %{ a: 33 }]
 }

 { [1, 2], {:a, 22}, %{ a: 99, :b => 11} }

 [ {1, 2}, %{[:x] => 33, b: 44}, :c, [], [:d, 55] ]
 `,
  }

  // const [, , input] = process.argv
  const input = tests[6]
  console.log('input', input)
  const tokens = scan(input)
  console.log('tokens', tokens)

  const p = new Parser(tokens)
  const res = p.parse()
  console.log(JSON.stringify(res))
}

main()
