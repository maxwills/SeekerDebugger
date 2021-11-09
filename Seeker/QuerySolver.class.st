Class {
	#name : #QuerySolver,
	#superclass : #Object,
	#instVars : [
		'query'
	],
	#category : #'Seeker-Query'
}

{ #category : #'instance creation' }
QuerySolver class >> newForQuery: aQuery [

	^ self new
		  query: aQuery;
		  yourself
]

{ #category : #accessing }
QuerySolver >> query [

	^ query
]

{ #category : #accessing }
QuerySolver >> query: anObject [

	query := anObject
]

{ #category : #navigating }
QuerySolver >> resolve [

	^ self subclassResponsibility
]
