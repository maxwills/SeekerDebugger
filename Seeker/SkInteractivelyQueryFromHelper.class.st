Class {
	#name : #SkInteractivelyQueryFromHelper,
	#superclass : #Object,
	#category : #'Seeker-Helpers'
}

{ #category : #'as yet unclassified' }
SkInteractivelyQueryFromHelper class >> requestClassName [

	^ self
		  requestSymbolInput: 'Enter class name:'
		  initialAnswer: 'MyClass'
		  title: 'Enter class name'
]

{ #category : #'as yet unclassified' }
SkInteractivelyQueryFromHelper class >> requestInput: message initialAnswer: initialAnswer title: title [

	^ UIManager default
		  request: message
		  initialAnswer: initialAnswer
		  title: title
]

{ #category : #'as yet unclassified' }
SkInteractivelyQueryFromHelper class >> requestNumberInput: message initialAnswer: initialAnswer title: title [
	"request user input, and test it for number. If not a number returns nil"

	| input |
	input := self
		         requestInput: message
		         initialAnswer: initialAnswer
		         title: title.
	[ ^ input asNumber ] onErrorDo: [ :e | ^ nil ]
]

{ #category : #'as yet unclassified' }
SkInteractivelyQueryFromHelper class >> requestOID [

	^ self
		  requestNumberInput: 'Enter object oid:'
		  initialAnswer: 'aNumber'
		  title: 'OID'
]

{ #category : #'as yet unclassified' }
SkInteractivelyQueryFromHelper class >> requestSelector [

	^ self
		  requestSymbolInput: 'Enter selector:'
		  initialAnswer: 'mySelector'
		  title: 'Enter selector'
]

{ #category : #'as yet unclassified' }
SkInteractivelyQueryFromHelper class >> requestSymbolInput: message initialAnswer: initialAnswer title: title [
	"request user input, returns a Symbol or nil"

	| input |
	input := self
		         requestInput: message
		         initialAnswer: initialAnswer
		         title: title.
	[
	input := input copyReplaceAll: '#' with: ''.
	^ input asSymbol ] onErrorDo: [ :e | ^ nil ]
]

{ #category : #'as yet unclassified' }
SkInteractivelyQueryFromHelper class >> requestVariableName [

	^ self
		  requestSymbolInput: 'Enter variable name:'
		  initialAnswer: 'variableName'
		  title: 'Variable Name'
]
