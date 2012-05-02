package net {
	
	import com.facebook.graph.Facebook;
	import com.facebook.graph.data.FacebookSession;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.errors.IOError;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	
	import net.events.EtniaFacebookConnectLoadEvent;
	import net.events.EtniaFacebookConnectLoginEvent;

	/**
	 * Objeto para iniciar sesión en Facebook usando el API de Actionscript 3 desarrollado por gskinner.com
	 * Funciona con las ultimas actulizaciones de Facebook al 18 de julio del 2011.
	 * 
	 * *Importante*
	 * Para utilizar FacebookUser es necesario:
	 * 	> Agregar a la etiqueta html el namespace xmlns:fb="http://facebook.com/2008/fbml"
	 * 	> En el head agregar el siguiente javascript http://connect.facebook.net/en_US/all.js
	 *
	 * Toda la informacion que obtengamos del usuario esta sujeta a la configuracion de seguridad del usuario. 
	 */	
	public class EtniaFacebookConnect extends EventDispatcher{
		
		//Variable que indica si el usuario inicio correctamente su sesion de FB
		private static var _session:Boolean = false; 
						
		//Tipos de permisos
		//Permmisos de usuario
		public const USER_ABOUT_ME:String = "user_about_me";	
		public const USER_ACTIVITIES:String = "user_activities";
		public const USER_BIRTHDAY:String = "user_birthday";
		public const USER_CHECKINS:String = "user_checkins";
		public const USER_EDUCATION_HISTORY:String = "user_education_history";
		public const USER_EVENTS:String = "user_events";
		public const USER_GROUPS:String = "user_groups";
		public const USER_HOMETOWN:String = "user_hometown";
		public const USER_INTERESTS:String = "user_interests";
		public const USER_LIKES:String = "user_likes";
		public const USER_LOCATION:String = "user_location";
		public const USER_NOTES:String = "user_notes";
		public const USER_ONLINE_PRESENCE:String = "user_online_presence";
		public const USER_PHOTO_VIDEO_TAG:String = "user_photo_video_tags";
		public const USER_PHOTOS:String = "user_photos";
		public const USER_RELATIONSHIPS:String = "user_relationships";
		public const USER_RELATIONSHIP_DETAILS:String = "user_relationship_details";
		public const USER_RELIGION_POLITICS:String = "user_religion_politics";
		public const USER_STATUS:String = "user_status";
		public const USER_VIDEOS:String = "user_videos";
		public const USER_WEBSITE:String = "user_website";
		public const USER_WORK_HISTORY:String = "user_work_history";
		public const EMAIL:String = "email";
		public const READ_FRIENDLIST:String = "read_friendlists";
		public const READ_INSIGHTS:String = "read_insights";
		public const READ_MAILBOX:String = "read_mailbox";
		public const READ_REQUEST:String = "read_requests";
		public const READ_STREAM:String = "read_stream";
		public const XMPP_LOGIN:String = "xmpp_login";
		public const ADDS_MANAGEMENT:String = "ads_management";
		
		//Permmisos de amigos
		public const FRIENDS_ABOUT_ME :String = "friends_about_me";
		public const FRIENDS_ACTIVITIES:String = "friends_activities";
		public const FRIENDS_BIRTHDAY:String = "friends_birthday";
		public const FRIENDS_CHECKINS:String = "friends_checkins";
		public const FRIENDS_EDUCATION_HISTORY:String = "friends_education_history";
		public const FRIENDS_EVENTS:String = "friends_events";
		public const FRIENDS_GROUPS:String = "friends_groups";
		public const FRIENDS_HOMETOWN:String = "friends_hometown";
		public const FRIENDS_INTEREST:String = "friends_interests";
		public const FRIENDS_LIKES:String = "friends_likes";
		public const FRIENDS_LOCATION:String = "friends_location";
		public const FRIENDS_NOTES:String = "friends_notes";
		public const FRIENDS_ONLINE_PRESENCE:String = "friends_online_presence";
		public const FRIENDS_PHOTO_VIDEO_TAGS:String = "friends_photo_video_tags";
		public const FRIENDS_PHOTOS:String = "friends_photos";
		public const FRIENDS_RELATIONSHIPS:String = "friends_relationships";
		public const FRIENDS_RELATIONSHIPS_DETAILS:String = "friends_relationship_details";
		public const FRIENDS_RELIGION_POLITICS:String = "friends_religion_politics";
		public const FRIENDS_STATUS:String = "friends_status";
		public const FRIENDS_VIDEOS:String = "friends_videos";
		public const FRIENDS_WEBSITE:String = "friends_website";
		public const FRIENDS_WORKS_HISTORY:String ="friends_work_history";
		
		//PERMISOS DE ESCRITURA
		public const PUBLISH_STREAM:String = "publish_stream";
		public const CREATE_EVENT:String = "create_event";
		public const RSVP_EVENT:String = "rsvp_event";
		public const SMS:String = "sms";
		public const OFFLINE_ACCESS:String = "offline_access";
		public const PUBLISH_CHECKINS:String = "publish_checkins";
		public const MANAGE_FRIENDLISTS:String = "manage_friendlists";
		
		//Objeto que contiene la info del usuario
		private var _fbUserData:Object = new Object();
		
		//Objeto que carga la imagen
		private var _userImageContainer:EtniaFacebookConnectUserImage;
		
		//Objeto que contiene los bitmapdata de las imagenes de usuario
		private var _userImageObj:Object = new Object();
		
		//Formatos en los que podemos solicitar la imagen de perfil del usuario
		public const USER_IMAGE_SQUARE:String = "square";
		public const USER_IMAGE_SMALL:String = "small ";
		public const USER_IMAGE_NORMAL:String = "normal ";
		public const USER_IMAGE_LARGE:String = "large ";
		
		public static function get session():Boolean{
			return _session;
		}
		
		public static function set session($value:Boolean):void{
			_session = $value;
		}
		
		public function get dataObject():Object{
			if(_session){			
				return _fbUserData;
			}else{
				return null;
				trace( "*FB Error* No se ha iniciado ninguna sesión" );
			}
		}
		
		//Creamos el objeto y comprobamos que el ID de Facebook funcione
		//Modificación Simkin agregue el $accessToken para que se pueda pasar desde un principio la sesión
		public function EtniaFacebookConnect($id:String, $accessToken:String = null):void{
			Facebook.init($id, onInit, null, $accessToken);
		}
		
		//Si la aplicacion inicia exitosamente permite iniciar sesion
		private function onInit($result:Object, $fail:Object):void {
			if ($result) {
				trace( "*FB Succes* Sesión Iniciada");
			} else {
				trace( "*FB Error* No hay ninguna sesíon" );
			}
		}
		
		/**
		 * Para iniciar sesion en Facebook es necesario solicitar los permisos necesarios para acceder
		 * a la información del usuario. Por defaul se envia el permiso PUBLISH_STREAM que trae los datos
		 * del usuario y permite hacer publicaciones en el muro. Si se desea accesar a mas información
		 * como el album de fotos se deben de enviar los permisos pertinentes.
		 */
		public function facebookLogin($perms:Array = null):void{
			var permsStr:String = "";
			if($perms != null){
				for(var i:int = 0; i < $perms.length; i++){
					permsStr = permsStr.concat($perms[i]);
					if(i < $perms.length-1){
						permsStr = permsStr.concat(", ");
					}
				}
			}else{
				permsStr = PUBLISH_STREAM;
			}
			var opts:Object = {scope:permsStr};
			Facebook.login(onLogin, opts);
		}
		
		//Si el usuario ha iniciado sesion correctamente, obtenemos su informacion
		private function onLogin($succes:Object, $fail:Object):void {
			if ($succes) {
				trace( "*FB Succes* Usuario ha iniciado sesion" );
				Facebook.api("me", setUserData);
			} else {
				dispatchEvent(new EtniaFacebookConnectLoginEvent(EtniaFacebookConnectLoginEvent.USER_LOGIN_FAIL));
				trace( "*FB Error* Fallo al iniciar sesion" );                         
			}
		}
		
		//Si obtenemos correctamente la informacion del usuario la asignamos al objeto _fbUserData
		private function setUserData($result:Object, $fail:Object):void{
			if($result){
				fbUserData = $result;
				_session = true;
				dispatchEvent(new EtniaFacebookConnectLoginEvent(EtniaFacebookConnectLoginEvent.USER_LOGIN_SUCCES));
				trace("*FB Succes* Obteniendo datos de usuario");
			}else{
				dispatchEvent(new EtniaFacebookConnectLoginEvent(EtniaFacebookConnectLoginEvent.USER_LOGIN_FAIL));
				trace("*FB Error* No se obtuvo la informacion del usuario");
			}
		}
		/**
		 * Muestra la informacion del objeto usuario que obtenemos al hacer login en Facebook
		 */
		public function showData():void{
			if(_fbUserData != null){
				trace("**************************");
				trace("*INFORMACIÓN DEL USUARIO**");
				trace("**************************");
				for(var i:String in _fbUserData){
					trace(i + ": " + _fbUserData[i]);	
				}
				trace("**************************");				
			}else{
				trace("*FB Error* No hay información de usuario cargada");
			}
		}

//------Datos del usuario
		
		public function set fbUserData($data:Object):void{
			_fbUserData = $data;
		}
		
		public function get fbUserData():Object{
			return _fbUserData;
		}
		
		/**
		 * ID de Facebook del usuario
		 */
		public function get id():String{
			if(_fbUserData != null){
				return _fbUserData.id;
			}else{
				trace("*FB Error* No hay información de usuario cargada");
				return null;
			}
		}
		
		/**
		 * Link de Facebook del usuario
		 */
		public function get link():String{
			if(_fbUserData != null){
				return _fbUserData.link;
			}else{
				trace("*FB Error* No hay información de usuario cargada");
				return null;
			}
		}
		
		/**
		 * Uso horario en el que se encuentra el usuario
		 */
		public function get timezone():String{
			if(_fbUserData != null){
				return _fbUserData.timezone;
			}else{
				trace("*FB Error* No hay información de usuario cargada");
				return null;
			}
		}
				
		/**
		 * Apellido del usuario
		 */
		public function get lastName():String{
			if(_fbUserData != null){
				return _fbUserData.last_name;			
			}else{
				trace("*FB Error* No hay información de usuario cargada");
				return null;
			}
		}
		
		/**
		* Localidad del usuario
		*/
		public function get locale():String{
			if(_fbUserData != null){
				return _fbUserData.locale;				
			}else{
				trace("*FB Error* No hay información de usuario cargada");
				return null;
			}
		}
		
		/**
		 * Ciudad de residencia del usuario
		 */
		public function get hometown():String{
			if(_fbUserData != null){
				return _fbUserData.hometown;
			}else{
				trace("*FB Error* No hay información de usuario cargada");
				return null;
			}
		}
		
		/**
		 * Nombre de usuario en Facebook
		 */
		public function get username():String{
			if(_fbUserData != null){
				return _fbUserData.username;			
			}else{
				trace("*FB Error* No hay información de usuario cargada");
				return null;
			}
		}
				
		/**
		 * Nombre completo del usuario
		 */
		public function get fullName():String{
			if(_fbUserData != null){
				return _fbUserData.name;			
			}else{
				trace("*FB Error* No hay información de usuario cargada");
				return null;
			}
		}
		
		public function get verified():String{
			if(_fbUserData != null){
				return _fbUserData.verified;				
			}else{
				trace("*FB Error* No hay información de usuario cargada");
				return null;
			}
		}
				
		/**
		 * Segundo nombre del usuario
		 */
		public function get middleName():String{
			if(_fbUserData != null){
				return _fbUserData.middle_name;			
			}else{
				trace("*FB Error* No hay información de usuario cargada");
				return null;
			}
		}
		
		/**
		 * Primero nombre del usuario
		 */
		public function get firstName():String{
			if(_fbUserData != null){
				return _fbUserData?_fbUserData.first_name:null;
			}else{
				trace("*FB Error* No hay información de usuario cargada");
				return null;
			}
		}
				
		/**
		 * Genero del usuario
		 */
		public function get gender():String{
			if(_fbUserData != null){
				return _fbUserData.gender;
			}else{
				trace("*FB Error* No hay información de usuario cargada");
				return null;
			}
		}
		
		/**
		 * Email del usuario
		 */
		public function get email():String{
			if(_fbUserData != null){
				return _fbUserData.email;			
			}else{
				trace("*FB Error* No hay información de usuario cargada");
				return null;				
			}
		}
				
		/**
		 * Fecha de nacimiento del usuario
		 */
		public function get birthday():String{
			if(_fbUserData != null){
				return _fbUserData.birthday;			
			}else{
				trace("*FB Error* No hay información de usuario cargada");
				return null;	
			}
		}
		
//------Pedimos la foto del usuario
		/**
		 * Solicitamos la imagen de perfil del usuario. Por default regresa la imagen mas pequeña del usuario que inicio sesion,
		 * pero si se desea obtener la imagen de otro usuario hay que pasar el id de Facebook como una cadena de texto. Por default
		 * el formato de la imagen es "square", pero pasando alguna de las constantes de tamaño lo podemos modificar. Para recibir
		 * la imagen es necesario inscribirse al evento EtniaFacebookConnectLoadEvent.USER_IMAGE_LOADED, al concluir el evento la
		 * imagen vendra en un nuevo Bitmap dentro de $event.data.image
		 */
		
		 public function loadUserPhoto($id:String = "", $type:String = ""):void{
			if(_session){
				if($id == ""){
					$id = id;
				}
				
				if($type == ""){
					$type = USER_IMAGE_SQUARE;
				}
				
				if(_userImageObj[$id+$type] != null){
					//La imagen ya existe o se esta cargando
					
					//Comprobamos que la imagen se cargo correctamente
					if(_userImageObj[$id+$type].status == "error"){
						trace("*FB Error* La imagen tuvo un error al cargarse, se reintentara la carga");
						createUserImageContainer($id, $type);
					}else if(_userImageObj[$id+$type].status == "loading"){
						trace("*FB Error* La imagen solicitada ya se esta cargando, espere a que se complete");
					}else if(_userImageObj[$id+$type].status == "complete"){
						userImageReady(_userImageObj[$id+$type]);
					}
				}else{
					//Creamos una nueva instancia de _userImageContainer y cargamos la imagen en el formato especificado
					createUserImageContainer($id, $type);
				}
			}else{
				dispatchEvent(new EtniaFacebookConnectLoadEvent(EtniaFacebookConnectLoadEvent.USER_IMAGE_ERROR, null));
				trace("*FB Error* Para obtener la imagen del usuario hay que iniciar sesion primero");
			}			
		}
		 
		private function createUserImageContainer($id:String, $type:String):void{
			_userImageContainer = new EtniaFacebookConnectUserImage($id, $type);
			_userImageContainer.addEventListener(Event.COMPLETE, userImageComplete);
			_userImageContainer.addEventListener(IOErrorEvent.IO_ERROR, userImageError);
			_userImageContainer.loadUserImage();
			_userImageObj[$id+$type] = _userImageContainer;
		}
				
		private function userImageComplete($event:Event):void{
			$event.currentTarget.removeEventListener(Event.COMPLETE, userImageComplete);
			$event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, userImageError);
			userImageReady($event.currentTarget as EtniaFacebookConnectUserImage);
		}
		
		private function userImageError($event:IOErrorEvent):void{
			$event.currentTarget.removeEventListener(Event.COMPLETE, userImageComplete);
			$event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, userImageError);
			
			dispatchEvent(new EtniaFacebookConnectLoadEvent(EtniaFacebookConnectLoadEvent.USER_IMAGE_ERROR, null));
			trace("*FB Error* Ha ocurrido un problema al cargar la imagen del usuario");
		}
		
		private function userImageReady($userImage:EtniaFacebookConnectUserImage):void{
			var userImg:Bitmap =  facebookUserImage($userImage.userImageBitmapData)
			dispatchEvent(new EtniaFacebookConnectLoadEvent(EtniaFacebookConnectLoadEvent.USER_IMAGE_LOADED, {image:userImg, type:$userImage.type}));
		}
		
		private function facebookUserImage($data:BitmapData):Bitmap{
			return new Bitmap($data, "auto", true);
		}
		
