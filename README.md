# elm-csv-parser
CSV Parser in Elm

## Build

[Install Elm](http://elm-lang.org/install) (we provide a [Dockerfile](https://github.com/jivagoalves/elm-csv-parser/blob/master/Dockerfile) too) and then:

```
$ make
```

## Usage

```
$ elm-repl 
Elm REPL 0.4 (Elm Platform 0.15)
  See usage examples at <https://github.com/elm-lang/elm-repl>
  Type :help for help, :exit to exit
> import CSV
> CSV.isValid "First, Second\n"
True : Bool
> CSV.isValid "\"malformed with unbalanced quotes\n"
False : Bool
```

## Running specs

```
$ make spec
elm-make  src/CSV.elm  spec/CSVSpec.elm  spec/MainSpec.elm --yes --output spec.js
Successfully generated spec.js                                      
bin/elm-io.sh spec.js spec.io.js MainSpec
node spec.io.js
  + Library
    + CSV
      + isValid
        + when the content is well-formed
          + regular line
            - OKAY
          + quoted cell
            - OKAY
          + comma within quoted cell
            - OKAY
          + empty content
            - OKAY
          + escaped quote
            - OKAY
          + multiple lines
            - OKAY
        + when the content is malformed
          + unclosed quoted cell
            - OKAY
```
