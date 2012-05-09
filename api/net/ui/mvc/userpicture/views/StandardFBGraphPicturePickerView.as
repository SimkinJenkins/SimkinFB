package net.ui.mvc.userpicture.views {
	

	import com.graphics.gallery.ScrollableGallery;
	import com.graphics.gallery.SimpleGallery;
	import com.graphics.gallery.StackGalleryTypes;
	import com.ui.controllers.mvc.fbpicture.BasicFBPicturePickerStates;
	import com.ui.controllers.mvc.interfaces.IController;
	import com.ui.controllers.mvc.interfaces.IModel;
	import com.ui.controllers.mvc.interfaces.IView;
	
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import net.core.EtniaFacebookGraph;
	import net.ui.mvc.fbpicture.BasicFriendsFBGraphPicturePickerView;
	import net.ui.mvc.userpicture.graphics.BigAlbumGraphThumbnail;
	import net.ui.mvc.userpicture.graphics.SmallGraphThumbnail;

	public class StandardFBGraphPicturePickerView extends BasicFriendsFBGraphPicturePickerView implements IView {
		
		protected var _bigGallery:ScrollableGallery;
		protected var _smallGallery:ScrollableGallery;
		protected var _galleryX:Number = 135;
		protected var _galleryY:Number = 353;
		protected var _galleryW:Number = 480;
		protected var _selectorColor:uint = 0xFFCC00;
		protected var _loader:MovieClip;
		protected var _deltaLoader:Point = new Point(0,0);
		protected var _bigGalleryMinThumbsRender:int = 3;
		protected var _smallGalleryMinThumbsRender:int = 5;
		
		
		public function set selectorColor($value:uint):void {
			_selectorColor = $value;
		}
		
		public function set galleryW($value:Number):void {
			_galleryW = $value;
		}
		
		public function set galleryX($value:Number):void {
			_galleryX = $value;
		}
		
		public function set galleryY($value:Number):void {
			_galleryY = $value;
		}
		
		public function set deltaLoader($value:Point):void{
			_deltaLoader = $value;
		}
		
		public function set bigGalleryMinThumbsRender($value:int):void {
			_bigGalleryMinThumbsRender = $value;
		}
		
		public function set smallGalleryMinThumbsRender($value:int):void {
			_smallGalleryMinThumbsRender = $value;
		}

		protected function get titleTxf():TextField {
			return graphicMC.titleTxf;
		}

		override protected function get selectButton():InteractiveObject {
			return graphicMC.selectButton;
		}
		
		override protected function get cancelButton():InteractiveObject {
			return graphicMC.cancelButton;
		}
		
		override protected function get myAlbumsButton():InteractiveObject {
			return graphicMC.myAlbumsButton;
		}

		override protected function get friendsAlbumsButton():InteractiveObject {
			return graphicMC.friendsAlbumButton;
		}

		protected function get changeAlbumButton():SimpleButton {
			return graphicMC.changeAlbum;
		}

		protected function get termsChb():MovieClip {
			return graphicMC.termsChb;
		}
		
		public function StandardFBGraphPicturePickerView($model:IModel, $controller:IController = null, $graphic:Sprite = null) {
			super($model, $controller, $graphic);
		}

		override protected function addGraphic($add:Boolean = true):void {}

		override public function destructor():void {
			addButtonListeners(false);
			enableTabButton(myAlbumsButton as SimpleButton, false);
			enableTabButton(friendsAlbumsButton as SimpleButton, false);
			super.destructor();
			addElement(myAlbumsButton);
			addElement(friendsAlbumsButton);
			addElement(graphicMC.back);
			addElement(graphicMC.left);
			addElement(graphicMC.right);
			addElement(graphicMC.cancelButton);
		}
		
		public function init():void {
			showSelectButton(false);
			graphicMC.gotoAndStop("mine");
			formController.clickHandler(getButtonID(myAlbumsButton));
			showLoader();
		}
		
		override protected function initGraphic():void {
			addButtonListeners();
			if(termsChb) {
				termsChb.useHandCursor = true;
				termsChb.buttonMode = true;
				termsChb.checkBox.gotoAndStop(1);
			}
			enableTabButton(myAlbumsButton as SimpleButton, false);
			enableTabButton(friendsAlbumsButton as SimpleButton);
		}
		
		override protected function getButtonID($button:InteractiveObject):String {
			switch($button) {
				case termsChb:			return BasicFBPicturePickerStates.TERMS;
				case cancelButton:		showLoader(false);	break;
				case selectButton: 		if(_model.currentState != BasicFBPicturePickerStates.PHOTO_SELECTED){
											removeGalleries();
											showLoader();
										}
										break;
				case myAlbumsButton:			
				case friendsAlbumsButton:	removeGalleries();	showLoader(); break;
			}
			return super.getButtonID($button);
		}
		
		override protected function createGallery():SimpleGallery {
			showLoader(false);
			switch(_model.currentState) {
				case BasicFBPicturePickerStates.ALBUMS_LOADED:
																		if(fbPPModel.isMyAlbums) {
																			titleTxf.text = EtniaFacebookGraph.getInstance().userData.name;
																			return createBigGallery();
																		}
																		break;
				case BasicFBPicturePickerStates.FRIEND_ALBUM_LOADED:
				case BasicFBPicturePickerStates.FRIENDS_LOADED:			
																		if(!fbPPModel.isMyAlbums){
																			return createBigGallery();
																		}
																		break;
				case BasicFBPicturePickerStates.PHOTOS_DATA_LOADED:		return createSmallGallery();
			}
			return super.createGallery();
		}
		
		override protected function removeGalleries():void {
			super.removeGalleries();
			destructGallery(_bigGallery);
			destructGallery(_smallGallery);
		}
		
		override protected function showSelectButton($add:Boolean = true):void {
			addElement(selectButton, $add, graphicMC);
		}

		override protected function errorHandler($event:ErrorEvent):void {
			super.errorHandler($event);
			trace($event);
			switch(_model.currentError) {
				case BasicFBPicturePickerStates.FRIEND_ALBUMS_ERROR:	addListener(selectButton, MouseEvent.CLICK, clickHandler);	break;
			}
		}
		
		override protected function albumsLoadedHandler():void {
			showLoader(false);
			super.albumsLoadedHandler();
		}
		
		protected function enableTabButton($mc:SimpleButton, $add:Boolean = true):void {
			if(!$mc) {
				return;
			}
			addListener($mc, MouseEvent.MOUSE_OVER, onTabMouseEvent, $add);
			addListener($mc, MouseEvent.MOUSE_OUT, onTabMouseEvent, false);
			addListener($mc, MouseEvent.CLICK, onTabMouseEvent, $add);
		}
		
		protected function onTabMouseEvent($event:MouseEvent):void {
			var mc:SimpleButton = $event.currentTarget as SimpleButton;
			if($event.type == MouseEvent.CLICK) {
				enableTabButton(mc, false);
				enableTabButton(mc == friendsAlbumsButton ? myAlbumsButton as SimpleButton : friendsAlbumsButton as SimpleButton);
				formController.clickHandler(getButtonID(mc));
				graphicMC.gotoAndStop(mc == myAlbumsButton ? "mine" : "friends");
				return;
			}
			var mouseOver:Boolean = $event.type == MouseEvent.MOUSE_OVER;
			addListener(mc, MouseEvent.MOUSE_OVER, onTabMouseEvent, !mouseOver);
			addListener(mc, MouseEvent.MOUSE_OUT, onTabMouseEvent, mouseOver);
		}
		
		protected function addButtonListeners($add:Boolean = true):void {
			addListener(selectButton, MouseEvent.CLICK, clickHandler, $add);
			addListener(cancelButton, MouseEvent.CLICK, clickHandler, $add);
			addListener(termsChb, MouseEvent.CLICK, onCheckClick, $add);
			addListener(termsChb, MouseEvent.CLICK, clickHandler, $add, true);
		}
		
		protected function onCheckClick($event:MouseEvent):void {
			var chb:MovieClip = ($event.currentTarget as MovieClip).checkBox;
			chb.gotoAndStop(chb.currentFrame == 1 ? 2 : 1);
		}
		
		protected function createBigGallery():ScrollableGallery {
			if(!_bigGallery) {
				addElement(graphicMC.left);
				addElement(graphicMC.right);
				graphicMC.left.visible = graphicMC.right.visible = true
				_bigGallery = new ScrollableGallery(StackGalleryTypes.HORIZONTAL_GALLERY, 2);
				_bigGallery.backgroundClass = SWCBigAlbumThumbnail;
				_bigGallery.thumbClass =  BigAlbumGraphThumbnail;
				_bigGallery.adjustImage = true;
				_bigGallery.minThumbsRender = _bigGalleryMinThumbsRender;
				_bigGallery.paddingX = 13;
				_bigGallery.paddingY = 3;
				_bigGallery.x = _galleryX;
				_bigGallery.y = _galleryY;
				_bigGallery.selectorColor = _selectorColor;
				_bigGallery.visibleWidth = _galleryW;
				_bigGallery.visibleHeight = 200;
				_bigGallery.posArrows = false;
				_bigGallery.left = graphicMC.left;
				_bigGallery.right = graphicMC.right;
				_bigGallery.loaderClass = _loaderClass;
				_bigGallery.visible = true;
//				addContainerMask(_bigGallery);
			}
			return _bigGallery;
		}
		
		protected function addContainerMask($container:Sprite):void {
			var mask:Sprite = new Sprite();
			mask.graphics.beginFill(0, .5);
			mask.graphics.drawRect(0, 0, _galleryW, 300);
			addElement(mask);
			$container.mask = mask;
		}

		protected function createSmallGallery():ScrollableGallery {
			if(!_smallGallery) {
				_smallGallery = new ScrollableGallery(StackGalleryTypes.HORIZONTAL_GALLERY, 2);
				_smallGallery.backgroundClass = SWCSmallThumbnail;
				_smallGallery.thumbClass = SmallGraphThumbnail;
				_smallGallery.paddingX = 3;
				_smallGallery.minThumbsRender = _smallGalleryMinThumbsRender;
				_smallGallery.paddingY = 3;
				_smallGallery.x = _galleryX;
				_smallGallery.y = _galleryY;
				_smallGallery.selectorColor = _selectorColor;
				_smallGallery.adjustImage = true;
				_smallGallery.visibleWidth = _galleryW;
				_smallGallery.visibleHeight = 165;

				_smallGallery.posArrows = false;
				_smallGallery.left = graphicMC.left;
				_smallGallery.right = graphicMC.right;
				_smallGallery.loaderClass = _loaderClass;
				_smallGallery.visible = true;
//				addContainerMask(_smallGallery);
			}
			return _smallGallery;
		}
		
		protected function showLoader($add:Boolean = true):void {
			if(!_loader){
				_loader = new _loaderClass();
				_loader.x = ((_graphic.width - _loader.width) / 2) + _deltaLoader.x;
				_loader.y = ((_graphic.height - _loader.height) / 2) + _deltaLoader.y;
			}
			(_loader.loaderTxf) ? (_loader.loaderTxf as TextField).text = "Cargando" : "";
			addElement(_loader, $add, _graphic);
		}
		
		public function countAlbums($value:Number = 0, $lenght:Number = 0):void {
			if(_loader && _loader.loaderTxf){
				(_loader.loaderTxf as TextField).text = "Cargando " + $value + "/" + $lenght;
			}
		}
	}
}