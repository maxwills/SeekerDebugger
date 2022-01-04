Class {
	#name : #SeekerInstallHelpers,
	#superclass : #Object,
	#category : #'Seeker-Helpers'
}

{ #category : #actions }
SeekerInstallHelpers class >> debuggerExtensionEnabled [

	^ SeekerDebuggerPresenter showInDebugger
]

{ #category : #actions }
SeekerInstallHelpers class >> debuggerExtensionEnabled: aBoolean [

	SeekerDebuggerPresenter showInDebugger: aBoolean
]

{ #category : #actions }
SeekerInstallHelpers class >> install [

	<script>
	| authorName |
	authorName := Author uniqueInstance fullNamePerSe.
	Author uniqueInstance fullName: 'SeekerInstaller'.
	self overrideStDebuggerActionModel.
	self debuggerExtensionEnabled: true.
	self instrumentHandMorph.
	self instrumentMouseButtonEventSendTo.
	self installQuickWrapSystem.
	self refreshAllWrappers.
	self installMoosePatch.
	Author uniqueInstance fullName: authorName
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
SeekerInstallHelpers class >> installMoosePatch [

	| f |
	f := self environment at: #FamixStClass ifAbsent: [ nil ].
	f ifNil: [ ^ self ].
	(f methodDictionary includesKey: #package) ifTrue: [ ^ self ].
	f
		compile: 'package
		"A hacky fix for Seeker"
		^ self class package'
		classified: '*Seeker'
]

{ #category : #'as yet unclassified' }
SeekerInstallHelpers class >> installQuickWrapSystem [

	"After installing the debugger packages, this is necessary to actually use the SubCached methods"

	QuickWrap installQuickWrapSystem
]

{ #category : #actions }
SeekerInstallHelpers class >> instrumentHandMorph [

	"Used to capture shift and command keys"

	| method |
	method := HandMorph >> #handleEvent:.
	(method hasPragmaNamed: #qwpWrappedBy:selector:) ifFalse: [ 
		method addPragmaExpression:
			'<qwpWrappedBy: #SeekerWrapperMethods selector: #handMorphHandleEventWrapper:method:arguments:>' ]
]

{ #category : #actions }
SeekerInstallHelpers class >> instrumentMouseButtonEventSendTo [

	| method |
	method := MouseButtonEvent >> #sentTo:.
	(method hasPragmaNamed: #skpDebugMouseButtonEventSentTo) ifFalse: [ 
		method addPragmaExpression: '<skpDebugMouseButtonEventSentTo>' ]
]

{ #category : #actions }
SeekerInstallHelpers class >> overrideStDebuggerActionModel [

	| methodSource |
	self flag: 'Hacky. Should be changed in the future'.

	methodSource := 'debuggerActionModel

	^ debuggerActionModel ifNil: [ 
		  debuggerActionModel := (self respondsTo: #instantiateDebuggerActionModel)
			                         ifTrue: [ 
			                         self instantiateDebuggerActionModel ]
			                         ifFalse: [ 
			                         StDebuggerActionModel on: self session ] ]'.
	StDebugger compile: methodSource
]

{ #category : #'as yet unclassified' }
SeekerInstallHelpers class >> refreshAllWrappers [

	QuickWrap refreshAllWrappers
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

{ #category : #actions }
SeekerInstallHelpers class >> uninstall [

	<script>
	| authorName |
	authorName := Author uniqueInstance fullNamePerSe.
	Author uniqueInstance fullName: 'SeekerInstaller'.
	"The code changes remain, although they will become inactive"
	"self overrideStDebuggerActionModel."
	self debuggerExtensionEnabled: false.
	"self instrumentHandMorph.
	self instrumentMouseButtonEventSendTo."
	QuickWrap uninstallQuickWrapSystem.
	"	self installMoosePatch."
	Author uniqueInstance fullName: authorName
]
