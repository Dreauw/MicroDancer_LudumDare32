package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.World;
	import utils.Assets;
	import worlds.WorldGame;
	import net.flashpunk.FP;
	import utils.SyParticle;
	
	/**
	 * ...
	 * @author Dreauw
	 */
	public class Laser extends Destroyable
	{
		private var laserSpriteMap:Spritemap;
		private var activated:Boolean;
		private var particleTimer:Number = 0;
		
		public function Laser() {
			super();
		}
		
		override public function init(x:Number, y:Number, world:World):void {
			super.init(x, y, world);
			this.laserSpriteMap = new Spritemap(Assets.LASER, 18, 85);
			laserSpriteMap.add("anim", [0, 1, 2], 13);
			laserSpriteMap.play("anim");
			this.graphic = laserSpriteMap;
			activated = true;
			setHitbox(4, 85, -6);
			layer = 6;
			this.x += Math.max(combo.width/2, this.width/2);
			combo.x = this.x + (this.width - combo.width) / 2;
			combo.y = this.y - 20;
		}
		
		override public function switchOff():void {
			super.switchOff();
			laserSpriteMap.frame = 3;
			activated = false;
			SyParticle.emit(FP.choose("spark1", "spark2"), this.x + 9, this.y + 10, 8);
			var explosion : Explosion = world.create(Explosion) as Explosion;
			explosion.init(this.x + 9, this.y +13);
			world.add(explosion);
		}
		
		override public function onDestruction():void 
		{
			super.onDestruction();
		}
		
		override public function update():void 
		{
			super.update();
			if (activated) {
				if (particleTimer <= 0) {
					SyParticle.emit("laser", this.x + 9, this.y + this.height - 5, 20);
					particleTimer = 0.1;
				} else {
					particleTimer -= FP.elapsed;
				}
				var player : Player = collide("player", x, y) as Player;
				if (player != null) {
					this.onDestruction();
					player.takeDamage();
					switchOff();
				}
			}
			
			if (combo.x + combo.width + 30 < FP.camera.x) {
				this.onDestruction();
				FP.world.remove(this);
			}
		}
		
	}

}