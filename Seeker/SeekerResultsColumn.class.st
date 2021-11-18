"
Base column class. The returned value is the same read from the model object. Use this for String fields (ie, when there is no need to convert). If a conversion to String is needed, use the corresponding subclass.
"
Class {
	#name : #SeekerResultsColumn,
	#superclass : #Object,
	#instVars : [
		'key',
		'valueProjectionBlock',
		'label',
		'expandable',
		'width'
	],
	#category : #'Seeker-UI'
}

{ #category : #'as yet unclassified' }
SeekerResultsColumn class >> colWidthUnit [

	^ 60
]

{ #category : #'as yet unclassified' }
SeekerResultsColumn >> bc [

	"makes the column width of bytecode column"

	self width: 70.
	self expandable: false.
	^ self
]

{ #category : #accessing }
SeekerResultsColumn >> expandable [

	^ expandable
]

{ #category : #accessing }
SeekerResultsColumn >> expandable: anObject [

	expandable := anObject
]

{ #category : #initialization }
SeekerResultsColumn >> initialize [

	width := 80.
	expandable := false
]

{ #category : #accessing }
SeekerResultsColumn >> key [

	^ key
]

{ #category : #accessing }
SeekerResultsColumn >> key: anObject [

	key := anObject
]

{ #category : #accessing }
SeekerResultsColumn >> label [

	label ifNil: [ ^ key ] ifNotNil: [ ^ label ]
]

{ #category : #accessing }
SeekerResultsColumn >> label: aString [

	label := aString
]

{ #category : #'as yet unclassified' }
SeekerResultsColumn >> lg [
	"makes the column large"
	self width: self class colWidthUnit *4.
	self expandable: false.
	^ self
]

{ #category : #'as yet unclassified' }
SeekerResultsColumn >> md [

	"makes the column medium"

	self width: self class colWidthUnit * 3.
	self expandable: false.
	^ self
]

{ #category : #'as yet unclassified' }
SeekerResultsColumn >> sm [

	"makes the column small"

	self width: self class colWidthUnit * 2.
	self expandable: false.
	^ self
]

{ #category : #accessing }
SeekerResultsColumn >> value: aRow [

	"Row is an object that responds to the key message"

	^ aRow perform: #key
]

{ #category : #accessing }
SeekerResultsColumn >> width [

	^ width
]

{ #category : #accessing }
SeekerResultsColumn >> width: anObject [

	width := anObject
]

{ #category : #'as yet unclassified' }
SeekerResultsColumn >> xl [

	"makes the column large"

	self width: self class colWidthUnit * 5.
	self expandable: false.
	^ self
]

{ #category : #'as yet unclassified' }
SeekerResultsColumn >> xp [

	"makes the column expandable"

	self expandable: true.
	^ self
]

{ #category : #'as yet unclassified' }
SeekerResultsColumn >> xs [

	"makes the column extra small"

	self width: self class colWidthUnit * 1.
	self expandable: false.
	^ self
]
