"
Seeker is a Time-Traveling Debugger built as an extension of the Pharo Debugger.

The stepping mechanism and its time-traveling features are organized in ""Components"", each one with a specific set of features and responsibilities.

The stepper takes care of the Stepping logic, the restorer takes care of reverting the state of the execution, etc.

Components work all together to make things works (they depend on the existance of the other components), however, they can be individually disabled, turning off their logic (therefore, the debugger will work without their features), or replaced by other definitions (such as a subclasses) to provide a modified behavior.

This component design is thought as a way of clarifying objects concerns, and to have an easier time isolating the causes of some errors.

## Components initialization and binding stages

Components can have cross-references. Without a clear initialization order it is likely to have unexpected results or unwanted nil references.

To prevent that, the componentsHolder needs to be first initialized. In its initialization, it creates the instances of each component receiving as a parameter the componentHolder.
Once all components are initialized, all their references other than the componentHolder are nil.
The component holder then calls each component's bindComponents method.
The method bindComponents must grab only ""first-level"" references from the component holder to fill the component's references to other components.
Then, the method componentsLateInitialization does all the remaining initialization logic.

One can think of this design as a set of stages:
- Stage 1 - Initialization: During each component initialization, the other referenced compoenents might not be initialized or even instantiated.
- Stage 2 - Binding: when the #bindComponents of a component is called, it is guaranteed that the component holder is referenced and it points to the references of all other components (which are instantiated but not necesarilly initialized). We use this stage to set up cross references.
- Stage 3 - ComponentLateInitialization: All the intialization that is not required by other components. At this point, we can consider other components as initialized. 

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
