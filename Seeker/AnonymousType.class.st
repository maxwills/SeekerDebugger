"
Used for cases when objects require a given setter/getter interface. Useful for mocking.

Wraps a dictionary and allows the wrapper object to reply to messages with selectors defined by the dictionary keys. The keys should be mandatory symbols.

See AnonymousTypeTest class tests for examples.
"
Class {
	#name : #AnonymousType,
	#superclass : #Dictionary,
	#category : #'Seeker-QueryData'
}

{ #category : #'instance creation' }
AnonymousType class >> newWith: aCollection [

	"Instantiates an anonymousType object that wraps the collection"

	| anonymousObj |
	anonymousObj := self new.
	anonymousObj mergeWith: aCollection asDictionary.
	^ anonymousObj
]

{ #category : #operations }
AnonymousType >> @ aSymbol [
	^self at: aSymbol
]

{ #category : #'as yet unclassified' }
AnonymousType >> asCsvPrintOn: aStream [

	| keys |
	aStream ifNil: [ ^ self ].
	keys := self keys asSortedCollection.
	keys ifEmpty: [ 
		^ aStream
			  nextPutAll: '-';
			  nextPutAll: String cr ].
	1 to: keys size do: [ :keyIndex | 
		| value |
		value := self at: (keys at: keyIndex).
		value ifNil: [ value := '' ].
		aStream nextPutAll: value asString.
		keyIndex = keys size ifFalse: [ "I am sure there is better code for this" 
			aStream nextPutAll: ';' ] ].
	aStream nextPutAll: String cr
]

{ #category : #'reflective operations' }
AnonymousType >> doesNotUnderstand: aMessage [

	| selector |
	selector := aMessage selector.
	^ [ aMessage arguments size ] switchCase: { 
			  (0 -> [ "this is a getter" self at: selector ]).
			  (1 -> [ "a setter"
			   | selectorForGetter |
			   selectorForGetter := selector copyFrom: 1 to: selector size - 1.
			   self at: selectorForGetter put: (aMessage arguments at: 1) ]).
			  (#defaultCase -> [ 
			   self error:
				   'AnonymousTypes interface is composed only by getters (0 arguments) and setters (1 argument)' ]) }
]

{ #category : #accessing }
AnonymousType >> fieldNames [

	^ self keys
]

{ #category : #'as yet unclassified' }
AnonymousType >> headersAsCsvPrintOn: aStream [

	| keys |
	aStream ifNil: [ ^ self ].
	keys := self keys asSortedCollection.
	keys ifEmpty: [ 
		^ aStream
			  nextPutAll: '-';
			  nextPutAll: String cr ].
	1 to: keys size do: [ :keyIndex | 
		| key |
		key := keys at: keyIndex.
		aStream nextPutAll: key asString.
		keyIndex = keys size ifFalse: [ "I am sure there is better code for this" 
			aStream nextPutAll: ';' ] ].
	aStream nextPutAll: String cr
]

{ #category : #operations }
AnonymousType >> mergeWith: anotherAnonymousTypeObject [

	"The second anonymous objects takes priority on its values"

	anotherAnonymousTypeObject keysDo: [ :eachKey | 
		self
			at: eachKey
			put: (anotherAnonymousTypeObject at: eachKey) ].
	^ self
]

{ #category : #printing }
AnonymousType >> printOn: aStream [

	| keys |
	keys := self keys.
	keys ifEmpty: [ ^ aStream nextPutAll: '-' ].
	1 to: keys size do: [ :keyIndex | 
		| key value |
		key := keys at: keyIndex.
		value := self at: key.
		aStream
			nextPutAll: key asString;
			nextPutAll: ': ';
			
			nextPutAll: (value ifNil:[''] ifNotNil:[value asString]).
		keyIndex = keys size ifFalse: [ "I am sure there is better code for this" 
			aStream nextPutAll: ' | ' ] ]
]

{ #category : #'as yet unclassified' }
AnonymousType >> tryInPrivateFieldOrDelegateForGetter: getterSelector [

	(self includesKey: getterSelector) ifTrue: [ 
		^ self at: getterSelector ].
	^ self perform: getterSelector
]

{ #category : #'as yet unclassified' }
AnonymousType >> tryInPrivateFieldOrDelegateForSetter: setterSelector argument: arg [

	| selectorForGetter |
	selectorForGetter := setterSelector
		                     copyFrom: 1
		                     to: setterSelector size - 1.
	(self includesKey: selectorForGetter) ifTrue: [ 
		^ self at: selectorForGetter put: arg ].


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
