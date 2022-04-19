"
Seeker is a Time-Traveling Debugger built as an extension of the Pharo Debugger.

The stepping mechanism and its time-traveling features are organized in ""Components"", each one with a specific set of features and responsibilities.

The stepper takes care of the Stepping logic, the restorer takes care of reverting the state of the execution, etc.

Components work all together to make things works (they depend on the existance of the other components), however, they can be individually disabled, turning off their logic (therefore, the debugger will work without their features), or replaced by other definitions (such as a subclasses) to provide a modified behavior.

This component design is thought as a way of clarifying objects concerns, and to have an easier time isolating the causes of some errors.

"
Class {
	#name : #SkComponent,
	#superclass : #Object,
	#instVars : [
		'componentsHolder',
		'enabled'
	],
	#category : #'Seeker-Components'
}

{ #category : #'instance creation' }
SkComponent class >> newFor: anObject [

	| component |
	component := self new
		             componentsHolder: anObject;
		             yourself.
	component bindComponents.
	^ component
]

{ #category : #'as yet unclassified' }
SkComponent >> bindComponents [

	"subclasses must reimplement this method"

	
]

{ #category : #accessing }
SkComponent >> componentsHolder [

	^ componentsHolder
]

{ #category : #accessing }
SkComponent >> componentsHolder: anObject [

	componentsHolder := anObject
]

{ #category : #accessing }
SkComponent >> enabled [

	^ enabled
]

{ #category : #accessing }
SkComponent >> enabled: anObject [

	enabled := anObject
]

{ #category : #initialization }
SkComponent >> initialize [

	enabled := true
]

{ #category : #'as yet unclassified' }
SkComponent >> lateInitialization [

	
]
