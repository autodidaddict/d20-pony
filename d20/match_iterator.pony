use "regex"

class MatchIterator is Iterator[Match]
  let _regex: Regex
  let _subject: String 
  var _offset: USize = 0

  new create(regex': Regex, subject': String, offset': USize = 0) =>    
    _regex = regex'
    _subject = subject'
    _offset = offset'

  fun has_next() : Bool =>
    try
      let m = _regex(_subject, _offset)
      true
    else
      false
    end 

  fun ref next() : Match? =>
    let m = _regex(_subject, _offset)    
    //_offset = _offset + (m.end_pos() + 1)
    _offset = m.end_pos() + 1 
    m