Class {
	#name : #QdmForMooseFamixReferenceNavigation,
	#superclass : #QueryDisplayModel,
	#category : #'Seeker-DTTQ-Moose-Queries'
}

{ #category : #'as yet unclassified' }
QdmForMooseFamixReferenceNavigation >> buildContextMenuForResults: aQueryResutls withSelectedItem: selection forTracer: tracer [

	"builds a context menu for an item of this display model"

	^ SpMenuPresenter new
]

{ #category : #'as yet unclassified' }
QdmForMooseFamixReferenceNavigation >> defaultQueryTitle [

	^ 'Moose collections modifications Query'
]

{ #category : #initialization }
QdmForMooseFamixReferenceNavigation >> initializeModel [

	columns := { 
		           ((ColumnDefinition newForKey: #bytecodeIndex)
			            label: 'Step';
			            bc).

		           ((ColumnDefinition newForKey: #messageReceiverClass)
			            label: 'Navigated by';
			            expandable: true;
			            md) }
]
