package entities 
{
	import flash.filters.GlowFilter;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import utils.Assets;
	/**
	 * ...
	 * @author Dreauw
	 */
	public class Signal extends Entity
	{
		private const SPEED:int = 200;
		
		private var lifeTimer:Number;
		private var xinc:Number;
		private var yinc:Number;
		private var spriteMap:Spritemap;
		private var target:Entity;
		
		public function Signal() {
			super(0, 0);
			spriteMap = new Spritemap(Assets.SIGNAL, 28, 21);
			spriteMap.add("anim", [0, 1, 2, 3, 4, 5, 6], 20);
			spriteMap.play("anim");
			spriteMap.originX = 14;
			spriteMap.originY = 10;
			this.graphic = spriteMap;
			setHitbox(10, 10);
			
			this.layer = 0.5;
		}
		
		public function init(x:Number, y:Number, target:Entity):void {
			lifeTimer = 4;
			this.x = x;
			this.y = y;
			this.target = target;
			spriteMap.play("anim", true);

		}
		
		private function destroy():void {
			FP.world.recycle(this);
		}
		
		override public function update():void {
			super.update();
			this.lifeTimer -= FP.elapsed;
			
			var angle:Number = FP.angle(this.x, this.y, target.x, target.y);
			spriteMap.angle = angle + 270;
			angle *= FP.RAD;
			this.xinc = Math.cos(angle) * SPEED;
			this.yinc = Math.sin(angle) * SPEED;
			
			if (lifeTimer <= 0) {
				destroy();
				return;
			}
			
			if (collideWith(target, this.x, this.y)) {
				(target as Destroyable).switchOff();
				destroy();
			}
			
			this.x += this.xinc * FP.elapsed;
			this.y += this.yinc * FP.elapsed;
			
			if (this.y > FP.screen.height / FP.screen.scale - 20) {
				destroy();
			}
			
		}
		
	}

}