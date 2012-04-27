package net.interalia.etnia.ui.mvc.userpicture.graphics {
	import com.etnia.graphics.gallery.IThumbnail;
	import com.etnia.graphics.gallery.IThumbnailData;
	import com.etnia.graphics.gallery.Thumbnail;
	import com.etnia.graphics.gallery.ThumbnailEventType;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	
	import net.interalia.etnia.ui.mvc.fbpicture.FbGraphUserThumbnailData;
	import net.interalia.etnia.ui.mvc.fbpicture.ThumbnailAlbumDataGraph;
	import net.interalia.structures.AlbumData;
	import net.interalia.structures.FBUserData;
	
	public class BigAlbumGraphThumbnail extends Thumbnail implements IThumbnail {
		
		protected var _loader:MovieClip;
		
		override public function set loaderClass($class:Class):void {
			_loaderClass = $class;
		}
		
		public function BigAlbumGraphThumbnail($ID:String, $background:DisplayObject, $imageUrl:String = "", $title:TextField = null) {
			super($ID, $background, $imageUrl, $title);
			_title = _background["infoAlbumTxt"] as TextField;
			_title.text = "";
//			Security.loadPolicyFile("http://sphotos.ak.fbcdn.net/crossdomain.xml");
		}
		
		override public function set data($value:IThumbnailData):void {
			super.data = $value;
			if(!(_data.thumbnailURL != "" && _data.thumbnailURL != null)) {
				setImage(new SWCNoPhoto());
				dispatchEvent(new Event(ThumbnailEventType.ON_THUMBNAIL_READY));
			}
			if($value is AlbumData || $value is FBUserData) {
				if(($value is AlbumData) && ($value as AlbumData).type == "mobile"){
					_title.text = "Fotos subidas con el celular"
				}else{
					_title.text = $value.imageName ? $value.imageName : "";
				}
				return;
			}
		}
		
		override protected function setPosition(): void{
			try {
				var thumbImg:Sprite = _background["thumbImg"] as Sprite;
				_image.x = thumbImg.x;
				_image.y = thumbImg.y;
			} catch ($error:Error) {}
		}
		
		override protected function setSizeImage(): void{
			try {
				if(_adjustImage){
					var thumbImg:Sprite = _background["thumbImg"] as Sprite;
					_image.width = thumbImg.width;
					_image.height = thumbImg.height;
				}
			} catch ($error:Error) {}
		}
		
		override protected function onLoadImage($event:Event):void {
			createLoadImageListeners(false);
			var thumbRaw:Bitmap = _imageLoader.content as Bitmap;
			var cropArea:Number = 0;
			if(thumbRaw.width > thumbRaw.height) {
				cropArea = thumbRaw.height;
			} else {
				cropArea = thumbRaw.width;
			}
			var thumbCrop:Bitmap = crop(0, 0, cropArea, cropArea * .84375, thumbRaw);
			setImage(thumbCrop);
			showLoader(false);
			dispatchEvent(new Event(ThumbnailEventType.ON_THUMBNAIL_READY));
		}
		
		override protected function arrangeTitle():void {}
		
		override protected function loadImage($imageURL:String):void {
			if(_data is FBUserData) {
				loadUserImage();
			} else {
				super.loadImage($imageURL);
			}
			showLoader();
		}
		
		public function loadUserImage():void{
			var imgUrlLoader:URLLoader = new URLLoader();
			var url:String = "https://graph.facebook.com/" + _data.ID + "/picture?type=large";
			imgUrlLoader.addEventListener(Event.COMPLETE, loadImgURLComplete);
			imgUrlLoader.addEventListener(IOErrorEvent.IO_ERROR, loadImgURLError);
			imgUrlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			imgUrlLoader.load(new URLRequest(url));
		}
		
		private function loadImgURLError($event:IOErrorEvent):void {
			$event.currentTarget.addEventListener(Event.COMPLETE, loadImgURLComplete);
			$event.currentTarget.addEventListener(IOErrorEvent.IO_ERROR, loadImgURLError);
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
			trace("*FB Error* Ha ocurrido un error al intentar cargar la informacion de la imagen de usuario");
		}
		
		private function loadImgURLComplete($event:Event):void{
			$event.currentTarget.addEventListener(Event.COMPLETE, loadImgURLComplete);
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
		}
		
		private function userImageComplete($event:Event = null):void{
			$event.currentTarget.removeEventListener(Event.COMPLETE, userImageComplete);
			$event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, userImageError);
			var userImageBitmapData:BitmapData = new BitmapData($event.target.content.width, $event.target.content.height);
			userImageBitmapData.draw($event.target.content);
			
			var thumbRaw:Bitmap = new Bitmap(userImageBitmapData);
			var cropArea:Number = 0;
			if(thumbRaw.width > thumbRaw.height) {
				cropArea = thumbRaw.height;
			} else {
				cropArea = thumbRaw.width;
			}
			var thumbCrop:Bitmap = crop(0, 0, cropArea, cropArea * .84375, thumbRaw);
			setImage(thumbCrop);
			showLoader(false);
			dispatchEvent(new Event(ThumbnailEventType.ON_THUMBNAIL_READY));
		}
		
		protected function showLoader($add:Boolean = true):void {
			if(!_loader) {
				(_loaderClass) ? _loader = new _loaderClass() : _loader = new GraphicInfinitLoader();
				_loader.scaleX = _loader.scaleY = .5;
				_loader.x = 60;
				_loader.y = 40;
				//				_loader.transform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
			}
			addElement(_loader, $add);
		}
		
		protected function crop( _x:Number, _y:Number, _width:Number, _height:Number, displayObject:DisplayObject = null):Bitmap {
			var cropArea:Rectangle = new Rectangle( 0, 0, _width, _height );
			var croppedBitmap:Bitmap = new Bitmap( new BitmapData( _width, _height ), PixelSnapping.ALWAYS, true );
			croppedBitmap.bitmapData.draw( (DisplayObject!=null) ? displayObject : stage, new Matrix(1, 0, 0, 1, -_x, -_y) , null, null, cropArea, true );
			return croppedBitmap;
		}
		
	}
}