//: Playground - play with String

import Foundation

var from = "herve.peroteau@gmail.com"
let dest = "toto@gmail.com"

if let index = from.characters.index(of: "@") {
  let suffix = from.substring(from: index)
  if dest.hasSuffix(suffix) {
    print ("same host")
  }
  else {
    print ("Different host")
  }
}
