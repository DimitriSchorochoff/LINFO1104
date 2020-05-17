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
	%Init = SideFunction.init
	SaveDict = SideFunction.saveDict
	MergeDict = SideFunction.mergeDict
	ParseDict = SideFunction.parseDict
	
	/*
	%Test init
	Dicti = {Init}
	{System.show {AlterDictionary.get Dicti "America"}}
	*/

	%Test SaveDict
	local F in
	P = {NewPort F} 
	S = ('Hello'#'World')|('Hello'#'World')|('Yo'#'bro')|nil
	{SaveDict S P}

	D = F.1

	
	local TestWorked in
	TestWorked = {NewCell true}
	if {AlterDictionary.get D ('Hello'#'World')} \= 2 then TestWorked:=false end
	if {AlterDictionary.get D ('Yo'#'bro')} \= 1 then TestWorked:=false end


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

	%Test MergeDictionary
	local P	Dictio IsDone Dict1 Dict2 TestWorked in
		Dictio = {AlterDictionary.new}
		P = {MergeDict Dictio 2 IsDone}


		Dict1 = {AlterDictionary.new}
		{AlterDictionary.put Dict1 ("America"#"is") 3}
		{AlterDictionary.put Dict1 ("Yolo"#"Swag") 2}
		
		{Send P Dict1}

		Dict2 = {AlterDictionary.new}
		{AlterDictionary.put Dict2 ("America"#"is") 7}
		{AlterDictionary.put Dict2 ("Yolo"#"Damn") 1}
		
		{Send P Dict2}
		
		if IsDone == true then skip end
		
		TestWorked = {NewCell true}
	
		if {AlterDictionary.get Dictio ("America"#"is")} \= 10 then TestWorked:=false end
		if {AlterDictionary.get Dictio ("Yolo"#"Swag")} \= 2 then TestWorked:= false end
		if {AlterDictionary.get Dictio ("Yolo"#"Damn")} \= 1 then TestWorked:= false end

		if @TestWorked then {System.show 'MergeDict test: completed'}
		else {System.show 'MergeDict test: failed'}
		end
	end


	%Test AddToEnd
	local TestWorked A B in

		TestWorked = {NewCell true}

		if{SideFunction.addToEnd "Donal" 100} \= "Donald" then TestWorked := false end
		if{SideFunction.addToEnd ["Make" "America" "Great"] "Again"} \= ["Make" "America" "Great" "Again"] then TestWorked := false end

		if @TestWorked then {System.show 'AddToEnd test: completed'}
		else {System.show 'AddToEnd test: failed'}
		end
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
