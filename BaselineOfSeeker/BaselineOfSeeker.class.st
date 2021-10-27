Class {
	#name : #BaselineOfSeeker,
	#superclass : #BaselineOf,
	#category : #BaselineOfSeeker
}

{ #category : #baselines }
BaselineOfSeeker >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		spec postLoadDoIt: #postload:package:.
		spec
			package: 'EvaluatorDebugger-Base';
			package: 'Seeker'
			with: [ spec requires: #( 'EvaluatorDebugger-Base' ) ];
			package: 'Seeker-Tests' with: [ ";
			package: 'SeekerDebuggerSpy'
			with: [ spec requires: #( 'Seeker' ) ]" 
				spec requires: #( 'Seeker' ) ]. "remove this after experiment"
		spec
			group: 'default'
			with: #( 'EvaluatorDebugger-Base' 'Seeker' 'Seeker-Tests' ) ]
]

{ #category : #actions }
BaselineOfSeeker >> postload: loader package: packageSpec [

	(self class environment at: #SeekerInstallHelpers) install
]
