Class {
	#name : #ColumnDefinition,
	#superclass : #Object,
	#instVars : [
		'key',
		'label',
		'width',
		'expandable'
	],
	#category : #'Seeker-Data'
}

{ #category : #'instance creation' }
ColumnDefinition class >> new [

	^ self error:
		  'This is an abstract class. Instances of subclasses can be created using the method newForKey:'
]

{ #category : #'instance creation' }
ColumnDefinition class >> newForKey: aSymbol [

	| col colClass |
	EpMonitor disableDuring: [ 
		colClass := (self << #AnonymousColumnDefinitionX)
			            slots: {  };
			            tag: 'Data';
			            package: 'Seeker';
			            build.

		colClass compile: 'readValueIn: anObject
	^ anObject ' , aSymbol.
		col := colClass basicNew
			       initialize;
			       yourself.
		col privateKey: aSymbol.
		col label: aSymbol.
		^ col ]
]

{ #category : #'as yet unclassified' }
ColumnDefinition class >> unitWidth [

	^ 60
]

{ #category : #accessing }
ColumnDefinition >> expandable [

	^ expandable
]

{ #category : #accessing }
ColumnDefinition >> expandable: anObject [

	expandable := anObject
]

{ #category : #initialization }
ColumnDefinition >> initialize [

	expandable := false.
	self md
]

{ #category : #accessing }
ColumnDefinition >> key [

	^ key
]

{ #category : #accessing }
ColumnDefinition >> label [

	^ label
]

{ #category : #accessing }
ColumnDefinition >> label: anObject [

	label := anObject
]

{ #category : #styling }
ColumnDefinition >> lg [

	"makes the column large"

	self width: self class unitWidth * 4.
	self expandable: false.
	^ self
]

{ #category : #styling }
ColumnDefinition >> md [

	"makes the column medium"

	self width: self class unitWidth * 3.
	self expandable: false.
	^ self
]

{ #category : #accessing }
ColumnDefinition >> privateKey: anObject [

	"Dont call this. Only used by the ColumnDefinition instantiation routine (ColumnDefinition newForKey:)."

	key := anObject
]

{ #category : #'as yet unclassified' }
ColumnDefinition >> readValueIn: anObject [

	"this method is automatically overwritten by AnonymousColumnDefinitionX"

	"executes the getter for an attribute with the same name as key, of anObject.
	^ anObject <key>.
	"

	^ self subclassResponsibility
]

{ #category : #styling }
ColumnDefinition >> sm [

	"makes the column small"

	self width: self class unitWidth * 2.
	self expandable: false.
	^ self
]

{ #category : #accessing }
ColumnDefinition >> width [

	^ width
]

{ #category : #accessing }
ColumnDefinition >> width: anObject [

	width := anObject
]

{ #category : #styling }
ColumnDefinition >> xl [

	"makes the column extra large"

	self width: self class unitWidth * 5.
	self expandable: false.
	^ self
]

{ #category : #styling }
ColumnDefinition >> xs [

	"makes the column extra small"

	self width: self class unitWidth * 1.
	self expandable: false.
	^ self
]
