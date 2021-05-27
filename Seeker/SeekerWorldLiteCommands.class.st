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
