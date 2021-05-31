Extension { #name : #String }

{ #category : #'*Seeker' }
String >> renderWidthUsingFont: font [

	"width class inheritsFromOrSameAs: Number"

	"font class inheritsFromOrSameAs: AbstractFont"

	"aFont example: StandardFonts listFont "

	^ font widthOfString: self
]

{ #category : #'*Seeker' }
String >> searchCharacterIndexForRenderTrim: width usingFont: font [

	"width class inheritsFromOrSameAs: Number"

	"font class inheritsFromOrSameAs: AbstractFont"

	"aFont example: StandardFonts listFont "

	| firstIndex lastIndex |
	firstIndex := 1.
	lastIndex := self size.
	"binary search  the character index that is the last one to fit in the string"
	[ firstIndex < lastIndex ] whileTrue: [ 
		| renderWidth midIndex |
		midIndex := (0.5 * (lastIndex + firstIndex)) floor.
		renderWidth := (self copyFrom: 1 to: midIndex) 
			               renderWidthUsingFont: font.

		renderWidth > width
			ifTrue: [ lastIndex := midIndex - 1 ]
			ifFalse: [ 
				firstIndex = midIndex ifTrue: [ ^ firstIndex ].
				firstIndex := midIndex ] ].
	^ firstIndex max: lastIndex
]

{ #category : #'*Seeker' }
String >> trimForRenderWidth: width usingFont: font autoEllipsis: autoEllipsis [

	"width class inheritsFromOrSameAs: Number"

	"font class inheritsFromOrSameAs: AbstractFont"

	"autoEllipsis class inheritsFromOrSameAs: Boolean "

	"aFont example: StandardFonts listFont "

	(self renderWidthUsingFont: font) <= width ifTrue: [ ^ self ].
	^ autoEllipsis
		  ifTrue: [ 
			  | elSize ellipsis trimTo |
			  ellipsis := '...'.
			  elSize := ellipsis renderWidthUsingFont: font.
			  trimTo := self
				            searchCharacterIndexForRenderTrim: width - elSize
				            usingFont: font.
			  ^ (self copyFrom: 1 to: trimTo) , ellipsis ]
		  ifFalse: [ 
			  | trimTo |
			  trimTo := self
				            searchCharacterIndexForRenderTrim: width
				            usingFont: font.
			  ^ self copyFrom: 1 to: trimTo ]
]
