Class {
	#name : #SeekerAndOidPair,
	#superclass : #Object,
	#instVars : [
		'seeker',
		'oid'
	],
	#category : #'Seeker-Helpers'
}

{ #category : #cleaning }
SeekerAndOidPair >> clean [

	seeker := nil.
	oid := nil
]

{ #category : #accessing }
SeekerAndOidPair >> oid [

	^ oid
]

{ #category : #accessing }
SeekerAndOidPair >> oid: anObject [

	oid := anObject
]

{ #category : #accessing }
SeekerAndOidPair >> seeker [

	^ seeker
]

{ #category : #accessing }
SeekerAndOidPair >> seeker: anObject [

	seeker := anObject
]
