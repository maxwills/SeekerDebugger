# SeekerDebugger

## CUSTOM-MODS BRANCH INFO
This branch contains untested changes such as Queries (from commands) executed in a forked proces.
This was done to be able to update the UI, so the app doesn't seem blocked. However, it might have introduced a bug.
Note to self: fix the softUIupdate code so it is only run when it is called from a different thread than the one from the UI (or consider using monitors or something)
(Sympthom: the StDebugger code presenter rendered a red X. It's the first time I've seen it with seeker, so the most likely reason is about this threading and UI change)

### This version new functionalities

- Command queries not executed in the UI thread (A status bar updates during their execution). However, the waiting cursor is now missing.
- New scripting functions:  
```Smalltalk
"setting custom execution boundaries"
seeker recordFromHereWithExecutionEndingConditionOnState: [:state| state bytecodeIndex = 2   ].
seeker recordOnThisContext.

"stepping to a marker"
seeker stepToNextMarker.
"other stepping"
seeker timeTravelToBytecodeIndex:  1001.
seeker stepBytecodes: 100.


"Not new, but useful to remember"
seeker timeTravelToTraceTime: 5 asExecutedBytecodeTraceTime 

```


## Baseline

Seeker Prototype Queryable Time-Traveling Debugger.

*(Beware that the SeekerInstallHelpers class>>install call will overwrite parts of the StDebugger's code of your image)*

Do this:
```Smalltalk
Metacello new
    baseline: 'Seeker';
    repository: 'github://maxwills/SeekerDebugger:custom-mods';
    onWarning: [ :ex | ex resume ];
    load.
```

### IMPORTANT
When installing Seeker in a non-moose Image, a warning will pop up duging the baseline installation. The message warns that there is a missing dependency (FamixStClass). Click proceed and ignore it for the moment. Future version will include diferent isntallation processes for particular images.

The `SeekerInstallHelpers>>#install` will:
- Enable the debugger extension in the StDebugger UI.
- Change the `StDebugger` `debuggerActionModel` default class to `SeekerStDebuggerActionModel`. This will make the StDebugger to need Seeker to be enabled to work. (You can still debug normaly without Seeker, but it will be shown at the right, even if it is not used). Don't use this if you rely on your own modifications of `StDebuggerActionModel`. If you unload Seeker, you will need to manually restore `StDebugger>>#debuggerActionModel`.
- Add a line to `HandMorph>>handleEvent:` to capture the pressed state of modifier keys.


## Limitations and known issues.
- Supports "Debug it" and TestCases when launched from the corresponding seeker menu entry. No support for non intentional debugging.
- No complete support for test clean up at the moment.
- Single thread executions only.
- No UI executions support.
- The execution reversal mechanism can only undo changes that originates from within an execution (the debugged execution call tree). Changes made from outside the execution could affect the reversal mechanism.
- Performance: Executing code with Seeker is slow. Consider closing by force if necessary.
- No support yet for "Debug Drive development". Modifying the debugged code during a debug session might produce problems with time-indices.

## Quick reference:
The Quick Reference pdf document is included in the repository, and can be accessed [here](./Resources/TTQs-QuickReference.pdf).

## UI Integrated Query Example

To show query results in the UI (the Query Tab of Seeker), follow this example.

1. Go to the Scripting Tab, as shown here. 
<img src="./Resources/scripting.png" width="700px">  


2. Paste and execute the following code.
```Smalltalk
|query|
"Lists the variable name for all the assignments of an execution."
query := Query from: seeker programStates
 select: [:state| state node isAssignment] 
 collect: [:state| New with: {
		(#bytecodeIndex -> state bytecodeIndex).
		(#varName -> state node variable variable name).
		}]
.
seeker ui showResult: query asSeekerResultsCollection  
```
3. See the results in the Query Tab. Click on any bytecodeIndex to time-travel to the result.

### Time-Traveling Queries Notes:

- The Query object instantiation doesn't trigger the production of results.
- The method asSeekerResultsCollection triggers the query evaluation, and additionally produces a Seeker UI-friendly object containing the resulting collection.
- The field bytecodeIndex is mandatory. Include it like in the example.
- `New with:` message instantiates a dictionary-like object. Collect your results attributes like that for displaying them in the UI, as in the example.

### Notes
	Remember:
	HandMorph handleEvent: SeekerGlobals instance updateModifierKeys: anEvent.