//------Publicamos un mensaje en el muro del usuario
		/**
		 * Publicamos un nuevo mensaje en el muro del usuario especificado. Por default este se publica en el usuario que tiene
		 * sesion, para publicar en el muro de algun otro usuario hay que pasar el ID de Facebook como una cadena de texto. Recuerda
		 * que para publicar en el muro de cualquier otro usuario este tiene que ser amigo del usuario que inicio sesión. Hay una
		 * serie de variables que se envian a traves de un objeto, estas variables contienen informacion especifica sobre la
		 * publicacion que se hace en el muro del usuario. Estas son:
		 * message. Cadena de texto que contiene el mensaje que se va a publicar.
		 * picture. URL de una imagen que acompañe la publicacion.
		 * link. Link a una pagina que acompaña la publicacion.
		 * name. Nombre del link que publicamos
		 * caption. Titulo del link
		 * description. Descripcion del link
		 * source. URL de un archivo de video o de un archivo de Flash
		 */		
		public function publishMessage($data:Object, $method:String = "post", $user:String = "me"):void{			
			Facebook.api($user+"/feed", postCallback, $data, $method);
		}
		
		private function postCallback($succes:Object, $fail:Object):void{
			if($succes){
				dispatchEvent(new Event(Event.COMPLETE))
				trace("*FB Succes* Mensaje publicado");
			}else{
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR))
				trace("*FB Error* Ocurrio un error con la publicacion");
			}
		}
				
