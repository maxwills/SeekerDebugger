Class {
	#name : #MyLoggerUtil,
	#superclass : #Object,
	#classInstVars : [
		'loggedMessages',
		'enabled'
	],
	#category : #'Seeker-Presentation'
}

{ #category : #logging }
MyLoggerUtil class >> clear [

	enabled ifFalse: [ ^ self ].
	[ 
	UIManager default defer: [ 
		Transcript clear.
		loggedMessages removeAll ] ] fork
]

{ #category : #'as yet unclassified' }
MyLoggerUtil class >> findArgumentsOfContextWithSelector: aSelector [

	| context found arguments |
	context := thisContext.
	arguments := nil.
	found := false.
	[ found not and: [ context isNotNil ] ] whileTrue: [ 
		context isBlockContext ifFalse: [ 
			context method selector = aSelector ifTrue: [ 
				found := true.
				arguments := context arguments ] ].
		context := context sender ].
	^ arguments
]

{ #category : #'as yet unclassified' }
MyLoggerUtil class >> findContextWithSelector: aSelector [

	| context found |
	context := thisContext.
	found := false.
	[ found not and: [ context isNotNil ] ] whileTrue: [ 
		context isBlockContext ifFalse: [ context method selector = aSelector ifTrue: [ found := true ] ].
		found ifFalse: [ context := context sender ] ].
	^ context
]

{ #category : #'as yet unclassified' }
MyLoggerUtil class >> getStringOfContextMethodFor: aContext andSenders: aNumber [

	aContext ifNil: [ ^ '' ].
	aNumber <= 0 ifTrue: [ ^ '' ].
	^   (self 
		  getStringOfContextMethodFor: aContext sender
		  andSenders: aNumber - 1), ' / ' , aContext method methodClass name , '>>#' , aContext method selector
]

{ #category : #initialization }
MyLoggerUtil class >> initialize [

	loggedMessages := OrderedCollection new.
	enabled := true.
]

{ #category : #logging }
MyLoggerUtil class >> log: aString [
	enabled ifFalse: [ ^self ].
	[ 
	UIManager default defer: [ 
		loggedMessages add: aString.
		(Transcript containingWindow isNil or: [ Transcript containingWindow isDisplayed not ]) ifTrue: [ 
			Transcript open ].
		Transcript
			show: aString;
			cr ] ] fork
]

{ #category : #'as yet unclassified' }
MyLoggerUtil class >> logTop3CallsInStack [

	self log: (self getStringOfContextMethodFor: thisContext sender andSenders: 3)
]

{ #category : #'as yet unclassified' }
MyLoggerUtil class >> logTopNCallsInStack: aNumber [

	self log: (self getStringOfContextMethodFor: thisContext sender andSenders: aNumber)
]

{ #category : #'as yet unclassified' }
MyLoggerUtil class >> makeDisabled [

	<script>
	enabled := false.
	self inform: 'Logger disabled'
]

{ #category : #'as yet unclassified' }
MyLoggerUtil class >> makeEnabled [

	<script>
	enabled := true.
	self inform: 'Logger enabled'
]
