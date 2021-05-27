"
Used for 'extending' object without the need of modifying their class definition.
Holds weak identity key dictionaries with the the extended propertied of any object. The object needs to be able to understan ""class"" message.
Useful when in need of new instance variables for objects that can't be modified (for example, context, RBNodes, etc).
Write your extension method for those object, and use this class to be able for the new ""extended instance variables"".

Example:

|context|
context := thisContext.
ExtendedProperties on: context at: 'newInstanceVariable' put: 'Hello'
"
Class {
	#name : #ObjectExtension,
	#superclass : #Object,
	#instVars : [
		'sourceObjWeakRef'
	],
	#category : #'Seeker-ObjectExtensions'
}
