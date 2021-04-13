Class {
	#name : #SkBugMarkdownEscapeCharTest,
	#superclass : #TestCase,
	#category : #'Seeker-BugCollection-Tests'
}

{ #category : #'as yet unclassified' }
SkBugMarkdownEscapeCharTest >> testMarkdownEscapeCharExample [

	"To originally reproduce this bug, put the failing string in the class comment tab (in any class) and save. The comment is saved, but an exception happens when the renderer tries to parse the content (because of the trailing escape character)"

	| micSplitter theStringWithEscapeChar |
	micSplitter := MicInlineSplitter new.
	theStringWithEscapeChar := 'this is a failing string \'.
	micSplitter pillarFrom: theStringWithEscapeChar
	
	"Nothing to assert. The previous call is not expected to have an unhandled exception"
]
