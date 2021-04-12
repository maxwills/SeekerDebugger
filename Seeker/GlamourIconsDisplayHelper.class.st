Class {
	#name : #GlamourIconsDisplayHelper,
	#superclass : #Object,
	#category : #'Seeker-Helpers'
}

{ #category : #protocol }
GlamourIconsDisplayHelper >> showList [
"Just select the code and Do It"
| iconList |
iconList := IconListModel new.
iconList
items: Smalltalk ui icons icons associations;
displayBlock: [ :assoc | assoc key];
sortingBlock: [ :assocA :assocB | assocA key < assocB key ];
icons: [ :assoc | assoc value ];
title: 'Availiable icons for the current theme.'.
iconList openWithSpec
"OR SIMPLY Smalltalk ui icons and inspect that"
]
