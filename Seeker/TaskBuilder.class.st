Class {
	#name : #TaskBuilder,
	#superclass : #Object,
	#instVars : [
		'receiver'
	],
	#category : #'Seeker-Helpers'
}

{ #category : #'instance creation' }
TaskBuilder class >> newForReceiver: anObject [

	^ self new
		  privateReceiver: anObject;
		  yourself
]

{ #category : #'reflective operations' }
TaskBuilder >> doesNotUnderstand: aMessage [

	"Creates a task with the messageSend to the receiver"

	^ TKTTask valuable: [ aMessage sendTo: receiver ]
]

{ #category : #accessing }
TaskBuilder >> privateReceiver [

	^ receiver
]

{ #category : #accessing }
TaskBuilder >> privateReceiver: anObject [

	receiver := anObject
]
