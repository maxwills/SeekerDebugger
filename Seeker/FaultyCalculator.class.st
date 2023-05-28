Class {
	#name : #FaultyCalculator,
	#superclass : #Object,
	#category : #'Seeker-BugCollection-Tests'
}

{ #category : #'test methods' }
FaultyCalculator class >> aMethod [

	| a |
	a :=0.
	a := a + 1.
	a := a + 2.
	a := a + 3.
	^ a
]

{ #category : #'test methods' }
FaultyCalculator class >> aMethodCopy [

	| a |
	a :=0.
	a := a + 1.
	a := a + 2.
	a := a + 3.
	^ a
]

{ #category : #'test methods' }
FaultyCalculator class >> aMethodCopy2 [

	| b |
	b :=10.
	b := b+ 1.
	b := b + 2.
	b := b+ 3.
	^ b
]

{ #category : #'test methods' }
FaultyCalculator class >> aMethodForExecutionStatesDo [

	<skpExecutionStatesDo: #SkESDCountBytecodes>
	1 asString.
	^ self aMethod
]

{ #category : #'test methods' }
FaultyCalculator class >> aMethodToDebug [

	<skpDebugWithSeeker>
	1 asString.
	^ self aMethod
]

{ #category : #'test methods' }
FaultyCalculator class >> aMethodToDebug2 [

	<skpDebugWithSeekerIfKeysPressed>
	1 asString.
	^ self aMethod
]

{ #category : #'as yet unclassified' }
FaultyCalculator class >> instrument [
|m m2|
	<script>
	m:= self class methodDictionary at: #aMethodCopy.
	m2:=self class methodDictionary at: #aMethodCopy2.

	self class methodDictionary at: #aMethodCopy put: m2.
	self class methodDictionary at: #aMethodCopy2 put: m.
]

{ #category : #'as yet unclassified' }
FaultyCalculator class >> sameInstanceWrapper: receiver wrappedMethod: aMethod arguments: args [

	| res |
	res := receiver execute: aMethod withArgs: args.
	^ 'result is: ' , res asString
]

{ #category : #'as yet unclassified' }
FaultyCalculator class >> theWrapperOfJuanito: receiver wrappedMethod: aMethod arguments: args [

	| res |
	res := receiver execute: aMethod withArgs: args.
	^ 'result is: ' , res asString
]

{ #category : #'as yet unclassified' }
FaultyCalculator >> obtainValuesFromSomewhere [
  ^{1 . 2. 3. 4. 5. 6. 7. 8. 9. 0 . 13 . 42 . 35 . 75 . 68 . 79}
]

{ #category : #'as yet unclassified' }
FaultyCalculator >> reciprocal: aCollection [
  ^ aCollection collect: [ :each | 1.0 / each ]
]
