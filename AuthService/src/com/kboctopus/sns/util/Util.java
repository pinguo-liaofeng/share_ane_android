package com.kboctopus.sns.util;
import android.app.Activity;
import android.content.Context;

import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;

public class Util {
	/**
	 * 判断当前网络是否可用
	 * 
	 * @param activity
	 *            当前Acitivity对象
	 * @return 可用返回true 否则返回false
	 * 
	 * */
	public static boolean isNetworkAvailable(Activity activity) {
		Context context = activity.getApplicationContext();
		ConnectivityManager cm = (ConnectivityManager) context
				.getSystemService(Context.CONNECTIVITY_SERVICE);
		if (cm == null) {
			return false;
		} else {
			NetworkInfo info[] = cm.getAllNetworkInfo();
			if (info != null) {
				for (int i = 0; i < info.length; i++) {
					if (info[i].getState() == NetworkInfo.State.CONNECTED) {
						return true;
					}
				}
			}
		}
		return false;
	}

	

	/**
	 * 获取手机ip
	 * 
	 * @param context
	 *            上下文
	 * @return 可用的ip
	 * 
	 */
	public static String getLocalIPAddress(Context context) {
		WifiManager wifiManager = (WifiManager) context
				.getSystemService(Context.WIFI_SERVICE);
		WifiInfo info = wifiManager.getConnectionInfo();
		int i = info.getIpAddress();
		String ipStr = (i & 0xFF) + "." + ((i >> 8) & 0xFF) + "."
				+ ((i >> 16) & 0xFF) + "." + (i >> 24 & 0xFF);
		return ipStr;
	}

	
}
