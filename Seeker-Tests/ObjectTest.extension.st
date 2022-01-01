Extension { #name : #ObjectTest }

{ #category : #'*Seeker-Tests' }
ObjectTest >> testSwitch [

	"Usage instructions:
1. You should use defaultCase if the return is important. (Not mandatory, but switch might return an unwanted block.
2. The switch receiver can be a block. If it is a block, it will be evaluated when testing each case. If you want to avoid that, use the value itself as a receiver.
"

	"nominal case"

	| res |
	res := 1 switch
		       case: 1 do: [ #one ];
		       case: 2 do: [ #two ];
		       defaultCase: #three.
	self assert: res = #one.

	"Should not execute cases after match"
	res := 1 switch
		       case: 1 do: [ #one ];
		       case: 2 do: [ 
			       #shouldNotExecuteThis.
			       self assert: false ];
		       defaultCase: #three.
	self assert: res = #one.

	"Should execute the defaultCase if no Match"
	res := nil switch
		       case: 1 do: [ #one ];
		       case: 2 do: [ #two ];
		       defaultCase: #three.
	self assert: res = #three.

	"Should be able to return nil"
	res := 123 switch
		       case: 1 do: [ #one ];
		       case: 2 do: [ #two ];
		       defaultCase: nil.
	self assert: res isNil.

	"use Valuables in cases"
	res := true switch
		       case: [ 1 < 0 ] do: [ #one ];
		       case: [ 1 < 2 ] do: [ #two ];
		       defaultCase: #three.
	self assert: res = #two.

	"Should only execute the first matching case"
	res := [ true ] switch
		       case: true do: [ #one ];
		       case: true do: [ #two ];
		       defaultCase: #three.
	self assert: res = #one.

	"can return blocks"
	res := true switch
		       case: [ true ] do: [ [ #one ] ];
		       case: [ 1 < 2 ] do: [ [ #two ] ];
		       defaultCase: #three.

	self assert: (res isBlock and: [ res value = #one ])
]
