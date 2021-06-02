Class {
	#name : #BaselineOfSeekerDebugger,
	#superclass : #BaselineOf,
	#category : #BaselineOfSeeker
}

{ #category : #baselines }
BaselineOfSeekerDebugger >> baseline: spec [

	<baseline>
	spec for: #common do: [ "Here is a typical package and its tests
	spec for: #'common' do: [
		spec 
			package: #'XXX-Core';
			package: #'XXX-Core-Tests' with: [
				spec requires: #('XXX-Core' ) ].
		spec 
			group: 'Core' with: #('XXX-Core' );
			group: 'CoreTests' with: #('XXX-Core' 'XXX-Core-Tests');
			group: 'default' with: #('Beacon-XXX' 'Beacon-XXX-Tests') ]
	"
		spec
			baseline: 'SeekerExperiment'
			with: [ 
			spec repository: 'github://StevenCostiou/SeekerExperiment:main' ].
		spec
			package: 'EvaluatorDebugger-Base';
			package: 'Seeker'
			with: [ spec requires: #( 'EvaluatorDebugger-Base' ) ];
			package: 'Seeker-Tests' with: [ spec requires: #( 'Seeker' ) ];
			package: 'SeekerDebuggerSpy'
			with: [ spec requires: #( 'DebuggingSpy' 'Seeker' ) ].
		spec
			group: 'default'
			with: #( 'EvaluatorDebugger-Base' 'Seeker' 'Seeker-Tests' ).
		spec
			group: 'SeekerExperiment'
			with:
			#( 'EvaluatorDebugger-Base' 'Seeker' 'Seeker-Tests' 'SeekerDebuggerSpy' ) ]
]
