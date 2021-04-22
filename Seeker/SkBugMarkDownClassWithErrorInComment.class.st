"
I'm a simple lexer. I'm used bt the DLitlleLParser.

I recogniseI
- names: list of characters letter and number and '
- separators: one character separator.
- escape char \

Whitespaces and separators can be customised using setters.
Subclasses may change the definition of names by redefining isCurrentALetter.
"
Class {
	#name : #SkBugMarkDownClassWithErrorInComment,
	#superclass : #TestCase,
	#category : #'Seeker-BugCollection-Tests'
}

{ #category : #'as yet unclassified' }
SkBugMarkDownClassWithErrorInComment >> justOpenTheCommentTab [
	"To reproduce the error, open the comment tab. Note however that a manual map is required"
]
