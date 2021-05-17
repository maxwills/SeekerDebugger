"
Used for cases when objects require a given setter/getter interface. Useful for mocking.

Wraps a dictionary and allows the wrapper object to reply to messages with selectors defined by the dictionary keys. The keys should be mandatory symbols.

See AnonymousTypeTest class tests for examples.
"
Class {
	#name : #AnonymousType,
	#superclass : #Object,
	#instVars : [
		'privateFields'
	],
	#category : #'Seeker-Components-Experimental'
}

{ #category : #'instance creation' }
AnonymousType class >> newWith: aCollection [

	"Instantiates an anonymousType object that wraps the collection"

	| anonymousObj |
	anonymousObj := self new.
	anonymousObj privateFields: aCollection asDictionary.
	^ anonymousObj
]

{ #category : #operations }
AnonymousType >> @ aSymbol [
	^privateFields at: aSymbol
]

{ #category : #'as yet unclassified' }
AnonymousType >> asCsvPrintOn: aStream [

	| keys |
	keys := privateFields keys asSortedCollection.
	keys ifEmpty: [ ^ aStream nextPutAll: '-' ].
	1 to: keys size do: [ :keyIndex | 
		| value |
		value := privateFields at: (keys at: keyIndex).
		aStream nextPutAll: value asString.
		keyIndex = keys size ifFalse: [ "I am sure there is better code for this" 
			aStream nextPutAll: ';' ] ].
	aStream nextPutAll: String cr
]

{ #category : #accessing }
AnonymousType >> at: aSymbol put: aValue [

	^ privateFields at: aSymbol put: aValue
]

{ #category : #'reflective operations' }
AnonymousType >> doesNotUnderstand: aMessage [

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
AnonymousType >> fieldNames [

	^ privateFields keys
]

{ #category : #'as yet unclassified' }
AnonymousType >> headersAsCsvPrintOn: aStream [

	| keys |
	keys := privateFields keys asSortedCollection.
	keys ifEmpty: [ ^ aStream nextPutAll: '-' ].
	1 to: keys size do: [ :keyIndex | 
		| key |
		key := keys at: keyIndex.
		aStream nextPutAll: key asString.
		keyIndex = keys size ifFalse: [ "I am sure there is better code for this" 
			aStream nextPutAll: ';' ] ].
	aStream nextPutAll: String cr
]

{ #category : #initialization }
AnonymousType >> initialize [

]

{ #category : #operations }
AnonymousType >> mergeWith: anotherAnonymousTypeObject [

	"The second anonymous objects takes priority on its values"

	anotherAnonymousTypeObject privateFields keysDo: [ :eachKey | 
		privateFields
			at: eachKey
			put: (anotherAnonymousTypeObject privateFields at: eachKey) ].
	^ self
]

{ #category : #printing }
AnonymousType >> printOn: aStream [

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
AnonymousType >> privateFields [

	^ privateFields
]

{ #category : #accessing }
AnonymousType >> privateFields: anObject [

	privateFields := anObject
]

{ #category : #'as yet unclassified' }
AnonymousType >> tryInPrivateFieldOrDelegateForGetter: getterSelector [

	(privateFields includesKey: getterSelector) ifTrue: [ 
		^ privateFields at: getterSelector ].
	^ self perform: getterSelector
]

{ #category : #'as yet unclassified' }
AnonymousType >> tryInPrivateFieldOrDelegateForSetter: setterSelector argument: arg [

	| selectorForGetter |
	selectorForGetter := setterSelector
		                     copyFrom: 1
		                     to: setterSelector size - 1.
	(privateFields includesKey: selectorForGetter) ifTrue: [ 
		^ privateFields at: selectorForGetter put: arg ].


	^ self perform: setterSelector with: arg
]

{ #category : #accessing }
AnonymousType >> value [

	"Override so the selector can be used in the anonymousObject as a field"
	"Just try to avoid overriding critical methods (initialize, error, etc)"

	^ self tryInPrivateFieldOrDelegateForGetter:
		  thisContext methodSelector
]

{ #category : #accessing }
AnonymousType >> value: anObject [

	"Override (not really)so the selector can be used in the anonymousObject"

	"value: doesn't exist in Object, but a setter's selector is needed to be freed so it can be used as a field, then copy this example"

	^ self
		  tryInPrivateFieldOrDelegateForSetter: thisContext methodSelector
		  argument: anObject
]
