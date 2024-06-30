Red []

; x: 1
; print x: x + 1

; if x = 2 [
;     print "its true"
; ]

; print [
;     {there are two caves
;     choose 1}
; ]
; choice: input 

; either choice = "1" [
;     print "you die"
; ] [
;     print "you live"
; ]

bur: function [x] [
    x + x
]

point: object [
    x: 1
    y: 2
]
next-point: make point [
    i-do-something: function [] []
]


letter: charset [#"A" - #"Z" #"a" - #"z"]
digit: charset [#"0" - #"9"]
digits: [some digit]
letters: [some letter]

access-modifiers: [
    "public" |
    "private" |
    "default" |
    "protected"
]
static: [
    "static"
]
type: [
    letters
    opt [some "[]"]
]
return-type: type
whitespace: [
    some " "
]
method-name: letters

open-paren: "("
close-paren: ")"
open-bracket: "{"
close-bracket: "}"

java-method: [
    opt [access-modifiers whitespace]
    opt [static whitespace]
    return-type
    whitespace
    method-name
]

argument: [
    type 
    whitespace
    some letter
]

arguments: [
    some [
        argument 
        opt whitespace 
        "," 
        opt whitespace
    ]
    argument
]

; probe parse "publicvoid main(String[] args){}" [
;     java-method
;     opt whitespace
;     open-paren
;     [argument | arguments]
;     opt whitespace
;     close-paren
;     mark:
; ] 

; probe mark

; code: [1 + 1]
; code/3: 5
; probe do code
; if-code: [print "what in the facker" if-code/1: ]
; if: 1 1 = 1 if-code

filter: function ['f block] [
    ret: copy []
    foreach elm block [
        if do reduce [f elm] [
            append ret elm
        ] 
    ]
    ret
]


; probe parse [1] [collect [integer! keep (to set-word! 'integer)]]

set-add: function [block elm] [
    if not (find block elm) [
        append block elm
    ]
    block
]
just-rules: []
purify-rule: [
    [
        ahead word!
        mark: if (find mark/1 just-rules)
        change word! (select just-rules mark/1)
    ] |
    [into | skip | end | purify-rule]
]
purify-rules: function [rule-body] [
    
    parse rule-body 
]
def-rule: function ['name rule] [
    keyword: compose [to set-word! (to lit-word! name)]
    parens: make paren! []
    parens2: make paren! []
    body: reduce [
        'ahead
        rule 
        'collect 
        compose/deep [keep (append parens (keyword)) 
                      keep (rule)]
    ]
    set do keyword body
    ; change this to a hashmap!
    ; s set-add just-rules name  back back tail deep/copy body
]

def-rule there "there"
def-rule hello [some letter space there space there]
; there: [
;     copy data "there" keep (to set-word! 'there)
; ]
probe hello

probe parse "hello there there" [collect hello]

probe select ['a 'b 'c] 'a

parse x: [1] [mark: change integer! 2]

kek: #[1 1 'hello 1]
probe kek/hello