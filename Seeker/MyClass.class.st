Class {
	#name : #MyClass,
	#superclass : #Object,
	#category : #'Seeker-Temp'
}

{ #category : #'as yet unclassified' }
MyClass >> methodA [

	| w |
	w := 1.
	^ w
]

{ #category : #'as yet unclassified' }
MyClass >> methodB [

	| x |
	x := 2.
	self methodC.
	^ x
]

{ #category : #'as yet unclassified' }
MyClass >> methodC [

	| y |
	y := 3.
	^ y
]

{ #category : #'as yet unclassified' }
MyClass >> methodD [

	| z |
	z := 4.
	^ z
]
