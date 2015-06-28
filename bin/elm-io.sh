#!/usr/bin/env bash
if [ "$#" = 3 ]; then
    MAIN_MODULE=$3
elif [ "$#" = 2 ]; then
    MAIN_MODULE=Main
else
    echo "Usage: $0 <generated-js-file> <output-file> [<Main>]"
    exit 1
fi

read -d '' handler <<- EOF
(function(){
    var stdin = process.stdin;
    var fs    = require('fs');
    if (typeof Elm === "undefined") { throw "elm-io config error: Elm is not defined. Make sure you call elm-io with a real Elm output file"}
    if (typeof Elm.${MAIN_MODULE} === "undefined" ) { throw "Elm.${MAIN_MODULE} is not defined, make sure your module is named ${MAIN_MODULE}." };
    var worker = Elm.worker(Elm.${MAIN_MODULE}
                            , {responses: null }
                           );
    var just = function(v) {
        return { 'Just': v};
    }
    var handle = function(request) {
        // Debugging:
        // console.log("Bleh: %j", request);
        switch(request.ctor) {
        case 'Put':
            process.stdout.write(request.val);
            break;
        case 'Get':
            stdin.resume();
            break;
        case 'Exit':
            process.exit(request.val);
            break;
        case 'WriteFile':
            fs.writeFileSync(request.file, request.content);
            break;
        }
    }
    var handler = function(reqs) {
        for (var i = 0; i < reqs.length; i++) {
            handle(reqs[i]);
        }
        if (reqs.length > 0 && reqs[reqs.length - 1].ctor !== 'Get') {
            worker.ports.responses.send(just(""));
        }
    }
    worker.ports.requests.subscribe(handler);
    
    // Read
    stdin.on('data', function(chunk) {
        //console.log('Got' + chunk);
        stdin.pause();
        worker.ports.responses.send(just(chunk.toString()));
    })

    // Start msg
    worker.ports.responses.send(null);
})();
EOF

cat $1 > $2
echo "$handler" >> $2
