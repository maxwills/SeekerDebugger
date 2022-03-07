# SeekerDebugger

## Baseline

Seeker: Prototype Scriptable Time-Traveling Queryable Debugger.
Compatible with Pharo 9.0, Moose Suite 9.0 and Pharo 10 at current date (2022-01-24).

Do this:
```Smalltalk
Metacello new
    baseline: 'Seeker';
    repository: 'github://maxwills/SeekerDebugger:main';
    load.
```

The rest of the readme is not up do date. The debugger is currently under constant changes. The readme will be updated when reaching a stable point.

Requires the following projects (installed automatically with this Seeker Baseline):

- https://github.com/maxwills/auto-type
- https://github.com/maxwills/quick-wrap

The baseline will:
- Enable the debugger extension in the StDebugger UI.
- Change the `StDebugger` `debuggerActionModel` default class to `SeekerStDebuggerActionModel`. This will make the StDebugger to need Seeker to be enabled to work. (You can still debug normaly without Seeker, but it will be shown at the right, even if it is not used). Don't use this if you rely on your own modifications of `StDebuggerActionModel`. If you unload Seeker, you will need to manually restore `StDebugger>>#debuggerActionModel`.
- Add a line to `HandMorph>>handleEvent:` to capture the pressed state of modifier keys.


## Limitations and known issues.

