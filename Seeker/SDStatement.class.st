Class {
	#name : #SDStatement,
	#superclass : #Object,
	#instVars : [
		'statementStaticID',
		'astNode'
	],
	#category : #Seeker
}

{ #category : #'instance creation' }
SDStatement class >> newFrom: anAstNode [

	^ self
]
