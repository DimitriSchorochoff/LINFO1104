functor
export
	init:Init
	saveDict:SaveDict
	parseDict:ParseDict
	
define

%PART Init
%Function
fun {Filename N}
   local P1 P2 in
      P1 = "tweets/part_"
      P2 = {Append P1 {Int.toString N}}

      {Append P2 ".txt"}
   end
end

proc {ReadFile A} skip end
proc {ParseLine S P} skip end 

proc {LaunchThread NumFile P}
%   if NumFile == 0 then skip end
%
 %  local Fname S in
  %    Fname = {Filename NumFile}
   %   thread S = {ReadFile Fname} end
    %  thread {ParseLine S P} end
  % end
%
 %  {LaunchThread NumFile-1 P}
skip
end

%Param
NumFile = 208

%Main
proc {Init}
	local Dict P in
		Dict = {NewDictionary}
		P = {SaveDict NumFile Dict}

		{LaunchThread NumFile P}
	end
end


%PART SaveDict	

proc {ProcessMajDict S NumThread Dict}
% Detect signal and end if last thread ended
	if S.1 == 0 then 
	if NumThread==1 then skip
	else {ProcessMajDict S.2 NumThread-1 Dict}
	end

%Common way
      else
	 {MajDict S.1 Dict}
	 {ProcessMajDict S.2 NumThread Dict}
      end
end


proc {MajDict Tuple Dict}
   {Dictionary.put Dict Tuple {Dictionary.condGet Dict Tuple 0}+1}
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
      DictMot = {NewDictionary}
      DictVal = {NewDictionary}
      
      for Entry in {Dictionary.entries dict} do
	 % Entry format: (Key#Pred)#Value
	 local Key Pred Value in
	    Key = Entry.1.1
	    Pred = Entry.1.2
	    Value = Entry.2

	    if Value > {Dictionary.condGet DictVal Key 0} then
	       {Dictionary.put DictMot Key Pred}
	       {Dictionary.put DictVal Key Value}
	    end
	 end
      end
      
      DictMot
   end
end

end
