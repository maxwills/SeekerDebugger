"
A SkObjectHelpersTest is a test class for testing the behavior of SkObjectHelpers
"
Class {
	#name : #SkObjectHelpersTest,
	#superclass : #TestCase,
	#category : #'Seeker-Tests-Helpers'
}

{ #category : #tests }
SkObjectHelpersTest >> testIsObjectSubclassOf [
|aCol|
aCol := OrderedCollection new.
	self assert: (SkObjectHelpers isObject: aCol subclassOf: Collection).
	self assert: (SkObjectHelpers isObject: aCol subclassOf: Object).
	self deny: (SkObjectHelpers isObject: aCol subclassOf: Number)
]
