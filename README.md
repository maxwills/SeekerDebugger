# SeekerDebugger

Seeker Prototype Queryable TimeTraveling Debugger.

*(Beware that the SeekerInstallHelpers class>>install call will overwrite parts of the StDebugger's code of your image)*

Do this:
```Smalltalk
Metacello new
    baseline: 'Seeker';
    repository: 'github://maxwills/SeekerDebugger:main';
    load.
    
#SeekerInstallHelpers asClass install.
```

The `SeekerInstallHelpers>>#install` will:
- Enable the debugger extension in the StDebugger UI.
- Change the `StDebugger` `debuggerActionModel` default class to `SeekerStDebuggerActionModel`. This will make the StDebugger to need Seeker to be enabled to work. (You can still debug normaly without Seeker, but it will be shown at the right, even if it is not used). Don't use this if you rely on your own modifications of `StDebuggerActionModel`. If you unload Seeker, you will need to manually restore `StDebugger>>#debuggerActionModel`.


## Limitations
- Non-local changes NOT supported (i.e. only supports assignments for temporary (and parameters?) variables.  
- Currently, supports only test cases.
  - It doesn't support tests tear down phase at the moment.
- Performance: Executing code with Seeker is slow. Consider closing by force if necessary.

## More information:
Usage examples can be found in the readme here:
https://github.com/Willembrinck/2021-TTQs
