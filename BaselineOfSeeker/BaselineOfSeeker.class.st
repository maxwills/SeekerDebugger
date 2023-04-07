Class {
	#name : #BaselineOfSeeker,
	#superclass : #BaselineOf,
	#category : #BaselineOfSeeker
}

{ #category : #baselines }
BaselineOfSeeker >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		spec
			baseline: 'AutoType'
			with: [ spec repository: 'github://maxwills/auto-type:main' ].
		spec
			baseline: 'LanguageExtensions'
			with: [ spec repository: 'github://maxwills/language-extensions:main' ].
		spec
			baseline: 'MockFlex'
			with: [ spec repository: 'github://maxwills/mock-flex:main' ].
		spec
			baseline: 'QuickWrap'
			with: [ spec repository: 'github://maxwills/quick-wrap:main' ].
		spec postLoadDoIt: #postload:package:.
		
		spec
			package: 'EvaluatorDebugger-Base';
			package: 'Seeker'
			with: [ spec requires: #( 'EvaluatorDebugger-Base' 'AutoType' 'LanguageExtensions' 'MockFlex' 'QuickWrap') ];
			package: 'Seeker-DomainSpecificQueries' with: [spec requires: #( 'Seeker' ) ];
			package: 'Seeker-DTTQ-Moose' with: [spec requires: #( 'Seeker-DomainSpecificQueries' ) ];
			package: 'Seeker-DTTQ-Microdown' with: [spec requires: #( 'Seeker-DomainSpecificQueries' ) ];		
			package: 'Seeker-DTTQ-Announcements' with: [spec requires: #( 'Seeker-DomainSpecificQueries' ) ];
			package: 'Seeker-Tests' with: [ ";
			package: 'SeekerDebuggerSpy'
			with: [ spec requires: #( 'Seeker' ) ]" 
				spec requires: #( 'Seeker' ) ]. "remove this after experiment"
		spec
			group: 'default'
			with: #( 'EvaluatorDebugger-Base' 'Seeker' 'Seeker-DomainSpecificQueries' 'Seeker-Tests' ).
		spec
			group: 'Moose'
			with: #( 'EvaluatorDebugger-Base' 'Seeker' 'Seeker-DomainSpecificQueries' 'Seeker-DTTQ-Announcements' 'Seeker-DTTQ-Moose' ).
		spec
			group: 'Microdown'
			with: #( 'EvaluatorDebugger-Base' 'Seeker' 'Seeker-DomainSpecificQueries' 'Seeker-DTTQ-Announcements' 'Seeker-DTTQ-Microdown' ) ].
		
	

]

{ #category : #actions }
BaselineOfSeeker >> postload: loader package: packageSpec [

	(self class environment at: #SeekerInstallHelpers)
		install
]
