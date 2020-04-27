functor
import
	Browser
	System
	Application
	Reader
	SideFunction
	SideFunctionDimi
	AlterDictionary

define
%	%Define function
%	SaveDict = SideFunctionDimi.saveDict
%	
%	%Test SaveDict
%	D = {NewDictionary}
%	P = {SaveDict 2 D}
%
%	{Send P ('Hello'#'World')#2}
%	{Send P ('Hello'#'ya')#1}
%	{Send P 0}
%	{Send P ('Hi'#'how')#4}
%	{Send P 0}

	
%	{System.show {Dictionary.get D ('Hello'#'World')}}
%	{System.show {Dictionary.get D ('Hi'#'how')}}

	D = {AlterDictionary.new}
	{AlterDictionary.put D 2#3 7}
	{AlterDictionary.put D 2#3 8}
	{AlterDictionary.put D 2#4 1}

	{System.show {AlterDictionary.isIn D 2#3}}
	{System.show {AlterDictionary.entries D}.2.1}
	{System.show {AlterDictionary.keys D}.2.1}
	{System.show {AlterDictionary.items D}.2.1}
	{Application.exit 0}
end
