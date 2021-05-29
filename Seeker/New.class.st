Class {
	#name : #New,
	#superclass : #Object,
	#category : #'Seeker-DataQuery'
}

{ #category : #'instance creation' }
New class >> with: aCollection [

	"A nicer notation to instantiate anonymous types. Use it like this"

	"myObj := New with: {#firstName->'John'. #lastName->'Dinner'}.
	self assert: myObj firstName = 'John'.
	"

	^ AnonymousType newWith: aCollection
]