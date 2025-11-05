$ErrorActionPreference = SilentlyContinue

Function function3 {
    Try {NonsenseString}
    Catch {"Error trapped inside function";Throw}
    "Function3 was completed"
}

Clear-Host
Try{Function3}
Catch {"Internal Function error re-thrown: $($_.ScriptStackTrace)"}
"Script Completed"