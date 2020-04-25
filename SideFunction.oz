declare
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


fun {LaunchServer}
   local S P ComputeProcess in
      {NewPort S P}
      ComputeProcess = {FunProcessMaker Compute}
      thread {ComputeProcess S} end

      P
   end
end

