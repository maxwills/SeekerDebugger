Class {
	#name : #SkXNodeInCompiledCodePath,
	#superclass : #OrderedCollection,
	#category : #'Seeker-Experimental-NodeNotation'
}

{ #category : #arithmetic }
SkXNodeInCompiledCodePath >> / aNodeInCompiledCode [

	(aNodeInCompiledCode class inheritsFromOrSameAs:
		 SkXNodeInCompiledCode)
		ifTrue: [ self add: aNodeInCompiledCode ]
		ifFalse: [ self addAll: aNodeInCompiledCode ].

	^ self
]