- Supports "Debug it" and TestCases when launched from the corresponding seeker menu entry. No support for non intentional debugging.
- Can be launched from the Playground, and SystemBrowser (for testCase methods), and from withing any instance of the StDebugger (Including other Seeker Debugging sessions) form the Right-Click Context Menu. The user MUST choose the "Debug it with Seeker Option" in order to enable a Time-Traveling Debugging session. Otherwise, a normal StDebugger debugging session will be started (even if Seeker is displayed in the Extensions panel).
- No complete support for test clean up at the moment.
- Single thread executions only.
- No UI executions support.
- (*) The **WorldMenu >> Library >> SeekerDev >> OpenSeekerDebugger Config** option opens a UI with the configarion of some parameters of the debugger. Not Documented at the moment.
- The execution reversal mechanism can only undo changes that originates from within an execution (the debugged execution call tree). Changes made from outside the execution could affect the reversal mechanism.
- Performance: Executing code with Seeker is slow. The emergency stop (STOP button in the toolbar) might be useful if a query is started and takes too long to finish. Consider closing it by force if necessary.
- No support yet for "Debug Drive development". Modifying the debugged code during a debug session might produce problems with time-indices.
- Not fully compatible with instrumentation:
  - Executing Seeker will remove all breakpoints in the system.
  - If Breakpoints are added later will result in undefined behavior (don't add breakpoints while using the debugger).
  - Not tested yet with metalinks.
  - Code instrumented with method proxies should work.
- The "execution interpretation and reversal mechanisms" are known to have problems with:
  - Executions that perform calls on and/or modify global state UI related objects (HandMorphs, for example), which is sadly a big part of Pharo.
  - Executions that performs class installations, and removal form the system.
  - Executions that compile code (adding methods to objects and classes).
  - Explicit garbage collection calls (Although not tested).
- ObservableSlots "extra behavior" is suspected to not be monitored by the debugger, and therefore it might be left out of the Queries and from the execution reversal mechanism. This hasn't been tested yet.

### Troubleshooting

**Problem:** I can't open a debugger anymore. Any time I try to debug something, the Emergency debugger is shown instead of the StDebugger, even if I am not using "debug it with Seeker". What can I do?

**Answer:** Since Seeker performs several initalization logic (which might fail), when a failure is detected during this phase, a flag is set to prevent any opening of the StDebugger. The reason for this is that once a failure is detected, Pharo will try to open a debugger to debug the failure, which result in the image being locked. If you didn't modify Seeker or StDebugger code, then the most likely cause of the failure is a Breakpoint or a halt in your domain code (that is being executed during the initialization of the Time-Traveling mechanism). To fix this:

1. Remove all breakpoints, and all Halts of your code.
2. Open the Seeker Config UI (as described in **Limitations and known issues**, point (*)), and click in the ***Reset emergency deactivation*** button.

This should enable the normal debugger, and with the Breakpoints and halts removed, it should bring back Seeker.


## Time-Traveling Queries Usage / Quick reference:
The Quick Reference pdf document is included in the repository, and can be accessed [here](./Resources/TTQs-QuickReference.pdf).

## User Defined Queries

Developers can use the scripting area to write their own program queries.

### The Query Notation

The Query notation is a general purpose notation to write queries over collections (Any collection, not just the ones related to executions). It uses standandar selection and collection semantics, however, the only difference is that selection and collection are lazily evaluated (This should be of no concern when writing the queries. 
This is only mentioned here, because it is the factor that makes possible to query the execution like this (ie, an eager evaluation select and collect would not work)).

**Example**

```Smalltalk
"In the scripting presenter, paste the following code:"

"This query obtains an OrderedCollection containing the list of all the methods of any step that corresponds to a message send to any method with the selector #add:".

(Query from: seeker newProgramStates "or just use the workspace variable: programStates"
    select: [ :state | state isMessageSend and: [ state node selector = #add: ] ]
    collect: [ :state | state methodAboutToExecute ]) asOrderedCollection
```

Then, select all the code, and **inspect it** (right click, and select **Inspect it** from the context menu, or simply press **cmd+i**). 
You should see an inspector with the collection of the results.

## User Time-Traveling Query.

Time-Traveling Queries are just a specific type of Query. To explain how to write one, we will start from the more generic Query form (as described in the previous point).

To transform a Query into a Time-Traveling Query (with integration in the UI)

1. Use **UserTTQ** instead of the **Query** class.
2. Use **Autotype** for collected items.
3. Include the **#bytecodeIndex** key as in this example:


```Smalltalk
"In the scripting presenter, paste the following code:"
| autoResultType |
    autoResultType := AutoType new.
    (UserTTQ from: seeker newProgramStates
        select: [ :state | state isMessageSend and: [ state node selector = #add: ] ]
        collect: [ :state | 
            autoResultType newWith
            bytecodeIndex: state bytecodeIndex;
            methodClass: state methodAboutToExecute methodClass name;
            messageSelector: state methodAboutToExecute selector;
            newColumnASD: 123; "you can add any column you want like this"
            endWith ]) showInSeeker
```
Then select all the code, and **do it** (right click, and select **Do it** from the context menu, or simply press **cmd+d**). 
The query should be displayed in the query tab of Seeker (you need to manually change to the tab at the moment).

### Queries (and TTQ) Composition.

Queries and TTQs can be composed. Ie, they can be used as a data source for other queries.

```Smalltalk

| query1 query2 |
   query1 := (Query from: seeker newProgramStates "or just use the workspace variable: programStates"
    select: [ :state | state isMessageSend and: [ state node selector = #add: ] ]
    collect: [ :state | state methodAboutToExecute ]).
    
    "Can be used to compose:"
    query2 := Query from: query1 select: [:state| state messageReceiver class = OrderedCollection]. 
    "Which is equivalent to:"
    query2 := query1 select: [:state| state messageReceiver class = OrderedCollection]. 
    "Finally, to trigger the query evaluation, do"
    query2 asOrderedCollection
```
In both examples, the selection conditions are applied in order, from the innermost ones (query1 selection predicate is applied first) to the outermost ones (query2 selection predicate is applied last). 
The same applies to Time-Traveling Queries (TTQs).
The methods #select: and #collect: of Queries returns new Queries objects (not the results of the query).

### Time-Traveling Queries Notes:

- The Query object instantiation doesn't trigger the production of results.
- The field bytecodeIndex is mandatory. Include it like in the example.
- AutoType automatically creates a class (and instances. The class is not registered in the system) that serves the collection function. To make time traveling queries, it is mandatory to include the bytecodeIndex field.

	
### 2021/11 functionalities

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
