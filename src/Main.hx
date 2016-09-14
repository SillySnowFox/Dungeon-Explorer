package;

import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;
import flash.*;
import flash.events.*;
import flash.ui.*;
import flash.text.*;
import flash.utils.*;

import MyButton;
import GlobalVars;
import MyPerk;

/**
 * ...
 * @author Kyra Sunseeker
 */

class Main 
{
	static var globals:GlobalVars;
	static var btns:Array<MyButton>;
	static var txtPublic:TextField;
	static var optionsBtn:MyButton;
	static var charDesc:MyButton;
	static var txtDebug:TextField;
	
	static var roomNPC:MyNPC;
	static var playerCharacter:MyPlayerObject;
	
	
	
	static function displayFAQ( e:MouseEvent ) {
		var qanda:Array<String> = new Array();
		var message:String = "";
		
		qanda.push("<p><b>Can I pay your for your wonderful game?</b></p><p>By all means, yes! Yes you can! ... And I've made it even easier for you, just head over to Patreon <a target='_new' href='https://www.patreon.com/SillySnowFox'><u>here</u></a> and pledge a couple dollars!</p>");
		qanda.push("<p><b>What do you use to make Dungeon Explorer?</b></p><p>Dungeon Explorer is written in ActionScript and compiled into flash by using HaXe. I use FlashDevelop as the debugging environment. This causes a few odd issues as HaXe doesn't support some aspects of ActionScript for some reason but it also doesn't require a subscription.</p>");
		
		clearAllEvents();
		
		for (i in 0...qanda.length) {
			message += qanda[i] + "<br>";
		}
		
		outputText(message, "Frequently Asked Questions");
		
		btns[8].setButton("Back");
		btns[8].setClickFunc(welcomeScreen);
	}
	
	static function displayCredits( e:MouseEvent ) {
		var credits:Array<String> = new Array();
		var backerCredits:Array<String> = new Array();
		var oneLineBackers:Array<String> = new Array();
		var message:String = "";
		
		clearAllEvents();
		
		
		oneLineBackers.push("pelle"); //Dropped to $1 Feb
		oneLineBackers.push("Writer"); //Paid Feb #10
		
		
		backerCredits.push("Foxlets"); //Dropped below $5 in October
		backerCredits.push("Bradley Taylor"); //Paid Feb $5
		backerCredits.push("OutsideOctaves"); //Paid Feb $5
		backerCredits.push("Michael Brookins"); //Paid Feb $5
		backerCredits.push("Erik Camp"); //Paid Feb $5
		backerCredits.push("Pell Torr"); //Paid Feb $5
		
		
		for (i in 0...credits.length) {
			message += "<p>" + credits[i] + "</p>";
		}
		
		message += "<br><p><b>Thanks to my Patreon backers!</b></p><br>";
		
		for (i in 0...oneLineBackers.length) {
			message += "<p>" + oneLineBackers[i] + "</p>";
		}
		
		message += "<br><p>" + backerCredits[0];
		
		for (i in 1...backerCredits.length) {
			message += ", " + backerCredits[i];
		}
		
		outputText("Game code and story by Kyra Sunseeker.</b></p><br>" + message, "Credits");
		
		btns[8].setButton("Back");
		btns[8].setClickFunc(welcomeScreen);
	}
	
