"
A direct copy of SpMorphicTableAdapter that builds a SeekerSpFTTableMorph instead of a SpFTTableMorph.
(TODO: Make this class to inherit from that instead of being a copy?)
"
Class {
	#name : #SkSpMorphicSeekerTableAdapter,
	#superclass : #SpAbstractMorphicListAdapter,
	#category : #'Seeker-UI'
}

{ #category : #accessing }
SkSpMorphicSeekerTableAdapter class >> adaptingName [

	^ 'SeekerTableAdapter' asSymbol
]

{ #category : #accessing }
SkSpMorphicSeekerTableAdapter class >> intercellSpacing [

	^ 2@0
]

{ #category : #initialization }
SkSpMorphicSeekerTableAdapter >> addKeyBindingsTo: aWidget [

	super addKeyBindingsTo: aWidget.
	self addContextMenuKeyBindings: aWidget
]

{ #category : #factory }
SkSpMorphicSeekerTableAdapter >> addModelTo: tableMorph [

	self model columns do: [ :each |
		tableMorph addColumn: (self newColumnFrom: each) ].
	self ensureAtLeastOneColumnIn: tableMorph.

	self isResizable 
		ifTrue: [ tableMorph beResizable ] 
		ifFalse: [ tableMorph beNotResizable ].
	
	tableMorph setMultipleSelection: self model isMultipleSelection.

	self refreshShowColumnHeaders.
	self refreshWidgetSelection.
	
	self presenter whenShowColumnHeadersChangedDo: [ :showColumns |
		self refreshShowColumnHeaders ].

	self presenter whenModelChangedDo: [ self refreshModel ].
	self presenter whenColumnsChangedDo: [ self refreshColumnsInWidget ].
	
	tableMorph setBalloonText: self help.

	self configureScrolling.

	tableMorph
		onAnnouncement: FTSelectionChanged
			send: #selectionChanged:
			to: self;
		onAnnouncement: FTStrongSelectionChanged
			send: #strongSelectionChanged:
			to: self.

	tableMorph dataSource: self newDataSource.
	
	self presenter whenItemFilterBlockChangedDo: [ :block | 
		self updateItemFilterBlockWith: block ].
	self presenter whenSearchEnabledChangedDo: [ 
		self updateSearch ].
	self updateItemFilterBlockWith: self itemFilter
]

{ #category : #factory }
SkSpMorphicSeekerTableAdapter >> buildWidget [

	widget := SeekerSpFTTableMorph new
		          hResizing: #spaceFill;
		          vResizing: #spaceFill;
		          intercellSpacing: self class intercellSpacing;
		          dragEnabled: self dragEnabled;
		          dropEnabled: self dropEnabled;
		          yourself.

	self addModelTo: widget.

	^ widget
]

{ #category : #emulating }
SkSpMorphicSeekerTableAdapter >> clickOnColumnHeaderAt: anIndex [
	self widgetDo: [ :tableWidget | tableWidget clickOnColumnHeaderAt: anIndex ]
]

{ #category : #testing }
SkSpMorphicSeekerTableAdapter >> columns [
	^ widget columns
]

{ #category : #factory }
SkSpMorphicSeekerTableAdapter >> defaultColumn [

	^ SpStringTableColumn new evaluated: #yourself
]

{ #category : #factory }
SkSpMorphicSeekerTableAdapter >> ensureAtLeastOneColumnIn: tableMorph [
	self model columns ifNotEmpty: [ ^ self ].
	tableMorph addColumn: (self newColumnFrom: self defaultColumn)
]

{ #category : #private }
SkSpMorphicSeekerTableAdapter >> ifSorted: sortedBlock ifNotSorted: notSortedBlock [ 
	widget columns 
		do: [ :column | | state | 
			column isSorted
				ifTrue: [ 
					state := column sortingStrategy state.
					state isSorted
						ifTrue: [ ^ sortedBlock cull: state ] ] ].
	^ notSortedBlock value
]

{ #category : #testing }
SkSpMorphicSeekerTableAdapter >> isNonEditableRow: aRow column: aColumn [

	^ (self widget dataSource
		cellColumn: (self widget columns at: aColumn)
		row: aRow) submorphs allSatisfy: [ :e | e asReadOnlyMorph == e ]
]

{ #category : #testing }
SkSpMorphicSeekerTableAdapter >> isResizable [
	^ self model isResizable
]

{ #category : #testing }
SkSpMorphicSeekerTableAdapter >> isShowColumnHeaders [

	^ widget isShowColumnHeaders 	
]

{ #category : #testing }
SkSpMorphicSeekerTableAdapter >> isShowingColumnHeaders [
	^ self model isShowingColumnHeaders
]

{ #category : #'private - factory' }
SkSpMorphicSeekerTableAdapter >> newColumnFrom: aTableColumn [

	^ (SpMorphicTableColumn on: aTableColumn)
		width: aTableColumn width;
		yourself
]

{ #category : #'private - factory' }
SkSpMorphicSeekerTableAdapter >> newDataSource [ 

	^ SpMorphicTableDataSource new
		model: self model;
		yourself

]

{ #category : #factory }
SkSpMorphicSeekerTableAdapter >> refreshColumnsInWidget [

	widget columns: (self model columns collect: [ :each | self newColumnFrom: each ]).
	self ensureAtLeastOneColumnIn: widget.
]

{ #category : #refreshing }
SkSpMorphicSeekerTableAdapter >> refreshList [

	^ self widget refresh
]

{ #category : #refreshing }
SkSpMorphicSeekerTableAdapter >> refreshModel [

	widget dataSource resetElements.
	self
		ifSorted: [ :sortingStrategyState | sortingStrategyState executeSortingOn: widget dataSource ]
		ifNotSorted: [ self refreshList ]
]

{ #category : #factory }
SkSpMorphicSeekerTableAdapter >> refreshShowColumnHeaders [
	
	self presenter isShowingColumnHeaders 
		ifTrue: [ 
			self widget
				showColumnHeaders;
				refresh ]
		ifFalse: [ 
			self widget
				hideColumnHeaders;
				refresh ]
]

{ #category : #refreshing }
SkSpMorphicSeekerTableAdapter >> refreshWidgetSelection [
	| rowIndexes |
	rowIndexes := self presenter selection selectedIndexes.
	rowIndexes = self widget selectedIndexes
		ifTrue: [ ^ self ].
	rowIndexes isEmpty
		ifTrue: [ self widget basicSelectIndexes: #() ]
		ifFalse: [ self widget basicSelectIndexes: rowIndexes ].
	^ self refreshList
]

{ #category : #selection }
SkSpMorphicSeekerTableAdapter >> selectIndex: anInteger [ 

	(anInteger = 0 and: [ widget selectedIndexes isEmpty ]) ifTrue: [ ^ self ].	
	(widget selectedIndexes includes: anInteger) ifTrue: [^self].
	widget selectIndex: anInteger
]

{ #category : #testing }
SkSpMorphicSeekerTableAdapter >> selectedIndexes [
	
	^ widget selectedIndexes 
]

{ #category : #factory }
SkSpMorphicSeekerTableAdapter >> selectionChanged: ann [
	| diff selection |

	selection := self presenter selection.
	selection selectIndexes: (selection isMultipleSelection
		ifTrue: [ 
			 (ann newSelectedIndexes reject: [ :e | e = 0 ]) ]
		ifFalse: [ 
			{ ann newSelectedIndexes
				ifNotEmpty: [ :indexes | indexes first ]
				ifEmpty: [ 0 ] } ]).

	diff := ann newSelectedIndexes difference: ann oldSelectedIndexes.
	(diff notEmpty and: [ self presenter activatesOnSingleClick ])
		ifTrue: [ self presenter doActivateAtIndex: diff last ].
		
	ann newSelectedIndexes ifEmpty: [ selection unselectAll ]
]

{ #category : #emulating }
SkSpMorphicSeekerTableAdapter >> sendRightClickEvent [
	| evt |

	evt := MouseButtonEvent new 
		setType: nil 
		position: widget center 
		which: MouseButtonEvent yellowButton 
		buttons: MouseButtonEvent yellowButton 
		hand: nil 
		stamp: nil.
	
	self widget click: evt
]

{ #category : #factory }
SkSpMorphicSeekerTableAdapter >> strongSelectionChanged: aFTStrongSelectionChanged [

	self presenter activatesOnDoubleClick ifFalse: [ ^ self ].	
	self presenter doubleClickAtIndex: aFTStrongSelectionChanged selectedIndex
]

{ #category : #'drag and drop' }
SkSpMorphicSeekerTableAdapter >> transferFrom: aTransferMorph event: anEvent [
	| rowAndColumn |

	rowAndColumn := self widget container rowAndColumnIndexContainingPoint: anEvent position.
	^ SpDragAndDropTransferToTable new
		passenger: aTransferMorph passenger;
		row: (rowAndColumn first ifNil: [ 0 ]);
		column: (rowAndColumn second ifNil: [ 0 ]);
		yourself
]

{ #category : #updating }
SkSpMorphicSeekerTableAdapter >> updateMenu [
	
	"there is no need to updateMenu here because it will be resolved at the dataSource"
]
