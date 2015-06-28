module MainSpec where

import IO.IO exposing (..)
import IO.Runner exposing (Request, Response, run)

import Spec.Runner.Console as Console
import Spec exposing (..)

import CSVSpec

allSpecs =
    describe "Library"
      [ CSVSpec.spec
      ]

testRunner : IO ()
testRunner = Console.run allSpecs

port requests : Signal Request
port requests = run responses testRunner

port responses : Signal Response
