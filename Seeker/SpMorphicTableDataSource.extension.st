Extension { #name : #SpMorphicTableDataSource }

{ #category : #'*Seeker' }
SpMorphicTableDataSource >> newDataSourceMatching: aFTFilter [

	"Fixes errors related to the usage of ItemFilters and SpTablePresenter"

	| newElements |
	newElements := Array withAll:
		               (self elements select: [ :each | 
			                aFTFilter matches: each ]).
	^ self class new
		  elements: newElements;
		  model: self model;
		  yourself
]
