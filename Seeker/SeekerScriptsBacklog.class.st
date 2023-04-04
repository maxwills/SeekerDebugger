"
Just a collection of seeker development scripts. 
Used as a reminder.
"
Class {
	#name : #SeekerScriptsBacklog,
	#superclass : #Object,
	#category : #'Seeker-Helpers'
}

{ #category : #'as yet unclassified' }
SeekerScriptsBacklog >> findNDS1: programStates tracer: tracer [

	^ SeekerMetaDebugHelper searchNDSNodeFor: tracer attemps: 2
]
