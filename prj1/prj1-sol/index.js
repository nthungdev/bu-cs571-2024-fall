/**
 *
 * @param {string} str
 * @returns
 */
const scan = (str) => {
  const tokens = []
  let m
  for (let s = str; s.length > 0; s = s.slice(m[0].length)) {
    if ((m = s.match(/^[ \t]+/))) {
      //s starts with linear whitespace
      continue //skip linear whitespace
    } else if ((m = s.match(/^\d+/))) {
      //one or more digits
      tokens.push(new Token('INT', m[0]))
    } else if ((m = s.match(/^./))) {
      //any single char
      tokens.push(new Token(m[0], m[0]))
    }
  }
  return tokens
}

class Token {
  constructor(kind, lexeme) {
    Object.assign(this, { kind, lexeme })
  }
}
