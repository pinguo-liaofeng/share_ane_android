package com.kboctopus.sns.service;

import java.io.IOException;
import java.net.URLEncoder;

import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.widget.Toast;

import com.adobe.fre.FREContext;
import com.kboctopus.sns.component.AuthActivity;

public class SinaService extends BaseService {

	public final static String NAME = "sina";
	private String code;
	private boolean authing;
	
	public SinaService(FREContext cnt)
	{
		super(cnt);
		this.authUrl = "https://open.weibo.cn/oauth2/authorize";
	}
	
	
	public void auth() {
		authing = true;
		String url = this.authUrl + 
				"?client_id=" + this.appKey + 
				"&response_type=code" + 
				"&redirect_uri=" + URLEncoder.encode(this.redirectUri) + 
				"&display=mobile";
		Intent i = new Intent(this.cnt.getActivity().getApplicationContext(), AuthActivity.class);
		Bundle bundle = new Bundle();
		bundle.putString("url", url);
		bundle.putString("platForm", NAME);
		bundle.putString("keyWord", "?code");
		bundle.putBoolean("savepsd", false);
		i.putExtras(bundle);
		this.cnt.getActivity().startActivity(i);
	}
	
	
	
	@Override
	public void handlerCallbackURL(String result){
		if(authing == false)
		{
			return;
		}
		
		authing = false;

		code = result.split("code=")[1];

		new Thread()
    	{
    		public void run()
    		{
    			String url = "https://api.weibo.com/oauth2/access_token?client_id=" + appKey +
    	    			"&client_secret=" + appSecret +
    	    			"&grant_type=authorization_code" + 
    	    			"&redirect_uri=" + URLEncoder.encode(redirectUri) +
    	    			"&code=" + code;
    	    	HttpPost hp = new HttpPost(url);
    	    	HttpClient client = new DefaultHttpClient();
    	    	HttpResponse respon = null;
    	    	try {
    				respon = client.execute(hp);
    				if(respon.getStatusLine().getStatusCode() == HttpStatus.SC_OK)
    				{
    					String tokenResult = EntityUtils.toString(respon.getEntity());
    					
    					JSONObject data;
    					data = new JSONObject(tokenResult);
    					token = data.getString("access_token");	
    					cnt.dispatchStatusEventAsync("getTokenComplete", token);
    				}
    				else
    				{
    					Toast.makeText(cnt.getActivity().getApplicationContext(), "获取token失败", Toast.LENGTH_LONG).show();
    				}
    			} catch (ClientProtocolException e) {
    				Toast.makeText(cnt.getActivity().getApplicationContext(), "获取token失败", Toast.LENGTH_LONG).show();
    			} catch (IOException e) {
    				Toast.makeText(cnt.getActivity().getApplicationContext(), "获取token失败", Toast.LENGTH_LONG).show();
    			} catch (JSONException e) {
    				Toast.makeText(cnt.getActivity().getApplicationContext(), "获取token失败", Toast.LENGTH_LONG).show();
    			}
    	    	
    	    	handler.sendEmptyMessage(0);
    		}
    	}.start();
	}
	
	
	private Handler handler =new Handler()
    { 
    	public void handleMessage(Message msg)
    	{ 
    		super.handleMessage(msg); 
//    		if (token != null && !"".equals(token)) {
//				cnt.dispatchStatusEventAsync("getTokenComplete", token);
//			}
    	} 
    };
}
