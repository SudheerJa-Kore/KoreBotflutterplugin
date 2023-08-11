package com.korebot.korebotplugin;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.telecom.Call;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;

import com.google.gson.Gson;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import kore.botssdk.activity.BotChatActivity;
import kore.botssdk.event.KoreEventCenter;
import kore.botssdk.events.SocketDataTransferModel;
import kore.botssdk.listener.BaseSocketConnectionManager;
import kore.botssdk.listener.BotSocketConnectionManager;
import kore.botssdk.listener.SocketChatListener;
import kore.botssdk.models.BotResponse;
import kore.botssdk.models.CallBackEventModel;
import kore.botssdk.net.SDKConfiguration;
import kore.botssdk.utils.BundleUtils;
import kore.botssdk.utils.StringUtils;

/** KorebotpluginPlugin */
public class KorebotpluginPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context context;
  private Result result;
  private Gson gson = new Gson();

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "kore.botsdk/chatbot");
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.getApplicationContext();
    KoreEventCenter.register(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    this.result = result;
    if(call.method.equals("getChatWindow"))
    {
      SDKConfiguration.Client.bot_id = "st-b9889c46-218c-58f7-838f-73ae9203488c";
      SDKConfiguration.Client.client_secret = "5OcBSQtH/k6Q/S6A3bseYfOee02YjjLLTNoT1qZDBso=";
      SDKConfiguration.Client.client_id = "cs-1e845b00-81ad-5757-a1e7-d0f6fea227e9";
      SDKConfiguration.Client.bot_name = "Kore Bot";
      SDKConfiguration.Client.identity = "anilkumar.routhu@kore.com";

//      BotSocketConnectionManager.getInstance().setChatListener(sListener);

      BotSocketConnectionManager.getInstance().startAndInitiateConnectionWithConfig(context, null);
      Intent intent = new Intent(context, BotChatActivity.class);
      intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
      Bundle bundle = new Bundle();
      bundle.putBoolean(BundleUtils.SHOW_PROFILE_PIC, false);
      if(!StringUtils.isNullOrEmpty(SDKConfiguration.Client.bot_name))
        bundle.putString(BundleUtils.BOT_NAME_INITIALS,SDKConfiguration.Client.bot_name.charAt(0)+"");
      else
        bundle.putString(BundleUtils.BOT_NAME_INITIALS,"B");
      intent.putExtras(bundle);
      context.startActivity(intent);
    }
  }

//  SocketChatListener sListener = new SocketChatListener() {
//    @Override
//    public void onMessage(BotResponse botResponse) {
////      processPayload("", botResponse);
//    }
//
//    @Override
//    public void onConnectionStateChanged(BaseSocketConnectionManager.CONNECTION_STATE state, boolean isReconnection) {
//      if(state == BaseSocketConnectionManager.CONNECTION_STATE.CONNECTED){
//        Toast.makeText(context, "Bot Connected Successfully", Toast.LENGTH_SHORT).show();
//      }
//    }
//
//    @Override
//    public void onMessage(SocketDataTransferModel data) {
//      if (data == null) return;
//      if (data.getEvent_type().equals(BaseSocketConnectionManager.EVENT_TYPE.TYPE_TEXT_MESSAGE)) {
//        Log.e("Payload", data.getPayLoad());
//        Toast.makeText(context, data.getPayLoad(), Toast.LENGTH_SHORT).show();
//      } else if (data.getEvent_type().equals(BaseSocketConnectionManager.EVENT_TYPE.TYPE_MESSAGE_UPDATE)) {
//      }
//    }
//  };

  public void onEvent(CallBackEventModel callBackEventModel)
  {
    channel.invokeMethod("Callbacks", gson.toJson(callBackEventModel));
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    KoreEventCenter.unregister(this);
  }
}
