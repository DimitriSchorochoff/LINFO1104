functor
import
	Browser
	System
	Application
	Reader
	SideFunction
	AlterDictionary

define
	%Define function
	Init = SideFunction.init
	SaveDict = SideFunction.saveDict
	ParseDict = SideFunction.parseDict

	%Test init
	D = {Init}
	{System.show {AlterDictionary.get D "America"}}

	%Test SaveDict
	D = {AlterDictionary.new}
	local IsDone in
	P = {SaveDict 2 D IsDone}

	{Send P ('Hello'#'World')}
	{Send P ('Hello'#'World')}
	{Send P ('Hello'#'World')}
	{Send P ('Hello'#'ya')}
	{Send P 0}
	{Send P ('Hi'#'how')}
	{Send P 0}

	if (IsDone == true) then skip end %Waiting for IsDone to be assigned

	
	local TestWorked in
	TestWorked = {NewCell true}
	if {AlterDictionary.get D ('Hello'#'World')} \= 3 then TestWorked:=false end
	if {AlterDictionary.get D ('Hi'#'how')} \= 1 then TestWorked:=false end


	if @TestWorked then {System.show 'SaveDict test: completed'}
	else {System.show 'SaveDict test: failed'}
	end
	end

	%Test parseDict
	D2 = {AlterDictionary.new}
	{AlterDictionary.put D2 ('America'#'is') 4}
	{AlterDictionary.put D2 ('America'#'suck') 2}
	{AlterDictionary.put D2 ('Yolo'#'swag') 100}
	
	DParsed = {ParseDict D2}
	
	local TestWorked in
	TestWorked = {NewCell true}

	if {AlterDictionary.get DParsed 'America'}\='is' then TestWorked := false end
	if {AlterDictionary.get DParsed 'Yolo'}\='swag' then TestWorked := false end

	if @TestWorked then {System.show 'ParseDict test: completed'}
	else {System.show 'ParseDict test: failed'}
	end
	end

	%Test AddToEnd
	local TestWorked in

		TestWorked = {NewCell true}

		if{SideFunction.addToEnd "Donal" "d"} \= "Donald" then TestWorked := false end
	end
/*
	%AlterDict test
	DAlter = {AlterDictionary.new}
	{AlterDictionary.put DAlter 2#3 7}
	{AlterDictionary.put DAlter 2#3 8}
	{AlterDictionary.put DAlter 2#4 1}

	{System.show {AlterDictionary.isIn DAlter 2#3}}
	{System.show {AlterDictionary.entries DAlter}.2.1}
	{System.show {AlterDictionary.keys DAlter}.2.1}
	{System.show {AlterDictionary.items DAlter}.2.1}
*/
	{Application.exit 0}
	end
end
