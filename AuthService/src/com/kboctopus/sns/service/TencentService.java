package com.kboctopus.sns.service;

import java.net.URLEncoder;

import android.content.Intent;
import android.os.Bundle;

import com.adobe.fre.FREContext;
import com.kboctopus.sns.component.AuthActivity;
import com.tencent.weibo.sdk.android.api.WeiboAPI;

public class TencentService extends BaseService {

	public final static String NAME = "tencent";
	private boolean authing;
	private WeiboAPI api;
	
	public TencentService(FREContext cnt)
	{
		super(cnt);
		this.authUrl = "https://open.t.qq.com/cgi-bin/oauth2/authorize";
	}
	
	
	public void auth() {
		authing = true;
		int state = (int) Math.random() * 1000 + 111;
		String url = this.authUrl + 
				"?client_id=" + this.appKey + 
				"&response_type=token" + 
				"&redirect_uri=" + URLEncoder.encode(this.redirectUri) + 
				"&state=" + state;
		Intent i = new Intent(this.cnt.getActivity().getApplicationContext(), AuthActivity.class);
		Bundle bundle = new Bundle();
		bundle.putString("url", url);
		bundle.putString("platForm", NAME);
		bundle.putString("keyWord", "access_token");
		bundle.putBoolean("savepsd", true);
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
		String resultParam = result.split("#")[1];
		String params[] = resultParam.split("&");
		token = params[0].split("=")[1];
		String openid = params[2].split("=")[1];
		String openkey = params[3].split("=")[1];

		String backResult = token + "|" + openid + "|" + openkey;
		
		if (token != null && !"".equals(token)) {
			this.cnt.dispatchStatusEventAsync("getTokenComplete", backResult);
		}
	}
}
