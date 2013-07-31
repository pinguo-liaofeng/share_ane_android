share_ane_android
=================

用于as3.0在android上的快速分享(目前只有新浪和腾讯微博的分享功能是完成的)<br />
作者:Kboctopus<br />
QQ:407743734

使用方式：
-----------------------------------
### 1.在使用任何平台前都需要初始化配置
    /**初始化平台服务*/
    ServiceManager.ins().initConfig(platForm:String, appid:String="", appKey:String="", appSecret:String="", redirectUri:String="");
参数中有的就填, 没的传"", 例如:

    /**下面是我的新浪测试用应用信息*/
    ServiceManager.ins().initConfig(ServiceType.SINA, "", "1062362054", "618be08bb2ebba7070e378e6d57b2367",  "https://api.weibo.com/oauth2/default.html");


### 2.授权与分享
    ServiceManager.ins().auth(ServiceType.SINA, authComplete);
    private function authComplete(result:String):void
    {
	    trace("授权完成, result是我给你们返回的数据, 不过这些数据一般用不着, 多为token,openid和openkey的组合字符串");
  
      /**授权完成想做什么自己决定咯, 当然一般是分享*/
	    ServiceManager.ins().share(currentPlatForm, "黑色的一片", testBa, shareBack, shareError);
    }


    private function shareBack(result:String):void
    {
	    trace("result是服务器返回的消息, 可能是分享成功信息也可能是分享失败的相关信息, 自己根据实际情况做分析吧！");
    }
		
    private function shareError(result:String):void
    {
	    trace("result的结果只可能是IO错误或者是安全错误！"); 
    }


### 3.授权分享一体化

也许上面的步骤你觉得有些费代码, 那么请用下面的方法

    ServiceManager.ins().authAndShare(platForm:String, content:String, img:ByteArray, result:Function, error:Function):void;


### 4.其他配置

请在xxx-app.xml中添加

    <uses-permission android:name="android.permission.INTERNET" />

还有

    <application >
            <activity android:name="com.kboctopus.sns.component.AuthActivity" >
            </activity>
    </application>

### 5.赶快试试看
