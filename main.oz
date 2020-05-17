functor
import
    QTk at 'x-oz://system/wp/QTk.ozf'
    System
    Application
    OS
    Browser
    AlterDictionary
    SideFunction
    Reader
define
%%% Easier macros for imported functions
    Init = SideFunction.init
    Browse = Browser.browse
    Show = System.show

%%% Read File
    fun {GetFirstLine IN_NAME}
        {Reader.scan {New Reader.textfile init(name:IN_NAME)} 1}
    end

%%% Make the dictionary
D = {Init}

%%% GUI
    % Make the window description, all the parameters are explained here:
    % http://mozart2.org/mozart-v1/doc-1.4.0/mozart-stdlib/wp/qtk/html/node7.html)
    Text1 Text2 Description=td(
        title: "Frequency count"
        lr(
            text(handle:Text1 width:28 height:5 background:white foreground:black wrap:word)
            button(text:"Prediction" action:Press)
	    glue:w
        )
	lr(
            text(handle:Text2 width:28 height:5 background:black foreground:white glue:w wrap:word)
	    button(text:"Add predict" action:AddPredict)
	    glue:w
	)
        action:proc{$}{Application.exit 0} end % quit app gracefully on window closing
    )
    proc {Press} Inserted Filtered Pred in
        Inserted = {Text1 getText(p(1 0) 'end' $)} % example using coordinates to get text
	Filtered = {SideFunction.lastWord Inserted}
	Pred = {AlterDictionary.condGet D Filtered "No prediction"}
	{Text2 set(1:Pred)} % you can get/set text this way too
    end


    proc {AddPredict} Inserted Filtered Filtered2 Pred in
	Inserted = {Text1 getText(p(1 0) 'end' $)}
	Filtered = {SideFunction.lastWord Inserted}
	Filtered2 = {Append {List.take Inserted {List.length Inserted}-1} " "}
	Pred = {AlterDictionary.condGet D Filtered ""}
	
	{Text1 set(1:{Append Filtered2 Pred})}
    end
	
    % Build the layout from the description
    W={QTk.build Description}
    {W show}

    {Text1 bind(event:"<Control-s>" action:Press)} % You can also bind events
    {Text1 bind(event:"<Control-d>" action:AddPredict)}
end
