use "regex"

class MatchIterator is Iterator[Match]
  """
  MatchIterator allows for calling code to repeatedly perform the same match
  against a subject string as an iterator. This lets clients repeat the match 
  until no more matches exist.
  """
  let _regex: Regex
  let _subject: String 
  var _offset: USize = 0

  new create(regex': Regex, subject': String, offset': USize = 0) =>   
    """
    Creates a new Match Iterator from a regular exprssion and a subject 
    string 
    """ 
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