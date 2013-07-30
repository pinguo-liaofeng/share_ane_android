package com.kboctopus.sns.component;

import com.kboctopus.sns.service.SNSServiceFactory;
import com.kboctopus.sns.util.Util;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.Window;
import android.view.WindowManager;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.LinearLayout;


public class AuthActivity extends Activity {

	public static final int ALERT_NETWORK = 4;
	
	private Dialog _dialog;

	private WebView webView;
	
	private String url;
	private String keyWord;
	private String platForm;
	
	protected void onCreate(Bundle savedInstanceState){
		super.onCreate(savedInstanceState);
		
		getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		
		if(!Util.isNetworkAvailable(this)){
			AuthActivity.this.showDialog(ALERT_NETWORK);
		}else{
			initLayout();
		}
	}
	
	
	
	private void initLayout(){
		
		LinearLayout.LayoutParams fillParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.MATCH_PARENT);
		LinearLayout layout = new LinearLayout(this);
		layout.setLayoutParams(fillParams);
		layout.setOrientation(LinearLayout.VERTICAL);
		
		webView = new WebView(this);
		webView.setLayoutParams(fillParams);
		
		Bundle data = this.getIntent().getExtras();
		url = data.getString("url");
		keyWord = data.getString("keyWord");
		platForm = data.getString("platForm");
		boolean savepsd = data.getBoolean("savepsd");
		
		WebSettings webSettings = webView.getSettings();
		webView.setVerticalScrollBarEnabled(false);
		webSettings.setJavaScriptEnabled(true);
		webSettings.setUseWideViewPort(true);
		webSettings.setSavePassword(savepsd);
		webSettings.setLoadWithOverviewMode(false);
		
		webView.loadUrl(url);
		
		webView.setWebViewClient(new WebViewClient(){
			
			@Override
			public void onPageStarted(WebView view, String url, Bitmap favicon)
	        {
				if (url.indexOf(keyWord) != -1) {
					jumpResultParser(url);
				}
	        }
			
			
			@Override
			public void onPageFinished(WebView view, String url) {
				if (url.indexOf(keyWord) != -1) {
					jumpResultParser(url);
				}
			}
			
			

			@Override
			public boolean shouldOverrideUrlLoading(WebView view, String url) {
				if (url.indexOf(keyWord) != -1) {
					jumpResultParser(url);
				}
				return false;
			}
		});
		
		layout.addView(webView);
		this.setContentView(layout);
	}
	
	
	
	/**
	 * 
	 * 获取授权后的返回地址，并对其进行解析传回服务中
	 */
	public void jumpResultParser(String result) {
		this.finish();
		SNSServiceFactory.getService(platForm).handlerCallbackURL(result);
	}
	
	
	
	@Override
	protected Dialog onCreateDialog(int id) {
		switch (id) {
		case ALERT_NETWORK:
			AlertDialog.Builder builder2 = new AlertDialog.Builder(this);
			builder2.setTitle("网络连接异常，是否重新连接？");
			builder2.setPositiveButton("是",
					new DialogInterface.OnClickListener() {
						@Override
						public void onClick(DialogInterface dialog, int which) {
							if (Util.isNetworkAvailable(AuthActivity.this)) {
								webView.loadUrl(url);
							} else {
								Message msg = Message.obtain();
								msg.what = 100;
								handle.sendMessage(msg);
							}
						}

					});
			builder2.setNegativeButton("否",
					new DialogInterface.OnClickListener() {
						@Override
						public void onClick(DialogInterface dialog, int which) {
							AuthActivity.this.finish();
						}
					});
			_dialog = builder2.create();
			break;
		}
		return _dialog;
	}
	
	
	Handler handle = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			super.handleMessage(msg);
			switch (msg.what) {
			case 100:
				AuthActivity.this.showDialog(ALERT_NETWORK);
				break;
			}
		}
	};
}
