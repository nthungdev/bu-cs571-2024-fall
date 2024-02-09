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
      tokens.push(new Token('symbol', m[0]))
    }
  }
  return tokens
}

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
  }

  // const [, , input] = process.argv
  const input = tests[3]
  console.log('input', input)
  console.log('tokens', scan(input))
}

main()
