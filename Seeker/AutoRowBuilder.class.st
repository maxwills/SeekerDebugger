Class {
	#name : #AutoRowBuilder,
	#superclass : #AutoTypeBuilder,
	#instVars : [
		'nextWidth',
		'columns'
	],
	#category : #'Seeker-Data'
}

{ #category : #'as yet unclassified' }
AutoRowBuilder >> buildClass [

	EpMonitor disableDuring: [ 
		| newClass |
		newClass := super buildClass.
		newClass addClassVarNamed: #columnWidths.
		newClass writeClassVariableNamed: #columns value: columns.
		newClass class compile: 'columns
	^ columns'.
		^ newClass ]
]

{ #category : #'reflective operations' }
AutoRowBuilder >> doesNotUnderstand: aMessage [

	| field |
	super doesNotUnderstand: aMessage.
	field := fields last.
	columns add: (ColumnDefinition new
			 name: field;
			 label: field;
			 width: nextWidth;
			 yourself).
	^ self
]

{ #category : #initialization }
AutoRowBuilder >> initialize [

	columns := OrderedCollection new.
	nextWidth := #md.
	^ super initialize
]

{ #category : #'as yet unclassified' }
AutoRowBuilder >> lgCol [

	nextWidth := #lg.
	^ self
]

{ #category : #'as yet unclassified' }
AutoRowBuilder >> mdCol [

	nextWidth := #md.
	^ self
]

{ #category : #'as yet unclassified' }
AutoRowBuilder >> smCol [

	nextWidth := #sm.
	^ self
]

{ #category : #'as yet unclassified' }
AutoRowBuilder >> xlCol [

	nextWidth := #xl.
	^ self
]

{ #category : #'as yet unclassified' }
AutoRowBuilder >> xsCol [

	nextWidth := #xs.
	^ self
]
