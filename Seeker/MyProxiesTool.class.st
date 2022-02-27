Class {
	#name : #MyProxiesTool,
	#superclass : #Object,
	#category : #'Seeker-Presentation'
}

{ #category : #'as yet unclassified' }
MyProxiesTool class >> doDetect [

	(MyLoggerUtil findContextWithSelector: #add:) ifNotNil: [ :ctx | 
		| newObject |
		newObject := ctx arguments first.
		newObject class = Apple ifTrue: [ 
			newObject healthy ifFalse: [ 
				MyLoggerUtil log:
					(MyLoggerUtil findArgumentsOfContextWithSelector: #doExchangeBetween:and:withRandom:) ] ] ]
]

{ #category : #'as yet unclassified' }
MyProxiesTool class >> installInterceptorProxyIn: aMethod withBlock: aBlockWithReceiverAndArgs [

	| mp handler |
	mp := MpMethodProxy onMethod: aMethod
		      handler: (handler := MpInterceptor new interceptorBlock: aBlockWithReceiverAndArgs).
	mp install
]

{ #category : #'as yet unclassified' }
MyProxiesTool class >> installProxyInOrderedCollectionAdd [

	<script>
	self installInterceptorProxyIn: OrderedCollection >> #add: withBlock: [ :receiver :args | 
		| newObject |
		newObject := args first.
		newObject class = Apple ifTrue: [ 
			newObject healthy ifFalse: [ 
				MyLoggerUtil log:
					(MyLoggerUtil findArgumentsOfContextWithSelector: #doExchangeBetween:and:withRandom:) ] ] ]
]

{ #category : #'as yet unclassified' }
MyProxiesTool class >> metalink [

	<script>
	| metalink |
	metalink := MetaLink new.
	metalink selector: #doDetect.
	metalink metaObject: self. 
	metalink control: #before.
	(OrderedCollection >> #add:) ast link: metalink
]

{ #category : #cleanup }
MyProxiesTool class >> uninstallAll [
<script>
	MpMethodProxy allInstances copy do: [ :mp | mp uninstall ]
]

{ #category : #'as yet unclassified' }
MyProxiesTool class >> uninstallAllLinks [

	<script>
	MetaLink uninstallAll
]

{ #category : #'as yet unclassified' }
MyProxiesTool class >> uninstallProxyFrom: method [

	method isMethodProxy ifTrue: [ method uninstall ]
]
