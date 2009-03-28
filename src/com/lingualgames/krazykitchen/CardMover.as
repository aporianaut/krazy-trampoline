package com.lingualgames.krazykitchen {
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	import mx.effects.Move;
	import mx.events.TweenEvent;
	
	public class CardMover {
		
		private var kk:KrazyKitchen;
		
		public function CardMover(kk:KrazyKitchen) {
			this.kk = kk;
		}
		/**
		 * Assumes sushiboat is non-empty
		 */
		internal function catapult(sushiBoat:SushiBoat):void {
			// Check whether catapulting will actually happen
			var targetSlot:HandSlot = kk.hand.getNextAvailableSlot();
			
			if (!targetSlot) {
				// TODO: Feedback for full hand
				return;
			}
			// Pull card off of boat (logically & graphically)
			var movee:Card = sushiBoat.card;
			var globalLoc:Point = sushiBoat.localToGlobal(new Point(movee.x, movee.y));
			sushiBoat.removeChild(movee);
			movee.move(globalLoc.x, globalLoc.y);
			kk.addChild(movee);			
			
			// Reserve a space in the hand
			targetSlot.free = false;
			
			// Animate card toward hand
			setUpMoveEffect(movee.moveEffect, targetSlot);
			movee.moveEffect.play();
			
			// Register that animation with the hand so it can display card when animation's done
			movee.moveEffect.addEventListener(TweenEvent.TWEEN_END, targetSlot.onCardReceived);

		}
		
		public function setUpMoveEffect(m:Move, dest:UIComponent):void {	
			var destPt:Point = dest.localToGlobal(new Point(dest.x, dest.y));
			m.xTo = destPt.x;
			m.yTo = destPt.y;
		}
		
	}
}