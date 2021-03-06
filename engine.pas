unit Engine;

interface
	uses
		outputcolor,
		effects,
		conditions,
		types;
		
	procedure Playing(var hero: THero; var antiHero: THero; locations: TLocations; location: TLocation; event: TEvent);
	function Fall(var hero: THero; var antiHero: THero; locations: TLocations; var location: TLocation; var event: TEvent): Boolean;
	function ChangeLocation(locations: TLocations; var location: TLocation; transition: TTransition): Boolean;
	function ChangeEvent(events: TEvents; var event: TEvent; toEvent: String): Boolean;
	function ChooseTransition(hero: THero; antiHero: THero; transitions: TTransitions; var transition: TTransition): Boolean;
	function ChooseCommand(commands: TCommands; var cmd: String; var command: TCommand): Boolean;
	procedure PrintEvent(event: TEvent);
	procedure PrintStatsHero(hero: THero);
	procedure PrintCommand(command: TCommand);
	procedure PrintTransition(transition: TTransition);
	
implementation
	procedure PrintStatsHero(hero: THero);
	begin
		ColorWrite('=======ХАРАКТЕРИСТИКИ ПЕРСОНАЖА=======',ColorDefault,1);
		ColorWrite('Здоровье: ', ColorAttribute);
		ColorWrite(hero.health, ColorNumber);
		ColorWrite('0%', ColorNumber, 1);
		ColorWrite('Бодрость: ', ColorAttribute);
		ColorWrite(hero.energy, ColorNumber);
		ColorWrite('0%', ColorNumber, 1);
		ColorWrite('Содержание алкоголя: ', ColorAttribute);
		ColorWrite(hero.alchohol, ColorNumber);
		ColorWrite('0%', ColorNumber, 1);
		ColorWrite('Накуренность: ', ColorAttribute);
		ColorWrite(hero.vape, ColorNumber);
		ColorWrite('0%', ColorNumber, 1);
		ColorWrite('Сила: ',ColorAttribute);
		ColorWrite(hero.strength, ColorNumber);
		ColorWrite('0%', ColorNumber, 1);
		ColorWrite('Интеллект: ',ColorAttribute);
		ColorWrite(hero.intelligence, ColorNumber);
		ColorWrite('0%', ColorNumber, 1);
		ColorWrite('Удача: ',ColorAttribute);
		ColorWrite(hero.fortune, ColorNumber);
		ColorWrite('0%', ColorNumber, 1);
		ColorWrite('Счастье: ',ColorAttribute);
		ColorWrite(hero.happy, ColorNumber);
		ColorWrite('0%', ColorNumber, 1);
		ColorWrite('Репутация в группе: ',ColorAttribute);
		ColorWrite(hero.reputationInGroup, ColorNumber);
		ColorWrite('0%', ColorNumber, 1);
		ColorWrite('Репутация в универе: ',ColorAttribute);
		ColorWrite(hero.reputationInUnderworld, ColorNumber);
		ColorWrite('0%', ColorNumber, 1);
		ColorWrite('======================================', ColorDefault, 1);
	end;
	
	procedure PrintEvent(event: TEvent);
	var I: Integer;
	begin
		if event.isMultiLine then
		begin
			for I := 0 to Length(event.texts) - 1 do
			begin
				ColorWrite(event.texts[I].text, event.texts[I].color, 1);
			end;
		end
		else
		begin
			ColorWrite(event.text.text, event.text.color, 1);
 		end;
 
		for I := 0 to Length(event.commands) - 1 do
		begin
			ColorWrite(event.commands[I].cmd, ColorNumber);
			ColorWrite(': ', ColorDefault);
			ColorWrite(event.commands[I].name.text, event.commands[I].name.color, 1);
		end;
		ColorWrite('Введите команду: ', ColorDefault);
	end;
	
	function ChooseCommand(commands: TCommands; var cmd: String; var command: TCommand): Boolean;
	var 
		I: Integer;
	begin
		ReadLn(cmd);
		for I := 0 to Length(commands) - 1 do
		begin
			if commands[I].cmd = cmd then
			begin
				command := commands[I];
				Exit(True);
			end;
		end;

		Exit(False);	
	end;
	
	procedure PrintCommand(command: TCommand);
 	var
 		I: Integer;
 	begin
 		if command.isMultiLine then
 		begin
 			for I := 0 to Length(command.texts) - 1 do
 			begin
 				ColorWrite(command.texts[I].text, command.texts[I].color, 1);
 			end;
 		end
 		else
 		begin
 			ColorWrite(command.text.text, command.text.color, 1);
 		end;
 	end;
 
	procedure PrintConditionText(condition: TCondition);
	var
		I: Integer;
	begin
		if condition.isMultiLine then
 			for I := 0 to Length(condition.texts) - 1 do
 				ColorWrite(condition.texts[I].text, condition.texts[I].color, 1)
 		else
			ColorWrite(condition.text.text, condition.text.color, 1);
	end;
	
	procedure PrintCommandConditions(hero, antiHero: THero; conditions: TConditions);
	var
		I: Integer;
	begin
		for I := 0 to Length(conditions) - 1 do
		begin
			if CheckCondition(hero, antiHero, conditions[I]) then
				PrintConditionText(conditions[I]);
		end;
	end;
		
	function ChooseTransition(hero: THero; antiHero: THero; transitions: TTransitions; var transition: TTransition): Boolean;
	var
		I: Integer;
	begin
		for I := 0 to Length(transitions) - 1 do
		begin			
			if (CheckConditions(hero, antiHero, transitions[I].conditions)) then
			begin
				transition := transitions[I];					
				Exit(True);
			end;
		end;
	end;
	
	procedure PrintTransition(transition: TTransition);
	var
		I: Integer;
	begin
		if transition.isMultiLine then
		begin
			for I := 0 to Length(transition.texts) - 1 do
 			begin
 				ColorWrite(transition.texts[I].text, transition.texts[I].color, 1);
 			end;
 		end
 		else
 		begin
			if transition.text.text <> '' then
				ColorWrite(transition.text.text, transition.text.color, 1);
 		end;
	end;
	
	function ChangeEvent(events: TEvents; var event: TEvent; toEvent: String): Boolean;
	var
		I: Integer;
	begin
		if toEvent <> '' then
		begin
			for I := 0 to Length(events) - 1 do
			begin
				if events[I].name.text = toEvent then
				begin	
					event := events[I];
					Exit(True);
				end;	
			end;	
		end;
		Exit(False);
	end;
	
	function ChangeLocation(locations: TLocations; var location: TLocation; transition: TTransition): Boolean;
	var
		I: Integer;
	begin
		if (transition.toLocation <> '') and (transition.toLocation <> location.name.text) then
		begin
			for I := 0 to (Length(locations) - 1) do
			begin
				if locations[I].name.text = transition.toLocation then
				begin	
					location := locations[I];
					ColorWrite('Переход на локацию "', ColorTransLocation);
					ColorWrite(transition.toLocation, ColorLocation);
					ColorWrite('" ', ColorTransLocation);
					ColorWrite('к событию "', ColorTransLocation);
					ColorWrite(transition.toEvent, ColorEventName);
					ColorWrite('" ', ColorTransLocation, 1);
					Exit(True);
				end;	
			end;	
		end;
		Exit(False);
	end;
	
	function Fall(var hero: THero; var antiHero: THero; locations: TLocations; var location: TLocation; var event: TEvent): Boolean;
	var
		isFalling: Boolean;
		command: TCommand;
		transition: TTransition;
		cmd: String;
	begin	
		cmd := '';
		PrintStatsHero(hero);
		PrintEvent(event);
		isFalling := ChooseCommand(event.commands, cmd, command);
		if not isFalling then
		begin
			Exit(not (cmd = 'exit'));
		end;
		PrintCommand(command);
		PrintCommandConditions(hero, antiHero, command.conditions);
		ChooseTransition(hero, antiHero, command.transitions, transition);
		PrintTransition(transition);
		Affect(hero, antiHero, transition.effects);
		ChangeLocation(locations, location, transition);
		isFalling := ChangeEvent(location.events, event, transition.toEvent);		
		Exit(isFalling);
	end;
	
	procedure Playing(var hero: THero; var antiHero: THero; locations: TLocations; location: TLocation; event: TEvent);
	var
		isFalling: Boolean;
	begin		
		repeat
			isFalling := Fall(hero, antiHero, locations, location, event);
		until (not isFalling);
	end;
end.