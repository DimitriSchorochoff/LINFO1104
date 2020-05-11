functor
import
	Browser
	System
export
	funToExport:FunToExport
	readFile.ReadFile
	parseLine:ParseLine
	parseWords:ParseWords

define
	proc {FunToExport} skip end


	proc{ReadFile InFile}
		fun {Recur N}
            Line
        in
            Line = {Reader.scan File N}   %pas sur de si j'ai bien utilisé la fonction externe
            if Line == none then nil
            else Line|{Recur N+1} end
        end
    in
		{Recur 0}
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
		of nil then skip
		[] H|T then {TwoGram H T}
		else {Browse 2} end

	end

	
end
