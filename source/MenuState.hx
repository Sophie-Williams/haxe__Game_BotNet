package;

import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import Std.*;

class MenuState extends FlxState {

	//Vars
	private var menuOpened:Bool;
	private var currentPage:String;
	private var btnMenu:FlxButton;
	private var btnBots:FlxButton;

	//getFlxText(x,y,w,?size,?color,?alignment,?text)
	//getFlxButton(x,y,file,w,h,?label,?size,?color,?alignment, function  )
	/*public var txtBotsCount:FlxText;
	public var btnBotsHack:FlxButton;
	public var txtBotsTasks:FlxText;
	public var botsItems:Array<FlxBasic>;
*/
	public var btnsBots:Array<FlxButton> = [];
	public var txtsBots:Array<FlxText> = [];
	public var txtBotsCount:FlxText;
	public var botAlocationNumInc:Bool = true;
	public var botAlocationAmount:Int = 1;
	public var botAlocationTotal:Int;
	public var btnBotsIncType:FlxButton;
	public var btnBotsIncAmount:FlxButton;
	public var txtBotsTotalInc:FlxText;
	public var txtsBotsAlocationInfo:Array<FlxText> = [];
	public var dataBotsAlocationInfo:Array<Int> = [];


	private var btnStore:FlxButton;
	private var btnStats:FlxButton;
	private var btnSettings:FlxButton;


	private var txtStatus:FlxText;
	private var botCount:Int;
	//private var botCountPow:Int;
	private var botMax:Int;
	private var money:Int;

	private var txtProc:FlxText;
	private var cpuCount:Int;
	private var cpuUsed:Int;
	private var memTotal:Int;
	private var memUsed:Int;

	private var txtBar:FlxText;

	private var testGraph:Graph;

	override public function create():Void {
		//makes a button at (0,0) that says play and calls clickPlay()
/*		btnMenu = new FlxButton(20, 20, "Menu", toggleMenu);
		btnMenu.loadGraphic("assets/images/btn_gor_32x128.png", true, 128, 32);
		btnMenu.label.setFormat("assets/fonts/Hack-Regular.ttf", 18, FlxColor.BLACK, LEFT);

		btnBots = new FlxButton(20, 20+10+32, "Bots", openBots);
		btnBots.loadGraphic("assets/images/btn_gor_32x128.png", true, 128, 32);
		btnBots.label.setFormat("assets/fonts/Hack-Regular.ttf", 18, FlxColor.BLACK, LEFT);

		btnStore = new FlxButton(20, 20+20+64, "Store", openStore);
		btnStore.loadGraphic("assets/images/btn_gor_32x128.png", true, 128, 32);
		btnStore.label.setFormat("assets/fonts/Hack-Regular.ttf", 18, FlxColor.BLACK, LEFT);

		btnStats = new FlxButton(20, 20+30+96, "Stats", clickPlay);
		btnStats.loadGraphic("assets/images/btn_gor_32x128.png", true, 128, 32);
		btnStats.label.setFormat("assets/fonts/Hack-Regular.ttf", 18, FlxColor.BLACK, LEFT);

		btnSettings = new FlxButton(20, 20+40+128, "Settings", clickPlay);
		btnSettings.loadGraphic("assets/images/btn_gor_32x128.png", true, 128, 32);
		btnSettings.label.setFormat("assets/fonts/Hack-Regular.ttf", 18, FlxColor.BLACK, LEFT);
		menuOpened = false;
		add(btnMenu);*/

		var menuFile = "assets/images/btn_gor_32x128.png";
		var menuW  = 128;
		var menuH = 32;
		btnMenu = getFlxButton(20, 20, menuFile, menuW, menuH, "Menu", toggleMenu);
		btnBots =  getFlxButton(20, 20+10+32, menuFile, menuW, menuH, "Bots", openBots);
		btnStore = getFlxButton(20,  20+20+64, menuFile, menuW, menuH, "Store", openStore);
		btnStats = getFlxButton(20, 20+30+96, menuFile, menuW, menuH, "Stats", clickPlay);
		btnSettings = getFlxButton(20, 20+40+128, menuFile, menuW, menuH, "Settings", clickPlay);

		menuOpened = false;
		add(btnMenu);

		testGraph = new Graph(0,0,250,300, FlxColor.TRANSPARENT ,FlxColor.GREEN);
		add(testGraph);

/*
		txtStatus = new FlxText(10, 10, (FlxG.width/2)-20); // x, y, width
		txtStatus.setFormat("assets/fonts/Hack-Regular.ttf", 18, FlxColor.GREEN, LEFT);

		txtProc = new FlxText(FlxG.width/2+10, 10, (FlxG.width/2)-20); // x, y, width
		txtProc.setFormat("assets/fonts/Hack-Regular.ttf", 12, FlxColor.GREEN, LEFT);
		txtBar = new FlxText(FlxG.width/2-9, 10, 19); // x, y, width
		txtBar.setFormat("assets/fonts/Hack-Regular.ttf", 12, FlxColor.GREEN, LEFT);
		txtBar.text = "|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n";
		add(txtStatus);
		add(txtProc);
		add(txtBar);
*/

		initVars();
		initBots();

		super.create();
	} //end create

