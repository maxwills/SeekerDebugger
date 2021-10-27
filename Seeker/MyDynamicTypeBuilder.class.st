Class {
	#name : #MyDynamicTypeBuilder,
	#superclass : #ProtoObject,
	#instVars : [
		'fields'
	],
	#category : #'Seeker-QueryData'
}

{ #category : #'as yet unclassified' }
MyDynamicTypeBuilder >> createAccessorsForField: aSymbol inClass: aClass [

	"getter"

	aClass compile: aSymbol , ' 
	^ ' , aSymbol.
	"setter"
	aClass compile: aSymbol , ': anObject 
	' , aSymbol , ' := anObject'
]

{ #category : #'reflective operations' }
MyDynamicTypeBuilder >> doesNotUnderstand: aMessage [

	| selector |
	selector := aMessage selector.
	aMessage arguments size = 0 ifTrue: [ fields add: selector ].
]

{ #category : #'as yet unclassified' }
MyDynamicTypeBuilder >> endNewType [

	"this builds the class and return it"

	| newClass |
	newClass := (Object << #AnonymousTypeX)
		            slots: fields;
		            tag: '';
		            sharedVariables: { #fields };
		            package: '';
		            "I also need to create the setters and getters"build.
	fields do: [ :each | 
		self createAccessorsForField: each inClass: newClass ].
	newClass writeClassVariableNamed: #fields value: fields.
	newClass compile: 'keysDo: aBlock
	fields do: [ :each | aBlock value: each ]'.
	newClass compile: 'at: anObject
	^self readSlotNamed: anObject'.
	newClass class compile: 'fields
	^ fields'.
	^ newClass
]

{ #category : #'as yet unclassified' }
MyDynamicTypeBuilder >> endWith [

	^ self endNewType 
]

{ #category : #initialization }
MyDynamicTypeBuilder >> initialize [

	fields := OrderedCollection new
]
