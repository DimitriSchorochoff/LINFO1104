functor
import
	Browser
	System
export
	funToExport:FunToExport
	parseLine:ParseLine
	parseWords:ParseWords

define
	proc {FunToExport} skip end


	fun{ParseLine Text}

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
			of 32|T then  %trucs qui separent des mots mais pas les phrases (espace)

				if AccWord == nil then {Split T nil AccPhrase}
				else {Split T nil {AddToEnd AccPhrase AccWord}}
				end

			of 130|T then  %trucs qui separent des mots mais pas les phrases (,)

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

	fun {OneGram Words OtherPhrases}

		case Words 
		of nil then   %a priori ce cas est useless, a enlever si on voit que ca marche sans
			{ParseWords OtherPhrases}
		[] H|nil then 
			{ParseWords OtherPhrases}
		[] W1|W2|T then 
			(W1#W2)|{OneGram W2|T OtherPhrases}
		else 1 end
		
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
			((W1#W2#W3)|{TwoGram W2|W3|T OtherPhrases}
		else 1 end
		
	end

	fun{ParseWords Ptext}

		case Ptext
		of nil then nil
		[] H|T then {TwoGram H T}
		else 2 end

	end

	
end