//------Obtenemos el estatus del Login
		public function loginStatus():void{
			trace(Facebook.getLoginStatus());
		}
		
//------Obtenemos la sesion de Facebook
//		private function get currentSession():FacebookSession{
//			return Facebook.getSession();
//		}
		
//------Obtenemos el Access Token
		public function get accessToken():String{
//			if(currentSession != null){			
//				return Facebook.getSession().accessToken;
//			}else{
				return null;
//			}
		}
		
//------Destruimos y la informacion del usuario y terminamos sesion
		public function endSession():void{
			Facebook.logout(logoutCallback)
		}
		
		private function logoutCallback($result:Object):void{
			if($result){
				session = false;
				eraseData();
				dispatchEvent(new EtniaFacebookConnectLoginEvent(EtniaFacebookConnectLoginEvent.USER_LOGOUT_SUCCES));
				trace("*FB Succes* El usuario ha terminado su sesion");
			}else{
				dispatchEvent(new EtniaFacebookConnectLoginEvent(EtniaFacebookConnectLoginEvent.USER_LOGOUT_FAIL));
				trace("*FB Error* Ha ocurrido un error al terminar la sesion");
			}
		}
		
		private function eraseData():void{
			for(var i:String in _fbUserData){
				_fbUserData[i] = null;	
			}
			_fbUserData = null;
		}
	}
}