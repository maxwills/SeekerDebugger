Class {
	#name : #GeneralSeekerExamples,
	#superclass : #TestCase,
	#category : #'Seeker-BugCollection-Tests'
}

{ #category : #'as yet unclassified' }
GeneralSeekerExamples class >> markersExample [

"In a playground, call SeekerSessionHelpers debugSession: [GeneralSeekerExamples markersExample] and select the Markers query from the menu. The executed query is: Se"

	| aCol aNumber aMarkerBlock |
	"Next assignment should not appear in the query results"
	aMarkerBlock := [ 
	                SeekerSessionHelpers marker: 'Should be the fourth' ].
	aCol := OrderedCollection new.
	aNumber := 0.
	SeekerSessionHelpers marker.
	"Next (inner) assignment should appear in the query"
	SeekerGlobals instance auxiliaryTempStorage1: 1.
	aNumber := aNumber + 10.
	SeekerGlobals instance auxiliaryTempStorage1: 2.
	SeekerSessionHelpers marker.
	aNumber := aNumber + 10.
	SeekerGlobals instance auxiliaryTempStorage1: aMarkerBlock.
	SeekerSessionHelpers marker. "Third one"
	SeekerGlobals instance auxiliaryTempStorage1 value. "Fourth one is inside this block"
]

{ #category : #'as yet unclassified' }
GeneralSeekerExamples class >> otherInstanceWrapper: receiver wrappedMethod: aMethod arguments: args [
	| res |
	res := receiver execute: aMethod withArgs: args.
	^ 'result is new: ' , res asString
]

{ #category : #'as yet unclassified' }
GeneralSeekerExamples class >> reversibilityExample [

	| aCollection |
	aCollection := OrderedCollection new.
	self reversibilityExampleWith: aCollection
]

{ #category : #'as yet unclassified' }
GeneralSeekerExamples class >> reversibilityExampleWith: aCollection [

	| aDistractingCollection |
	aDistractingCollection := OrderedCollection new.

	aCollection add: 1.
	aCollection add: 2.
	aCollection add: 3.

	aDistractingCollection add: -1.

	aCollection removeAll.
	aCollection add: 4.
	aCollection add: 5.

	aDistractingCollection add: -2.

	aCollection add: aCollection.
	aCollection add: 6.
	aCollection add: 7.
	aDistractingCollection add: -3.
	1 to: 10 do: [ :i | aCollection add: i ]
]

{ #category : #'as yet unclassified' }
GeneralSeekerExamples class >> tempClassBuilderExample [

	| myNewClass obj1 obj2 result |
	myNewClass := (Object << #MyNonInstalledClass)
		              slots: {  };
		              tag: 'BugCollection-Tests';
		              package: 'Seeker';
		              build.
	myNewClass compile: '+ anObject
		^ #aResultOf+'.
	obj1 := myNewClass new.
	obj2 := myNewClass new.
	result := obj1 + obj2
]
