package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class MenuState extends FlxState {
	//makes a var for our button .. where FlxButton is the type?
	private var btnPlay:FlxButton;
	private var txtStatus:FlxText;

	override public function create():Void {
		//makes a button at (0,0) that says play and calls clickPlay()
		btnPlay = new FlxButton(0, 0, "Play", clickPlay);
		btnPlay.loadGraphic("assets/images/btn_gor_32x64.png", true, 64, 32);
		//centers the button
		btnPlay.screenCenter();
		//puts the button on the screen
		add(btnPlay);


		txtStatus = new FlxText(10, 10, FlxG.width-20,FlxG.height/3); // x, y, width
		txtStatus.text = "Hello World this is a long peis so I can see it?";
		txtStatus.setFormat("assets/data/Hack-Regular.ttf", 12, FlxColor.GREEN, LEFT);
		//myText.setBorderStyle(OUTLINE, FlxColor.RED, 1);

		add(txtStatus);

		super.create();
	} //end create

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	} // end update

	private function clickPlay():Void {
		trace("Pushed Play");
		txtStatus.text += "Pushes play\n";
		//switched to the play state
		//FlxG.switchState(new PlayState());
	} //end clickPlay
} // end class MenuState
