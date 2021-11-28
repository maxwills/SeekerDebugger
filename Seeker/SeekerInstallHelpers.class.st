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
	self overrideHandMorph.
	self installQuickWrapSystem.
	self refreshSubChachedMethods.
	self refreshSubChacheDelegationProxies
]

{ #category : #actions }
SeekerInstallHelpers class >> installAndShowMessageOnCompletion [

	self install.
	[ 
	UIManager default defer: [ 
		SeekerMessageDialog
			showModalDialog:
			'SeekerDebugger installation is finished. The debugger is ready to use.'
			withTitle: 'Installation complete' ] ] fork "Done this way to avoid blocking the progressbar with the modal"
]

{ #category : #'as yet unclassified' }
SeekerInstallHelpers class >> installQuickWrapSystem [

	"After installing the debugger packages, this is necessary to actually use the SubCached methods"

	QuickWrap installQuickWrapSystem
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

{ #category : #'as yet unclassified' }
SeekerInstallHelpers class >> refreshSubChacheDelegationProxies [

	"After installing the debugger packages, this is necessary to actually use the SubCached methods"

	"Requires QuickWrap to be installed (not just loaded)"

	SubCacheDelegatedInstantiation refreshAllMethodsDelegations
]

{ #category : #'as yet unclassified' }
SeekerInstallHelpers class >> refreshSubChachedMethods [

	"After installing the debugger packages, this is necessary to actually use the SubCached methods"

	"Requires QuickWrap to be installed (not just loaded)"

	SubCache refreshAllMethodsCaches
]
