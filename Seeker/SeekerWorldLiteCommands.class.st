"
The world menu build logic is in the class side. It follows the same pattern as Roassal3 menu
"
Class {
	#name : #SeekerWorldLiteCommands,
	#superclass : #Object,
	#category : #'Seeker-Commands-World'
}

{ #category : #menu }
SeekerWorldLiteCommands class >> menu00SeekerDevOn: aBuilder [
	"<worldMenu>" 
	(aBuilder item: #SeekerDev)
		parent: #Tools;
		label: 'SeekerDev';
		icon: (self iconNamed: 'smallDebug');
		help: 'Seeker Dev Debugger shortcuts';
		order: 777
]

{ #category : #'as yet unclassified' }
SeekerWorldLiteCommands class >> menuBrowseSeekerExamplesClass: aBuilder [
	"<worldMenu>"
	(aBuilder item: #SeekerDevBrowseSeekerExamplesClass)
		parent: #SeekerDevBrowseSeekerPackage;
		order: 1;
		label: 'Browser Seeker Examples Class';
		icon: (self iconNamed: 'smallDebug');
		help: 'Opens the Seeker examples class';
		action: [ RecursionExamples browse ] 
]

{ #category : #'as yet unclassified' }
SeekerWorldLiteCommands class >> menuBrowseSeekerPackage: aBuilder [

	"<worldMenu>"
	(aBuilder item: #SeekerDevBrowseSeekerPackage)
		parent: #SeekerDev;
		order: 1;
		label: 'Open Seeker Package';
		icon: (self iconNamed: 'smallDebug');
		help: 'Opens a browser on Seeker package';
		action: [ (RPackageOrganizer default packageNamed: 'Seeker') browse ]
]

{ #category : #'as yet unclassified' }
SeekerWorldLiteCommands class >> menuBrowseSeekerTracerClass: aBuilder [
	"<worldMenu>"
	(aBuilder item: #SeekerDevBrowseSeekerTracerClass)
		parent: #SeekerDevBrowseSeekerPackage;
		order: 1;
		label: 'Browser Seeker Tracer Class';
		icon: (self iconNamed: 'smallDebug');
		help: 'Opens the Seeker tracer class';
		action: [ SkQueryExperimentalTracer  browse ] 
]

{ #category : #'as yet unclassified' }
SeekerWorldLiteCommands class >> menuBrowseStDebuggerActionModel: aBuilder [

	"<worldMenu>"
	(aBuilder item: #SeekerDevBrowseStDebuggerActionModel)
		parent: #SeekerDev;
		order: 2;
		label: 'Go to StDebugger for override step';
		icon: (self iconNamed: 'smallDebug');
		help: 'Opens a browser on the method';
		action: [ 
			(StDebugger >> #debuggerActionModel) browse.
			Clipboard clipboardText:
					SeekerStDebuggerDebuggerActionModel name asString.
			self inform:
					'SeekerStDebuggerDebuggerActionModel ready in clipboard for overwriting' ]
]

{ #category : #'as yet unclassified' }
SeekerWorldLiteCommands class >> menuEsteban: aBuilder [

	"<worldMenu> " 
	(aBuilder item: #SkEsteban)
		parent: #SeekerDev;
		order: 1;
		label: 'UI bug for Esteban';
		icon: (self iconNamed: 'smallDebug');
		help: 'No label';
		action: [ "Does Nothing" ]
]

{ #category : #'as yet unclassified' }
SeekerWorldLiteCommands class >> menuEstebanColumnsCreation: aBuilder [

	"<worldMenu>"
	(aBuilder item: #SkEstebanGoToColumnsCreation)
		parent: #SkEsteban;
		order: 3;
		label: 'Go to Seeker Columns Creation in custom presenter';
		icon: (self iconNamed: 'smallDebug');
		help: 'No label';
		action: [ (SeekerQueriesPresenter >> #showResult:) browse ]
]

{ #category : #'as yet unclassified' }
SeekerWorldLiteCommands class >> menuEstebanDebuggerExtensionPresenter: aBuilder [

	"<worldMenu>"
	(aBuilder item: #SkEstebanDebPresenter)
		parent: #SkEsteban;
		order: 2;
		label:
			'Browse debugger extesion Presenter (SeekerDebuggerPresenter)';
		icon: (self iconNamed: 'smallDebug');
		help: 'No label';
		action: [ SeekerDebuggerPresenter browse ]
]

{ #category : #'as yet unclassified' }
SeekerWorldLiteCommands class >> menuEstebanTestCase: aBuilder [

	"<worldMenu>"
	(aBuilder item: #SkEstebanGoToTestCase) 
		parent: #SkEsteban;
		order: 1;
		label: 'Test Case to reproduce issue';
		icon: (self iconNamed: 'smallDebug');
		help: 'No label';
		action: [ 
			(MetacelloVersionNumberTestCase >> #testApproxVersion02) browse ]
]

{ #category : #menu }
SeekerWorldLiteCommands class >> menuSeekerWarmup: aBuilder [

	<worldMenu>
	(aBuilder item: #SeekerWarmUp) 
		parent: #Tools;
		label: 'Seeker Warmup';
		icon: (self iconNamed: 'exception');
		help: 'Opens the Seeker Warmup test case';
		action: [ (DoubleLinkedListTest >> #testLinksDo) browse ];
		order: 776
]
