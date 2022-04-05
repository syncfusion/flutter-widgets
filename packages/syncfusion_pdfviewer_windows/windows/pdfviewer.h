#ifndef PDFVIEWER_H_
#define PDFVIEWER_H_

#include <fpdfview.h>

#include <memory>
#include <string>
#include <vector>

namespace pdfviewer
{
  class PdfDocument
  {
  private:
    std::vector<uint8_t> data;

  public:
    PdfDocument(std::vector<uint8_t> data, std::string id);

    ~PdfDocument();

    FPDF_DOCUMENT pdfDocument;
    std::string documentID;
  };

  std::shared_ptr<PdfDocument> initializePdfRenderer(std::vector<uint8_t> data, std::string docID);
  std::shared_ptr<PdfDocument> getPdfDocument(std::string docID);
  void closePdfDocument(std::string docID);
}
#endif