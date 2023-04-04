Class {
	#name : #SkUnsupportedCases,
	#superclass : #Object,
	#instVars : [
		'unsupportedMethods',
		'unsupportedClassesForInstantiation',
		'unsupportedClassesAsReceiver',
		'logMessage'
	],
	#category : #'Seeker-Components'
}

{ #category : #'as yet unclassified' }
SkUnsupportedCases >> checkCaseSupport: programState [

(self isUnsupportedCase: programState) ifTrue: [ 
	UIManager default inform: 'SeekerDebugger: Unsupported case detected and logged.'.
	Transcript show:'SeekerDebugger UnsupportedCase: ',logMessage ;cr.
	 ]
]

{ #category : #initialization }
SkUnsupportedCases >> initialize [ 
logMessage :=''.
unsupportedClassesForInstantiation := {
	"Semaphore."
	Deprecation.
	Process.
} asIdentitySet.
unsupportedClassesAsReceiver := {
Deprecation.
	"Semaphore."
} asIdentitySet.
unsupportedMethods := { 
	BlockClosure >>#newProcess.
 } asIdentitySet
]

{ #category : #testing }
SkUnsupportedCases >> isSupportedCase: programState [
^ (self isUnsupportedCase: programState)not
]

{ #category : #testing }
SkUnsupportedCases >> isUnsupportedCase: programState [
programState isMessageSend ifTrue: [^self isUnsupportedMessageSend:programState  ].
^ false
]

{ #category : #testing }
SkUnsupportedCases >> isUnsupportedMessageSend: programState [

	programState isInstantiationMessage ifTrue: [
		(unsupportedClassesForInstantiation includes:
			 programState messageReceiver) ifTrue: [
			logMessage := 'Unsupported instantiation: '
			              , programState messageReceiver class name.
			^ true ] ].
	(unsupportedMethods includes: programState methodAboutToExecute)
		ifTrue: [
			logMessage := 'Unsupported method: '
			              , programState methodAboutToExecute name.
			^ true ].
	(unsupportedClassesAsReceiver includes:
		 programState messageReceiver class) ifTrue: [
		logMessage := 'Unsupported class: '
		              , programState messageReceiver class name.
		^ true ].
	^ false
]
