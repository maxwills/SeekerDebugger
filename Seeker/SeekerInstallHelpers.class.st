Class {
	#name : #SeekerInstallHelpers,
	#superclass : #Object,
	#category : #'Seeker-Helpers'
}

{ #category : #actions }
SeekerInstallHelpers class >> enableDebuggerExtension [

	SeekerDebuggerPresenter showInDebugger: true
]

{ #category : #actions }
SeekerInstallHelpers class >> install [

	self overrideStDebuggerActionModel.
	self enableDebuggerExtension
]

{ #category : #actions }
SeekerInstallHelpers class >> overrideStDebuggerActionModel [

	| methodSource |
	self flag: 'Hacky. Should be changed in the future'.

	methodSource := (StDebugger >> #debuggerActionModel) sourceCode.
	methodSource := methodSource
		                copyReplaceAll: StDebuggerActionModel name asString
		                with:
		                SeekerStDebuggerDebuggerActionModel name asString.
	StDebugger compile: methodSource

	"(StDebugger >> #debuggerActionModel) browse"
]
