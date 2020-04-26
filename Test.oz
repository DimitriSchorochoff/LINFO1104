functor
import
	Browser
	System
	Application
	Reader
	SideFunction
	SideFunctionDimi
	SideFunctionAlex

define
	%Define function
	SaveDict = SideFunctionDimi.saveDict
	
	%Test SaveDict
	D = {NewDictionary}
	P = {SaveDict 2 D}

	{Send P ('Hello'#'World')#2}
	{Send P ('Hello'#'ya')#1}
	{Send P 0}
	{Send P ('Hi'#'how')#4}
	{Send P 0}

	
	{System.show {Dictionary.get D ('Hello'#'World')}}
	{System.show {Dictionary.get D ('Hi'#'how')}}

	{Application.exit 0}
end
