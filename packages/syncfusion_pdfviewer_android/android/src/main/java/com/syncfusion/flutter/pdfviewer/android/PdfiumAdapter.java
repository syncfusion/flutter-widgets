package com.syncfusion.flutter.pdfviewer.android;

/**
 * PdfiumAdapter provides methods to interact 
 * with native PDFium libraries for rendering and processing PDFs.
 */
public class PdfiumAdapter {

    static {
        // Load the native PDFium wrapper library which acts as a wrapper built via CMake
        System.loadLibrary("pdfium_wrapper");
    }

    /**
     * Initializes the PDFium library for usage.
     */
    public static native boolean initLibrary();

    /**
     * Destroys the PDFium library and cleans up any resources used.
     */
    public static native void destroyLibrary();

    /**
     * Loads a PDF document using byte data and an optional password for encrypted PDFs.
     * 
     * @param data the byte array representing the PDF document
     * @param password the password for encrypted PDFs (pass an empty string if not needed)
     * @return long representing the handle or reference to the loaded document
     */
    public static native long loadDocument(byte[] data, String password);

    /**
     * Closes the specified PDF document and releases resources tied to it.
     * 
     * @param docHandle the handle to the loaded PDF document
     */
    public static native void closeDocument(long docHandle);

    /**
     * Retrieves the total number of pages in the specified PDF document.
     * 
     * @param docHandle the handle to the loaded PDF document
     * @return the number of pages in the PDF document
     */
    public static native int getPageCount(long docHandle);

    /**
     * Retrieves the width of a specific page in the PDF document.
     * 
     * @param docHandle the handle to the loaded PDF document
     * @param index the page index for which the width is needed
     * @return the width of the page in points
     */
    public static native float getPageWidth(long docHandle, int index);

    /**
     * Retrieves the height of a specific page in the PDF document.
     * 
     * @param docHandle the handle to the loaded PDF document
     * @param index the page index for which the height is needed
     * @return the height of the page in points
     */
    public static native float getPageHeight(long docHandle, int index);
    /**
     * Renders a specific page of the PDF as an image.
     * 
     * @param docHandle the handle to the loaded PDF document
     * @param pageIndex the index of the page to render
     * @param width the desired width of the rendered output
     * @param height the desired height of the rendered output
     * @return a byte array representing the rendered image of the page
     */
    public static native byte[] renderPage(long docHandle, int pageIndex, int width, int height);

    /**
     * Renders a specific tile of the page to handle large pages efficiently.
     *
     * @param docHandle the handle to the loaded PDF document
     * @param pageIndex the index of the page
     * @param x the x coordinate of the tile's top-left corner
     * @param y the y coordinate of the tile's top-left corner
     * @param width the width of the tile to render
     * @param height the height of the tile to render
     * @param scale the scale factor for rendering
     * @return a byte array representing the rendered tile image
     */
    public static native byte[] renderTile(long docHandle, int pageIndex, float x, float y, int width, int height, float scale);
}

