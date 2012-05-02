package net.interalia.ui {

	import com.etnia.core.system.EtniaSystem;
	import com.etnia.net.DataSenderFormat;
	import com.etnia.net.EtniaLoaderEvent;
	import com.etnia.ui.controllers.BasicController;
	import com.etnia.ui.controllers.BasicTransactionController;
	import com.etnia.utils.EtniaMath;
	import com.facebook.graph.Facebook;
	
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import net.etnia.utils.MathUtils;
	import net.interalia.core.EtniaFacebookGraph;

	public class BasicFacebookGraphController extends BasicTransactionController {

		public function BasicFacebookGraphController($container:Sprite) {
			super($container);
			_dataFormat = DataSenderFormat.XML;
		}

		protected function streamPublish($message:String = "", $picture:String = "", $link:String = "", $name:String = "", $caption:String = "", $desc:String = "", $source:String = "", $profileID:String = ""):void {
			$profileID = $profileID == "" ? EtniaFacebookGraph.getInstance().userData.id : $profileID;
			var args:Array = arguments;
			EtniaSystem.addDebugMessage(args.toString());
			Facebook.ui("stream.publish", {name:$name, link:$link, picture:$picture, caption:$caption, description:$desc}, onPostResponse, "popup");
		}

		protected function linkPublish($message:String = "", $picture:String = "", $link:String = "", $name:String = "", $caption:String = "", $desc:String = "", $source:String = "", $profileID:String = ""):void {
			trace(encodeURI("http://www.facebook.com/sharer/sharer.php?u=" + $link + "&t=" + $message));
			navigateToURL(new URLRequest(encodeURI("http://www.facebook.com/sharer/sharer.php?u=" + $link + "&t=" + $message)), "_blank");
		}

		protected function onSendPostResponse($event:EtniaLoaderEvent):void {
			trace($event.serverResponse);
		}

		protected function onPostResponse($result:Object):void {
			if($result) {
				trace("Result");
			} else {
				trace("Fail");
			}
		}

		protected function getPublishArguments($message:String = "", $picture:String = "", $link:String = "", $name:String = "", $caption:String = "", $desc:String = "", $source:String = ""):Object {
			var data:Object = new Object();
//			if($message != "") {
//				data.message = $message;
//			}
			if($picture != "") {
				data.picture = $picture;
			}
			if($link != "") {
				data.link = $link;
			}
			if($name != "") {
				data.name = $name;
			}
			if($caption != "") {
				data.caption = $caption;
			}
			if($desc != "") {
				data.description = $desc;
			}
//			if($source != "") {
//				data.source = $source;
//			}
			return data;
		}


		protected function getPublishVars($message:String = "", $picture:String = "", $link:String = "", $name:String = "", $caption:String = "", $desc:String = "", $source:String = ""):String {
			var uri:String = "";
			if($message != "") {
				uri += "&message=" + $message;
			}
			if($picture != "") {
				uri += "&picture=http://java.stg.interalia.net/CCZeroMX11/" + $picture;
			}
			if($link != "") {
				uri += "&link=http://java.stg.interalia.net/CCZeroMX11/" + $link;
			}
			if($name != "") {
				uri += "&name=" + $name;
			}
			if($caption != "") {
				uri += "&caption=" + $caption;
			}
			if($desc != "") {
				uri += "&description=" + $desc;
			}
			if($source != "") {
				uri += "&source=http://java.stg.interalia.net/CCZeroMX11/" + $source;
			}
			return uri;
		}
	}
}