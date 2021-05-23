Class {
	#name : #SkObjectHelpers,
	#superclass : #Object,
	#category : #'Seeker-Helpers'
}

{ #category : #testing }
SkObjectHelpers class >> isClass: aClass sameOrInheritsFrom: aParentClass [

	^ aClass == aParentClass or: [ aClass inheritsFrom: aParentClass ]
]

{ #category : #testing }
SkObjectHelpers class >> isObject: anObject subclassOf: aClass [
	|iterationClass|
	iterationClass := anObject class.
	(aClass = Object) ifTrue: [^true  ].
	[ iterationClass = Object] whileFalse: [ 
	(iterationClass = aClass) ifTrue: [ ^true ] ifFalse: [ iterationClass := iterationClass superclass ]
	 ].
^ false
]
