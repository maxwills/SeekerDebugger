Class {
	#name : #SubCachedSeekerCurrentStateInterface,
	#superclass : #SeekerCurrentStateInterface,
	#instVars : [
		'_cacheTimeKey',
		'__cached_context',
		'__cached_contextTimeKey'
	],
	#category : #'Seeker-Interfaces'
}

{ #category : #'as yet unclassified' }
SubCachedSeekerCurrentStateInterface >> updateCacheTimeKey [

	_cacheTimeKey := tracer bytecodeIndex 
]
