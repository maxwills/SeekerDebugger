Extension { #name : #SequenceableCollection }

{ #category : #'*Seeker' }
SequenceableCollection >> doUnpacked: aBlock [

	"Refer to the comment in Collection|do:."

	1 to: self size do: [ :index | 
	aBlock valueWithArguments: (self at: index) ]
]
