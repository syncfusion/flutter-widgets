#include <jni.h>
#include <fpdfview.h>
#include <dlfcn.h>

extern "C" {

static void* pdfiumLibHandle = nullptr;

JNIEXPORT jboolean JNICALL
Java_com_syncfusion_flutter_pdfviewer_android_PdfiumAdapter_initLibrary(JNIEnv* env, jobject thiz) {
    const char* libName = "libpdfium.so";

    pdfiumLibHandle = dlopen(libName, RTLD_NOW | RTLD_LOCAL);
    if (!pdfiumLibHandle) {
        return JNI_FALSE;
    }
    FPDF_InitLibraryWithConfig(nullptr);
    return JNI_TRUE;
}

JNIEXPORT void JNICALL
Java_com_syncfusion_flutter_pdfviewer_android_PdfiumAdapter_destroyLibrary(JNIEnv* env, jobject thiz) {
    FPDF_DestroyLibrary();
    if (pdfiumLibHandle) {
        dlclose(pdfiumLibHandle);
        pdfiumLibHandle = nullptr;
    }
}

JNIEXPORT jlong JNICALL
Java_com_syncfusion_flutter_pdfviewer_android_PdfiumAdapter_loadDocument(JNIEnv* env, jobject thiz, jbyteArray pdfData, jstring password) {
    if (!pdfiumLibHandle) {
        return 0;
    }
    if (pdfData == nullptr) {
        return 0;
    }

    jbyte* buffer = env->GetByteArrayElements(pdfData, nullptr);
    jsize length = env->GetArrayLength(pdfData);
    const char* pwd = password ? env->GetStringUTFChars(password, nullptr) : nullptr;

    FPDF_DOCUMENT doc = FPDF_LoadMemDocument64(buffer, (size_t)length, pwd);
    env->ReleaseByteArrayElements(pdfData, buffer, JNI_ABORT);
    if (pwd) {
        env->ReleaseStringUTFChars(password, pwd);
    }
    if (!doc) {
        return 0;
    }

    return reinterpret_cast<jlong>(doc);
}

JNIEXPORT void JNICALL
Java_com_syncfusion_flutter_pdfviewer_android_PdfiumAdapter_closeDocument(JNIEnv* env, jobject thiz, jlong docHandle) {
    if (!pdfiumLibHandle) {
        return;
    }
    FPDF_DOCUMENT doc = reinterpret_cast<FPDF_DOCUMENT>(docHandle);
    if (doc) {
        FPDF_CloseDocument(doc);
    }
}

JNIEXPORT jint JNICALL
Java_com_syncfusion_flutter_pdfviewer_android_PdfiumAdapter_getPageCount(JNIEnv* env, jobject thiz, jlong docHandle) {
    if (!pdfiumLibHandle) {
        return -1;
    }
    FPDF_DOCUMENT doc = reinterpret_cast<FPDF_DOCUMENT>(docHandle);
    return doc ? FPDF_GetPageCount(doc) : -1;
}

JNIEXPORT jfloat JNICALL
Java_com_syncfusion_flutter_pdfviewer_android_PdfiumAdapter_getPageWidth(JNIEnv* env, jobject thiz, jlong docHandle, jint index) {
    if (!pdfiumLibHandle) {
        return -1;
    }
    FPDF_DOCUMENT doc = reinterpret_cast<FPDF_DOCUMENT>(docHandle);
    if (!doc) return -1;

    FPDF_PAGE page = FPDF_LoadPage(doc, index);
    if (!page) return -1;
    jfloat width = FPDF_GetPageWidthF(page);
    FPDF_ClosePage(page);
    return width;
}

JNIEXPORT jfloat JNICALL
Java_com_syncfusion_flutter_pdfviewer_android_PdfiumAdapter_getPageHeight(JNIEnv* env, jobject thiz, jlong docHandle, jint index) {
    if (!pdfiumLibHandle) {
        return -1;
    }
    FPDF_DOCUMENT doc = reinterpret_cast<FPDF_DOCUMENT>(docHandle);
    if (!doc) return -1;

    FPDF_PAGE page = FPDF_LoadPage(doc, index);
    if (!page) return -1;

    jfloat height = FPDF_GetPageHeightF(page);
    FPDF_ClosePage(page);
    return height;
}

JNIEXPORT jbyteArray JNICALL
Java_com_syncfusion_flutter_pdfviewer_android_PdfiumAdapter_renderPage(JNIEnv* env, jobject thiz, jlong docHandle, jint pageIndex, jint width, jint height) {
    if (!pdfiumLibHandle) {
        return nullptr;
    }
    FPDF_DOCUMENT doc = reinterpret_cast<FPDF_DOCUMENT>(docHandle);
    if (!doc) return nullptr;

    FPDF_PAGE page = FPDF_LoadPage(doc, pageIndex);
    if (!page) return nullptr;

    FPDF_BITMAP bitmap = FPDFBitmap_Create(width, height, 0);
    if (!bitmap) {
        FPDF_ClosePage(page);
        return nullptr;
    }

    FPDFBitmap_FillRect(bitmap, 0, 0, width, height, 0xFFFFFFFF);
    FPDF_RenderPageBitmap(bitmap, page, 0, 0, width, height, 0, FPDF_LCD_TEXT | FPDF_REVERSE_BYTE_ORDER);

    void* buffer = FPDFBitmap_GetBuffer(bitmap);
    int stride = FPDFBitmap_GetStride(bitmap);
    int totalSize = stride * height;

    jbyteArray result = env->NewByteArray(totalSize);
    if (result != nullptr) {
        env->SetByteArrayRegion(result, 0, totalSize, (jbyte*)buffer);
    }

    FPDFBitmap_Destroy(bitmap);
    FPDF_ClosePage(page);

    return result;
}

JNIEXPORT jbyteArray JNICALL
Java_com_syncfusion_flutter_pdfviewer_android_PdfiumAdapter_renderTile(JNIEnv* env, jobject thiz,
                                                 jlong docHandle,
                                                 jint pageIndex,
                                                 jfloat x, jfloat y,
                                                 jint width, jint height,
                                                 jfloat scale) {
    if (!pdfiumLibHandle) {
        return nullptr;
    }
    FPDF_DOCUMENT doc = reinterpret_cast<FPDF_DOCUMENT>(docHandle);
    if (!doc) return nullptr;

    FPDF_PAGE page = FPDF_LoadPage(doc, pageIndex);
    if (!page) return nullptr;

    FPDF_BITMAP bitmap = FPDFBitmap_Create(width, height, 0);
    if (!bitmap) {
        FPDF_ClosePage(page);
        return nullptr;
    }

    FPDFBitmap_FillRect(bitmap, 0, 0, width, height, 0xFFFFFFFF);

    FS_MATRIX matrix = {
        scale, 0, 0,
        scale, -x * scale, -y * scale
    };

    FS_RECTF clip = {0, 0, (float)(width * scale), (float)(height * scale)};

    FPDF_RenderPageBitmapWithMatrix(bitmap, page, &matrix, &clip, FPDF_LCD_TEXT | FPDF_REVERSE_BYTE_ORDER);

    void* buffer = FPDFBitmap_GetBuffer(bitmap);
    int stride = FPDFBitmap_GetStride(bitmap);
    int totalSize = stride * height;

    jbyteArray result = env->NewByteArray(totalSize);
    if (result != nullptr) {
        env->SetByteArrayRegion(result, 0, totalSize, (jbyte*)buffer);
    }

    FPDFBitmap_Destroy(bitmap);
    FPDF_ClosePage(page);

    return result;
}

} // extern "C"
