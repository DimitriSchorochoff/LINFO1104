functor
export
	new:New
	put:Put
	get:Get
	condGet:CondGet
	keys:Keys
	entries:Entries
	items:Items
	isEmpty:IsEmpty

define
	fun {New}
		%Indice 0 of DictKey correspond to newIndex
		local DictKey in
			DictKey = {NewDictionary}
			{Dictionary.put DictKey 0 1}
			
			DictKey#{NewDictionary}
		end
	end

	proc {Put D K V}
		if ({Not {IsEmpty D}}) then
		%Check if K is already a Key
		for Entry in {Dictionary.entries D.1} do
			if K == Entry.2 then {Dictionary.put D.2 Entry.1 V} end
		end
		end

		local Index in
			Index = {Dictionary.get D.1 0}
			
			{Dictionary.put D.1 Index K}
			{Dictionary.put D.2 Index V}
			
			{Dictionary.put D.1 0 Index+1}
		end
	end

	proc {Get D K ?R}
		local C in
			C = {NewCell nil} %If nothing is found return nil
		for Entry in {Dictionary.entries D.1} do
			if (K == Entry.2) then 
				C := {Dictionary.get D.2 Entry.1}
			 end
		end
		R = @C
		end
	end

	fun {CondGet D K DefV}
		local R in
			R = {Get D K}

			if R == nil then DefV
			else R
			end
		end
	end
	
	proc {Keys D ?R}
		if ({IsEmpty D}) then R=nil
		else
		local L in
			L = {NewCell nil}

			for Index in 1..({Dictionary.get D.1 0}-1) do
				L := {Dictionary.get D.1 Index}|@L
			end		
			R=@L
		end
		end
	end


	proc {Entries D ?R}
		if ({IsEmpty D}) then R=nil
		else
		local L in
			L = {NewCell nil}
			
			for Index in 1..({Dictionary.get D.1 0}-1) do
				local Key Val in
					Key = {Dictionary.get D.1 Index}
					Val = {Dictionary.get D.2 Index}
				
					L :=(Key#Val)|@L
				end
			end
			R=@L
		end
		end
	end

	fun {Items D}
		local L in
			L = {NewCell nil}
			
			for V in {Dictionary.items D.2} do
				L := V|@L
			end
			@L
		end
	end

	fun {IsEmpty D} ({Dictionary.get D.1 0} == 1) end

end
