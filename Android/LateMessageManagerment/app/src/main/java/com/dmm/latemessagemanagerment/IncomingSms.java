package com.dmm.latemessagemanagerment;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.telephony.SmsMessage;
import android.util.Log;
import android.widget.Toast;

import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.VolleyLog;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;

/**
 * Created by TranAnhQuoc on 8/22/16.
 */

public class IncomingSms extends BroadcastReceiver {
    public void onReceive(Context context, Intent intent) {
        final Bundle bundle = intent.getExtras();
        String senderNumber = null;
        String message = null;
        try {
            if (bundle != null) {
                final Object[] pdusObj = (Object[]) bundle.get("pdus");
                SmsMessage currentMessage = null;
                for (int i = 0; i < pdusObj.length; i++) {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        String format = bundle.getString("format");
                        currentMessage = SmsMessage.createFromPdu((byte[]) pdusObj[i], format);
                    } else {
                        currentMessage = SmsMessage.createFromPdu((byte[]) pdusObj[i]);
                    }
                    senderNumber = currentMessage.getDisplayOriginatingAddress();
                    message = currentMessage.getDisplayMessageBody();
                    Log.i("SmsReceiver", "senderNum: "+ senderNumber + "; message: " + message);
                    int duration = Toast.LENGTH_LONG;
                    Toast toast = Toast.makeText(context, "senderNum: "+ senderNumber + ", message: " + message, duration);
                    toast.show();
                }

                if (senderNumber != null && message != null) {
                    sendMessageToServer(senderNumber, message, context);
                }
            }
        } catch (Exception e) {
            Log.e("SmsReceiver", "Exception smsReceiver" +e);
        }
    }

    private void sendMessageToServer(String senderNumber, String message, Context context) {
        HashMap<String, String> params = new HashMap<String, String>();
        params.put("description", message);
        params.put("phone_number", senderNumber);

        JsonObjectRequest req = new JsonObjectRequest(Constants.kURL_MESSAGELATE_URL, new JSONObject(params),
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject response) {
                        try {
                            VolleyLog.v("Response:%n %s", response.toString(4));
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    }
                }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                VolleyLog.e("Error: ", error.getMessage());
            }
        });

        RequestQueue queue = Volley.newRequestQueue(context);
        queue.add(req);
    }
}