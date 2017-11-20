class AnimationManager {
	
	AnimationBase currentAnimation;
	AnimationBase nextAnimation;

	Boolean startAnimation = true;

	final float alphaSpeed = .05;
	float animationAlpha = 0;
	float alphaTarget = 1;

	public AnimationManager() {}

	public void display() {
		colorMode(RGB, 255);
		background(0, 255 - 255*animationAlpha)
		animationAlpha += (alphaTarget - animationAlpha) * alphaSpeed;
		if(abs(animationAlpha - alphaTarget) < .05){
			animationAlpha = alphaTarget;
			if(alphaTarget == 0){
				console.log("BOOM");
				currentAnimation = nextAnimation;
				alphaTarget = 1;
			}
		}
		// console.log("currentAnimation: " + currentAnimation.name + ", alphaTarget: " + alphaTarget + ", animationAlpha: " + animationAlpha)
		currentAnimation.display();

		// transition animation fade
		// draw a rectangle on the main sketch, above the currentAnimation
		fill(0, 255 - 255*animMgr.animationAlpha);
		rect(0, 0, width, height);
	}

	public void setNewMode(Boolean fromBlack){
	  background(0);//clean previous animation
	  background(0, 0);//show background image
	  console.log("set new mode: " + currentMode);
	  alphaTarget = fromBlack ? 1 : 0;
	  if(currentMode == SUN_MODE) {
	    nextAnimation = new Sun();
	  }else if(currentMode == SIMPLE_FREQ_MODE){
	    nextAnimation = new SimpleFreqAnalyzer();
	  }else if(currentMode == RENAME_ME_MODE){
	    nextAnimation = new RenameMe();
	  }else if(currentMode == HAIRY_MODE){
	    nextAnimation = new Hairy();
	  }else if(currentMode == COLOR_RINGS_MODE){
	    nextAnimation = new ColorRings();
	  }
	  if(fromBlack){
	  	currentAnimation = nextAnimation;
	  }
	}

}