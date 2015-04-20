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
	public class Camera extends Destroyable
	{
		private var cameraSpriteMap:Spritemap;
		private var activated:Boolean;
		private var reloadTimer:Number = 0;
		private var disabledParticleTimer:Number = 0;
		
		public function Camera() 
		{
			super();
		}
		
		override public function init(x:Number, y:Number, world:World):void 
		{
			super.init(x, y, world);
			this.cameraSpriteMap = new Spritemap(Assets.CAMERA, 41, 32);
			cameraSpriteMap.add("anim", [0, 1], 2);
			cameraSpriteMap.add("shot", [2, 0], 8, false);
			cameraSpriteMap.play("anim");
			
			this.graphic = cameraSpriteMap;
			activated = true;
			setHitbox(4, 85, -6);
			layer = 5;
			this.x += Math.max(combo.width/2, this.width/2);
			combo.x = this.x + (this.width - combo.width) / 2;
			combo.y = this.y - 20;
		}
		
		override public function switchOff():void {
			cameraSpriteMap.frame = 3;
			activated = false;
			var explosion : Explosion = world.create(Explosion) as Explosion;
			explosion.init(this.x + 20, this.y +13);
			world.add(explosion);
		}
		
		override public function onDestruction():void 
		{
			super.onDestruction();
		}
		
		override public function update():void 
		{
			super.update();
			reloadTimer -= FP.elapsed;
			
			if (activated) {
				if (reloadTimer <= 0) {
					var bullet:Bullet = FP.world.create(Bullet) as Bullet;
					bullet.init(this.x + this.cameraSpriteMap.width - 7, this.y + 18, FP.RAD * 330);
					SyParticle.emit("laser", bullet.x, bullet.y, 5);
					FP.world.add(bullet);
					cameraSpriteMap.play("shot", true);
					reloadTimer = 0.5;
				}
			} else {
				disabledParticleTimer -= FP.elapsed;
				if (disabledParticleTimer <= 0) {
					SyParticle.emit(FP.choose("spark1", "spark2"), this.x + 20, this.y +13, 3);
					disabledParticleTimer = 2;
				}
			}
			
			
			if (combo.x + combo.width + 60 < FP.camera.x) {
				FP.world.remove(this);
				this.onDestruction();
			}
		}
		
	}

}