/**
 * @param {string} str
 */
const scan = (str) => {
  const tokens = []
  let m
  for (let s = str; s.length > 0; s = s.slice(m[0].length)) {
    if ((m = s.match(/^[ \t]+|^#.*$/))) {
      // s starts with linear whitespace or comment
      continue
    } else if ((m = s.match(/^true|false/))) {
      // boolean
      tokens.push(new Token('boolean', m[0]))
    } else if ((m = s.match(/^\d+(_\d+)*/))) {
      // integer (with internal underscore)
      tokens.push(new Token('integer', m[0]))
    } else if ((m = s.match(/^:[_a-zA-Z]+[_a-zA-Z0-9]*/))) {
      // atom
      tokens.push(new Token('atom', m[0]))
    } else if ((m = s.match(/^%?{|^[\[\]}]|^=>\s*)/s))) {
      // map or tuple bracket, =>
      // TODO handle when not found closing bracket
      tokens.push(new Token('symbol', m[0]))
    } else if ((m = s.match(/^./))) {
      // TODO do I need this?
      // any single char
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
