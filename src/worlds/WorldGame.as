package worlds
{
	import entities.Camera;
	import entities.Combo;
	import entities.Conveyor;
	import entities.Destroyable;
	import entities.Explosive;
	import entities.Laser;
	import entities.Player;
	import entities.Score;
	import entities.ScoreBar;
	import entities.ShieldSkill;
	import entities.Signal;
	import entities.Skill;
	import entities.StopSkill;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.graphics.Text;
	import org.si.sion.SiONDriver;
	import org.si.sion.SiONVoice;
	import org.si.sion.utils.Scale;
	import org.si.sion.utils.SiONPresetVoice;
	import org.si.sound.DrumMachine;
	import utils.WorldBase;
	import net.flashpunk.FP;
	import utils.Assets;
	import utils.Audio;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import utils.SyParticle;
	import utils.ComboGenerator;
	
	
	/**
	 * ...
	 * @author Dreauw
	 */
	public class WorldGame extends WorldBase
	{
		private const NB_BAR_SPECTRUM:int = 5;
		
		private var drum:DrumMachine;
		private var driver:SiONDriver;
		private var drumChangeTimer:Number = 0;
		private var scale:Scale = new Scale("Amp");
		private var preset:SiONPresetVoice = new SiONPresetVoice();
		private var noteReload:Number = 0;
		private var player:Player;
		private var enemiReload:Number = 0;
		private var previouseHeights:Array = new Array(NB_BAR_SPECTRUM);
		private var updateSpectrumTimer:Number = 0;
		private var background:Backdrop;
		private var conveyor:Conveyor;
		private var stoppedTimer:Number = 0;
		private var voice:SiONVoice;
		private var voiceId:int = 0;
		private var scoreBar:ScoreBar;
		private var scoreDownTimer:Number = 0;
		private var score:Score;
		private var gameover:Boolean = false;
		private var gameoverTimer:Number = 0;
		private var gameoverText:Entity;
		private var elapsedFromStart:Number = 0;
		private var difficultyBoostTimer:Number = 5;
		private var difficultyBoostCount:int = 0;
		
		
		// Variable that affect difficulty
		private var enemyReloadDelay:Number = 5;
		private var conveyorSpeed:Number = 40;
		
		
		// Variable for the tutorial
		private var tutorialStep:int = 0;
		private var shieldSkill:ShieldSkill;
		private var stopSkill:StopSkill;
		private var tutoEnemy:Destroyable;
		
		
		public function WorldGame(tuto:Boolean = true) 
		{
			super();
			ComboGenerator.getInstance().maxComboSize = 3;
			driver = Audio.getDriver();
			drum = new DrumMachine(0, 0, 0, 0);
			driver.compile("%5 v32 q0 s30,-150 o3 $ab;%5 @8 q8 l8 o3 $[ae]4[dg]4[ae]4[cf]4;%2 @1 v8 l32 o6 $[cr)]32[cr(]8");
			driver.fadeIn(8);
			driver.play();
			drum.volume = 64;
			drum.play();
			add(player = new Player());
			add(conveyor = new Conveyor());
			addGraphic(background = new Backdrop(Assets.BACKGROUND, true, false), 0);
			Audio.registerSound("comboSuccess", "1,,0.0686,,0.4505,0.3112,,0.186,,,,,,,,0.6502,,,1,,,,,0.35");
			Audio.registerSound("scoreBar", "0,,0.0439,,0.3152,0.3104,,0.4351,,,,,,0.2956,,0.6002,,,1,,,,,0.5");
			
			// HUD
			add(shieldSkill = new ShieldSkill(this));
			add(stopSkill = new StopSkill(this));
			add(scoreBar = new ScoreBar());
			add(score = new Score());
			
			FP.camera.x = Math.floor(player.x);
			if (tuto) {
				shieldSkill.combo.visible = stopSkill.combo.visible = scoreBar.visible = stopSkill.visible = shieldSkill.visible = false;
				
				tutoEnemy = this.create(Laser) as Destroyable;
				tutoEnemy.init(FP.camera.x + FP.screen.width / FP.screen.scale - 80, FP.screen.height / FP.screen.scale - 104, this);
				add(tutoEnemy);
			}
		}
		
		public function onGameover():void {
			gameoverTimer = 0.5;
			gameover = true;
			stoppedTimer = 9999;
			
			var text:Text = new Text(" Game Over !\n\n  Score : " + score.getValue() + "\n\nSpace to retry",
			0, 0, { size:16, color:0x222222 } );
			
			//
			text.filters = [new GlowFilter(0xFFFFFF)];
			
			text.scrollX = 0;
			
			gameoverText = new Entity(((FP.screen.width / FP.screen.scale) - text.width) / 2, 14, text);
			
		}
		
		override public function update():void 
		{
			elapsedFromStart += FP.elapsed;
			
			if (gameover) {
				gameoverTimer -= FP.elapsed;
				if (gameoverTimer <= 0) {
					if (Input.mousePressed || Input.pressed(Key.SPACE)) {
						FP.world = new WorldGame();
					}
					return;
				}
			}
			
			if (tutorialStep >= 0) {
				if (tutoEnemy.inactive) {
					tutorialStep = -1;
					shieldSkill.combo.visible = stopSkill.combo.visible = scoreBar.visible = stopSkill.visible = shieldSkill.visible = true;
				}
			}
			
			
			
			// Difficulty curve
			if (tutorialStep == -1) {
				difficultyBoostTimer -= FP.elapsed;
			}
			
			if (difficultyBoostTimer <= 0) {
				difficultyBoostCount++;
				if (difficultyBoostCount == 3) {
					ComboGenerator.getInstance().maxComboSize = 4;
				}
				
				if (difficultyBoostCount == 10) {
					ComboGenerator.getInstance().maxComboSize = 5;
				}
				
				enemyReloadDelay -= 0.2;
				
				if (enemyReloadDelay < 0.5) {
					enemyReloadDelay = 0.5;
				}
				
				conveyorSpeed += 1;
				Audio.getDriver().bpm += 1;
				
				
				difficultyBoostTimer = 3;
				
				if (difficultyBoostCount > 10) {
					difficultyBoostTimer = 13;
				}
			}
			
			if (stoppedTimer <= 0 && tutorialStep != 0) {
				// First thing to do, floor for smooth scrolling
				player.x += FP.elapsed * conveyorSpeed;
			} else {
				stoppedTimer -= FP.elapsed;
				// To avoid enemy superposition
				if (stoppedTimer <= 0) {
					enemiReload = enemyReloadDelay;
				}
			}
			FP.camera.x = Math.floor(player.x);
			
			super.update();
			
			drumChangeTimer += FP.elapsed;
			noteReload -= FP.elapsed;
			enemiReload -= FP.elapsed;
			
			if (drumChangeTimer > 1) {
				var bassPattern:Number = Math.floor(Math.random() * 16);
				var snarePattern:Number = Math.floor(Math.random() * 16);
				var hihatPattern:Number = Math.floor(Math.random() * 16);
				drum.setPatternNumbers(bassPattern,snarePattern, hihatPattern);
				drumChangeTimer = 0;
			}
			
			if (enemiReload <= 0 && stoppedTimer <= 0 && tutorialStep == -1) {
				// Create a new enemy
				var enemi:Destroyable = this.create(FP.choose(Explosive, Laser, Camera)) as Destroyable;
				enemi.init(FP.camera.x + FP.screen.width / FP.screen.scale, FP.screen.height / FP.screen.scale - 104, this);
				add(enemi);
				enemiReload = enemyReloadDelay + Math.random();
			}
			updateSpectrumTimer -= FP.elapsed;
			
			// Update the combo focus
			var comb:Combo = FP.world.nearestToEntity("combo", player) as Combo;
			if (comb != null) {
				comb.onFocus();
			}
			
			
			if (scoreDownTimer <= 0) {
				if (scoreBar.getBarLevel() > 0) {
					scoreBar.setBarLevel(scoreBar.getBarLevel() - 5);
				}
				scoreDownTimer = 0.5;
			} else {
				scoreDownTimer -= FP.elapsed;
			}
			
		}
		
		public function changeInstrument():void {
			voiceId = Math.floor(Math.random() * voiceList.length);
			voice = preset[voiceList[voiceId]];
			Audio.playSound("comboSuccess");
		}
		
		public function playNote(note:int):void {
			if (noteReload > 0) return;
			
			
			driver.noteOn(scale.getNote(note) + 1, voice, 1, 0, 1);
			
			var nLevel:Number = scoreBar.getBarLevel() + 5;
			scoreBar.setBarLevel(nLevel);
			
			if (nLevel >= 100) {
				Audio.playSound("scoreBar");
				scoreBar.explose();
				score.add(1000);
			}
			
			SyParticle.emit("note" + (note + 1), player.x - player.originX, player.y - player.originY + 10);
			
			// For the fake spectrum
			for (var i:int = 0; i < previouseHeights.length; ++i) {
				previouseHeights[i] = FP.screen.height / FP.screen.scale - Math.random() * 50;
			}
			
			var arr:Array = new Array();
			FP.world.getType("skillCombo", arr);
			
			for each(var p:Combo in arr) {
				if (p.onNotePlayed(note)) {
					// When a combo is done, change the instrument
					changeInstrument();
				}
			}
			
			// Update only the nearest combo
			var comb:Combo = FP.world.nearestToEntity("combo", player) as Combo;
			if (comb != null) {
				if (comb.onNotePlayed(note)) {
					changeInstrument();
					// Increment the score
					score.add(100);
					
					// Emit a signal toward the entity
					var signal:Signal = this.create(Signal) as Signal;
					signal.init(player.x - player.originX, player.y - player.originY, comb.getParent());
					add(signal);
				}
			}
			
			//noteReload = 0.2;
		}
		
		override public function render():void 
		{
			/*
			// Fake spectrum
			var screenWidth:int = (FP.screen.width / FP.screen.scale);
			var barWidth:int = (screenWidth) / NB_BAR_SPECTRUM;
			for (var i:int = 0; i < NB_BAR_SPECTRUM; ++i) {
				var barHeight:int = previouseHeights[i];
				if (updateSpectrumTimer <= 0) {
					barHeight = Math.random() * (FP.screen.height / FP.screen.scale) * 0.2 + previouseHeights[i] * 0.8;
				}
				var subBarHeight:int = 10;
				var x:int = FP.camera.x;
				// Subrect
				for (var j:int = 0; j < Math.floor(barHeight / subBarHeight); ++j) {
					var xx:int = (((15 + (barWidth) * i - x)%screenWidth) + screenWidth) % screenWidth
					FP.buffer.fillRect(new Rectangle(xx, (FP.screen.height / FP.screen.scale) - (j * subBarHeight), barWidth - 5, subBarHeight - 2), 0xFF333333);
				}
				//FP.buffer.fillRect(new Rectangle(15 + (barWidth) * i, FP.screen.height / FP.screen.scale - barHeight, barWidth - 5, barHeight), 0xFFFF0000);
				previouseHeights[i] = barHeight;
			}
			if (updateSpectrumTimer <= 0) {
				updateSpectrumTimer = 0.05;
			}*/
			super.render();
			if (gameover && gameoverTimer <= 0) {
				FP.buffer.applyFilter(FP.buffer, FP.buffer.rect, new Point(0, 0), new BlurFilter());
				gameoverText.render();
			}
		}
		
		public function getPlayer() : Player {
			return player;
		}
		
		public function stopConveyor() : void {
			stoppedTimer = 2;
		}
		
		
		
		
		
		private var voiceList:Array = [
		"valsound.bass1", 
		"valsound.bass2", 
		"valsound.bass3", 
		"valsound.bass4", 
		"valsound.bass5", 
		"valsound.bass6", 
		"valsound.bass7", 
		"valsound.bass8", 
		"valsound.bass12", 
		"valsound.bass13", 
		"valsound.bass14", 
		"valsound.bass15", 
		"valsound.bass16", 
		"valsound.bass17", 
		"valsound.bass18", 
		"valsound.bass19", 
		"valsound.bass20", 
		"valsound.bass21", 
		"valsound.bass22", 
		"valsound.bass23", 
		"valsound.bass24", 
		"valsound.bass25", 
		"valsound.bass26", 
		"valsound.bass27", 
		"valsound.bass28", 
		"valsound.bass30", 
		"valsound.bass31", 
		"valsound.bass32", 
		"valsound.bass33", 
		"valsound.bass34", 
		"valsound.bass35", 
		"valsound.bass36", 
		"valsound.bass37", 
		"valsound.bass38", 
		"valsound.bass39", 
		"valsound.bass40", 
		"valsound.bass41", 
		"valsound.bass42", 
		"valsound.bass43", 
		"valsound.bass44", 
		"valsound.bass45", 
		"valsound.bass46", 
		"valsound.bass47", 
		"valsound.bass48", 
		"valsound.bass49", 
		"valsound.bass50", 
		"valsound.bass51", 
		"valsound.bass52", 
		"valsound.bass53", 
		"valsound.bell1", 
		"valsound.bell2", 
		"valsound.bell5", 
		"valsound.bell6", 
		"valsound.bell7", 
		"valsound.bell9", 
		"valsound.bell10", 
		"valsound.bell11", 
		"valsound.bell12", 
		"valsound.bell13", 
		"valsound.bell14", 
		"valsound.bell15", 
		"valsound.bell16", 
		"valsound.bell17", 
		"valsound.brass1", 
		"valsound.brass2", 
		"valsound.brass3", 
		"valsound.brass4", 
		"valsound.brass5", 
		"valsound.brass6", 
		"valsound.brass8", 
		"valsound.brass10", 
		"valsound.brass11", 
		"valsound.brass12", 
		"valsound.brass13", 
		"valsound.brass14", 
		"valsound.brass16", 
		"valsound.brass17", 
		"valsound.brass18", 
		"valsound.brass19", 
		"valsound.guitar2", 
		"valsound.guitar3", 
		"valsound.guitar5", 
		"valsound.lead2", 
		"valsound.lead4", 
		"valsound.lead5", 
		"valsound.lead6", 
		"valsound.lead7", 
		"valsound.lead8", 
		"valsound.lead9", 
		"valsound.lead10", 
		"valsound.lead11", 
		"valsound.lead12", 
		"valsound.lead13", 
		"valsound.lead17", 
		"valsound.lead18", 
		"valsound.lead20", 
		"valsound.lead23", 
		"valsound.lead40", 
		"valsound.lead41", 
		"valsound.lead42", 
		"valsound.piano9",
		"valsound.piano11",
		"valsound.strpad23",
		"valsound.strpad24",
		"valsound.wind2",
		"valsound.wind6",
		"valsound.wind8",
		"valsound.world5",
		"midi.piano1",
		"midi.piano8",
		"midi.chrom5",
		"midi.chrom6",
		"midi.organ1",
		"midi.strings1",
		"midi.brass7",
		"midi.reed1",
		"midi.reed8",
		"midi.pipe5"
		];
		
	}

}