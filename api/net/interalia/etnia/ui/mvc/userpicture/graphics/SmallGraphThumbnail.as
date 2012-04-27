package net.interalia.etnia.ui.mvc.userpicture.graphics {
	import com.etnia.graphics.gallery.IThumbnail;
	import com.etnia.graphics.gallery.Thumbnail;
	import com.etnia.graphics.gallery.ThumbnailEventType;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	public class SmallGraphThumbnail extends Thumbnail implements IThumbnail {
		
		protected var _loader:MovieClip;
		//		protected var _loaderClass:Class;
		
		
		override public function set loaderClass($class:Class):void {
			_loaderClass = $class;
		}
		
		public function SmallGraphThumbnail($ID:String, $background:DisplayObject, $imageUrl:String = "", $title:TextField = null) {
			super($ID, $background, $imageUrl, $title);
		}
		
		override protected function setPosition():void {
			try {
				var thumbImg:Sprite = _background["phptoContent"] as Sprite;
				thumbImg.alpha = 0;
				_image.x = thumbImg.x;
				_image.y = thumbImg.y;
			} catch ($error:Error) {}
		}
		
		override protected function setSizeImage():void {
			try {
				if(_adjustImage) {
					var thumbImg:Sprite = _background["phptoContent"] as Sprite;
					thumbImg.alpha = 0;
					_image.width = thumbImg.width;
					_image.height = thumbImg.height;
				}
			} catch ($error:Error) {}
		}
		
		override protected function loadImage($imageURL:String):void {
			super.loadImage($imageURL);
			showLoader();
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
			showLoader(false);
			var thumbCrop:Bitmap = crop(0, 0, cropArea, cropArea * .84375, thumbRaw);
			setImage(thumbCrop);
			dispatchEvent(new Event(ThumbnailEventType.ON_THUMBNAIL_READY));
		}
		
		override protected function arrangeTitle():void {}
		
		protected function crop( _x:Number, _y:Number, _width:Number, _height:Number, displayObject:DisplayObject = null):Bitmap {
			var cropArea:Rectangle = new Rectangle( 0, 0, _width, _height );
			var croppedBitmap:Bitmap = new Bitmap( new BitmapData( _width, _height ), PixelSnapping.ALWAYS, true );
			croppedBitmap.bitmapData.draw( (DisplayObject!=null) ? displayObject : stage, new Matrix(1, 0, 0, 1, -_x, -_y) , null, null, cropArea, true );
			return croppedBitmap;
		}
		
		protected function showLoader($add:Boolean = true):void {
			if(!_loader) {
				_loader = _loaderClass ? new _loaderClass() : _loader = new GraphicInfinitLoader();
				_loader.scaleX = _loader.scaleY = .3;
				_loader.x = 40;
				_loader.y = 30;
			}
			addElement(_loader, $add);
		}
	}
}