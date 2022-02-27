Class {
	#name : #TownEventLoggerUtil,
	#superclass : #Object,
	#classInstVars : [
		'loggedMessages',
		'enabled'
	],
	#category : #'Seeker-Presentation'
}

{ #category : #logging }
TownEventLoggerUtil class >> clear [

	enabled ifFalse: [ ^ self ].
	[ 
	UIManager default defer: [ 
		Transcript clear.
		loggedMessages removeAll ] ] fork
]

{ #category : #initialization }
TownEventLoggerUtil class >> initialize [

	loggedMessages := OrderedCollection new.
	enabled := true.
]

{ #category : #logging }
TownEventLoggerUtil class >> log: aString [
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
TownEventLoggerUtil class >> makeDisabled [

	<script>
	enabled := false.
	self inform: 'Logger disabled'
]

{ #category : #'as yet unclassified' }
TownEventLoggerUtil class >> makeEnabled [

	<script>
	enabled := true.
	self inform: 'Logger enabled'
]
