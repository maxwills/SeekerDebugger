Class {
	#name : #SkAnonymousType,
	#superclass : #Object,
	#instVars : [
		'privateFields'
	],
	#category : #'Seeker-Components-Experimental'
}

{ #category : #'instance creation' }
SkAnonymousType class >> newWith: anAssocArray [
|annonymousObj|
annonymousObj := self new.
annonymousObj privateFields: anAssocArray asDictionary.
^annonymousObj 
]

{ #category : #operations }
SkAnonymousType >> @ aSymbol [
	^privateFields at: aSymbol
]

{ #category : #accessing }
SkAnonymousType >> at: aSymbol put: aValue [

	^ privateFields at: aSymbol put: aValue
]

{ #category : #'reflective operations' }
SkAnonymousType >> doesNotUnderstand: aMessage [

	| selector |
	"Inspired from the pillar bug image from thomas"
	selector := aMessage selector.
	^ [ aMessage arguments size ] switchCase: { 
			  (0 -> [ "this is a getter" privateFields at: selector ]).
			  (1 -> [ "a setter"
			   | selectorForGetter |
			   selectorForGetter := selector copyFrom: 1 to: selector size - 1.
			   privateFields
				   at: selectorForGetter
				   put: (aMessage arguments at: 1) ]).
			  (#defaultCase -> [ 
			   self error:
				   'AnonymousTypes interface is composed only by getters (0 arguments) and setters (1 argument)' ]) }
]

{ #category : #accessing }
SkAnonymousType >> fieldNames [

	^ privateFields keys
]

{ #category : #operations }
SkAnonymousType >> mergeWith: anotherAnonymousTypeObject [

	"The second anonymous objects takes priority on its values"

	anotherAnonymousTypeObject privateFields keysDo: [ :eachKey | 
		privateFields
			at: eachKey
			put: (anotherAnonymousTypeObject privateFields at: eachKey) ].
	^ self
]

{ #category : #printing }
SkAnonymousType >> printOn: aStream [

	| keys |
	keys := privateFields keys.
	keys ifEmpty: [ ^ aStream nextPutAll: '-' ].
	1 to: keys size do: [ :keyIndex | 
		| key value |
		key := keys at: keyIndex.
		value := privateFields at: key.
		aStream
			nextPutAll: key asString;
			nextPutAll: ': ';
			nextPutAll: value asString.
		keyIndex = keys size ifFalse: [ "I am sure there is better code for this" 
			aStream nextPutAll: ' | ' ] ]
]

{ #category : #accessing }
SkAnonymousType >> privateFields [

	^ privateFields
]

{ #category : #accessing }
SkAnonymousType >> privateFields: anObject [

	privateFields := anObject
]

{ #category : #'as yet unclassified' }
SkAnonymousType >> tryInPrivateFieldOrDelegateForGetter: getterSelector [

	(privateFields includesKey: getterSelector) ifTrue: [ 
		^ privateFields at: getterSelector ].
	^ self perform: getterSelector
]

{ #category : #'as yet unclassified' }
SkAnonymousType >> tryInPrivateFieldOrDelegateForSetter: setterSelector argument: arg [

	| selectorForGetter |
	selectorForGetter := setterSelector
		                     copyFrom: 1
		                     to: setterSelector size - 1.
	(privateFields includesKey: selectorForGetter) ifTrue: [ 
		^ privateFields at: selectorForGetter put: arg ].


	^ self perform: setterSelector with: arg
]

{ #category : #accessing }
SkAnonymousType >> value [

	"Override so the selector can be used in the anonymousObject as a field"
	"Just try to avoid overriding critical methods (initialize, error, etc)"

	^ self tryInPrivateFieldOrDelegateForGetter:
		  thisContext methodSelector
]

{ #category : #accessing }
SkAnonymousType >> value: anObject [

	"Override (not really)so the selector can be used in the anonymousObject"

	"value: doesn't exist in Object, but a setter's selector is needed to be freed so it can be used as a field, then copy this example"

	^ self
		  tryInPrivateFieldOrDelegateForSetter: thisContext methodSelector
		  argument: anObject
]
