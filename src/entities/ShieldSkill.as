package entities 
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.motion.LinearMotion;
	import net.flashpunk.World;
	import worlds.WorldGame;
	/**
	 * ...
	 * @author Dreauw
	 */
	public class ShieldSkill extends Skill
	{
		//private var tween:LinearMotion;
		//public var inTutorial:Boolean = false;
		
		public function ShieldSkill(world:World) {
			super(world, 2, "Shield", [0, 1, 0, 2]);
		}
		
		
		override public function onCast():void {
			super.onCast();
			(world as WorldGame).getPlayer().activateShield();
			/*if (inTutorial) {
				tween = new LinearMotion();
			
				tween.setMotion(this.x, this.y, 1, 0, 1);
				tween.start();
				addTween(tween);
			}*/
		}
		
		/*
		public function inTuto():void {
			combo.visible = this.visible = true;
			combo.y = 53;
			this.y = 50;
			combo.x = 100;
			this.x = 80;
			inTutorial = true;
		}*/
		
		
		override public function update():void {
			super.update();
			/*if (tween) {
				this.x = tween.x;
				this.combo.x = this.x + (this.graphic as Image).width + 2
				this.y = tween.y;
				this.combo.y =  this.y + 2;
			}*/
		}
		
	}

}