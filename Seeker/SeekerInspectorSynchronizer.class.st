Class {
	#name : #SeekerInspectorSynchronizer,
	#superclass : #Object,
	#instVars : [
		'inspectorAndSeekerNOidsDictionary',
		'showOutOfTimeAsNil'
	],
	#classInstVars : [
		'default'
	],
	#category : #'Seeker-Helpers'
}

{ #category : #accessing }
SeekerInspectorSynchronizer class >> default [

	^ default
]

{ #category : #initialization }
SeekerInspectorSynchronizer class >> initialize [

	default := self new
]

{ #category : #initialization }
SeekerInspectorSynchronizer >> cleanUpInvalidatedEntries [

	"inspector synchronization is invalidated once the debugger session ends (or they are manually invalidated when recompiling or changing the debugged execution)"

	| invalidatedKeys |
	invalidatedKeys := IdentitySet new.
	inspectorAndSeekerNOidsDictionary keysDo: [ :insp | 
		| seekerNOid "type: SeekerNOidPair" |
		seekerNOid := inspectorAndSeekerNOidsDictionary at: insp.
		seekerNOid seeker ifNil: [ invalidatedKeys add: insp ] ifNotNil: [ 
			seekerNOid seeker isSessionActive ifFalse: [ 
				invalidatedKeys add: insp.
				seekerNOid clean ] ] ].
	invalidatedKeys do: [ :k | inspectorAndSeekerNOidsDictionary removeKey: k ]
]

{ #category : #initialization }
SeekerInspectorSynchronizer >> getSeekerAndOidForInspector: aStInspector [

	^ inspectorAndSeekerNOidsDictionary at: aStInspector ifAbsent: [ ^ nil ]
]

{ #category : #initialization }
SeekerInspectorSynchronizer >> initialize [

	inspectorAndSeekerNOidsDictionary := WeakIdentityKeyDictionary new.
	showOutOfTimeAsNil := true
]

{ #category : #'as yet unclassified' }
SeekerInspectorSynchronizer >> invalidateInspectorFor: tracer [

	"SubtypeOf: SkTracerBase"

	"Invalidates all inspectors. Beware, Might not be what you want."

	| invalidatedKeys |
	invalidatedKeys := OrderedCollection new.
	inspectorAndSeekerNOidsDictionary keysDo: [ :insp | 
		| seekerNOid "type: SeekerNOidPair" |
		seekerNOid := inspectorAndSeekerNOidsDictionary at: insp.
		seekerNOid seeker == tracer ifFalse: [ 
			invalidatedKeys add: insp.
			seekerNOid clean ] ].
	invalidatedKeys do: [ :k | inspectorAndSeekerNOidsDictionary remove: k ]
]

{ #category : #'as yet unclassified' }
SeekerInspectorSynchronizer >> searchNewInspectorsFor: tracer [
	"Add entries to the inspectors dictionary if a new one is detected"

	tracer isSessionActive ifFalse: [ ^ self ].
	StInspector allInstances do: [ :each |
		(inspectorAndSeekerNOidsDictionary includesKey: each) ifFalse: [
			| obj |
			obj := each model inspectedObject.
			obj ifNotNil: [
				| oid |
				oid := tracer getOidOf: obj.
				oid ifNotNil: [
					inspectorAndSeekerNOidsDictionary
						at: each
						put: (SeekerAndOidPair new
								 seeker: tracer;
								 oid: oid;
								 yourself) ] ] ] ]
]

{ #category : #accessing }
SeekerInspectorSynchronizer >> showOutOfTimeAsNil [

	^ showOutOfTimeAsNil
]

{ #category : #accessing }
SeekerInspectorSynchronizer >> showOutOfTimeAsNil: anObject [

	showOutOfTimeAsNil := anObject
]

{ #category : #'as yet unclassified' }
SeekerInspectorSynchronizer >> updateInspectorsFor: tracer [

	"SubtypeOf: SkTracerBase"

	inspectorAndSeekerNOidsDictionary keysDo: [ :insp | 
		| seekerNOid "type: SeekerNOidPair" |
		seekerNOid := inspectorAndSeekerNOidsDictionary at: insp.
		seekerNOid seeker == tracer ifTrue: [ 
			| objectToShow title atTimeIndex |
			objectToShow := tracer objectsTracker getObjectByOid: seekerNOid oid.
			insp
				model: (StInspectorModel on: objectToShow);
				updateList.
			title := insp windowTitle.
			atTimeIndex := title findString: '>)'.
			atTimeIndex > 0 ifTrue: [ title := title copyFrom: atTimeIndex + 1 to: title size ].
			title := '(Oid:<' , seekerNOid oid asString , '>@Time: <' , tracer bytecodeIndex asString , '>) '
			         , title.
			insp window ifNotNil: [ insp window title: title ] ] ]
]
