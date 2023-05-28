Class {
	#name : #TtdValidationProgram,
	#superclass : #Object,
	#instVars : [
		'global'
	],
	#category : #'Seeker-Tests-ECU'
}

{ #category : #accessing }
TtdValidationProgram class >> firstMarker [

]

{ #category : #'as yet unclassified' }
TtdValidationProgram class >> runWithGlobal: global [
|localVar randomNumber set obj number|
"stage 1: increment local and global vars"
localVar:=1.
localVar :=localVar + 1.
global val: global val + 1.
self firstMarker.
randomNumber := SharedRandom globalGenerator nextInteger:9999.
"Stage 2: increment by random (syscall)"
localVar:= localVar + randomNumber.
global val: global val + randomNumber.
self secondMarker.
"Stage 3: identity hashes nds"
obj := Object new.
set := IdentitySet new.
1 to: 100 do: [ :i| set add: Object new ].
set add: obj.
number:=set asArray indexOf: obj.
self thirdMarker.
"Stage 4: incrementing the variables by the nds index"
localVar := localVar + number.
global val: global val + number.
^{localVar . global }
]

{ #category : #accessing }
TtdValidationProgram class >> secondMarker [

]

{ #category : #accessing }
TtdValidationProgram class >> thirdMarker [

]
