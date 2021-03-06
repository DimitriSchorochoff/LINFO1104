functor
import
	Browser
	System
	AlterDictionary
	Reader
export
	init:Init
	
	%For testing
	readFile:ReadFile
	parseLine:ParseLine
	parseWords:ParseWords
	filename:Filename
	saveDict:SaveDict
	mergeDict:MergeDict
	parseDict:ParseDict
	addToEnd:AddToEnd
	lastWord:LastWord
	lastTwoWords:LastTwoWords

define
%Param
NumFile = 4

%PART Init
%Function
fun {Filename N}
   local P1 P2 in
      P1 = "tweets/part_"
      P2 = {Append P1 {Int.toString N}}

      {Append P2 ".txt"}
   end
end 

%Main
fun {Init}
	local Dict P IsDone in
		Dict = {AlterDictionary.new}
		P = {MergeDict Dict NumFile IsDone}

		for I in 1..NumFile do
			local S1 S2 S3 in
				thread S1 = {ReadFile {Filename I}} end
				thread S2 = {ParseLine S1} end
				thread S3 = {ParseWords S2} end

				{SaveDict S3 P}
			end
		end
		
		if IsDone then skip end

		{ParseDict Dict}
	end
end

%PART SaveDict	
proc {ProcessMajDict S Dict P}
	case S of 
		nil then {Send P Dict}
		[] S1|S2 then 
			{MajDict S1 Dict} 
			{ProcessMajDict S2 Dict P}
	end
end


proc {MajDict Tuple Dict}
   {AlterDictionary.put Dict Tuple {AlterDictionary.condGet Dict Tuple 0}+1}
end


proc {SaveDict S P}
	thread {ProcessMajDict S {AlterDictionary.new} P} end
end


%Merge Dictionary
fun {MergeDict Dict Num IsDone}
	local P S in
		P = {NewPort S}
		thread {ProcessMergeDictionaries S Dict Num IsDone} end
		P 
	end
end


proc {ProcessMergeDictionaries S Dict Num IsDone}
	if Num == 0 then IsDone = true
	else
		case S of S1|S2 then
		
		for Entry in {AlterDictionary.entries S1} do
			local Value in
				Value = {AlterDictionary.condGet Dict Entry.1 0}
				{AlterDictionary.put Dict Entry.1 Value+Entry.2}
			end
		end
		
		{ProcessMergeDictionaries S2 Dict Num-1 IsDone}
		end
	end
end	

