Extension { #name : #Object }

{ #category : #'*Seeker-DTTQ-Announcements' }
Object >> querySubscriptionsWith: aQuery forSelector: selector [

	| seeker error |
	error := true. 

	[
	seeker := self seekMe.
	seeker ifNotNil: [
		| oid | 
		oid := self seekMyOid.
		oid ifNil: [ ^ self error: 'Seeker: obtained Oid was nil.' ].
		seeker ui showInResult: (aQuery
				 queryFrom: seeker newProgramStates
				 withObjectOid: oid
				 andMessageSelector: selector) displayModel.
		error := false ] ] ensure: [
		error
			ifFalse: [ self inform: 'Results being shown in results table' ]
			ifTrue: [ self error: 'Could not execute query' ] ]
]
