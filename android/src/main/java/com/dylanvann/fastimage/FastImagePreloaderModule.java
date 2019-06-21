package com.dylanvann.fastimage;

import android.app.Activity;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.signature.ObjectKey;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;

import java.util.HashMap;
import java.util.Map;

class FastImagePreloaderModule extends ReactContextBaseJavaModule {

    private static final String REACT_CLASS = "FastImagePreloaderManager";
    private int preloaders = 0;
    private Map<Integer, FastImagePreloaderConfiguration> fastImagePreloaders = new HashMap<>();

    FastImagePreloaderModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @ReactMethod
    public void createPreloader(Promise promise) {
        promise.resolve(preloaders++);
    }

    @ReactMethod
    public void createPreloaderWithConfig(ReadableMap preloadConfig, Promise promise) {
        preloaders++;

        fastImagePreloaders.put(preloaders,
                new FastImagePreloaderConfiguration(preloadConfig.getString("namespace"), preloadConfig.getInt("maxCacheAge"))
        );

        promise.resolve(preloaders);
    }

    @ReactMethod
    public void preload(final int preloaderId, final ReadableArray sources, final String cacheControl) {
        final Activity activity = getCurrentActivity();
        if (activity == null) return;
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                FastImagePreloaderListener preloader = new FastImagePreloaderListener(getReactApplicationContext(), preloaderId, sources.size());
                FastImagePreloaderConfiguration fastImagePreloaderConfiguration = fastImagePreloaders.get(preloaderId);
                String maxAgeSignature = String.valueOf(System.currentTimeMillis() / (fastImagePreloaderConfiguration.getMaxCacheAge() * 1000));

                for (int i = 0; i < sources.size(); i++) {
                    final ReadableMap source = sources.getMap(i);
                    final FastImageSource imageSource = FastImageViewConverter.getImageSource(activity, source);

                    Glide
                            .with(activity.getApplicationContext())
                            // This will make this work for remote and local images. e.g.
                            //    - file:///
                            //    - content://
                            //    - res:/
                            //    - android.resource://
                            //    - data:image/png;base64
                            .load(
                                    imageSource.isBase64Resource() ? imageSource.getSource() :
                                            imageSource.isResource() ? imageSource.getUri() : imageSource.getGlideUrl()
                            )
                            .diskCacheStrategy(DiskCacheStrategy.ALL)
                            // This image will have an expiration time of max age passed from the params.
                            // re-request periodically (balanced performance, if period is big enough, say a week)
                            .signature(new ObjectKey(String.format("%s%s", fastImagePreloaderConfiguration.getNamespace(), maxAgeSignature)))
                            .listener(preloader)
                            .apply(FastImageViewConverter.getOptions(source))
                            .preload();
                }
            }
        });
    }

    @ReactMethod
    public void remove(final ReadableArray sources, Promise promise) {
        promise.resolve("Removing images from cache by sourse is not supported on Android.");
    }
}