	function initVars() : Void {
		botCount = 128;
		botMax = 2048;
		money = 0;

	}

	override public function update(elapsed:Float):Void {

		switch currentPage {
		case "bots":
			txtBotsCount.text = "Bots: "+intToString(botCount, 2)+" / "+intToString(botMax, 2);
			calcBotAlocationTotal();
			txtBotsTotalInc.text = "Total Increment: (+-)\n["+intToString(botAlocationTotal, 3) + "]";
			var i = 0;
			while(i < txtsBotsAlocationInfo.length) {
				txtsBotsAlocationInfo[i].text = "[" + dataBotsAlocationInfo[i] + "] "
							+ "[" + Std.int((dataBotsAlocationInfo[i]/botCount)*100) + "%]";
				i++;
			}
		default:
			//nothing

		}


		super.update(elapsed);
	} // end update

	function calcBotAlocationTotal():Void {
		if(botAlocationNumInc) {
			botAlocationTotal = botAlocationAmount;
		} else {
			botAlocationTotal = Std.int( (botAlocationAmount/100)*botCount );
		}
	}
	function intToString(num:Int, accuracy:Int) : String {
		var sufix = ["", "K","M","G","T","P","E", "Z", "Y"];
		var str = ""+num;
		var ret = "";
		if(accuracy<1) accuracy = 1;
		if(num < 1000) return ""+num;
		var len = str.length;
		var tip = len%3;
		var i = 1;
		ret += str.substr(0, tip) + sufix[ Std.int( (len-tip)/3 ) ];
		while(i<accuracy && i < Std.int( (len-tip)/3 )+1 ) {
			ret += str.substr(tip+3*(i-1), 3) + sufix[ ( Std.int( (len-tip)/3) )-i ];
			i++;
		}
		return ret;
	}

 /*
	private function updateProc():Void {
		var proc:String;
		proc = "Cores Avalibale: " + cpuCount +"\nUsage : [";
		var res:Int = 25;
		var barcount:Int = Std.int((cpuUsed * res) / cpuCount);
		for(i in 0...barcount) {
			proc += "|";
		}
		for(i in res-barcount...res) {
			proc += " ";
		}
		proc += "]\nMem [|||||||||         ]\nTotal: " + memTotal + "  Used: "
						+ memUsed + "  Free: " + (memTotal - memUsed) + "\n";
		txtProc.text = proc;
		return ;
	}

	private function updateStatus():Void {
		var status:String;
		status = "Bots: "+ botCount + "\nMoney: " + money + "$\n";
		txtStatus.text = status;
		return;
	}*/

	private function toggleMenu():Void {
		if(menuOpened) {
			remove(btnBots);
			remove(btnStore);
			remove(btnStats);
			remove(btnSettings);
			menuOpened = false;
		} else {
			add(btnBots);
			add(btnStore);
			add(btnStats);
			add(btnSettings);
			menuOpened = true;
		}
	}

	private function getFlxText( x:Int, y:Int, w:Int, ?s:Int = 18,
															?color:FlxColor = FlxColor.GREEN,
															?text:String = "",
															?alignment:FlxTextAlign = LEFT):FlxText {

	var txt:FlxText = new FlxText(x, y, w); // x, y, width
	txt.setFormat("assets/fonts/Hack-Regular.ttf", s, color, alignment);
	txt.text = text;
	trace( x+", "+y+", "+w+", "+text );
	return txt;
	}

