Rem
	bbdoc: Sprite animation style for timed animations.
	about: Allows you to show an animation for a user-specified period of time.
End Rem
Type TTimedAnimation Extends TAnimation

	Const DEFAULT_ANIMATION_LENGTH:Int = 10000 'default in ms
	
	Field animation:TAnimation
	Field animationLength:Int
	Field finishTime:Int
	
	Method New()
		animationLength:Int = DEFAULT_ANIMATION_LENGTH
	End Method
	
	Method SetAnimationTime(animationLength:Int)
		Self.animationLength = animationLength
	End Method
	
	Method SetAnimation(animation:TAnimation)
		Self.animation = animation
	End Method
	
	Method Reset()
		finishTime = null
		animation.Reset()
		Super.Reset()
	End Method
	
	Method Update:Int(sprite:TActor)
		If Not animation Then Throw "TTimedAnimation does not have an assigned TSpriteAnimation"
		If Not finishTime Then finishTime = MilliSecs() + animationLength
		If finishTime - MilliSecs() > 0
			animation.Update(sprite)
		Else
			isFinished = True
		End If
		Return Finished()
	End Method
	
End Type
