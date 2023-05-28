Class {
	#name : #ColumnDefinition,
	#superclass : #Object,
	#instVars : [
		'key',
		'label',
		'width',
		'expandable'
	],
	#classInstVars : [
		'shouldLog'
	],
	#category : #'Seeker-UI'
}

{ #category : #'instance creation' }
ColumnDefinition class >> newCollectionForKeys: aCollection [

	^ aCollection collect: [ :each | self newForKey: each ]
]

{ #category : #'instance creation' }
ColumnDefinition class >> newForKey: aSymbol [
	"This might be an overkill. The method compiled is used only for the view, and I thing that little is 'optimized' by creating this anonymous class instead of just storing the selector and call a perform primitive."

	"Dropped the runtime compilation approach, because there is little to gain and is hard to maintain"

	| col |
	"EpMonitor disableDuring: [
		colClass := (self << #AnonymousColumnDefinitionX)
			            slots: {  };
			            tag: 'Data';
			            package: 'Seeker';
			            build.

		colClass compileSecretly: 'readValueIn: anObject
	^ anObject ' , aSymbol.
		col := colClass basicNew
			       initialize;
			       yourself."
	col := self new.
	col privateKey: aSymbol.
	col label: aSymbol.
	^ col "]"
]

{ #category : #'as yet unclassified' }
ColumnDefinition class >> unitWidth [

	^ 60
]

{ #category : #'as yet unclassified' }
ColumnDefinition >> bc [

	"makes the column width of bytecode column"

	self width: 70.
	self expandable: false.
	^ self
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

	^ anObject perform: key
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
