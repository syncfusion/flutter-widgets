// Copyright 2014 PDFium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Original code copyright 2014 Foxit Software Inc. http://www.foxitsoftware.com

#ifndef PUBLIC_FPDF_TEXT_H_
#define PUBLIC_FPDF_TEXT_H_

// clang-format off
// NOLINTNEXTLINE(build/include)
#include "fpdfview.h"

// Exported Functions
#ifdef __cplusplus
extern "C" {
#endif

// Function: FPDFText_LoadPage
//          Prepare information about all characters in a page.
// Parameters:
//          page    -   Handle to the page. Returned by FPDF_LoadPage function
//                      (in FPDFVIEW module).
// Return value:
//          A handle to the text page information structure.
//          NULL if something goes wrong.
// Comments:
//          Application must call FPDFText_ClosePage to release the text page
//          information.
//
FPDF_EXPORT FPDF_TEXTPAGE FPDF_CALLCONV FPDFText_LoadPage(FPDF_PAGE page);

// Function: FPDFText_ClosePage
//          Release all resources allocated for a text page information
//          structure.
// Parameters:
//          text_page   -   Handle to a text page information structure.
//                          Returned by FPDFText_LoadPage function.
// Return Value:
//          None.
//
FPDF_EXPORT void FPDF_CALLCONV FPDFText_ClosePage(FPDF_TEXTPAGE text_page);

// Function: FPDFText_CountChars
//          Get number of characters in a page.
// Parameters:
//          text_page   -   Handle to a text page information structure.
//                          Returned by FPDFText_LoadPage function.
// Return value:
//          Number of characters in the page. Return -1 for error.
//          Generated characters, like additional space characters, new line
//          characters, are also counted.
// Comments:
//          Characters in a page form a "stream", inside the stream, each
//          character has an index.
//          We will use the index parameters in many of FPDFTEXT functions. The
//          first character in the page
//          has an index value of zero.
//
FPDF_EXPORT int FPDF_CALLCONV FPDFText_CountChars(FPDF_TEXTPAGE text_page);

// Function: FPDFText_GetUnicode
//          Get Unicode of a character in a page.
// Parameters:
//          text_page   -   Handle to a text page information structure.
//                          Returned by FPDFText_LoadPage function.
//          index       -   Zero-based index of the character.
// Return value:
//          The Unicode of the particular character.
//          If a character is not encoded in Unicode and Foxit engine can't
//          convert to Unicode,
//          the return value will be zero.
//
FPDF_EXPORT unsigned int FPDF_CALLCONV
FPDFText_GetUnicode(FPDF_TEXTPAGE text_page, int index);

// Function: FPDFText_GetFontSize
//          Get the font size of a particular character.
// Parameters:
//          text_page   -   Handle to a text page information structure.
//                          Returned by FPDFText_LoadPage function.
//          index       -   Zero-based index of the character.
// Return value:
//          The font size of the particular character, measured in points (about
//          1/72 inch). This is the typographic size of the font (so called
//          "em size").
//
FPDF_EXPORT double FPDF_CALLCONV FPDFText_GetFontSize(FPDF_TEXTPAGE text_page,
                                                      int index);

// Experimental API.
// Function: FPDFText_GetFontInfo
//          Get the font name and flags of a particular character.
// Parameters:
//          text_page - Handle to a text page information structure.
//                      Returned by FPDFText_LoadPage function.
//          index     - Zero-based index of the character.
//          buffer    - A buffer receiving the font name.
//          buflen    - The length of |buffer| in bytes.
//          flags     - Optional pointer to an int receiving the font flags.
//                      These flags should be interpreted per PDF spec 1.7
//                      Section 5.7.1 Font Descriptor Flags.
// Return value:
//          On success, return the length of the font name, including the
//          trailing NUL character, in bytes. If this length is less than or
//          equal to |length|, |buffer| is set to the font name, |flags| is
//          set to the font flags. |buffer| is in UTF-8 encoding. Return 0 on
//          failure.
//
FPDF_EXPORT unsigned long FPDF_CALLCONV
FPDFText_GetFontInfo(FPDF_TEXTPAGE text_page,
                     int index,
                     void* buffer,
                     unsigned long buflen,
                     int* flags);

// Experimental API.
// Function: FPDFText_GetFontWeight
//          Get the font weight of a particular character.
// Parameters:
//          text_page   -   Handle to a text page information structure.
//                          Returned by FPDFText_LoadPage function.
//          index       -   Zero-based index of the character.
// Return value:
//          On success, return the font weight of the particular character. If
//          |text_page| is invalid, if |index| is out of bounds, or if the
//          character's text object is undefined, return -1.
//
FPDF_EXPORT int FPDF_CALLCONV FPDFText_GetFontWeight(FPDF_TEXTPAGE text_page,
                                                     int index);

// Experimental API.
// Function: FPDFText_GetTextRenderMode
//          Get text rendering mode of character.
// Parameters:
//          text_page   -   Handle to a text page information structure.
//                          Returned by FPDFText_LoadPage function.
//          index       -   Zero-based index of the character.
// Return Value:
//          On success, return the render mode value. A valid value is of type
//          FPDF_TEXT_RENDERMODE. If |text_page| is invalid, if |index| is out
//          of bounds, or if the text object is undefined, then return
//          FPDF_TEXTRENDERMODE_UNKNOWN.
//
FPDF_EXPORT FPDF_TEXT_RENDERMODE FPDF_CALLCONV
FPDFText_GetTextRenderMode(FPDF_TEXTPAGE text_page, int index);

// Experimental API.
// Function: FPDFText_GetFillColor
//          Get the fill color of a particular character.
// Parameters:
//          text_page      -   Handle to a text page information structure.
//                             Returned by FPDFText_LoadPage function.
//          index          -   Zero-based index of the character.
//          R              -   Pointer to an unsigned int number receiving the
//                             red value of the fill color.
//          G              -   Pointer to an unsigned int number receiving the
//                             green value of the fill color.
//          B              -   Pointer to an unsigned int number receiving the
//                             blue value of the fill color.
//          A              -   Pointer to an unsigned int number receiving the
//                             alpha value of the fill color.
// Return value:
//          Whether the call succeeded. If false, |R|, |G|, |B| and |A| are
//          unchanged.
//
FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV
FPDFText_GetFillColor(FPDF_TEXTPAGE text_page,
                      int index,
                      unsigned int* R,
                      unsigned int* G,
                      unsigned int* B,
                      unsigned int* A);

// Experimental API.
// Function: FPDFText_GetStrokeColor
//          Get the stroke color of a particular character.
// Parameters:
//          text_page      -   Handle to a text page information structure.
//                             Returned by FPDFText_LoadPage function.
//          index          -   Zero-based index of the character.
//          R              -   Pointer to an unsigned int number receiving the
//                             red value of the stroke color.
//          G              -   Pointer to an unsigned int number receiving the
//                             green value of the stroke color.
//          B              -   Pointer to an unsigned int number receiving the
//                             blue value of the stroke color.
//          A              -   Pointer to an unsigned int number receiving the
//                             alpha value of the stroke color.
// Return value:
//          Whether the call succeeded. If false, |R|, |G|, |B| and |A| are
//          unchanged.
//
FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV
FPDFText_GetStrokeColor(FPDF_TEXTPAGE text_page,
                        int index,
                        unsigned int* R,
                        unsigned int* G,
                        unsigned int* B,
                        unsigned int* A);

// Experimental API.
// Function: FPDFText_GetCharAngle
//          Get character rotation angle.
// Parameters:
//          text_page   -   Handle to a text page information structure.
//                          Returned by FPDFText_LoadPage function.
//          index       -   Zero-based index of the character.
// Return Value:
//          On success, return the angle value in radian. Value will always be
//          greater or equal to 0. If |text_page| is invalid, or if |index| is
//          out of bounds, then return -1.
//
FPDF_EXPORT float FPDF_CALLCONV FPDFText_GetCharAngle(FPDF_TEXTPAGE text_page,
                                                      int index);

// Function: FPDFText_GetCharBox
//          Get bounding box of a particular character.
// Parameters:
//          text_page   -   Handle to a text page information structure.
//                          Returned by FPDFText_LoadPage function.
//          index       -   Zero-based index of the character.
//          left        -   Pointer to a double number receiving left position
//                          of the character box.
//          right       -   Pointer to a double number receiving right position
//                          of the character box.
//          bottom      -   Pointer to a double number receiving bottom position
//                          of the character box.
//          top         -   Pointer to a double number receiving top position of
//                          the character box.
// Return Value:
//          On success, return TRUE and fill in |left|, |right|, |bottom|, and
//          |top|. If |text_page| is invalid, or if |index| is out of bounds,
//          then return FALSE, and the out parameters remain unmodified.
// Comments:
//          All positions are measured in PDF "user space".
//
FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV FPDFText_GetCharBox(FPDF_TEXTPAGE text_page,
                                                        int index,
                                                        double* left,
                                                        double* right,
                                                        double* bottom,
                                                        double* top);

// Experimental API.
// Function: FPDFText_GetLooseCharBox
//          Get a "loose" bounding box of a particular character, i.e., covering
//          the entire glyph bounds, without taking the actual glyph shape into
//          account.
// Parameters:
//          text_page   -   Handle to a text page information structure.
//                          Returned by FPDFText_LoadPage function.
//          index       -   Zero-based index of the character.
//          rect        -   Pointer to a FS_RECTF receiving the character box.
// Return Value:
//          On success, return TRUE and fill in |rect|. If |text_page| is
//          invalid, or if |index| is out of bounds, then return FALSE, and the
//          |rect| out parameter remains unmodified.
// Comments:
//          All positions are measured in PDF "user space".
//
FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV
FPDFText_GetLooseCharBox(FPDF_TEXTPAGE text_page, int index, FS_RECTF* rect);

// Experimental API.
// Function: FPDFText_GetMatrix
//          Get the effective transformation matrix for a particular character.
// Parameters:
//          text_page   -   Handle to a text page information structure.
//                          Returned by FPDFText_LoadPage().
//          index       -   Zero-based index of the character.
//          matrix      -   Pointer to a FS_MATRIX receiving the transformation
//                          matrix.
// Return Value:
//          On success, return TRUE and fill in |matrix|. If |text_page| is
//          invalid, or if |index| is out of bounds, or if |matrix| is NULL,
//          then return FALSE, and |matrix| remains unmodified.
//
FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV FPDFText_GetMatrix(FPDF_TEXTPAGE text_page,
                                                       int index,
                                                       FS_MATRIX* matrix);

// Function: FPDFText_GetCharOrigin
//          Get origin of a particular character.
// Parameters:
//          text_page   -   Handle to a text page information structure.
//                          Returned by FPDFText_LoadPage function.
//          index       -   Zero-based index of the character.
//          x           -   Pointer to a double number receiving x coordinate of
//                          the character origin.
//          y           -   Pointer to a double number receiving y coordinate of
//                          the character origin.
// Return Value:
//          Whether the call succeeded. If false, x and y are unchanged.
// Comments:
//          All positions are measured in PDF "user space".
//
FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV
FPDFText_GetCharOrigin(FPDF_TEXTPAGE text_page,
                       int index,
                       double* x,
                       double* y);

// Function: FPDFText_GetCharIndexAtPos
//          Get the index of a character at or nearby a certain position on the
//          page.
// Parameters:
//          text_page   -   Handle to a text page information structure.
//                          Returned by FPDFText_LoadPage function.
//          x           -   X position in PDF "user space".
//          y           -   Y position in PDF "user space".
//          xTolerance  -   An x-axis tolerance value for character hit
//                          detection, in point units.
//          yTolerance  -   A y-axis tolerance value for character hit
//                          detection, in point units.
// Return Value:
//          The zero-based index of the character at, or nearby the point (x,y).
//          If there is no character at or nearby the point, return value will
//          be -1. If an error occurs, -3 will be returned.
//
FPDF_EXPORT int FPDF_CALLCONV
FPDFText_GetCharIndexAtPos(FPDF_TEXTPAGE text_page,
                           double x,
                           double y,
                           double xTolerance,
                           double yTolerance);

// Function: FPDFText_GetText
//          Extract unicode text string from the page.
// Parameters:
//          text_page   -   Handle to a text page information structure.
//                          Returned by FPDFText_LoadPage function.
//          start_index -   Index for the start characters.
//          count       -   Number of characters to be extracted.
//          result      -   A buffer (allocated by application) receiving the
//                          extracted unicodes. The size of the buffer must be
//                          able to hold the number of characters plus a
//                          terminator.
// Return Value:
//          Number of characters written into the result buffer, including the
//          trailing terminator.
// Comments:
//          This function ignores characters without unicode information.
//
FPDF_EXPORT int FPDF_CALLCONV FPDFText_GetText(FPDF_TEXTPAGE text_page,
                                               int start_index,
                                               int count,
                                               unsigned short* result);

// Function: FPDFText_CountRects
//          Count number of rectangular areas occupied by a segment of texts.
// Parameters:
//          text_page   -   Handle to a text page information structure.
//                          Returned by FPDFText_LoadPage function.
//          start_index -   Index for the start characters.
//          count       -   Number of characters.
// Return value:
//          Number of rectangles. Zero for error.
// Comments:
//          This function, along with FPDFText_GetRect can be used by
//          applications to detect the position on the page for a text segment,
//          so proper areas can be highlighted. FPDFTEXT will automatically
//          merge small character boxes into bigger one if those characters
//          are on the same line and use same font settings.
//
FPDF_EXPORT int FPDF_CALLCONV FPDFText_CountRects(FPDF_TEXTPAGE text_page,
                                                  int start_index,
                                                  int count);

// Function: FPDFText_GetRect
//          Get a rectangular area from the result generated by
//          FPDFText_CountRects.
// Parameters:
//          text_page   -   Handle to a text page information structure.
//                          Returned by FPDFText_LoadPage function.
//          rect_index  -   Zero-based index for the rectangle.
//          left        -   Pointer to a double value receiving the rectangle
//                          left boundary.
//          top         -   Pointer to a double value receiving the rectangle
//                          top boundary.
//          right       -   Pointer to a double value receiving the rectangle
//                          right boundary.
//          bottom      -   Pointer to a double value receiving the rectangle
//                          bottom boundary.
// Return Value:
//          On success, return TRUE and fill in |left|, |top|, |right|, and
//          |bottom|. If |text_page| is invalid then return FALSE, and the out
//          parameters remain unmodified. If |text_page| is valid but
//          |rect_index| is out of bounds, then return FALSE and set the out
//          parameters to 0.
//
FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV FPDFText_GetRect(FPDF_TEXTPAGE text_page,
                                                     int rect_index,
                                                     double* left,
                                                     double* top,
                                                     double* right,
                                                     double* bottom);

// Function: FPDFText_GetBoundedText
//          Extract unicode text within a rectangular boundary on the page.
// Parameters:
//          text_page   -   Handle to a text page information structure.
//                          Returned by FPDFText_LoadPage function.
//          left        -   Left boundary.
//          top         -   Top boundary.
//          right       -   Right boundary.
//          bottom      -   Bottom boundary.
//          buffer      -   A unicode buffer.
//          buflen      -   Number of characters (not bytes) for the buffer,
//                          excluding an additional terminator.
// Return Value:
//          If buffer is NULL or buflen is zero, return number of characters
//          (not bytes) of text present within the rectangle, excluding a
//          terminating NUL. Generally you should pass a buffer at least one
//          larger than this if you want a terminating NUL, which will be
//          provided if space is available. Otherwise, return number of
//          characters copied into the buffer, including the terminating NUL
//          when space for it is available.
// Comment:
//          If the buffer is too small, as much text as will fit is copied into
//          it.
//
FPDF_EXPORT int FPDF_CALLCONV FPDFText_GetBoundedText(FPDF_TEXTPAGE text_page,
                                                      double left,
                                                      double top,
                                                      double right,
                                                      double bottom,
                                                      unsigned short* buffer,
                                                      int buflen);

// Flags used by FPDFText_FindStart function.
//
// If not set, it will not match case by default.
#define FPDF_MATCHCASE 0x00000001
// If not set, it will not match the whole word by default.
#define FPDF_MATCHWHOLEWORD 0x00000002
// If not set, it will skip past the current match to look for the next match.
#define FPDF_CONSECUTIVE 0x00000004

// Function: FPDFText_FindStart
//          Start a search.
// Parameters:
//          text_page   -   Handle to a text page information structure.
//                          Returned by FPDFText_LoadPage function.
//          findwhat    -   A unicode match pattern.
//          flags       -   Option flags.
//          start_index -   Start from this character. -1 for end of the page.
// Return Value:
//          A handle for the search context. FPDFText_FindClose must be called
//          to release this handle.
//
FPDF_EXPORT FPDF_SCHHANDLE FPDF_CALLCONV
FPDFText_FindStart(FPDF_TEXTPAGE text_page,
                   FPDF_WIDESTRING findwhat,
                   unsigned long flags,
                   int start_index);

// Function: FPDFText_FindNext
//          Search in the direction from page start to end.
// Parameters:
//          handle      -   A search context handle returned by
//                          FPDFText_FindStart.
// Return Value:
//          Whether a match is found.
//
FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV FPDFText_FindNext(FPDF_SCHHANDLE handle);

// Function: FPDFText_FindPrev
//          Search in the direction from page end to start.
// Parameters:
//          handle      -   A search context handle returned by
//                          FPDFText_FindStart.
// Return Value:
//          Whether a match is found.
//
FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV FPDFText_FindPrev(FPDF_SCHHANDLE handle);

// Function: FPDFText_GetSchResultIndex
//          Get the starting character index of the search result.
// Parameters:
//          handle      -   A search context handle returned by
//                          FPDFText_FindStart.
// Return Value:
//          Index for the starting character.
//
FPDF_EXPORT int FPDF_CALLCONV FPDFText_GetSchResultIndex(FPDF_SCHHANDLE handle);

// Function: FPDFText_GetSchCount
//          Get the number of matched characters in the search result.
// Parameters:
//          handle      -   A search context handle returned by
//                          FPDFText_FindStart.
// Return Value:
//          Number of matched characters.
//
FPDF_EXPORT int FPDF_CALLCONV FPDFText_GetSchCount(FPDF_SCHHANDLE handle);

// Function: FPDFText_FindClose
//          Release a search context.
// Parameters:
//          handle      -   A search context handle returned by
//                          FPDFText_FindStart.
// Return Value:
//          None.
//
FPDF_EXPORT void FPDF_CALLCONV FPDFText_FindClose(FPDF_SCHHANDLE handle);

// Function: FPDFLink_LoadWebLinks
//          Prepare information about weblinks in a page.
// Parameters:
//          text_page   -   Handle to a text page information structure.
//                          Returned by FPDFText_LoadPage function.
// Return Value:
//          A handle to the page's links information structure, or
//          NULL if something goes wrong.
// Comments:
//          Weblinks are those links implicitly embedded in PDF pages. PDF also
//          has a type of annotation called "link" (FPDFTEXT doesn't deal with
//          that kind of link). FPDFTEXT weblink feature is useful for
//          automatically detecting links in the page contents. For example,
//          things like "https://www.example.com" will be detected, so
//          applications can allow user to click on those characters to activate
//          the link, even the PDF doesn't come with link annotations.
//
//          FPDFLink_CloseWebLinks must be called to release resources.
//
FPDF_EXPORT FPDF_PAGELINK FPDF_CALLCONV
FPDFLink_LoadWebLinks(FPDF_TEXTPAGE text_page);

// Function: FPDFLink_CountWebLinks
//          Count number of detected web links.
// Parameters:
//          link_page   -   Handle returned by FPDFLink_LoadWebLinks.
// Return Value:
//          Number of detected web links.
//
FPDF_EXPORT int FPDF_CALLCONV FPDFLink_CountWebLinks(FPDF_PAGELINK link_page);

// Function: FPDFLink_GetURL
//          Fetch the URL information for a detected web link.
// Parameters:
//          link_page   -   Handle returned by FPDFLink_LoadWebLinks.
//          link_index  -   Zero-based index for the link.
//          buffer      -   A unicode buffer for the result.
//          buflen      -   Number of 16-bit code units (not bytes) for the
//                          buffer, including an additional terminator.
// Return Value:
//          If |buffer| is NULL or |buflen| is zero, return the number of 16-bit
//          code units (not bytes) needed to buffer the result (an additional
//          terminator is included in this count).
//          Otherwise, copy the result into |buffer|, truncating at |buflen| if
//          the result is too large to fit, and return the number of 16-bit code
//          units actually copied into the buffer (the additional terminator is
//          also included in this count).
//          If |link_index| does not correspond to a valid link, then the result
//          is an empty string.
//
FPDF_EXPORT int FPDF_CALLCONV FPDFLink_GetURL(FPDF_PAGELINK link_page,
                                              int link_index,
                                              unsigned short* buffer,
                                              int buflen);

// Function: FPDFLink_CountRects
//          Count number of rectangular areas for the link.
// Parameters:
//          link_page   -   Handle returned by FPDFLink_LoadWebLinks.
//          link_index  -   Zero-based index for the link.
// Return Value:
//          Number of rectangular areas for the link.  If |link_index| does
//          not correspond to a valid link, then 0 is returned.
//
FPDF_EXPORT int FPDF_CALLCONV FPDFLink_CountRects(FPDF_PAGELINK link_page,
                                                  int link_index);

// Function: FPDFLink_GetRect
//          Fetch the boundaries of a rectangle for a link.
// Parameters:
//          link_page   -   Handle returned by FPDFLink_LoadWebLinks.
//          link_index  -   Zero-based index for the link.
//          rect_index  -   Zero-based index for a rectangle.
//          left        -   Pointer to a double value receiving the rectangle
//                          left boundary.
//          top         -   Pointer to a double value receiving the rectangle
//                          top boundary.
//          right       -   Pointer to a double value receiving the rectangle
//                          right boundary.
//          bottom      -   Pointer to a double value receiving the rectangle
//                          bottom boundary.
// Return Value:
//          On success, return TRUE and fill in |left|, |top|, |right|, and
//          |bottom|. If |link_page| is invalid or if |link_index| does not
//          correspond to a valid link, then return FALSE, and the out
//          parameters remain unmodified.
//
FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV FPDFLink_GetRect(FPDF_PAGELINK link_page,
                                                     int link_index,
                                                     int rect_index,
                                                     double* left,
                                                     double* top,
                                                     double* right,
                                                     double* bottom);

// Experimental API.
// Function: FPDFLink_GetTextRange
//          Fetch the start char index and char count for a link.
// Parameters:
//          link_page         -   Handle returned by FPDFLink_LoadWebLinks.
//          link_index        -   Zero-based index for the link.
//          start_char_index  -   pointer to int receiving the start char index
//          char_count        -   pointer to int receiving the char count
// Return Value:
//          On success, return TRUE and fill in |start_char_index| and
//          |char_count|. if |link_page| is invalid or if |link_index| does
//          not correspond to a valid link, then return FALSE and the out
//          parameters remain unmodified.
//
FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV
FPDFLink_GetTextRange(FPDF_PAGELINK link_page,
                      int link_index,
                      int* start_char_index,
                      int* char_count);

// Function: FPDFLink_CloseWebLinks
//          Release resources used by weblink feature.
// Parameters:
//          link_page   -   Handle returned by FPDFLink_LoadWebLinks.
// Return Value:
//          None.
//
FPDF_EXPORT void FPDF_CALLCONV FPDFLink_CloseWebLinks(FPDF_PAGELINK link_page);

#ifdef __cplusplus
}
#endif

#endif  // PUBLIC_FPDF_TEXT_H_
