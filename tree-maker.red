Red []


pure-rules: context []
transformations: context []

; homework for user: make it to where the functions can take contexts so that there can be multiple
; context for words, this would allow one to have multiple compiler passes

; removes the word keep from anywhere in a block
clear-keeps: function [b [block!]] [
    remove-keep: [
        some [
            remove 'keep | 
            ahead block! into remove-keep | 
            skip
        ]
    ]
    parse b remove-keep
    b
]

; defines a rule in the form of def-rule rule-name [some parsing with rules]
def-rule: func ['name rules [block!] /local keyword parens body cleared-rules] [
    ; check for a transformation, if there is none create one that simple returns the node
    if not in transformations name [
        transformations: make transformations compose/deep [
            (to set-word! name) function [args] [
                probe head insert copy/deep args (to lit-word! name)
            ]
        ]
    ]
    parens: make paren! []
    cleared-rules: bind clear-keeps copy/deep rules pure-rules  
    pure-rules: make pure-rules compose/deep [
        (to set-word! name) [(cleared-rules)]
    ]
    bind cleared-rules pure-rules
    body: compose/deep [
        ahead [(cleared-rules)] 
        collect [
            keep (append copy parens to lit-word! name) 
            [(rules)]
        ]
    ]
    set name body
    
]
; depth first traversal that applies functions to nodes that match
dfs-f-apply: function [blk [block!]] [
    while [not tail? blk] [
        elm: blk/1
        if (type? elm) = block! [
            dfs-f-apply elm
            probe blk/1: do reduce [
                bind first blk/1 transformations
                next blk/1
            ]
        ]
        blk: next blk
    ]
    head blk
]
; creates transformations for each node in the tree
def-transformation: func ['name args body [block!]] [
    transformations: make transformations compose/only [
        (to set-word! name) function (args) (body)
    ]

]

;; below are just examples erase code

def-transformation there [args] [
    args/1
]

def-transformation hello [args] [
    rejoin ["hi " next args]
]


; letter: charset [#"A" - #"Z" #"a" - #"z"]

; def-rule there [keep "there"]
; def-rule hello [
;     [keep [some letter] space there space there]
; ]
; def-rule lawl [
;     hello | ["lawl " hello]
; ]
; ; dfs-f-apply  
; ; probe 
; x: parse "lawl hello there there" [collect lawl]

; probe dfs-f-apply x

