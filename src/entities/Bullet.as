package entities 
{
	import flash.filters.GlowFilter;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import utils.Assets;
	import utils.SyParticle;
	/**
	 * ...
	 * @author Dreauw
	 */
	public class Bullet extends Entity
	{
		private const SPEED:int = 150;
		
		private var lifeTimer:Number;
		private var xinc:Number;
		private var yinc:Number;
		
		public function Bullet() {
			var img:Image = new Image(Assets.BULLET);
			setHitbox(img.width, img.height);
			img.filters = [new GlowFilter(0xFF0000)];
			super(0, 0, img);
			this.layer = 6;
		}
		
		public function init(x:Number, y:Number, angle:Number):void {
			lifeTimer = 4;
			this.x = x;
			this.y = y;
			this.xinc = Math.cos(angle) * SPEED;
			this.yinc = Math.sin(angle) * SPEED;
		}
		
		private function destroy():void {
			FP.world.recycle(this);
		}
		
		override public function update():void {
			super.update();
			this.lifeTimer -= FP.elapsed;
			
			if (lifeTimer <= 0) {
				destroy();
				return;
			}
			
			this.x += this.xinc * FP.elapsed;
			this.y += this.yinc * FP.elapsed;
			
			if (this.y > FP.screen.height / FP.screen.scale - 20) {
				destroy();
			}
			
			var player:Player = (this.collide("player", this.x, this.y) as Player);
			if (player != null) {
				player.takeDamage();
				SyParticle.emit("laser", this.x + this.width/2, this.y + this.height/2, 5);
				destroy();
			}
			
		}
		
	}

}