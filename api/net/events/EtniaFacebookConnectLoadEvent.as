package net.events {

	import flash.events.Event;
	
	public class EtniaFacebookConnectLoadEvent extends Event{
		
		public var data:Object;
		
		/**
		 * La imagen del usuario de a cargado satisfactoriamente
		 */
		public static const USER_IMAGE_LOADED:String = "USER_IMAGE_LOADED";
		
		/**
		 * Ha ocurrido un problema al cargar la imagen del usuario
		 */
		public static const USER_IMAGE_ERROR:String = "USER_IMAGE_ERROR";
		
				
		public function EtniaFacebookConnectLoadEvent($type:String, $data:Object, $bubbles:Boolean=false, $cancelable:Boolean=false):void{
			super($type, $bubbles, $cancelable);
			data = $data;
		}
		
	}
}