	static function optionsScreen(?e:MouseEvent) {
		var btnOptions:Object = Lib.current.getChildByName("Options Button");
		var gameLogo:Object = Lib.current.getChildByName("gameLogo");
		var btnDesc:Object = Lib.current.getChildByName("Desc Button");
		var txtTime:Object = Lib.current.getChildByName("Time");
		var txtBowels:Object = Lib.current.getChildByName("Bowels");
		var txtDebug:Object = Lib.current.getChildByName("Debug");
		var txtArousal:Object = Lib.current.getChildByName("Arousal");
		
		var clicked:Int = 0;
		
		if (e != null)
			clicked = e.currentTarget.btnID;
		
		clearAllEvents();
		
		outputText("Debug Mode: " + globals.debugMode + "</p><p>Text Size: " + globals.textSize + "</p><p>Allow Scat: " + globals.allowScat + "</p><p>Allow Sex: " + globals.allowSex, "Options");
		
		btnOptions.visible = false;
		btnDesc.visible = false;
		txtTime.visible = false;
		txtPublic.visible = false;
		//newRoom = false;
		
		switch (clicked) {
		case 0:
			btns[0].setButton("Scat", "Allow/disallow scat. Controls if your character poops or not.", 1);
			btns[0].setClickFunc(optionsScreen);
			btns[1].setButton("Arousal", "Allow/disallow sex. Controls if your character becomes aroused.", 3);
			btns[1].setClickFunc(optionsScreen);
			btns[2].setButton("Debug", "Toggle debug mode.", 2);
			btns[2].setClickFunc(optionsScreen);
			btns[3].setButton("Font Size+", null, 1);
			btns[3].setClickFunc(changeFontSize);
			btns[4].setButton("Font Size-", null, 2);
			btns[4].setClickFunc(changeFontSize);
			
			if (globals.backTo != "Welcome") {
				btns[6].setButton("Main Menu", "Start a new game. Current game will be lost.", 0);
				//btns[6].setClickFunc(resetGame);
			}
			
			btns[11].setButton("Back");
			
			switch (globals.backTo) {
				case "Welcome":
					btns[11].setClickFunc(welcomeScreen);
				case "move":
					btns[9].setButton("Save", null, 0);
					//btns[9].setClickFunc(saveGame);
					
					//btns[11].setClickFunc(movePlayer);
				default:
					new AlertBox("Bad options screen backTo: " + globals.backTo);
			}
		case 1:
			//Toggle scat
			if (globals.allowScat) {
				globals.allowScat = false;
				txtBowels.visible = false;
			} else {
				globals.allowScat = true;
				txtBowels.visible = true;
			}
			optionsScreen();
		case 2:
			//Toggle debug
			if ( globals.debugMode ) {
				globals.debugMode = false;
				txtDebug.visible = false;
			} else {
				globals.debugMode = true;
				txtDebug.visible = true;
			}
			optionsScreen();
		case 3:
			//Toggle sex
			if (globals.allowSex) {
				globals.allowSex = false;
				txtArousal.visible = false;
			} else {
				globals.allowSex = true;
				txtArousal.visible = true;
			}
			optionsScreen();
		case 4:
			
		}
	}
	
	static function changeFontSize( e:MouseEvent ) {
		var txtOutput:Object = Lib.current.getChildByName("Output Field");
		var clicked:Dynamic = e.currentTarget.btnID;
		
		var outStyle:StyleSheet = new StyleSheet();
		var headStyle:StyleSheet = new StyleSheet();
		var bodyStyle:StyleSheet = new StyleSheet();
		var byStyle:StyleSheet = new StyleSheet();
		var pStyle:StyleSheet = new StyleSheet();
		var titleStyle:StyleSheet = new StyleSheet();
		
		var labelFormat:TextFormat = new TextFormat();
		var charNameFormat:TextFormat = new TextFormat();
		var versionFormat:TextFormat = new TextFormat();
		
		var textSize:Int = globals.textSize;
		
		if (clicked == 1) {
			//increase
			textSize += 2;
		} else {
			//decrease
			textSize -= 2;
		}
		
		if (textSize >= 32)
			textSize = 30;
		if (textSize <= 6)
			textSize = 8;
		
		headStyle.fontWeight = "bold";
		headStyle.fontSize = textSize + 20;
		headStyle.textAlign = "center";
		
		bodyStyle.textSize = textSize;
		pStyle.textSize = textSize +2;
		
		byStyle.fontStyle = "italic";
		byStyle.fontSize = textSize - 2;
		byStyle.textAlign = "center";
		
		titleStyle.fontWeight = "bold";
		titleStyle.fontSize = textSize + 8;
		
		outStyle.setStyle(".heading", headStyle);
		outStyle.setStyle(".byline", byStyle);
		outStyle.setStyle("p", pStyle);
		outStyle.setStyle("body", bodyStyle);
		outStyle.setStyle(".title", titleStyle);
		
		globals.textSize = textSize;
		
		optionsScreen();
	}
	
