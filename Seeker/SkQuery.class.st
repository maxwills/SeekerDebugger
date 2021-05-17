"
SeekerQuery
Its an object that represents a query against data. Follows stardard terminology while also providing a language integrated API to create expressions.
Seeker Queries are only processed when issuing the results.

Example:

|myQuery|
myQuery := SeekerQuery from: DataSource where: [:dataSourceRow| dataSetRow id = 100] select: [:dataSourceRow| dataSetRow].

Will create a query object with a datasource, a row matching predicate 'where', and a projection function 'select'.

The query will not execute unless an operation is specified:
|result|

""Operation: #asTable""
result := myQuery asTable. 
Will iterate through the rows of the datasource while storing the matching rows projectiong in a resulting table.

""Operation: #count""
result := myQuery count. 
Will iteration though the rows of the datasource while counting the matching rows.

DataSource are objects that represent a table. They must reply to currentRow message, and provide an iteration logic.

Rows:
Rows can be of any type of object.

AnoymousType integration.
Queries experessions are compatible with AnonymousTypes. Providing freedom to express the result types while keeping a standard syntax.

"
Class {
	#name : #SkQuery,
	#superclass : #SkIterableDataTableBase,
	#instVars : [
		'fromDataSource',
		'selectBlock',
		'whereBlock',
		'resultBuffer',
		'result',
		'onQueryRowMatch',
		'operationType',
		'disableOptimization'
	],
	#category : #'Seeker-Components-Experimental'
}
