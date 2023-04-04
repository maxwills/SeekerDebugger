"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestSeekerDTTQMoose,
	#superclass : #PackageManifest,
	#category : #'Seeker-DTTQ-Moose-Manifest'
}

{ #category : #'code-critics' }
ManifestSeekerDTTQMoose class >> ruleInconsistentMethodClassificationRuleV1FalsePositive [
	^ #(#(#(#RGClassDefinition #(#SkSelectionFamixAssociationNodeAccesses)) #'2023-04-04T15:31:28.74074+02:00') )
]
