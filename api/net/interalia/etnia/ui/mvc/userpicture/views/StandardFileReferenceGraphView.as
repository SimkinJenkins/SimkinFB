package net.interalia.etnia.ui.mvc.userpicture.views {
	import com.etnia.core.config.DisplayContainer;
	import com.etnia.utils.graphics.MainDisplayController;
	
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import net.interalia.etnia.ui.mvc.interfaces.IFormController;
	import net.interalia.etnia.ui.mvc.interfaces.IModel;
	import net.interalia.etnia.ui.mvc.interfaces.IView;
	import net.interalia.etnia.ui.mvc.userpicture.BasicFileReferenceModel;
	import net.interalia.etnia.ui.mvc.userpicture.BasicFileReferenceStates;
	import net.interalia.etnia.ui.mvc.userpicture.BasicFileReferenceView;
	
	public class StandardFileReferenceGraphView extends BasicFileReferenceView implements IView {
		
		protected var _loader:MovieClip;
		protected var _loaderPoint:Point;
		protected var _loaderClass:Class;
		
		public function set loaderClass($class:Class):void {
			_loaderClass = $class;
		}
		
		public function get loader():MovieClip{
			return _loader;
		}
		
		public function set loader($movie:MovieClip):void{
			_loader = $movie;
		}
		
		public function set loaderPoint($point:Point):void {
			_loaderPoint = $point;
		}
		
		override protected function get addButton():InteractiveObject {
			return graphicMC.addButton;
		}
		
		override protected function get changeButton():InteractiveObject {
			return graphicMC.changeButton;
		}
		
		override protected function get cancelButton():InteractiveObject {
			return graphicMC.cancelButton;
		}
		
		override protected function get selectButton():InteractiveObject {
			return graphicMC.selectButton;
		}
		
		override protected function get fileTxf():TextField {
			return graphicMC.fileTxf;
		}
		
		protected function get termsChb():MovieClip {
			return graphicMC.termsChb;
		}
		
		public function StandardFileReferenceGraphView($model:IModel, $controller:IFormController, $graphic:Sprite=null) {
			super($model, $controller, $graphic);
			addListener($model, BasicFileReferenceModel.ON_TERMS_CHANGE, onTermsChange);
		}
		
		override public function destructor():void {
			addButtonListeners(false);
			showLoader(false);
			if(fileTxf) {
				fileTxf.text = "";
			}
			super.destructor();
			addElement(fileTxf);
		}
		
		override protected function initGraphic():void {
			if(termsChb) {
				termsChb.useHandCursor = true;
				termsChb.buttonMode = true;
				termsChb.checkBox.gotoAndStop(1);
			}
			addButtonListeners();
		}
		
		override protected function addSelectListeners($add:Boolean = true):void {}
		
		override protected function stateUpdate($event:Event):void {
			switch(_model.currentState) {
				case BasicFileReferenceStates.LOADING_FILE:		showLoader();		break;
			}
			super.stateUpdate($event);
		}
		
		override protected function getButtonID($button:InteractiveObject):String {
			switch($button) {
				case termsChb:			return BasicFileReferenceStates.TERMS;
			}
			return super.getButtonID($button);
		}
		
		protected function addButtonListeners($add:Boolean = true):void {
			addListener(addButton, MouseEvent.CLICK, clickHandler, $add);
			addListener(changeButton, MouseEvent.CLICK, clickHandler, $add);
			addListener(cancelButton, MouseEvent.CLICK, clickHandler, $add);
			addListener(selectButton, MouseEvent.CLICK, clickHandler, $add);
			//			addListener(termsChb, MouseEvent.CLICK, onCheckClick, $add);
			addListener(termsChb, MouseEvent.CLICK, clickHandler, $add, true);
		}
		
		protected function onTermsChange($event:Event):void {
			if(termsChb) {
				termsChb.checkBox.gotoAndStop((_model as BasicFileReferenceModel).terms ? 2 : 1);
			}
		}
		
		protected function showLoader($add:Boolean = true):void {
			if(!_loader && !_loaderClass) {
				_loader = new GraphicInfinitLoader();
				locatedLoader();
			} else {
				if(_loaderClass){
					_loader = new _loaderClass();
					locatedLoader();
				}
			}
			addElement(_loader, $add);
		}
		
		protected function locatedLoader():void{
			if(_loaderPoint){
				_loader.x = _loaderPoint.x;
				_loader.y = _loaderPoint.y;
			}else{
				_loader.x = 350;
				_loader.y = 150;
			}
		}
	}
}