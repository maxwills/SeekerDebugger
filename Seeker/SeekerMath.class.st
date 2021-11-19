Class {
	#name : #SeekerMath,
	#superclass : #Object,
	#category : #'Seeker-Helpers'
}

{ #category : #public }
SeekerMath class >> clampedInverseLerp: t a: a b: b [

	"inverseLerp: 1 a:0 b:2 returns 0.5. Result clamped to [0-1]"

	^ (self inverseLerp: t a: a b: b) min: 1 max: 0
]

{ #category : #public }
SeekerMath class >> clampedLerp: t a: a b: b [

	^ (self lerp: t a: a b: b) min: b max: a
]

{ #category : #public }
SeekerMath class >> inverseLerp: t a: a b: b [

	"inverseLerp: 1 a:0 b:2 returns 0.5"

	^ (t - a) / (b - a )
]

{ #category : #public }
SeekerMath class >> lerp: t a: a b: b [

	^ a + (t * (b - a))
]
