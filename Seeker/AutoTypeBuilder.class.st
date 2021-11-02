Class {
	#name : #AutoTypeBuilder,
	#superclass : #Object,
	#instVars : [
		'type',
		'fields',
		'assignments',
		'autoType'
	],
	#category : #'Seeker-QueryData'
}

{ #category : #'instance creation' }
AutoTypeBuilder class >> newFor: autoType [

	^ self new
		  autoType: autoType;
		  yourself
]

{ #category : #accessing }
AutoTypeBuilder >> autoType [

	^ autoType
]

{ #category : #accessing }
AutoTypeBuilder >> autoType: anObject [

	autoType := anObject
]

{ #category : #'as yet unclassified' }
AutoTypeBuilder >> createAccessorsForField: aSymbol inClass: aClass [

	"getter"

	aClass compile: aSymbol , ' 
	^ ' , aSymbol.
	"setter"
	aClass compile: aSymbol , ': anObject 
	' , aSymbol , ' := anObject'
]

{ #category : #'as yet unclassified' }
AutoTypeBuilder >> doPendingAssignmentsOn: anObject [

	assignments do: [ :each | 
		| selector arg |
		selector := each at: 1.
		arg := each at: 2.
		anObject perform: selector with: arg ].
	^ anObject
]

{ #category : #'reflective operations' }
AutoTypeBuilder >> doesNotUnderstand: aMessage [

	| selector |
	selector := aMessage selector.
	aMessage arguments size = 0
		ifTrue: [ fields add: selector ]
		ifFalse: [ 
			| field pendingAssignment |
			field := (selector copyFrom: 1 to: selector size - 1) asSymbol.
			pendingAssignment := { 
				                     selector.
				                     aMessage argument }.
			assignments add: pendingAssignment.
			fields add: field ]
]

{ #category : #'as yet unclassified' }
AutoTypeBuilder >> endNewType [

	"this builds the class and return it"

	EpMonitor disableDuring: [ 
		| newClass |
		newClass := (Object << #AnonymousTypeX)
			            slots: fields;
			            tag: '';
			            sharedVariables: { #fields };
			            package: '';
			            build.
		fields do: [ :each | 
			self createAccessorsForField: each inClass: newClass ].
		newClass writeClassVariableNamed: #fields value: fields.
		newClass compile: 'keysDo: aBlock
	fields do: [ :each | aBlock value: each ]'.
		newClass compile: 'at: anObject
	^self readSlotNamed: anObject'.
		newClass compile: 'endWith
	^self'.
		newClass class compile: 'fields
	^ fields'.
		^ newClass ]
]

{ #category : #'as yet unclassified' }
AutoTypeBuilder >> endWith [

	type := self endNewType.
	autoType type: type. "without this, the code would be always calling the builder, which is super slow"
	^ self doPendingAssignmentsOn: type new
]

{ #category : #initialization }
AutoTypeBuilder >> initialize [

	fields := OrderedCollection new.
	assignments := OrderedCollection new
]

{ #category : #'instance creation' }
AutoTypeBuilder >> with: aBlock [
"executes the block. The block has already a reference to self"
]
