declare

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
      thread {ParseLine S P} end
   end

   {LaunchThread NumFile-1 P}
end

%Param
NumFile = 208

%Main
Dict = {Dictionary.new}
P = {SaveDict NumFile Dict}

{LaunchThread NumFile P}


%PART SaveDict

fun {FunProcessMaker F}
   local FunProcess in
      proc {FunProcess S}
	 case S of S1|S2 then
	    {F S1}
	    {FunProcess S2}
	 end
      end
      FunProcess
   end
end

fun {FunProcessMakerTwoArg F A NumFile}
   local FunProcess in
      proc {FunProcess S}
	 case S of S1|S2 then
	    {F S1 A NumFile}
	    {FunProcessOneArg S2 A NumFile}
	 end
      end
      FunProcess
   end
end

fun {ProcessMajDict S NumThread Dict}
   case S of S1|S2 then
% Detect signal and end if last thread ended
      if S1 == 0 then
	 if NumThread == 1 then skip
	 else {ProcessMajDict S2 NumThread-1 Dict}
	 end

%Common way
      else
	 {MajDict S1 Dict}
	 {ProcessMajDict S NumThread Dict}
      end
   end
end


proc {MajDict Tuple Dict}
   {Dict.put Tuple {Dict.condGet Tuple 0}+1}
end


fun {SaveDict NumFile Dict}
   local S P in
      {NewPort S P}
      thread {ProcessMajDict S NumFile Dict} end
      
      P
   end
end


fun {ParseDict Dict}
   local DictMot DictVal in
      DictMot = {Dictionary.new}
      DictVal = {Dictionary.new}
      
      for Entry in {Dict.entries} do
	 % Entry format: (Key#Pred)#Value
	 local Key Pred Value
	    Key = Entry.1.1
	    Pred = Entry.1.2
	    Value Entry.2

	    if Value > {DictVal.condGet Key 0} then
	       {DictMot.put Key Pred}
	       {DictVal.put Key Value}
	    end
	 end
      end
      
      DictMot
   end
end