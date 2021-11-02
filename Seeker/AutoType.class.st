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

{ #category : #accessing }
AutoType >> newWith [

	"The first time this is executed, it will create a class builder that will being listening for setter to define the type, until endWith is called, which will return an instance of the new defined class.
The second time and forth, it will immediately return a new instance of the already defined class (whose endWith method is equivalent to #yourself)
See AutoTypeBuild for more info.
"

	^ type ifNotNil: [ type new ] ifNil: [ AutoTypeBuilder newFor: self ]
]

{ #category : #accessing }
AutoType >> type [

	^ type
]

{ #category : #accessing }
AutoType >> type: anObject [

	type := anObject
]
