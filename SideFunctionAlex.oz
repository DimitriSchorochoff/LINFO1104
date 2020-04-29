functor
import
	Browser
	System
export
	funToExport:FunToExport
	parseLine:ParseLine

define
	proc {FunToExport} skip end


	proc{ParseLine Text StreamOut}

		fun{Split Text AccWord AccPhrase}

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

		in
			case Text
			of 32|T then  %trucs qui separent des mots mais pas les phrases (a priori que espace)

				if AccWord == nil then {Split T nil AccPhrase}
				else {Split T nil {AddToEnd AccPhrase AccWord}}
				end

			[] 46|T then %trucs qui separent les phrases (point)
		
				if {AddToEnd AccPhrase AccWord} == nil then {Split T nil nil}
				else {AddToEnd AccPhrase AccWord}|{Split T nil nil}
				end

			[] 33|T then %trucs qui separent les phrases (!)
		
				if {AddToEnd AccPhrase AccWord} == nil then {Split T nil nil}
				else {AddToEnd AccPhrase AccWord}|{Split T nil nil}
				end
			[] 34|T then %trucs qui separent les phrases (")
		
				if {AddToEnd AccPhrase AccWord} == nil then {Split T nil nil}
				else {AddToEnd AccPhrase AccWord}|{Split T nil nil}
				end
			[] 63|T then %trucs qui separent les phrases (?)
		
				if {AddToEnd AccPhrase AccWord} == nil then {Split T nil nil}
				else {AddToEnd AccPhrase AccWord}|{Split T nil nil}
				end
			[] 58|T then %trucs qui separent les phrases (:)
		
				if {AddToEnd AccPhrase AccWord} == nil then {Split T nil nil}
				else {AddToEnd AccPhrase AccWord}|{Split T nil nil}
				end
			[] 59|T then %trucs qui separent les phrases (;)
		
				if {AddToEnd AccPhrase AccWord} == nil then {Split T nil nil}
				else {AddToEnd AccPhrase AccWord}|{Split T nil nil}
				end

			[] H|T then   %juste une lettre normale

				{Split T {AddToEnd AccWord H} AccPhrase}
						
			[] nil then   %la fin de tout le texte
				if {AddToEnd AccPhrase AccWord} == nil then nil
				else {AddToEnd AccPhrase AccWord}|nil end

			end
		end

	in
		{Split Text nil nil}
	end
	
end
