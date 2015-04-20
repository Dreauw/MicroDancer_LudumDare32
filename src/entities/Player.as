package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import utils.Assets;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import worlds.WorldGame;
	import net.flashpunk.FP;
	import utils.SyParticle;
	import utils.Audio;
	
	/**
	 * ...
	 * @author Dreauw
	 */
	public class Player extends Entity
	{
		private var spritemap:Spritemap;
		private var frames:Array = ["right", "left", "up", "down"];
		private var frameResetTimer:Number = 0;
		private var shieldImg:Image;
		private var shieldTimer:Number = 0;
		
		public function Player() 
		{
			super(50, FP.screen.height / FP.screen.scale - 72);
			this.spritemap = new Spritemap(Assets.SPRITESHEET_DOC, 53, 53);
			this.shieldImg = new Image(Assets.SHIELD);
			shieldImg.alpha = 0.1;
			shieldImg.visible = false;
			
			this.spritemap.add("stand", [0, 5], 5, true);
			
			Input.define("up", Key.UP, Key.Z, Key.W);
			Input.define("down", Key.DOWN, Key.S);
			Input.define("left", Key.LEFT, Key.Q, Key.A);
			Input.define("right", Key.RIGHT, Key.D);
			
			this.spritemap.play("stand");
			this.graphic = spritemap;
			this.layer = 5;
			this.type = "player";
			setHitbox(11, 46, -20, -8);
			addGraphic(shieldImg);
			Audio.registerSound("death", "3,,0.3285,0.2328,0.135,0.5094,,-0.3008,,,,,,,,,,,1,,,,,0.5");
		}
		
		
		override public function update():void 
		{
			super.update();
			if (shieldImg.visible) {
				shieldTimer += FP.elapsed;
				shieldImg.alpha = 0.1 + Math.abs(Math.sin(shieldTimer) * 0.2);
			}
			for (var i:int = 0; i < frames.length; ++i) {
				if (Input.pressed(frames[i])) {
					spritemap.frame = i + 1;
					(this.world as WorldGame).playNote(i);
					frameResetTimer = 0.2;
				}
			}
			frameResetTimer -= FP.elapsed;
			if (frameResetTimer <= 0 && spritemap.frame != 0) {
				spritemap.play("stand");
			}
		}
		
		public function activateShield():void {
			shieldImg.visible = true;
		}
		
		public function takeDamage():void {
			if (shieldImg.visible) {
				shieldImg.visible = false;
			} else {
				SyParticle.emit("laser", this.x - this.originX + 10, this.y - this.originY + 20, 50);
				(world as WorldGame).onGameover();
				world.remove(this);
				Audio.playSound("death");
			}
		}
		
	}

}