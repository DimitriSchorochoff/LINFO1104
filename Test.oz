functor
import
	Browser
	System
	Application
	Reader
define
	D = {Dictionary.new}
%	{Dictionary.put D 1 2}
%	{Dictionary.put D 1 3}

%	{System.show {Dictionary.condGet D 1 0}}
%	{System.show {Dictionary.condGet D 2 0}}
	{System.show 2}
	{Application.exit 0}
end