	static function welcomeScreen(?event:MouseEvent) {
		var txtOutput:Object  = Lib.current.getChildByName("Output Field");
		var welcomeMessage:Array<String> = globals.welcomeMessage;
		var date:Date = Date.now();
		var textSize:Int = globals.textSize;
		
		var message:String = "";
		var rndNumer:Int = Math.round(Math.random() * (welcomeMessage.length - 1));
		var month:Int = date.getMonth();
		var day:Int = date.getDate();
		
		// for testing startup messages, set to the index of the message to test and uncomment
		//rndNumer = 26;
		message = welcomeMessage[rndNumer];
		
		//Date specific messages
		if (month == 7 && day == 8) // my birthday!
			message = "Happy birthday Kyra!";
		
		if (month == 9 && day == 31) //Halloween
			message = "Happy Halloween!";
		
		if (month == 11 && day == 25) //Christmas
			message = "Merry Christmas!";
		
		if (month == 0 && day == 1) //New Years
			message = "Happy New Year!";
		
		txtOutput.htmlText = "<body><br><br><p><span class='byline'>Created by Kyra Sunseeker</span></p><br><br><p><span class = 'heading'>&nbsp;&nbsp;Welcome to<br><font size = '" + (textSize + 30) + "'>Dungeon Explorer</font></span></p><br><br><br><br><br><p><font size='" + textSize + "'><br><br><br><br><br><font size = '" + textSize + "'><p align = 'center'>" + message + "</p></font></body>";
		
		clearAllEvents();
		
		btns[0].setButton("New Game", "Start a new game", 0);
		//btns[0].setClickFunc(newGame);
		btns[1].setButton("Load", "Load a saved game", 0);
		btns[1].disableButton();
		//btns[1].setClickFunc(loadGame);
		btns[2].setButton("Options");
		btns[2].setClickFunc(optionsScreen);
		
		btns[6].setButton("F.A.Q.");
		btns[6].setClickFunc(displayFAQ);
		
		btns[8].setButton("Credits");
		btns[8].setClickFunc(displayCredits);
		
		globals.backTo = "Welcome";
	}
	
	static function scrollTop( e:MouseEvent ) {
		var txtOutput:Object = Lib.current.getChildByName("Output Field");
		
		txtOutput.scrollV = 1;
	}
	
	static function scrollUp( e:MouseEvent ) {
		var txtOutput:Object = Lib.current.getChildByName("Output Field");
		
		txtOutput.scrollV -= 3;
	}
	
	static function scrollDn( e:MouseEvent ) {
		var txtOutput:Object = Lib.current.getChildByName("Output Field");
		
		txtOutput.scrollV += 3;
	}
	
	static function scrollBm( e:MouseEvent ) {
		var txtOutput:Object = Lib.current.getChildByName("Output Field");
		
		txtOutput.scrollV = txtOutput.maxScrollV;
	}
	
	/***********************\
	 *                     *
	 * Non-Click Functions *
	 *                     *
	\***********************/ 
	
	static function outputText(body:String, title:String = null) {
		var txtOutput:Object = Lib.current.getChildByName("Output Field");
		var textSize:Int = globals.textSize;
		var toTop:Object = Lib.current.getChildByName("U2T");
		var upThree:Object = Lib.current.getChildByName("U3L");
		var dnThree:Object = Lib.current.getChildByName("D3L");
		var toBtm:Object = Lib.current.getChildByName("D2B");
		
		var formattedText:String = "<body>";
		var parsedText:String = "";
		
		var text:TextField = new TextField();
		
		if (title != null) {
			formattedText += "<span class = 'title'>" + title + "</span><br>";
			for (n in 0...20) {
				formattedText += "—";
			}
			formattedText += "<br>";
		}
		
		//parse in-text variables
		parsedText = textParse(body);
		
		formattedText += "<font size = '" + textSize + "'><p>" + parsedText + "</p></font></body>";
		
		txtOutput.htmlText = formattedText;
		
		if (txtOutput.numLines > txtOutput.bottomScrollV) {
			toTop.textColor = 0x000000;
			toTop.text = "Tp";
			toTop.addEventListener(MouseEvent.CLICK, scrollTop);
			
			upThree.textColor = 0x000000;
			upThree.text = "Up";
			upThree.addEventListener(MouseEvent.CLICK, scrollUp);
			
			dnThree.textColor = 0x000000;
			dnThree.text = "Dn";
			dnThree.addEventListener(MouseEvent.CLICK, scrollDn);
			
			toBtm.textColor = 0x000000;
			toBtm.text = "Bm";
			toBtm.addEventListener(MouseEvent.CLICK, scrollBm);
		} else {
			toTop.textColor = 0xD8D8D8;
			toTop.text = "Tp";
			toTop.removeEventListener(MouseEvent.CLICK, scrollTop);
			
			upThree.textColor = 0xD8D8D8;
			upThree.text = "Up";
			upThree.removeEventListener(MouseEvent.CLICK, scrollUp);
			
			dnThree.textColor = 0xD8D8D8;
			dnThree.text = "Dn";
			dnThree.removeEventListener(MouseEvent.CLICK, scrollDn);
			
			toBtm.textColor = 0xD8D8D8;
			toBtm.text = "Bm";
			toBtm.removeEventListener(MouseEvent.CLICK, scrollBm);
		}
	}
	
