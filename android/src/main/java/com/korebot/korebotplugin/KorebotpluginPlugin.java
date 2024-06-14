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
  private final Gson gson = new Gson();

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
      SDKConfiguration.Client.bot_id = call.argument("botId");
      SDKConfiguration.Client.client_secret = call.argument("clientSecret");
      SDKConfiguration.Client.client_id = call.argument("clientId");
      SDKConfiguration.Client.bot_name = call.argument("chatBotName");
      SDKConfiguration.Client.identity = call.argument("identity");
      SDKConfiguration.Client.history_call = Boolean.TRUE.equals(call.argument("callHistory"));

      SDKConfiguration.Server.SERVER_URL = call.argument("server_url");
      SDKConfiguration.setJwtServerUrl(call.argument("jwt_server_url"));

      Intent intent = new Intent(context, BotChatActivity.class);
      intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
      Bundle bundle = new Bundle();
      bundle.putBoolean(BundleUtils.SHOW_PROFILE_PIC, false);
      if(!StringUtils.isNullOrEmpty(SDKConfiguration.Client.bot_name))
        bundle.putString(BundleUtils.BOT_NAME_INITIALS, String.valueOf(SDKConfiguration.Client.bot_name.charAt(0)));
      else
        bundle.putString(BundleUtils.BOT_NAME_INITIALS,"B");
      intent.putExtras(bundle);
      context.startActivity(intent);
    }
  }

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
