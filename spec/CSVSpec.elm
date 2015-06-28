module CSVSpec where

import CSV exposing (..)
import Spec exposing (..)

spec = describe "CSV"
    [ describe "isValid"
        [ describe "when the content is well-formed"
            [ describe "regular line"
                [ isValid "Product,Price\n" `shouldEqual` True
                ]
            , describe "quoted cell"
                [ isValid "\"Product\",Price\n" `shouldEqual` True
                ]
            , describe "comma within quoted cell"
                [ isValid "\"hey, you!\"\n" `shouldEqual` True
                ]
            , describe "empty content"
                [ isValid "" `shouldEqual` True
                ]
            , describe "escaped quote"
                [ isValid "\"My name is \"\"Capitu\"\"!\"\n" `shouldEqual` True
                ]
            , describe "multiple lines"
                [ isValid "First line\nSecond line\n" `shouldEqual` True
                ]
            ]
        , describe "when the content is malformed"
            [ describe "unclosed quoted cell"
                [ isValid "\"Product,Price\n" `shouldEqual` False
                ]
            ]
        ]
    ]

