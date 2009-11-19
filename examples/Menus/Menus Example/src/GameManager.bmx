
'Const GAME_MANAGER_CHANNEL:Int = 0

Type MyGameManager Extends TGameManager
	
	Field MenuManager:TMenuManager
	Field layerManager:TLayerManager

	Method MessageListener(message:TMessage)
		Select message.messageID
			Case MSG_KEY
				HandleKeyboardMessages(message)
			Case MSG_MENU
				HandleMenuMessages(message)
		End Select
	End Method
	
	Method HandleKeyboardMessages(message:TMessage)
		Local data:TKeyboardMessageData = TKeyboardMessageData(message.data)
		Select data.key
			Case KEY_UP
				If data.keyHits Then MenuManager.PreviousItem()
			Case KEY_DOWN
				If data.keyHits Then MenuManager.NextItem()
			Case KEY_LEFT
				If data.keyHits Then MenuManager.PreviousOption()
			Case KEY_RIGHT
				If data.keyHits Then MenuManager.NextOption()
			Case KEY_ENTER
				If data.keyHits Then MenuManager.DoItemAction()
		End Select
	End Method
	
	Method HandleMenuMessages(message:TMessage)
		Local data:TMenuMessageData = TMenuMessageData(message.data)
		Select data.action
			Case MENU_ACTION_QUIT
				Quit()
			Case MENU_ACTION_GRAPHICS_APPLY						' apply the set options in the graphics menu (built-in menu)
				MenuManager.ApplyGraphicsMenu()
		End Select
	End Method
	
	
	Method Quit()
		TGameEngine.GetInstance().Stop()
	End Method
	
	
	Method New()
	End Method
		
		
	Method Render(tweening:Double, fixed:Int)
		'TODO
	End Method

	' The Start() method is called after all engine services have been started, therefore
	' the graphics context has been create and all engine facilities should be available.
	' This is basically were we do our game initialisation, and kick things off.		
	Method Start()
		SetUpMenus()

		layerManager = New TLayerManager
		layerManager.CreateLayer(0, "main")
		layerManager.AddRenderableToLayerById(menuManager, 0)

		TMessageService.GetInstance().SubscribeToChannel(CHANNEL_INPUT, Self)			' get keyboard input
		TMessageService.GetInstance().SubscribeToChannel(CHANNEL_MENU, Self)			' get messages from menu action items
	End Method
		
	Method Stop()
		TMessageService.GetInstance().UnsubscribeAllChannels(Self)
	End Method
	
	Method SetUpMenus()
		MenuManager = New TMenuManager
		Local m:TMenu
		Local a:TActionMenuItem
		Local s:TSubMenuItem
		Local i:TOptionMenuItem
		Local o:TMenuOption
		
		'
		'main menu
		
		m = New TMenu
		m.SetFooterColor(255, 0, 0)					' set ugly color!
		m.SetLabel("Main Menu")
		MenuManager.AddMenu(m)
		
		menuManager.SetMenuYpos(rrGetGraphicsHeight() - 300)
		
		
		a = New TActionMenuItem
		a.SetText("Start", "begin the game")
		
		' make this item create a game start message.
		a.SetAction(MENU_ACTION_START)
		menumanager.additemtomenu(m, a)
		
		s = New TSubMenuItem
		s.SetText("Options", "configure stuff")
		
		'this item send you to the options menu.
		s.SetNextMenu("Options")
		menumanager.additemtomenu(m, s)
		
		a = New TActionMenuItem
		a.SetText("Exit", "chicken out")
		
		' make this menu item create a game quit message.
		a.SetAction(MENU_ACTION_QUIT)
		menumanager.additemtomenu(m, a)
		
		'
		'options menu
		
		m = New TMenu
		m.SetLabel("Options")
		MenuManager.AddMenu(m)

		s = New TSubMenuItem
		s.SetText("Graphics", "configure screen stuff")
		
		' name of built-in menu. don't change. the menu is created at the bottom of this method.
		s.SetNextMenu("Configure Graphics")
		menumanager.additemtomenu(m, s)
		
		i = New TOptionMenuItem
		i.SetText("Sillyness", "left and right to select sillyness")
		menumanager.additemtomenu(m, i)
		o = New TMenuOption
		o.SetLabel("Reasonable")
		i.AddOption(o)
		o = New TMenuOption
		o.SetLabel("Totally")
		i.AddOption(o)
		o = New TMenuOption
		o.SetLabel("Insane")
		i.AddOption(o)
		
		' this item now saves the selected option to the config file (ini file)		
		i.EnableGameSetting()
				
		s = New TSubMenuItem
		s.SetText("Back", "back to main menu")
		
		' this forces a 'go back'
		s.SetNextMenu("back")
		menumanager.additemtomenu(m, s)
		
		'create built-in menu called "Configure Graphics"... only show 60 hz modes, and don't care about depth.
		MenuManager.BuildGraphicsMenu(60, 0)
		
		MenuManager.SetCurrentMenu(MenuManager.GetMenuByName("Main Menu"))
	End Method
	
	Method ToString:String()
		Return "Game Manager:" + Super.ToString()
	End Method
	
	Method Update()
	End Method
	
End Type



