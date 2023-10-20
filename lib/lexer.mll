(* header section *)
{
    open Error
    open Tokens
    open Lexer_utils
}

(* definitions section *)
let digit   = ['0'-'9']
let xdigit  = ['0'-'9' 'a'-'f' 'A'-'F']
let ws      = [' ' '\t' '\r']
let id      = ['a'-'z' 'A'-'Z' '_']['a'-'z' 'A'-'Z' '0'-'9' '_']*

let chr     = [' '-'~'] (* valid ASCII characters found in a normal text/string *)

(* rules section *)
rule token = parse
        ws+                         { token lexbuf                                          }
    |   '\n'                        { Lexing.new_line lexbuf; token lexbuf                  }
    |   "$$"                        { comment lexbuf                                        }
    |   '$' ([^ '$' '\n'][^'\n']*)? { token lexbuf                                          }

    |   '+'                         { PLUS                                                  }
    |   '-'                         { MINUS                                                 }
    |   '*'                         { MULT                                                  }

    |   "<="                        { LESS_EQ                                               }
    |   ">="                        { MORE_EQ                                               }
    |   '<'                         { LESS                                                  }
    |   '>'                         { MORE                                                  }
    |   '='                         { EQ                                                    }
    |   '#'                         { NOT_EQ                                                }
    |   '('                         { LEFT_PAR                                              }
    |   ')'                         { RIGHT_PAR                                             }
    |   '['                         { LEFT_BRACKET                                          }
    |   ']'                         { RIGHT_BRACKET                                         }
    |   '{'                         { LEFT_CURL                                             }
    |   '}'                         { RIGHT_CURL                                            }
    |   ','                         { COMMA                                                 }
    |   ';'                         { SEMICOLON                                             }
    |   ':'                         { COLON                                                 }
    |   "<-"                        { ASSIGN                                                }
  
    |   id as word                  {   try (* keyword_table is from Utils module *)
                                            let tok = Hashtbl.find keyword_table word in
                                                tok
                                        with
                                            Not_found -> ID word                            }
    |   digit+ as num               { LIT_INT (int_of_string num)                           }
    |   '\''                        { character lexbuf                                      }
    |   '"'                         {   let buf = Buffer.create 17 in
                                            str buf lexbuf                                  }
    |   eof                         { EOF                                                   }
    |   _ as c                      { fail_b "Lexical" ("Bad character: '"^(String.make 1 c)^"'") lexbuf}
and comment = parse             
        "$$"                        { token lexbuf                                          }
    |   '\n'                        { Lexing.new_line lexbuf; comment lexbuf                }
    |   _                           { comment lexbuf                                        }
    |   eof                         { fail_b "Lexical" "Multiline comment does not terminate" lexbuf    }

and character = parse
        '\\'                        { escape end_character lexbuf                           }
    |   chr as c                    { end_character c lexbuf                                }
    |   eof                         { fail_b "Lexical" "Improper use of character syntax" lexbuf        }
    |   _ as c                      { fail_b "Lexical" ("Bad character: '"^(String.make 1 c)^"'") lexbuf}

and end_character c = parse
        '\''                        { LIT_CHAR c                                            }
    |   _                           { fail_b "Lexical" "Improper use of character syntax" lexbuf        }

and str buf = parse
        '"'                         { LIT_STR (Buffer.contents buf)                         }
    |   '\\'                        {   let str_exec_func c lexbuf =
                                            Buffer.add_char buf c;
                                            str buf lexbuf
                                        in
                                        escape str_exec_func lexbuf                         }
    |   chr as c                    { Buffer.add_char buf c; str buf lexbuf                 }
    |   eof                         { fail_b "Lexical" "String does not terminate" lexbuf               }
    |   _ as c                      { fail_b "Lexical" ("Bad character: '"^(String.make 1 c)^"'") lexbuf}    

and escape exec_func = parse
        'n'                         { exec_func '\n' lexbuf                                 }
    |   't'                         { exec_func '\t' lexbuf                                 }
    |   'r'                         { exec_func '\r' lexbuf                                 }
    |   '0'                         { exec_func '\x00' lexbuf                               }
    |   '\\'                        { exec_func '\\' lexbuf                                 }
    |   '\''                        { exec_func '\'' lexbuf                                 }
    |   '"'                         { exec_func '"' lexbuf                                  }
    |   'x' xdigit xdigit as code   {
                                        let dec_code = int_of_string ("0"^code) in
                                        let ascii_char = char_of_int dec_code in
                                            exec_func ascii_char lexbuf                     }
    |   _ as c                      { fail_b "Lexical" ("Bad escape: '\\"^(String.make 1 c)^"'") lexbuf }