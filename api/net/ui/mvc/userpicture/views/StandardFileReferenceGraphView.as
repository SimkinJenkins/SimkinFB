package net.ui.mvc.userpicture.views {

	import com.ui.controllers.mvc.interfaces.IFormController;
	import com.ui.controllers.mvc.interfaces.IModel;
	import com.ui.controllers.mvc.interfaces.IView;
	import com.ui.controllers.mvc.userpicture.BasicFileReferenceModel;
	import com.ui.controllers.mvc.userpicture.BasicFileReferenceStates;
	import com.ui.controllers.mvc.userpicture.BasicFileReferenceView;
	
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	public class StandardFileReferenceGraphView extends BasicFileReferenceView implements IView {

		public function StandardFileReferenceGraphView($model:IModel, $controller:IFormController, $graphic:Sprite=null) {
			super($model, $controller, $graphic);
			formController.clickHandler(BasicFileReferenceStates.SELECT);
			addListener($model, Event.CHANGE, onModelChange, true, true);
		}

		protected function onModelChange($event:Event):void {
			trace(" ::: " + _model.currentState + " :: " + BasicFileReferenceStates.FILE_SELECTED);
			if(_model.currentState == BasicFileReferenceStates.FILE_SELECTED) {
				formController.clickHandler(BasicFileReferenceStates.ADD);
			}
		}

		override protected function initGraphic():void {}
		
		override protected function addSelectListeners($add:Boolean = true):void {}

	}
}