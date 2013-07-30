package
{

	import com.kboctopus.sns.ServiceManager;
	import com.kboctopus.sns.constant.ServiceType;
	
	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;

	
	public class TestMobile extends Sprite
	{
		
		public function TestMobile()
		{
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;

			init();
		}
		
		
		private var testBa:ByteArray;
		private var currentPlatForm:String;
		
		private function init():void
		{
			/**初始化腾讯平台服务*/
			ServiceManager.ins().initConfig(ServiceType.TENCENT, "", "801386256", "6fa520a3c9b35b3a1fc16f117ae7a9a0", "http://www.sharesdk.cn");
			ServiceManager.ins().initConfig(ServiceType.SINA, "", "1062362054", "618be08bb2ebba7070e378e6d57b2367",  "https://api.weibo.com/oauth2/default.html");
			
			
			/**测试UI*/
			var sp:Sprite = new Sprite();
			this.addChild(sp);
			var tmp:TempButton = new TempButton("腾讯快捷分享", testTencent);
			tmp.y = 60*0;
			sp.addChild(tmp);
			tmp = new TempButton("新浪快捷分享", testSina);
			tmp.y = 60*1;
			sp.addChild(tmp);
			sp.x = (this.stage.stageWidth-sp.width)>>1;
			sp.y = (this.stage.stageHeight-sp.height)>>1;
			
			
			/**测试图片数据*/
			var bmd:BitmapData = new BitmapData(100, 100, false, 0x000000);
			testBa = bmd.encode(bmd.rect, new JPEGEncoderOptions());
		}
		
		
		protected function testTencent(event:MouseEvent):void
		{
			currentPlatForm = ServiceType.TENCENT;
			ServiceManager.ins().auth(ServiceType.TENCENT, authComplete);
		}
		
		
		protected function testSina(event:MouseEvent):void
		{
			ServiceManager.ins().auth(ServiceType.SINA, authComplete);
		}
		
		
		private function authComplete(result:String):void
		{
			trace("authComplete:" + result);
			ServiceManager.ins().share(currentPlatForm, "黑色的一片", testBa, shareBack, shareError);
		}
		
		
		private function shareBack(result:String):void
		{
			trace("shareBack:" + result);
		}
		
		private function shareError(result:String):void
		{
			trace("shareError:" + result);
		}
		
		
		

	}
}



import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;

class TempButton extends Sprite
{
	private var btnTF:TextField;
	
	public function TempButton(lab:String, handler:Function)
	{
		this.graphics.clear();
		this.graphics.beginFill(0x881123, .5);
		this.graphics.drawRoundRect(0, 0, 150, 40, 10, 10);
		this.graphics.endFill();
		btnTF = new TextField();
		btnTF.defaultTextFormat = new TextFormat("微软雅黑", 18, 0xffffff, true, null, null, null, null, "center");
		btnTF.text = lab;
		btnTF.width = 150;
		btnTF.y = 10;
		btnTF.height = 25;
		btnTF.mouseEnabled = false;
		this.addChild(btnTF);
		
		this.addEventListener(MouseEvent.CLICK, handler);
	}
	
	public function set lab(value:String):void
	{
		btnTF.text = value;
	}
}