Class {
	#name : #SkAutoMapSessionFromTestUnhandledExceptionLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkAutoMapSessionFromTestUnhandledExceptionLC >> description [
	^'Automatically sets starting and ending point for the session'
]

{ #category : #executing }
SkAutoMapSessionFromTestUnhandledExceptionLC >> executeCommand [

	 self seeker stepper autoSetupForTestForUnhandledException
]

{ #category : #accessing }
SkAutoMapSessionFromTestUnhandledExceptionLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkAutoMapSessionFromTestUnhandledExceptionLC >> name [
	^'Automatically map session from Test uncaught exception'
]
