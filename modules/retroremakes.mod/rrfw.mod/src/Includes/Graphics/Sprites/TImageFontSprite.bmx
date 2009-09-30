'This BMX file was edited with BLIde ( http://www.blide.org )
Rem
	bbdoc:Undocumented type
End Rem
Type TImageFontSprite Extends TSprite

	Field font:TImageFont
	
	Field spriteText:String
	Field width:Float
	Field height:Float
	Field midWidth:Float
	Field midHeight:Float
	Field midHandle:Int

	Method SetFont(font:TImageFont)
		Self.font = font
	End Method
	
	Method SetText(text:String)
		spriteText = Text
	End Method
	
	Method SetMidHandle(bool:Int)
		midHandle = bool
	End Method
	
	Method Render(tweening:Double, fixed:int)
		Interpolate(tweening)
		SetRenderState()
		If font And IsVisible()
			Local xOffset:Float = 0.0
			Local yOffset:Float = 0.0
			If midHandle
				If midWidth = 0.0 And midHeight = 0.0
					SetImageFont(font)
					midWidth = TextWidth(spriteText) / 2
					midHeight = TextHeight(spriteText) / 2
				End If
				xOffset = midWidth * GetXScale()
				yOffset = midHeight * GetYScale()
			End If
			SetImageFont(font)
			if fixed
				DrawText(spriteText, int(renderPosition_.x - xOffset), int(renderPosition_.y - yOffset))
			else
				DrawText(spriteText, renderPosition_.x - xOffset, renderPosition_.y - yOffset)
			endif
		EndIf
	End Method

	Method RenderFixed(tweening:Double)
	End Method
End Type
