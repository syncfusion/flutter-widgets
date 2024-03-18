#pragma warning(disable : 4458)

#include <Windows.h>
#include <gdiplus.h>

#include <iostream>
#include <stdexcept>
#include <string>
#include <map>

#include "pdfviewer.h"

#pragma comment(lib, "gdiplus.lib")

namespace pdfviewer
{

  std::map<std::string, std::shared_ptr<PdfDocument>> documentRepo;

  std::shared_ptr<PdfDocument> getPdfDocument(std::string docID)
  {
    std::shared_ptr<PdfDocument> documentPtr = nullptr;

    std::map<std::string, std::shared_ptr<PdfDocument>>::iterator documentRepoIterator = documentRepo.find(docID);
    // Checks whether the docID is present or not in the documentRepo map
    if (documentRepoIterator != documentRepo.end())
    {
      documentPtr = documentRepoIterator->second;
    }
    else 
    {
      documentPtr = nullptr;
    }

    return documentPtr;
  }

  void closePdfDocument(std::string docID)
  {
    std::shared_ptr<PdfDocument> documentPtr = getPdfDocument(docID);
    if (documentPtr == nullptr)
        return;
    FPDF_DOCUMENT document = documentPtr->pdfDocument;
    FPDF_CloseDocument(document);
    documentRepo.erase(docID);
  }

  std::shared_ptr<PdfDocument> initializePdfRenderer(std::vector<uint8_t> data, std::string docID)
  {
    if (documentRepo.size() == 0)
    {
      FPDF_InitLibraryWithConfig(nullptr);
    }

    std::shared_ptr<PdfDocument> doc = std::make_shared<PdfDocument>(data, docID);
    documentRepo[docID] = doc;

    return doc;
  }

  PdfDocument::PdfDocument(std::vector<uint8_t> dataRef, std::string id) : documentID{id}
  {
    data.swap(dataRef);

    pdfDocument = FPDF_LoadMemDocument64(data.data(), data.size(), nullptr);
  }

  PdfDocument::~PdfDocument() {}
}