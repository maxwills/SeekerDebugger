Class {
	#name : #SubCachedSeekerCurrentStateInterface,
	#superclass : #SeekerCurrentStateInterface,
	#instVars : [
		'_cacheTimeKey',
		'__cached_context',
		'__cached_contextTimeKey',
		'__cached_compiledCode',
		'__cached_compiledCodeTimeKey',
		'__cached_contextPC',
		'__cached_contextPCTimeKey',
		'__cached_contextTop',
		'__cached_contextTopTimeKey'
	],
	#category : #'Seeker-Interfaces'
}

{ #category : #'as yet unclassified' }
SubCachedSeekerCurrentStateInterface >> updateCacheTimeKey [

	_cacheTimeKey := tracer bytecodeIndex
]
