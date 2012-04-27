package net.interalia.events{
	
	import flash.events.Event;
	
	public class EtniaFacebookConnectLoginEvent extends Event{
		/**
		 * El usuario ha iniciado sesion en Facebook y hemos obtenido su informacion satisfactoriamente
		 */
		public static const USER_LOGIN_SUCCES:String = "USER_LOGIN_SUCCES";
		
		/**
		 * Ha ocurrido un error al intentar iniciar sesión. No hemos obtenido ninguna informacion del usuario
		 */
		public static const USER_LOGIN_FAIL:String = "USER_LOGIN_FAIL";
		
		/**
		 * El usuario ha terminado su sesion de Facebook
		 */
		public static const USER_LOGOUT_SUCCES:String = "USER_LOGOUT";
		
		/**
		 * Ocurrio un error mientras el usuario intentaba cerrar sesion
		 */
		public static const USER_LOGOUT_FAIL:String = "LOGOUT_ERROR";
		
		public function EtniaFacebookConnectLoginEvent($type:String, $bubbles:Boolean=false, $cancelable:Boolean=false):void{
			super($type, $bubbles, $cancelable);
		}
		
	}
}