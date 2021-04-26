Class {
	#name : #FaultyCalculator,
	#superclass : #Object,
	#category : #'Seeker-BugCollection-Tests'
}

{ #category : #'as yet unclassified' }
FaultyCalculator >> obtainValuesFromSomewhere [
  ^{1 . 2. 3. 4. 5. 6. 7. 8. 9. 0 . 13 . 42 . 35 . 75 . 68 . 79}
]

{ #category : #'as yet unclassified' }
FaultyCalculator >> reciprocal: aCollection [
  ^ aCollection collect: [ :each | 1.0 / each ]
]
