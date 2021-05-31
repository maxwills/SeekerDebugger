Class {
	#name : #SkAllInstanceCreationsOfClassLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkAllInstanceCreationsOfClassLC >> description [

	^'MyCommand description'
]

{ #category : #executing }
SkAllInstanceCreationsOfClassLC >> executeCommand [

	self showResult:
		self tracer find allInstanceCreationsOfClassNamedAsSelectedCode
			asSeekerResultsCollection forInstancesCreation
]

{ #category : #accessing }
SkAllInstanceCreationsOfClassLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkAllInstanceCreationsOfClassLC >> name [

	^'All Instances Creation of Class named as selection'
]
