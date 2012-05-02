package net {

	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	public class EtniaFacebookConnectUserImage extends Sprite {

		private var _userImageBitmapData:BitmapData;
		private var _id:String = "";
		private var _type:String = "";
		private var _status:String = "new";
		private var _bitmapDataObject:Object;
		
		/**
		* ID de usuario de Facebook
		*/
		public function get id():String{
			return _id;
		}
		
		/**
		 * Formato de la imagen solicitada
		 */
		public function get type():String{
			return _type;
		}
		
		/**
		 * Estatus de la imagen en carga
		 */
		public function get status():String{
			return _status;
		}
				
		public function get userImageBitmapData():BitmapData{
			return _userImageBitmapData;
		}
				
		public function EtniaFacebookConnectUserImage($id:String, $type:String)
		{
			_bitmapDataObject = new Object();
			_id = $id;
			_type = $type;
		}
				
		public function loadUserImage():void{
			var imgUrlLoader:URLLoader = new URLLoader();
			var url:String = "https://graph.facebook.com/"+id+"/picture?type="+_type;			
			imgUrlLoader.addEventListener(Event.COMPLETE, loadImgURLComple);
			imgUrlLoader.addEventListener(IOErrorEvent.IO_ERROR, loadImgURLError);
			imgUrlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			imgUrlLoader.load(new URLRequest(url));
			_status = "loading";
		}
		
		private function loadImgURLError($event:IOErrorEvent):void{
			$event.currentTarget.addEventListener(Event.COMPLETE, loadImgURLComple);
			$event.currentTarget.addEventListener(IOErrorEvent.IO_ERROR, loadImgURLError);
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
			trace("*FB Error* Ha ocurrido un error al intentar cargar la informacion de la imagen de usuario");
			_status = "error";
		}
		
		private function loadImgURLComple($event:Event):void{
			$event.currentTarget.addEventListener(Event.COMPLETE, loadImgURLComple);
			$event.currentTarget.addEventListener(IOErrorEvent.IO_ERROR, loadImgURLError);
			var userImgLoader:Loader = new Loader();
			userImgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, userImageComplete);
			userImgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, userImageError);
			userImgLoader.loadBytes($event.target.data as ByteArray);
		}
		
		private function userImageError($event:Event):void{
			$event.currentTarget.removeEventListener(Event.COMPLETE, userImageComplete);
			$event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, userImageError);
			trace("*FB Error* Ha ocurrido un problema al cargar la imagen del usuario");
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
			_status = "error";
		}
		
		private function userImageComplete($event:Event = null):void{
			$event.currentTarget.removeEventListener(Event.COMPLETE, userImageComplete);
			$event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, userImageError);
			_userImageBitmapData = new BitmapData($event.target.content.width, $event.target.content.height);
			_userImageBitmapData.draw($event.target.content);
			dispatchEvent(new Event(Event.COMPLETE));
			_status = "complete";
		}
	}
}