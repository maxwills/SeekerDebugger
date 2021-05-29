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
	<worldMenu>
	(aBuilder item: #SeekerDev)
		parent: #Tools;
		label: 'SeekerDev';
		icon: (self iconNamed: 'smallDebug');
		help: 'Seeker Dev Debugger shortcuts';
		order: 777
]

{ #category : #'as yet unclassified' }
SeekerWorldLiteCommands class >> menuBrowseSeekerExamplesClass: aBuilder [
	<worldMenu>
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

	<worldMenu>
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
	<worldMenu>
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

	<worldMenu>
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
