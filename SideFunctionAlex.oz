functor
import
	Browser
	System
export
	funToExport:FunToExport

define
	proc {FunToExport} skip end
end

proc{ParseLine Lines StreamOut}

   	fun{SeparateWords Lines Acc}
		fun{AddToEnd Target ToPut} 
			case Target
			of emptyword then	
				if ToPut == nil then emptyword

			[] H|T then H|{AddToEnd T ToPut}
			else Target|ToPut 
			end
		end
		Word
	in
		case Lines
		of 32|T then  %mettre d'autres nbres si on 
			Word = {AddToEnd Acc nil}
			if Word == nil then {SeparateWords T emptyword}
			else Word|{SeparateWords T emptyword} end
		[] H|T then
			{SeparateWords T {AddToEnd Acc H}}		
		[] nil then 
		end
	end

in
	case Lines
	of H|T then
		%send le H a StreamOut, comment on fait deja?
		{ParseLine T StreamOut}

	[] nil then %envoyer nil au stream
	end
end
	