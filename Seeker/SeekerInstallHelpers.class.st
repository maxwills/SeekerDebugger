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
	self enableDebuggerExtension.
	self overrideHandMorph
]

{ #category : #actions }
SeekerInstallHelpers class >> overrideHandMorph [

	"Used to capture shift and command keys"

	| methodSource |
	self flag: 'Hacky. Should be changed in the future'.

	methodSource := (HandMorph  >> #handleEvent:) sourceCode.
	methodSource := methodSource
		                copyReplaceAll: 'evt := anEvent.'
		                with:
		                'evt := anEvent "this comment prevent a second installation". 
		SeekerGlobals instance updateModifierKeys: anEvent.'.
	HandMorph compile: methodSource

	"(StDebugger >> #debuggerActionModel) browse"
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