fun {ParseDict Dict}
   local DictMot DictVal in
      DictMot = {AlterDictionary.new}
      DictVal = {AlterDictionary.new}
      
      for (Key#Pred)#Value in {AlterDictionary.entries Dict} do
	    if Value > {AlterDictionary.condGet DictVal Key 0} then
	       {AlterDictionary.put DictMot Key Pred}
	       {AlterDictionary.put DictVal Key Value}
	    end
      end
      
      DictMot
   end
end

    fun{ReadFile Filename}
        fun {Recur InFile}
            Line = {InFile getS($)}
        in
            if Line == false then
                {InFile close}
                nil
            else 
                Line|{Recur InFile}
            end
        end
    in
        {Recur {New Reader.textfile init(name:Filename)} }
    end



	fun{AddToEnd Target ToPut} 
		case Target
		of nil then	
			if ToPut == nil then nil
			else ToPut|nil end
		[] H|nil then
			H|ToPut|nil
		[] H|T then H|{AddToEnd T ToPut}
		end
	end


	fun{ParseLine Text}

		fun{Split Text AccWord AccPhrase AccText}

			case Text
			of 32|T then  %trucs qui separent des mots mais pas les phrases (espace)

				if AccWord == nil then {Split T nil AccPhrase AccText}
				else {Split T nil {AddToEnd AccPhrase AccWord} AccText}
				end

			[] 10|T then %trucs qui separent les phrases (\n)
		
				if {AddToEnd AccPhrase AccWord} == nil then {Split T nil nil AccText}
				else {AddToEnd AccPhrase AccWord}|{Split T nil nil AccText}
				end

			[] 130|T then %trucs qui separent les phrases (,)

				if {AddToEnd AccPhrase AccWord} == nil then {Split T nil nil AccText}
				else {AddToEnd AccPhrase AccWord}|{Split T nil nil AccText}
				end

			[] 46|T then %trucs qui separent les phrases (.)

				if {AddToEnd AccPhrase AccWord} == nil then {Split T nil nil AccText}
				else {AddToEnd AccPhrase AccWord}|{Split T nil nil AccText}
				end

			[] 33|T then %trucs qui separent les phrases (!)
		
				if {AddToEnd AccPhrase AccWord} == nil then {Split T nil nil AccText}
				else {AddToEnd AccPhrase AccWord}|{Split T nil nil AccText}
				end
			[] 34|T then %trucs qui separent les phrases (")
		
				if {AddToEnd AccPhrase AccWord} == nil then {Split T nil nil AccText}
				else {AddToEnd AccPhrase AccWord}|{Split T nil nil AccText}
				end
			[] 63|T then %trucs qui separent les phrases (?)
		
				if {AddToEnd AccPhrase AccWord} == nil then {Split T nil nil AccText}
				else {AddToEnd AccPhrase AccWord}|{Split T nil nil AccText}
				end
			[] 58|T then %trucs qui separent les phrases (:)
		
				if {AddToEnd AccPhrase AccWord} == nil then {Split T nil nil AccText}
				else {AddToEnd AccPhrase AccWord}|{Split T nil nil AccText}
				end
			[] 59|T then %trucs qui separent les phrases (;)
		
				if {AddToEnd AccPhrase AccWord} == nil then {Split T nil nil AccText}
				else {AddToEnd AccPhrase AccWord}|{Split T nil nil AccText}
				end
			[] 13|T then %trucs qui separent les phrases (une sorte de \n il semblerait)
		
				if {AddToEnd AccPhrase AccWord} == nil then {Split T nil nil AccText}
				else {AddToEnd AccPhrase AccWord}|{Split T nil nil AccText}
				end

			[] H|T then   %juste une lettre normale

				{Split T {AddToEnd AccWord H} AccPhrase AccText}
						
			[] nil then   %la fin de tout le texte
				if {AddToEnd AccPhrase AccWord} == nil then {ParseLine AccText}
				else {AddToEnd AccPhrase AccWord}|{ParseLine AccText} end

			end
		end
		

				
	in
		case Text 
		of H|T then 
			{Split H nil nil T}
		[] nil then nil end
	end

	fun {OneGram Words OtherPhrases}

		case Words 
		of nil then   %a priori ce cas est useless, a enlever si on voit que ca marche sans
			{ParseWords OtherPhrases}
		[] H|nil then 
			{ParseWords OtherPhrases}
		[] W1|W2|T then 
			%{Send Port (W1#W2)}
			(W1#W2)|{OneGram W2|T OtherPhrases}
		end
		
	end


	fun {TwoGram Words OtherPhrases}

		case Words 
		of nil then  %a priori ce cas est useless, a enlever si on voit que ca marche sans
			{ParseWords OtherPhrases}
		[] H|nil then  %celui la aussi probablement
			{ParseWords OtherPhrases}
		[] W1|W2|nil then 
			{ParseWords OtherPhrases}
		[] W1|W2|W3|T then 
			((W1#W2)#W3)|{TwoGram W2|W3|T OtherPhrases}
		end
		
	end

	fun{ParseWords Ptext}
		case Ptext
		of nil then nil
		[] H|T then {OneGram H T}
		end
	end


	fun{GetLast Phrase}
		case Phrase
		of W|nil then W 
		[] H|T then {GetLast T}
		else nil end
	end

	fun{LastWord Text}
		LastPhrase
	in
		LastPhrase = {GetLast {ParseLine Text|nil}}
		{GetLast LastPhrase}
	end


	fun{LastTwoWords Text}
		fun{SubLastTwoWords Text}
			case Text 
			of W|nil then W 
			[] W1|W2|nil then (W1#W2)
			[] H|T then {SubLastTwoWords T}
			else nil end
		end
		LastPhrase
	in
		LastPhrase = {GetLast {ParseLine Text|nil}}
		{SubLastTwoWords LastPhrase}
	end
	
end
