Class {
	#name : #SkPrintTraceToClipboardCommand,
	#superclass : #SeekerCommand,
	#category : #'Seeker-Commands'
}

{ #category : #default }
SkPrintTraceToClipboardCommand class >> defaultDescription [
	^'Print trace to the Clipboard'
]

{ #category : #initialization }
SkPrintTraceToClipboardCommand class >> defaultIconName [
	^#smallAdd 
]

{ #category : #default }
SkPrintTraceToClipboardCommand class >> defaultName [
	<seekerDebuggerCodeExtensionCommand: 50>
	^'Print Trace to the Clipboard'
]

{ #category : #executing }
SkPrintTraceToClipboardCommand >> executeCommand [

	Clipboard clipboardText: self seeker stepper trace asString
]