	static function textParse(text:String):String {
		var arrayToParse:Array<String> = new Array();
		var subArray:Array<String> = new Array();
		var logicArray:Array<String> = new Array();
		var extraToHold:String = "";
		var stringToTest:String = "";
		var parsedText:String = "";
		var parsedCharCount:Int = 0;
		var subSplit:Array<String> = new Array();
		
		arrayToParse = text.split(" ");
		
		for (i in 0...arrayToParse.length) {
			subArray = arrayToParse[i].split("]");
			
			if (subArray[0].substr(0, 4) == "[Has") {
				//Logic
				logicArray = subArray[0].split(":");
				
				if (logicArray.length > 1)
					stringToTest = logicArray[0];
				
				if (stringToTest == "[HasBreasts") {
					if (roomNPC.breasts) 
						parsedText += textParse(convertSpaces(logicArray[1]));
				}
				if (stringToTest == "[HasVagina") {
					if (roomNPC.vagina)
						parsedText += convertSpaces(logicArray[1]);
				}
				if (stringToTest == "[HasPenis") {
					if (roomNPC.penis)
						parsedText += convertSpaces(logicArray[1]);
				}
				if (stringToTest == "[HasBalls") {
					if (roomNPC.balls)
						parsedText += convertSpaces(logicArray[1]);
				}
				if (stringToTest == "[HasPandV") { //NPC has both a cock and vagina
					if (roomNPC.penis && roomNPC.vagina)
						parsedText += convertSpaces(logicArray[1]);
				}
			}
			
			
			if (subArray.length > 1) {
				extraToHold = subArray[1] + " ";
			} else {
				extraToHold = " ";
			}
			if (subArray[0].substr(0, 1) == "[") {
				stringToTest = subArray[0].substr(1);
				
				logicArray = stringToTest.split(":");
				
				if (logicArray.length > 1)
					stringToTest = logicArray[0];
				
				switch (stringToTest) {
				case "PCNAME":
					parsedText += playerCharacter.name;
				case "PCSPECIESC":
					parsedText += playerCharacter.species.name;
				case "PCSPECIESL":
					parsedText += playerCharacter.species.name.toLowerCase();
				case "PCARMS":
					parsedText += playerCharacter.arms;
				case "PCLEGS":
					parsedText += playerCharacter.legs;
				case "PCSKIN":
					parsedText += playerCharacter.skin;
				case "PCMOUTH":
					parsedText += playerCharacter.mouth;
				case "PCHANDS":
					parsedText += playerCharacter.hands;
				case "PCFEETS":
					parsedText += playerCharacter.feet;
				case "NPCNAME":
					parsedText += roomNPC.name;
				case "NPCGENDER":
					parsedText += roomNPC.gender("gender");
				case "SUBJC":
					parsedText += roomNPC.gender("sub");
				case "SUBJ":
					parsedText += roomNPC.gender("sub").toLowerCase();
				case "OBJC":
					parsedText += roomNPC.gender("obj");
				case "OBJ":
					parsedText += roomNPC.gender("obj").toLowerCase();
				case "POSC":
					parsedText += roomNPC.gender("pos");
				case "POS":
					parsedText += roomNPC.gender("pos").toLowerCase();
				case "HasBreasts":
					
				case "HasVagina":
					
				case "HasPenis":
					
				case "HasBalls":
					
				
				default:
					parsedText += "{Unknown variable: " + stringToTest + "}";
				}
				
				if (parsedText.length > parsedCharCount)
					parsedText += extraToHold;
				parsedCharCount = parsedText.length;
			} else {
				parsedText += arrayToParse[i] + " ";
				parsedCharCount = parsedText.length;
			}
		}
		
		
		return parsedText;
	}
	
