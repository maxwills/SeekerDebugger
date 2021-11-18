Class {
	#name : #AutoRow,
	#superclass : #AutoType,
	#instVars : [
		'width'
	],
	#category : #'Seeker-Data'
}

{ #category : #'instance creation' }
AutoRow >> newWith [

	"The first time this is executed, it will create a class builder that will being listening for setter to define the type, until endWith is called, which will return an instance of the new defined class.
The second time and forth, it will immediately return a new instance of the already defined class (whose endWith method is equivalent to #yourself)
See AutoRowBuilder for more info.
"

	^ type ifNotNil: [ type new ] ifNil: [ AutoRowBuilder newFor: self ]
]

{ #category : #'as yet unclassified' }
AutoRow >> xsCol [

	"in the instance side, this does nothing"

	^ self
]
