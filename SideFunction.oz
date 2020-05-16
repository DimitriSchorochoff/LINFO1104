functor
import
	Browser
	System
	AlterDictionary
	Reader
export
	readFile:ReadFile
	parseLine:ParseLine
	parseWords:ParseWords
	init:Init
	filename:Filename
	saveDict:SaveDict
	parseDict:ParseDict
	addToEnd:AddToEnd
	lastWord:LastWord
	launchThread:LaunchThread

define
Browse = Browser.browse


%PART Init
%Function
fun {Filename N}
   local P1 P2 in
      P1 = "tweets/part_"
      P2 = {Append P1 {Int.toString N}}

      {Append P2 ".txt"}
   end
end 

proc {LaunchThread NumFile P}
   if NumFile == 0 then skip end

   local Fname S in
      Fname = {Filename NumFile}
      thread S = {ReadFile Fname} end
      thread {ParseWords {ParseLine S} P} end
   end

  {LaunchThread NumFile-1 P}
end

%Param
NumFile = 208

%Main
fun {Init}
	local Dict P IsDone in
		Dict = {AlterDictionary.new}
		P = {SaveDict NumFile Dict IsDone}

		{LaunchThread NumFile P}

		{Wait IsDone}
		
		{ParseDict Dict}
	end
end


%PART SaveDict	

proc {ProcessMajDict S NumThread Dict IsDone}
% Detect signal and end if last thread ended
      if S.1 == 0 then
		if NumThread==1 then IsDone=true
		else {ProcessMajDict S.2 NumThread-1 Dict IsDone}
		end

%Common way
      else
	 {MajDict S.1 Dict}
	 {ProcessMajDict S.2 NumThread Dict IsDone}
      end
end


proc {MajDict Tuple Dict}
   {AlterDictionary.put Dict Tuple {AlterDictionary.condGet Dict Tuple 0}+1}
end


fun {SaveDict NumFile Dict IsDone}
   local S P in
      {NewPort S P}
      thread {ProcessMajDict S NumFile Dict IsDone} end
      
      P
   end
end


fun {ParseDict Dict}
   local DictMot DictVal in
      DictMot = {AlterDictionary.new}
      DictVal = {AlterDictionary.new}
      
      for Entry in {AlterDictionary.entries Dict} do
	 % Entry format: (Key#Pred)#Value
	 local Key Pred Value in
	    Key = Entry.1.1
	    Pred = Entry.1.2
	    Value = Entry.2

	    if Value > {AlterDictionary.condGet DictVal Key 0} then
	       {AlterDictionary.put DictMot Key Pred}
	       {AlterDictionary.put DictVal Key Value}
	    end
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

	proc {OneGram Words OtherPhrases Port}

		case Words 
		of nil then   %a priori ce cas est useless, a enlever si on voit que ca marche sans
			{ParseWords OtherPhrases Port}
		[] H|nil then 
			{ParseWords OtherPhrases Port}
		[] W1|W2|T then 
			{Send Port (W1#W2)}
			{OneGram W2|T OtherPhrases Port}
		else {Browse 1} end
		
	end


	proc {TwoGram Words OtherPhrases Port}

		case Words 
		of nil then  %a priori ce cas est useless, a enlever si on voit que ca marche sans
			{ParseWords OtherPhrases Port}
		[] H|nil then  %celui la aussi probablement
			{ParseWords OtherPhrases Port}
		[] W1|W2|nil then 
			{ParseWords OtherPhrases Port}
		[] W1|W2|W3|T then 
			{Send Port (W1#W2)#W3 }
			{TwoGram W2|W3|T OtherPhrases Port}
		else {Browse 1} end
		
	end

	proc{ParseWords Ptext Port}
		case Ptext
		of nil then {Send Port 0}
		[] H|T then {OneGram H T Port}
		else {Browse 2} end
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
		LastPhrase = {GetLast {GetLast Text|nil}}
		{GetLast LastPhrase}
	end


	fun{LastTwoWords Text}
		fun{SubLastTwoWords Text}
			case Text 
			of W|nil then W 
			[] H|T then {SubLastTwoWords T}
			else nil end
		end
		LastPhrase
	in
		LastPhrase = {GetLast {ParseLine Text|nil}}
		{SubLastTwoWords LastPhrase}
	end
	
end
