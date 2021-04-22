Class {
	#name : #SkPrintTraceToClipboardLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkPrintTraceToClipboardLC >> description [
	^'MyCommand description'
]

{ #category : #executing }
SkPrintTraceToClipboardLC >> executeCommand [

	Clipboard clipboardText: self seeker stepper trace asString
]

{ #category : #accessing }
SkPrintTraceToClipboardLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkPrintTraceToClipboardLC >> name [
	^'Print Trace to the Clipboard'
]
