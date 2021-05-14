Class {
	#name : #SkNew,
	#superclass : #Object,
	#category : #'Seeker-Components-Experimental'
}

{ #category : #'instance creation' }
SkNew class >> with: array [

	"Just an experimental short cut for anonymous types"

	^ SkAnonymousType newWith: array
]
