fun{ParseLine Text}
    fun{Split Text AccWord AccPhrase AccText} 
		SepPhrases
		SepWords
	in
		case Text
		of H|T then
			for Char in [32] do %Separators between words
				if H == Char then
					SepWords = true
				end
			end
			case SepWords
			of true then
				if AccWord == nil then {Split T H AccPhrase AccText}
				else {Split T nil {AddToEnd AccPhrase AccWord} AccText}
			else
				skip
			end


			for Char2 in [10 130 46 33 34 63 58 59 13] do
				if H == Char2 then 
					SepPhrases = true
				end
			end

			case SepPhrases
			of true then
				if {AddToEnd AccPhrase AccWord} == nil then {Split T nil nil AccText}
				else {AddToEnd AccPhrase AccWord}|{Split T nil nil AccText}
				end
			else 
				skip
			end


			{Split T {AddToEnd AccWord H} AccPhrase AccText} 

		[] nil then 
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