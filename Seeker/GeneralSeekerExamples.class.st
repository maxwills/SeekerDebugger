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
	self assert: false
]
