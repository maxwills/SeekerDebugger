Class {
	#name : #SkXInstantiationPrimitivesInstancesLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkXInstantiationPrimitivesInstancesLC >> description [

	^ self commonDescriptionIntroString
	  , 'for every assignment of any <variable> for delta query'
]

{ #category : #executing }
SkXInstantiationPrimitivesInstancesLC >> executeCommand [

	| res |
	res := self tracer find variablesWrittenForDeltaQuery
		       asSeekerResultsCollection "forAssignmentsOfAnyVariable".

	self showResult: res.
	"[ DSSeekerActionRecord for: self ]
		on: Error
		do: [ :e | DSSpy log: #ERROR key: #PROCEED ]"
]

{ #category : #accessing }
SkXInstantiationPrimitivesInstancesLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #changeUpdate
]

{ #category : #accessing }
SkXInstantiationPrimitivesInstancesLC >> name [

	^ 'Experiment Instantiation Primitive Query'
]
