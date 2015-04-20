package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.World;
	import utils.Assets;
	import worlds.WorldGame;
	import net.flashpunk.FP;
	import utils.Audio;
	
	/**
	 * ...
	 * @author Dreauw
	 */
	public class Explosive extends Destroyable
	{
		private var explosivesSpriteMap:Spritemap;
		private var activated:Boolean;
		
		public function Explosive() 
		{
			super();
			Audio.registerSound("destroyExplosive", "1,,0.0955,,0.1691,0.4026,,-0.3839,,,,,,,,,,,1,,,,,0.5");
		}
		
		override public function init(x:Number, y:Number, world:World):void 
		{
			super.init(x, y + 76, world);
			this.explosivesSpriteMap = new Spritemap(Assets.EXPLOSIVES, 17, 23);
			explosivesSpriteMap.frame = FP.choose(0, 1, 2);
			
			this.graphic = explosivesSpriteMap;
			activated = true;
			setHitbox(17, 23);
			layer = 5;
			explosivesSpriteMap.originX = 8;
			explosivesSpriteMap.originY = 11;
			this.x += Math.max(combo.width/2, this.width/2);
			combo.x = (this.x - explosivesSpriteMap.originX) + (this.width - combo.width) / 2;
			combo.y = this.y - 25;
		}
		
		override public function switchOff():void {
			//cameraSpriteMap.frame = 1;
			activated = false;
			Audio.playSound("destroyExplosive");
		}
		
		override public function onDestruction():void 
		{
			super.onDestruction();
		}
		
		override public function update():void 
		{
			super.update();
			
			if (activated) {
				var player:Player = (this.collide("player", this.x, this.y) as Player);
				if (player != null) {
					this.onDestruction();
					player.takeDamage();
					switchOff();
				}
			} else {
				explosivesSpriteMap.angle += 1500 * FP.elapsed;
				explosivesSpriteMap.scale += FP.elapsed * 1;
				explosivesSpriteMap.alpha -= FP.elapsed * 1.3;
				this.y += FP.elapsed * 30;
			}
			
			if ((combo.x + combo.width + 30 < FP.camera.x) || explosivesSpriteMap.alpha <= 0) {
				FP.world.recycle(this);
				this.onDestruction();
			}
			
		}
		
	}

}