"
A class builder that is used to automatically generate a class from a ""setter expression"".

auto := AutoType new.

""Creates a new auto type builder"".

item := auto newWith: [:x| x name: 'asd';  age: 21]

The first time newWith is executed, it will use the builder to define the class, then it will return the new class with the assigned values. This means that the ""setter expression"" is executed twice.
After the first time, it will directly create a new instance of the auto defined class.
"
Class {
	#name : #AutoType,
	#superclass : #Object,
	#instVars : [
		'type'
	],
	#category : #'Seeker-QueryData'
}

{ #category : #'instance creation' }
AutoType >> new [

	"The first time this is executed, it will return a class builder that uses the with: method to define the class,.
Therefore, it is the with: method that will return the new instance. the second time and forth, it will return a new instance of the auto defined class.
"

	^ type ifNil: [ AutoTypeBuilder new ] ifNotNil: [ type new ]
]

{ #category : #accessing }
AutoType >> type [

	^ type
]

{ #category : #accessing }
AutoType >> type: anObject [

	type := anObject
]

{ #category : #accessing }
AutoType >> with [

	"returns a class builder. The class definition finished when the endWith method of the builder is called"

	^ type
		  ifNotNil: [ type new ]
		  ifNil: [ AutoTypeBuilder newFor: self ]
]