	private function getFlxButton( x:Int, y:Int, file:String, w:Int, h:Int,
															?label:String = "", ?s:Int = 18,
															?color:FlxColor = FlxColor.BLACK,
														 	?alignment:FlxTextAlign = LEFT,
															?onClick:Void->Void):FlxButton {

	var btn:FlxButton = new FlxButton(x, y, label, onClick);
	btn.loadGraphic(file, true, w, h);
	btn.label.setFormat("assets/fonts/Hack-Regular.ttf", s, color, alignment);

	return btn;
	}



	private function initBots() : Void {
		//getFlxText(x,y,w,?size,?color,?text,?alignment)
		//getFlxButton(x,y,file,w,h,?label,?size,?color,?alignment, function  )
		/*txtBotsCount = getFlxText(20+128+40,20,FlxG.width-128-80,
								"BotCOunter :sdfds");
		btnBotsHack = getFlxButton(40,40+32,"assets/images/btn_gor_32x128",
								128, 32, "Hack A Bot", CENTER, botsHackABot);
		txtBotsTasks = getFlxText(40, 60+64, FlxG.width-40,"Bot Alocation:");

		botsItems = [txtBotsCount, btnBotsHack, txtBotsTasks];
		*/
		btnsBots.push( getFlxButton(40,40+32,"assets/images/btn_gor_32x128.png",
								128, 32, "Hack A Bot", CENTER, botsHackABot) );
		txtBotsCount = getFlxText(20+128+20,20,FlxG.width-128-80,
								"Bots: ");
		txtsBots.push( txtBotsCount );
		txtsBots.push( getFlxText(40, 60+64, FlxG.width-40,"Bot Alocation:") );

		btnBotsIncType = getFlxButton(40,80+96,"assets/images/btn_gor_32x32.png",
								32, 32, "#", CENTER, botsIncType);
		btnsBots.push( btnBotsIncType );
		btnBotsIncAmount = getFlxButton(50+32,80+96,"assets/images/btn_gor_32x64.png",
								64, 32, "1", CENTER, botsIncAmount);
		btnsBots.push( btnBotsIncAmount );

		txtBotsTotalInc = getFlxText(60+32+64,80+92,FlxG.width-80-96,
								"Total Increment: (+-)\n[1]",CENTER);
		txtsBots.push( txtBotsTotalInc );

		//bf = 0 ddos = 1 phish = 2 reserch = 3
		var tasks = ["Brute Force" , "DDoS", "Phish", "Research"];
		var taskInc = [addBF, addDDoS, addPhish, addResearch];
		var taskDec = [subBF, subDDoS, subPhish, subResearch];
		var x = 40;
		var y = 100+128;
		var space = 10;
		var gap = 150;
		var i = 0;
		while(i < tasks.length ) {
			txtsBots.push( getFlxText(x, y+i*(space+32), 200,tasks[i]) );
			btnsBots.push( getFlxButton(x+gap, y+i*(space+32),"assets/images/btn_gor_32x32.png",
									32, 32, "+", CENTER, taskInc[i]) );
			btnsBots.push( getFlxButton(x+gap+32+20, y+i*(space+32),"assets/images/btn_gor_32x32.png",
									32, 32, "-", CENTER, taskDec[i]) );
			txtsBotsAlocationInfo.push( getFlxText(x+gap+104, y+i*(space+32),FlxG.width-(x+gap+104) ,"[###][xx%]"));
			dataBotsAlocationInfo.push(0);
			txtsBots.push(txtsBotsAlocationInfo[i]);

			i++;
		}

	}

	private function openBots():Void {
		toggleMenu();
		if(currentPage == "bots") {
			return;
		} else {
			closePage(currentPage);

			for(i in txtsBots) {
				add(i);
				trace( "Adding stuff" );
			}
			for(i in btnsBots) {
				add(i);
				trace( "Adding stuff" );
			}

			currentPage = "bots";
		}
	}
	private function botsHackABot() : Void {
		botCount++;
	}

	private function closePage( page:String ) : Void {
		switch page {
		case "bots":
			//close bots stuff

						for(i in txtsBots) {
							remove(i);
							trace( "removing stuff" );
						}
						for(i in btnsBots) {
							remove(i);
							trace( "removing stuff" );
						}

		default:
			//do nothing
		}

	}

