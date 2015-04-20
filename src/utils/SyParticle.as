package utils {
	import adobe.utils.CustomActions;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.ParticleType;
	/**
	* ...
	* @author Dreauw
	*/
	
	public class SyParticle extends Entity {
		static public var instance : SyParticle;
		public function SyParticle() {
			super(0, 0, new Emitter(Assets.PARTICLES, 7, 9));
			layer = 5;
			registerParticle();
		}
		
		public function newType(name:String, frames:Array = null):ParticleType {
			return (graphic as Emitter).newType(name, frames);
		}

		private function registerParticle() : void {
			newType("note1", [0])
				.setAlpha(1, 0)
				.setMotion(0, 20, 0.7, 360, 0, 0.4)
				.setColor(0xFF2222);
				
			newType("note2", [0])
				.setAlpha(1, 0)
				.setMotion(0, 20, 0.7, 360, 0, 0.4)
				.setColor(0x22FF22);
			
			newType("note3", [0])
				.setAlpha(1, 0)
				.setMotion(0, 20, 0.7, 360, 0, 0.4)
				.setColor(0x2222FF);
				
			newType("note4", [0])
				.setAlpha(1, 0)
				.setMotion(0, 20, 0.7, 360, 0, 0.4)
				.setColor(0xFFFF00);
				
			newType("laser", [1])
				.setAlpha(1, 0)
				.setMotion(0, 20, 0.7, 360, 0, 0.4);
				
			newType("spark1", [2])
				.setAlpha(1, 0)
				.setGravity(5, 10)
				.setMotion(0, 20, 0.7, 360, 0, 0.4);	
			
			newType("spark2", [3])
				.setAlpha(1, 0)
				.setGravity(5, 10)
				.setMotion(0, 20, 0.7, 360, 0, 0.4);	
				
				
			var colors:Array = [0xca2f2f, 0xcf6b29, 0xd0bb28, 0x8dd028, 0x60cf29, 0x29cf60,
			0x27d192, 0x2796d1, 0x2867d0, 0x6328d0, 0x9725d3, 0xd024d5, 0xd22674, 0xd2262b];
			
			for (var i : int = 0; i < colors.length; ++i) {
				newType("p"+i, [4])
					.setAlpha(1, 0)
					.setGravity(5, 10)
					.setColor(colors[i])
					.setMotion(0, 20, 0.7, 360, 0, 0.8);
			}
			/*
			newType("foobar", [0])
				.setAlpha(1, 0)
				.setMotion(0, 20, 0.7, 360, 0, 0.4)
				.setGravity(5, 10);
			*/
		}

		static public function emit(name:String, x:Number, y:Number, nbr:Number = 1) : void {
			if (!instance || instance.world != FP.world) {
				instance = new SyParticle();
				if (instance.world) instance.world.remove(instance);
				FP.world.add(instance);
			}
			for (var i : Number = 0; i < nbr ; i++) {(instance.graphic as Emitter).emit(name, x, y);}
		}

	}

}