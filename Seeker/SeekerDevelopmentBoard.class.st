"
# Seeker Development Board.

## Useful things:
- FLSerializer: In the comment section there is an example of how to serializa and deserialize form it.
  - Based in Stevens recommendation of checking out FuelOutStackCommand.
- ""Smalltalk ui icons"": Inspect the string (without the double quotes) To list all glamour icons.
"
Class {
	#name : #SeekerDevelopmentBoard,
	#superclass : #Object,
	#category : #'Seeker-Helpers'
}

{ #category : #initialization }
SeekerDevelopmentBoard >> initialize [
	"This class does nothing. It is used as a notedpad for seeker development and ideas."
	"Contents could be Comments section or anywhere in the class. No rules for the moment."	
^self
]