	static function convertSpaces(textToConvert:String):String {
		var pass1:String = "";
		var pass2:String = "";
		var pass3:String = "";
		
		for (i in 0...textToConvert.length) {
			if (textToConvert.charAt(i) == "_") {
				pass1 += " ";
			} else {
				pass1 += textToConvert.charAt(i);
			}
		}
		for (i in 0...pass1.length) {
			if (pass1.charAt(i) == "<") {
				pass2 += "[";
			} else {
				pass2 += pass1.charAt(i);
			}
		}
		for (i in 0...pass2.length) {
			if (pass2.charAt(i) == ">") {
				pass3 += "]";
			} else {
				pass3 += pass2.charAt(i);
			}
		}
		
		return pass3;
	}
	
	static function onMouseEnter(e:MouseEvent) {
		Mouse.cursor = "button";
	}
	
	static function onMouseOut(e:MouseEvent) {
		Mouse.cursor = "auto";
	}
	
	static function drawPlayfield() {
		var flashSC = flash.Lib.current;
		var outStyle:StyleSheet = new StyleSheet();
		var headStyle:StyleSheet = new StyleSheet();
		var bodyStyle:StyleSheet = new StyleSheet();
		var byStyle:StyleSheet = new StyleSheet();
		var pStyle:StyleSheet = new StyleSheet();
		var titleStyle:StyleSheet = new StyleSheet();
		
		var labelFormat:TextFormat = new TextFormat();
		var charNameFormat:TextFormat = new TextFormat();
		var versionFormat:TextFormat = new TextFormat();
		var textSize:Int = globals.textSize;
		
		headStyle.fontWeight = "bold";
		headStyle.fontSize = textSize + 20;
		headStyle.textAlign = "center";
		
		bodyStyle.textSize = textSize;
		pStyle.textSize = textSize +2;
		
		byStyle.fontStyle = "italic";
		byStyle.fontSize = textSize - 2;
		byStyle.textAlign = "center";
		
		titleStyle.fontWeight = "bold";
		titleStyle.fontSize = textSize + 8;
		
		outStyle.setStyle(".heading", headStyle);
		outStyle.setStyle(".byline", byStyle);
		outStyle.setStyle("p", pStyle);
		outStyle.setStyle("body", bodyStyle);
		outStyle.setStyle(".title", titleStyle);
		
		labelFormat.size = textSize;
		charNameFormat.size = textSize + 4;
		versionFormat.align = RIGHT;
		versionFormat.italic = true;
		versionFormat.size = 10;

		txtPublic = new TextField();
		txtPublic.name = "Public";
		txtPublic.x = 676;
		txtPublic.y = 11;
		txtPublic.width = 34;
		txtPublic.height = 26;
		txtPublic.border = false;
		txtPublic.text = "Public";
		txtPublic.visible = false;
		
		var txtOutput:TextField = new TextField();
		txtOutput.name = "Output Field";
		txtOutput.x = 10;
		txtOutput.y = 10;
		txtOutput.width = 700;
		txtOutput.height = 470;
		txtOutput.border = true;
		txtOutput.borderColor = 0x000000;
		txtOutput.multiline = true;
		txtOutput.htmlText = "";
		txtOutput.wordWrap = true;
		txtOutput.styleSheet = outStyle;
		
		var toTop:TextField = new TextField();
		toTop.name = "U2T";
		toTop.x = 710;
		toTop.y = 400;
		toTop.width = 20;
		toTop.height = 20;
		toTop.border = true;
		toTop.textColor = 0x808080;
		toTop.text = "Tp";
		toTop.visible = true;
		toTop.addEventListener(MouseEvent.ROLL_OVER, onMouseEnter);
		toTop.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		
		var upThreeLines:TextField = new TextField();
		upThreeLines.name = "U3L";
		upThreeLines.x = 710;
		upThreeLines.y = 420;
		upThreeLines.width = 20;
		upThreeLines.height = 20;
		upThreeLines.border = true;
		upThreeLines.textColor = 0x808080;
		upThreeLines.text = "Up";
		upThreeLines.visible = true;
		upThreeLines.addEventListener(MouseEvent.ROLL_OVER, onMouseEnter);
		upThreeLines.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		
		var downThreeLines:TextField = new TextField();
		downThreeLines.name = "D3L";
		downThreeLines.x = 710;
		downThreeLines.y = 440;
		downThreeLines.width = 20;
		downThreeLines.height = 20;
		downThreeLines.border = true;
		downThreeLines.textColor = 0x808080;
		downThreeLines.text = "Dn";
		downThreeLines.visible = true;
		downThreeLines.addEventListener(MouseEvent.ROLL_OVER, onMouseEnter);
		downThreeLines.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		
		var toBottom:TextField = new TextField();
		toBottom.name = "D2B";
		toBottom.x = 710;
		toBottom.y = 460;
		toBottom.width = 20;
		toBottom.height = 20;
		toBottom.border = true;
		toBottom.textColor = 0x808080;
		toBottom.text = "Bm";
		toBottom.visible = true;
		toBottom.addEventListener(MouseEvent.ROLL_OVER, onMouseEnter);
		toBottom.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		
		var txtName:TextField = new TextField();
		txtName.name = "Character Name";
		txtName.x = 720;
		txtName.y = 10;
		txtName.width = 200;
		txtName.height = 26;
		txtName.htmlText = " ";
		txtName.selectable = false;

		var txtHealth:TextField = new TextField();
		txtHealth.name = "Health";
		txtHealth.x = 720;
		txtHealth.y = 40;
		txtHealth.width = 200;
		txtHealth.height = 26;
		txtHealth.htmlText = "Health: 0/0";
		txtHealth.selectable = false;

		var txtStr:TextField = new TextField();
		txtStr.name = "Strength";
		txtStr.x = 720;
		txtStr.y = 480;
		txtStr.width = 120;
		txtStr.height = 20;
		txtStr.htmlText = "Strength: ";
		txtStr.selectable = false;

		var txtAgi:TextField = new TextField();
		txtAgi.name = "Agility";
		txtAgi.x = 720;
		txtAgi.y = 510;
		txtAgi.width = 120;
		txtAgi.height = 20;
		txtAgi.htmlText = "Agility: ";
		txtAgi.selectable = false;

		var txtEnd:TextField = new TextField();
		txtEnd.name = "Endurance";
		txtEnd.x = 720;
		txtEnd.y = 540;
		txtEnd.width = 120;
		txtEnd.height = 20;
		txtEnd.htmlText = "Endurance: ";
		txtEnd.selectable = false;

		var txtInt:TextField = new TextField();
		txtInt.name = "Intelligence";
		txtInt.x = 720;
		txtInt.y = 570;
		txtInt.width = 120;
		txtInt.height = 20;
		txtInt.htmlText = "Intelligence: ";
		txtInt.selectable = false;

		var txtStomach:TextField = new TextField();
		txtStomach.name = "Stomach";
		txtStomach.x = 300;
		txtStomach.y = 490;
		txtStomach.width = 220;
		txtStomach.height = 22;
		txtStomach.htmlText = "Fullness: 0/0";
		txtStomach.selectable = false;

		var txtBowels:TextField = new TextField();
		txtBowels.name = "Bowels";
		txtBowels.x = 300;
		txtBowels.y = 525;
		txtBowels.width = 220;
		txtBowels.height = 22;
		txtBowels.htmlText = "Bowels: 0/0";
		txtBowels.selectable = false;

		var txtWeight:TextField = new TextField();
		txtWeight.name = "Weight";
		txtWeight.x = 530;
		txtWeight.y = 490;
		txtWeight.width = 150;
		txtWeight.height = 22;
		txtWeight.htmlText = "Weight: 0lbs";
		txtWeight.selectable = false;

		var txtFat:TextField = new TextField();
		txtFat.name = "Fat";
		txtFat.x = 530;
		txtFat.y = 525;
		txtFat.width = 150;
		txtFat.height = 22;
		txtFat.htmlText = "Fat: ";
		txtFat.selectable = false;

		var txtBuildVersion:TextField = new TextField();
		txtBuildVersion.name = "Version";
		txtBuildVersion.x = 800;
		txtBuildVersion.y = 620;
		txtBuildVersion.width = 30;
		txtBuildVersion.height = 20;
		txtBuildVersion.htmlText = globals.buildVersion;
		txtBuildVersion.selectable = false;

		var txtDebugTag:TextField = new TextField();
		txtDebugTag.name = "Debug";
		txtDebugTag.x = 720;
		txtDebugTag.y = 620;
		txtDebugTag.width = 70;
		txtDebugTag.height = 20;
		txtDebugTag.htmlText = "Debug Mode";
		txtDebugTag.selectable = false;
		txtDebugTag.visible = false;
		txtDebug = txtDebugTag;

		var txtArousal:TextField = new TextField();
		txtArousal.name = "Arousal";
		txtArousal.x = 300;
		txtArousal.y = 560;
		txtArousal.width = 220;
		txtArousal.height = 22;
		txtArousal.htmlText = "Arousal: 0%";
		txtArousal.selectable = false;

		var txtMoney:TextField = new TextField();
		txtMoney.name = "Money";
		txtMoney.x = 300;
		txtMoney.y = 585;
		txtMoney.width = 220;
		txtMoney.height = 22;
		txtMoney.htmlText = "Money: ";
		txtMoney.selectable = false;
		
		var txtTime:TextField = new TextField();
		txtTime.name = "Time";
		txtTime.x = 590;
		txtTime.y = 460;
		txtTime.width = 200;
		txtTime.height = 22;
		txtTime.htmlText = "Time";
		txtTime.selectable = false;
		txtTime.visible = false;

		txtName.setTextFormat(charNameFormat);
		txtHealth.setTextFormat(labelFormat);
		txtStomach.setTextFormat(labelFormat);
		txtBowels.setTextFormat(labelFormat);
		txtBuildVersion.setTextFormat(versionFormat);

		flashSC.addChild(txtOutput);
		flashSC.addChild(txtName);
		flashSC.addChild(txtHealth);
		flashSC.addChild(txtStomach);
		flashSC.addChild(txtWeight);
		flashSC.addChild(txtFat);
		flashSC.addChild(txtMoney);
		flashSC.addChild(txtArousal);
		flashSC.addChild(txtBuildVersion);
		flashSC.addChild(txtDebugTag);
		flashSC.addChild(txtBowels);
		flashSC.addChild(txtTime);
		flashSC.addChild(txtPublic);
		flashSC.addChild(downThreeLines);
		flashSC.addChild(toBottom);
		flashSC.addChild(toTop);
		flashSC.addChild(upThreeLines);

		flashSC.addChild(txtStr);
		flashSC.addChild(txtAgi);
		flashSC.addChild(txtEnd);
		flashSC.addChild(txtInt);
		
		btns = new Array();
		btns[0] = new MyButton(10, 490);
		btns[1] = new MyButton(105, 490);
		btns[2] = new MyButton(200, 490);
		btns[3] = new MyButton(10, 525);
		btns[4] = new MyButton(105, 525);
		btns[5] = new MyButton(200, 525);
		btns[6] = new MyButton(10, 560);
		btns[7] = new MyButton(105, 560);
		btns[8] = new MyButton(200, 560);
		btns[9] = new MyButton(10, 595);
		btns[10] = new MyButton(105, 595);
		btns[11] = new MyButton(200, 595);
		
		charDesc = new MyButton(720, 300);
		optionsBtn = new MyButton(720, 335);
		
		charDesc.name = "Desc Button";
		optionsBtn.name = "Options Button";
		
		charDesc.setButton("Description", null, 0);
		optionsBtn.setButton("Options");
		
		//charDesc.addEventListener(MouseEvent.CLICK, doDescription);
		//optionsBtn.addEventListener(MouseEvent.CLICK, optionsScreen);
		
		charDesc.visible = false;
		optionsBtn.visible = false;
	}
	
	static function initialize() {
		globals = new GlobalVars();
		
		globals.name = "GlobalVars";
		Lib.current.addChild(globals);
		
		roomNPC = new MyNPC();
	}
	
	static function clearAllEvents() {
		for (i in 0...btns.length) {
			btns[i].setButton(" ");
			btns[i].clearClickFunc();
		}
	}
	
	static function main() {
		var stage = Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		// Entry point
		
		initialize();
		drawPlayfield();
		welcomeScreen();
	}
	
}