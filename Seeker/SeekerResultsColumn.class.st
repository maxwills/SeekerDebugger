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
	#category : #'Seeker-DataQuery'
}

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

	valueProjectionBlock := [ :a | "override this if there is a special need" 
	                        a asString ].
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

{ #category : #accessing }
SeekerResultsColumn >> value: aRow [

	"Row is an object that responds to the key message"

	^ valueProjectionBlock value: (aRow at: key)
]

{ #category : #accessing }
SeekerResultsColumn >> valueProjectionBlock [

	^ valueProjectionBlock
]

{ #category : #accessing }
SeekerResultsColumn >> valueProjectionBlock: anObject [

	valueProjectionBlock := anObject
]

{ #category : #accessing }
SeekerResultsColumn >> width [

	^ width
]

{ #category : #accessing }
SeekerResultsColumn >> width: anObject [

	width := anObject
]
