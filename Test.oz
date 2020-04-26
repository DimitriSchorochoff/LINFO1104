functor
import
	Browser
	System
	Application
	Reader
	SideFunction
	SideFunctionDimi
	BetterDictionary

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

	D = {BetterDictionary.new}
	{BetterDictionary.put D 2#3 7}
	{BetterDictionary.put D 2#3 8}
	{BetterDictionary.put D 2#4 1}

	{System.show {BetterDictionary.condGet D 2#3 0}}
	{System.show {BetterDictionary.entries D}.2.1}
	{System.show {BetterDictionary.keys D}.2.1}
	{System.show {BetterDictionary.items D}.2.1}
	{Application.exit 0}
end