	private function openStore() : Void {
		closePage("bots");
		currentPage = "";
	}
	private function clickPlay():Void {
		trace("Pushed Buy Bot");
		//txtStatus.text += "\n";
		botCount++;
		money -= 10*botCount;
		//switched to the play state
		//FlxG.switchState(new PlayState());
	} //end clickPlay

private function botsIncType() : Void {
	if(botAlocationNumInc) {
		btnBotsIncType.label.text = "%";
		btnBotsIncAmount.label.text = "1";
		botAlocationAmount = 1;
		botAlocationNumInc = false;
	} else {
		btnBotsIncType.label.text = "#";
		btnBotsIncAmount.label.text = "1";
		botAlocationAmount = 1;
		botAlocationNumInc = true;
	}
}

private function botsIncAmount() : Void {
	if(botAlocationNumInc) {
		if(botAlocationAmount >= 65536) {
			botAlocationAmount = 1;
		} else if(botAlocationAmount == 1) {
			botAlocationAmount = 2;
		} else {
			botAlocationAmount = Std.int( Math.pow( botAlocationAmount, 2 ) );
		}

		btnBotsIncAmount.label.text = botAlocationAmount+"";

	} else {
			switch botAlocationAmount {
			case 1:
				botAlocationAmount = 5;
			case 5:
				botAlocationAmount = 10;
			case 10:
				botAlocationAmount = 15;
			case 15:
				botAlocationAmount = 25;
			case 25:
				botAlocationAmount = 33;
			case 33:
				botAlocationAmount = 50;
			case 50:
				botAlocationAmount = 75;
			case 75:
				botAlocationAmount = 100;
			case 100:
				botAlocationAmount = 1;
			default:
				botAlocationAmount = 1;
		}

		btnBotsIncAmount.label.text = botAlocationAmount+"";

	}
}

private function addBF():Void {
	var alocated =0;
	for(i in dataBotsAlocationInfo) {
		alocated += i;
	}
	calcBotAlocationTotal;
	if(alocated+botAlocationTotal > botCount) {
		dataBotsAlocationInfo[0] += (botCount - alocated);
	} else {
		dataBotsAlocationInfo[0] += botAlocationTotal;
	}
}
private function addDDoS():Void {
	var alocated =0;
	for(i in dataBotsAlocationInfo) {
		alocated += i;
	}
	calcBotAlocationTotal;
	if(alocated+botAlocationTotal > botCount) {
		dataBotsAlocationInfo[1] += (botCount - alocated);
	} else {
		dataBotsAlocationInfo[1] += botAlocationTotal;
	}
}
private function addPhish():Void {
	var alocated =0;
	for(i in dataBotsAlocationInfo) {
		alocated += i;
	}
	calcBotAlocationTotal;
	if(alocated+botAlocationTotal > botCount) {
		dataBotsAlocationInfo[2] += (botCount - alocated);
	} else {
		dataBotsAlocationInfo[2] += botAlocationTotal;
	}
}
private function addResearch():Void {
	var alocated =0;
	for(i in dataBotsAlocationInfo) {
		alocated += i;
	}
	calcBotAlocationTotal;
	if(alocated+botAlocationTotal > botCount) {
		dataBotsAlocationInfo[3] += (botCount - alocated);
	} else {
		dataBotsAlocationInfo[3] += botAlocationTotal;
	}
}
private function subBF():Void {
	calcBotAlocationTotal;
	dataBotsAlocationInfo[0] -= botAlocationTotal;
	if(dataBotsAlocationInfo[0] < 0) {
		dataBotsAlocationInfo[0] = 0;
	}

}
private function subDDoS():Void {
	calcBotAlocationTotal;
	dataBotsAlocationInfo[1] -= botAlocationTotal;
	if(dataBotsAlocationInfo[1] < 0) {
		dataBotsAlocationInfo[1] = 0;
	}

}
private function subPhish():Void {
	calcBotAlocationTotal;
	dataBotsAlocationInfo[2] -= botAlocationTotal;
	if(dataBotsAlocationInfo[2] < 0) {
		dataBotsAlocationInfo[2] = 0;
	}

}
private function subResearch():Void {
	calcBotAlocationTotal;
	dataBotsAlocationInfo[3] -= botAlocationTotal;
	if(dataBotsAlocationInfo[3] < 0) {
		dataBotsAlocationInfo[3] = 0;
	}

}

} // end class MenuState
