Extension { #name : #ThreadSafeTranscript }

{ #category : #'*Seeker' }
ThreadSafeTranscript >> shiftMenu [

	"Adding this mthod prevents some crashes"

	"Without this, an error is displayed when shift-clicking in a transcript"

	^ nil
]
