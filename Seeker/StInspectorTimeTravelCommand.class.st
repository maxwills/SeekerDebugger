Class {
	#name : #StInspectorTimeTravelCommand,
	#superclass : #StInspectorCommand,
	#category : #'Seeker-Commands'
}

{ #category : #default }
StInspectorTimeTravelCommand class >> defaultDescription [

	^ 'Time travel to this description'
]

{ #category : #default }
StInspectorTimeTravelCommand class >> defaultName [
	"<toolbarInspectCommand: 40>"

	^ 'Time Travel'
]

{ #category : #documentation }
StInspectorTimeTravelCommand class >> documentContextRequiredSelectors [

	^ super documentContextRequiredSelectors, #(selectedObject)
]

{ #category : #converting }
StInspectorTimeTravelCommand >> asSpecCommand [

	^ super asSpecCommand 
		iconName: #smallSystemBrowser;
		yourself
]

{ #category : #execution }
StInspectorTimeTravelCommand >> execute [

	self interestingObject timeTravelToThis
]

{ #category : #execution }
StInspectorTimeTravelCommand >> interestingObject [

	^ self context selectedObject
]
