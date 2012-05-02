package net.ui.mvc.userpicture.views {
	
	import com.geom.ComplexPoint;
	import com.ui.controllers.mvc.BasicFormStates;
	import com.ui.controllers.mvc.fbpicture.BasicFBPicturePickerStates;
	import com.ui.controllers.mvc.interfaces.IController;
	import com.ui.controllers.mvc.interfaces.IModel;
	import com.ui.controllers.mvc.interfaces.IView;
	import com.ui.controllers.mvc.userpicture.views.StandardWebcamView;
	
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import net.ui.mvc.fbpicture.FacebookGraphPhotoPickerModel;
	
	public class StandardPicturePickerGraphView extends UserPicturePickerBasicGraphView implements IView {
		
		protected var _fileReferenceView:Class = StandardFileReferenceGraphView;
		protected var _graphics:Dictionary;
		protected var _preview:Sprite;
		protected var _previewMask:Sprite;
		protected var _loader:MovieClip;
		protected var _fbGalleryX:Number = 135;
		protected var _fbGalleryY:Number = 353;
		protected var _fbGalleryW:Number = 480;
		protected var _webCamContainerPosition:ComplexPoint;
		protected var _gallerySelectorColor:uint = 0xFFCC00;
		protected var _webCamPreviewPosition:ComplexPoint;
		protected var _loaderFilePoint:ComplexPoint;
		protected var _loaderFBPoint:ComplexPoint;
		protected var _loaderClass:Class = GraphicInfinitLoader;
		protected var _bigGalleryMinThumbsRender:int = 3;
		protected var _smallGalleryMinThumbsRender:int = 8;
		
		public function set bigGalleryMinThumbsRender($value:int):void {
			_bigGalleryMinThumbsRender = $value;
		}
		
		public function set smallGalleryMinThumbsRender($value:int):void {
			_smallGalleryMinThumbsRender = $value;
		}
		
		public function set loaderClass($value:Class):void {
			_loaderClass = $value;
		}
		
		public function set fileReferenceView($value:Class):void {
			_fileReferenceView = $value;
		}
		
		public function set gallerySelectorColor($value:uint):void {
			_gallerySelectorColor = $value;
		}
		
		public function set fbGalleryW($value:Number):void {
			_fbGalleryW = $value;
		}
		
		public function set fbGalleryX($value:Number):void {
			_fbGalleryX = $value;
		}
		
		public function set fbGalleryY($value:Number):void {
			_fbGalleryY = $value;
		}
		
		public function set preview($value:Sprite):void {
			_preview = $value;
		}
		
		public function set previewMask($value:Sprite):void {
			_previewMask = $value;
		}
		
		public function set webCamContainerPosition($value:ComplexPoint):void {
			_webCamContainerPosition = $value;
		}
		
		public function set webCamPreviewPosition($value:ComplexPoint): void {
			_webCamPreviewPosition = $value;
		}
		
		public function get loader():MovieClip {
			return _loader;
		}
		
		public function set loaderFilePoint($point:ComplexPoint):void{
			_loaderFilePoint = $point;
		}
		
		public function set loaderFBPoint($point:ComplexPoint):void{
			_loaderFBPoint = $point;
		}
		
		override protected function get fbPictureButton():InteractiveObject {
			return graphicMC.fbButton;
		}
		
		override protected function get webCamPicButton():InteractiveObject {
			return graphicMC.webcamButton;
		}
		
		override protected function get userFilePicButton():InteractiveObject {
			return graphicMC.userFileButton;
		}
		
		override protected function get cancelButton():InteractiveObject {
			return graphicMC.cancelButton;
		}
		
		override public function StandardPicturePickerGraphView($model:IModel, $controller:IController = null, $graphic:Sprite = null, $graphics:Dictionary = null) {
			_graphics = $graphics;
			super($model, $controller, $graphic);
		}
		
		override public function destructor():void {
			if(_currentSubView) {
				_currentSubView.destructor();
			}
			super.destructor();
			addListener(_model, Event.CHANGE, stateUpdate, false);
			addButtonListeners(false);
		}

		override protected function addGraphic($add:Boolean = true):void {}

		override protected function showMenu($show:Boolean = true):void {}

		override protected function initGraphic():void {
			showMenu();
			addButtonListeners();
		}
		
		override protected function setWebcamPictureView():void {
			var view:StandardWebcamView = new StandardWebcamView(userPickerModel.webcamPicModel,
				userPickerModel.selectFileController, new Sprite());
			
			view.webCamPreviewPosition = _webCamPreviewPosition;
			view.webCamContainerPosition = _webCamContainerPosition;
			view.previewMask = _previewMask;
			view.preview = _preview;
			
			view.init();
			addView(view);
		}
		
		override protected function setUserPickerView():void {
			var view:IView = new _fileReferenceView(userPickerModel.userFileModel,
				userPickerModel.selectFileController, new Sprite());
			addView(view);
		}
		
		protected var _viewFB:StandardFBGraphPicturePickerView;
		
		override protected function setFBPicPickerView():void {
			addListener(userPickerModel.fbPicModel, BasicFBPicturePickerStates.LOADING_COVER, onModelStateChange);
			_viewFB = new StandardFBGraphPicturePickerView(userPickerModel.fbPicModel,
				userPickerModel.selectFileController, _graphics.fbPPGraphic);
			_viewFB.galleryX = _fbGalleryX;
			_viewFB.galleryY = _fbGalleryY;
			_viewFB.galleryW = _fbGalleryW;
			_viewFB.selectorColor = _gallerySelectorColor;
			if(_loaderClass){
				_viewFB.loaderClass = _loaderClass;
			}
			_viewFB.bigGalleryMinThumbsRender = _bigGalleryMinThumbsRender;
			_viewFB.smallGalleryMinThumbsRender = _smallGalleryMinThumbsRender;
			_viewFB.deltaLoader = _loaderFBPoint;
			addView(_viewFB);
			_viewFB.init();
		}
		
		override protected function stateUpdate($event:Event):void {
			super.stateUpdate($event);
			showLoader(_model.currentState == BasicFormStates.LOADING);
		}
		
		protected function addButtonListeners($add:Boolean = true):void {
			addListener(fbPictureButton, MouseEvent.CLICK, clickHandler, $add);
			addListener(webCamPicButton, MouseEvent.CLICK, clickHandler, $add);
			addListener(userFilePicButton, MouseEvent.CLICK, clickHandler, $add);
			addListener(cancelButton, MouseEvent.CLICK, clickHandler, $add);
		}
		
		protected function onModelStateChange($event:Event):void {
			if(($event.currentTarget as FacebookGraphPhotoPickerModel).isMyAlbums){
				_viewFB.countAlbums(($event.currentTarget as FacebookGraphPhotoPickerModel).currentCover, ($event.currentTarget as FacebookGraphPhotoPickerModel).albums.length);
			}else{
				_viewFB.countAlbums(($event.currentTarget as FacebookGraphPhotoPickerModel).currentCover, ($event.currentTarget as FacebookGraphPhotoPickerModel).friendAlbums.length);
			}
		}
		
		protected function showLoader($add:Boolean = true):void {
			if(!_loader) {
				_loader = new GraphicInfinitLoader();
				_loader.x = 200;
				_loader.y = 150;
			}
			addElement(_loader, $add);
		}
		
		
	}
}