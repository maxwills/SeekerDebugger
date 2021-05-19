Class {
	#name : #SkXTrace,
	#superclass : #Object,
	#instVars : [
		'stepIndex'
	],
	#category : #'Seeker-Experimental'
}

{ #category : #converting }
SkXTrace >> asSeekerOfflineExpressionString [

	^ '[#trace @ ' , stepIndex asString , ']'
]

{ #category : #accessing }
SkXTrace >> stepIndex [

	^ stepIndex
]

{ #category : #accessing }
SkXTrace >> stepIndex: anObject [

	stepIndex := anObject
]
