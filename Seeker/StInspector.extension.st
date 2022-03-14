Extension { #name : #StInspector }

{ #category : #'*Seeker' }
StInspector class >> on: aDomainObject [

	"This makes things slot. I believe that there is an update cycle of some sort."

	| inspector |
	inspector := super on: aDomainObject.
	[ 
	UIManager default defer: [ 
		SkTracerBase allSubInstancesDo: [ :seeker | 
			SeekerInspectorSynchronizer default searchNewInspectorsFor: seeker.
			SeekerInspectorSynchronizer default updateInspectorsFor: seeker ] ] ] fork.

	^ inspector
]
