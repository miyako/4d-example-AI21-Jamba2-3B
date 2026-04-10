var $event : Object
$event:=FORM Event:C1606

Case of 
	: ($event.code=On Load:K2:1)
		
		If (Not:C34(OB Instance of:C1731(Form:C1466; cs:C1710._Agent)))
			OBJECT SET VISIBLE:C603(*; "@"; False:C215)
			return 
		End if 
		
		var $text : Text
		$text:=File:C1566("/RESOURCES/sample.txt").getText()
		
		Form:C1466.systemPrompt:="You are a helpful assistant.\n"+"Answer questions about the following document:\n"+$text
		Form:C1466.userPrompt:="What is being discussed? (document length="+String:C10(Length:C16($text))+")"
		Form:C1466.focusUserPrompt().clearConversation()
		
	: ($event.code=On After Edit:K2:43)
		
		Form:C1466.onAfterEdit()
		
	: ($event.code=On Unload:K2:2)
		
End case 