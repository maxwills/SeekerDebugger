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

{ #category : #'as yet unclassified' }
SkBugMarkdownEscapeCharTest >> testMarkdownEscapeCharMediumExample [

	"To originally reproduce this bug, put the failing string in the class comment tab (in any class) and save. The comment is saved, but an exception happens when the renderer tries to parse the content (because of the trailing escape character)"

	| micSplitter theStringWithEscapeChar |
	micSplitter := MicInlineSplitter new.
	theStringWithEscapeChar := 'Hi this is a joierjtoije oijfsdoijf###omd soi  sdf ds///ººººasdas larg sdfe text to try the per oijj### ,//\\formance . .## asdnother onehey!!! \'.
	micSplitter pillarFrom: theStringWithEscapeChar
	
	"Nothing to assert. The previous call is not expected to have an unhandled exception"
]

{ #category : #'as yet unclassified' }
SkBugMarkdownEscapeCharTest >> testMarkdownEscapeCharShortExample [

	"To originally reproduce this bug, put the failing string in the class comment tab (in any class) and save. The comment is saved, but an exception happens when the renderer tries to parse the content (because of the trailing escape character)"

	| micSplitter theStringWithEscapeChar |
	micSplitter := MicInlineSplitter new.
	theStringWithEscapeChar := 'Hi SDdhjh asd\'.
	micSplitter pillarFrom: theStringWithEscapeChar
	
	"Nothing to assert. The previous call is not expected to have an unhandled exception"
]
