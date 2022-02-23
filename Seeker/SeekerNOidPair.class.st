Class {
	#name : #SeekerNOidPair,
	#superclass : #Object,
	#instVars : [
		'seeker',
		'oid'
	],
	#category : #'Seeker-Helpers'
}

{ #category : #cleaning }
SeekerNOidPair >> clean [

	seeker := nil.
	oid := nil
]

{ #category : #accessing }
SeekerNOidPair >> oid [

	^ oid
]

{ #category : #accessing }
SeekerNOidPair >> oid: anObject [

	oid := anObject
]

{ #category : #accessing }
SeekerNOidPair >> seeker [

	^ seeker
]

{ #category : #accessing }
SeekerNOidPair >> seeker: anObject [

	seeker := anObject
]
