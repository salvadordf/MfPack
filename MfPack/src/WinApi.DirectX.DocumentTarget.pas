// FactoryX
//
// Copyright: � FactoryX. All rights reserved.
//
// Project: WinApi.DirectX - DirectX
// Project location: https://sourceforge.net/projects/MFPack
//                   https://github.com/FactoryXCode/MfPack
// Module: WinApi.DirectX.DocumentTarget.pas
// Kind: Pascal / Delphi unit
// Release date: 30-04-2019
// Language: ENU
//
// Revision Version: 3.1.7
// Description: Defines for document package target interfaces.
//
// Organisation: FactoryX
// Initiator(s): Tony (maXcomX), Peter (OzShips)
// Contributor(s): Tony Kalf (maXcomX), Peter Larson (ozships)
//
//------------------------------------------------------------------------------
// CHANGE LOG
// Date       Person              Reason
// ---------- ------------------- ----------------------------------------------
// 30/06/2024 All                 RammStein release  SDK 10.0.26100.0 (Windows 11)
//------------------------------------------------------------------------------
//
// Remarks: -
//
// Related objects: -
// Related projects: MfPackX317
// Known Issues: -
//
// Compiler version: 23 up to 35
// SDK version: 10.0.26100.0
//
// Todo: -
//
//==============================================================================
// Source: DocumentTarget.h
//
// Copyright (c) Microsoft Corporation. All rights reserved.
//==============================================================================
//
// LICENSE
//
// The contents of this file are subject to the Mozilla Public License
// Version 2.0 (the "License"); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
// https://www.mozilla.org/en-US/MPL/2.0/
//
// Software distributed under the License is distributed on an "AS IS"
// basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
// License for the specific language governing rights and limitations
// under the License.
//
// Non commercial users may distribute this sourcecode provided that this
// header is included in full at the top of the file.
// Commercial users are not allowed to distribute this sourcecode as part of
// their product.
//
//==============================================================================
unit WinApi.DirectX.DocumentTarget;

  {$HPPEMIT '#include "DocumentTarget.h"'}

interface

// {$DEFINE USE_EMBARCADERO_DEF}

uses
  {WinApi}
  WinApi.WinApiTypes,
  {ActiveX}
  {$IFDEF USE_EMBARCADERO_DEF}
  WinApi.ActiveX;
  {$ELSE}
  WinApi.ActiveX.ObjIdlbase;
  {$ENDIF}


  {$MINENUMSIZE 4}

  {$IFDEF WIN32}
    {$ALIGN 1}
  {$ELSE}
    {$ALIGN 8} // Win64
  {$ENDIF}


type

//#if (NTDDI_VERSION >= NTDDI_WIN7)

  // Interface IPrintDocumentPackageTarget
  // =====================================
  // Document Target IPrintDocumentPackageTarget interface:
  // Allows user to enumerate supported package target types and create one with type ID.
  // It also supports tracking package printing progess and cancelling.
  //
  {$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IPrintDocumentPackageTarget);'}
  {$EXTERNALSYM IPrintDocumentPackageTarget}
  IPrintDocumentPackageTarget = interface(IUnknown)
  ['{1b8efec4-3019-4c27-964e-367202156906}']

    // This method is called for enumerating supported target types.
    // The first GUID is preferred type by target.
    function GetPackageTargetTypes(out targetCount: UINT32;
                                   out targetTypes: PGUID): HResult; stdcall;

    // This method is called for createing a target instance.")]
    function GetPackageTarget({in} const guidTargetType: TGUID;
                              {in} const riid: TGUID;
                              out ppvTarget: Pointer): HResult; stdcall;

    function Cancel(): HResult; stdcall;
  end;
  IID_IPrintDocumentPackageTarget = IPrintDocumentPackageTarget;
  {$EXTERNALSYM IID_IPrintDocumentPackageTarget}


  PPrintDocumentPackageCompletion = ^PrintDocumentPackageCompletion;
  PrintDocumentPackageCompletion              = (
    PrintDocumentPackageCompletion_InProgress = 0,
    PrintDocumentPackageCompletion_Completed  = ( PrintDocumentPackageCompletion_InProgress + 1),
    PrintDocumentPackageCompletion_Canceled   = ( PrintDocumentPackageCompletion_Completed + 1),
    PrintDocumentPackageCompletion_Failed     = ( PrintDocumentPackageCompletion_Canceled + 1)
  );
  {$EXTERNALSYM PrintDocumentPackageCompletion}


  PPrintDocumentPackageStatus = ^PrintDocumentPackageStatus;
  PrintDocumentPackageStatus = record
    JobId: UINT32;
    CurrentDocument: INT32;
    CurrentPage: INT32;
    CurrentPageTotal: INT32;
    Completion: PrintDocumentPackageCompletion;
    PackageStatus: HResult;
  end;
  {$EXTERNALSYM PrintDocumentPackageStatus}


  // Interface IPrintDocumentPackageStatusEvent
  // ==========================================
  // Com event implemented by clients, who want to listen print job progress.
  //
  {$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IPrintDocumentPackageStatusEvent);'}
  {$EXTERNALSYM IPrintDocumentPackageStatusEvent}
  IPrintDocumentPackageStatusEvent = interface(IDispatch)
  ['{ed90c8ad-5c34-4d05-a1ec-0e8a9b3ad7af}']

    // This method is called for updating package status when the progressive
    // print job event signals or job completes.
    function PackageStatusUpdated({in} packageStatus: PrintDocumentPackageStatus): HResult; stdcall;

  end;
  IID_IPrintDocumentPackageStatusEvent = IPrintDocumentPackageStatusEvent;
  {$EXTERNALSYM IID_IPrintDocumentPackageStatusEvent}


  // Interface IPrintDocumentPackageTargetFactory
  // ============================================
  // Document Target IPrintDocumentPackageTargetFactory interface for
  // starting your print job on IPrintDocumentPackageTarget.
  //
  {$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IPrintDocumentPackageTargetFactory);'}
  {$EXTERNALSYM IPrintDocumentPackageTargetFactory}
  IPrintDocumentPackageTargetFactory = interface(IUnknown)
  ['{d2959bf7-b31b-4a3d-9600-712eb1335ba4}']

    // This method is the entry point for creating IPrintDocumentPackageTarget.
    function CreateDocumentPackageTargetForPrintJob({in} printerName: PWideChar;
                                                    {in} jobName: PWideChar;
                                                    // application must set seek pointer to original before specifying the job output stream.
                                                    {in} jobOutputStream: IStream;
                                                    {in} jobPrintTicketStream: IStream;
                                                    out docPackageTarget: IPrintDocumentPackageTarget): HResult; stdcall;

  end;
  IID_IPrintDocumentPackageTargetFactory = IPrintDocumentPackageTargetFactory;
  {$EXTERNALSYM IID_IPrintDocumentPackageTargetFactory}


  // Interface IPrintDocumentPackageTarget2
  // ======================================
  // Allows users to see if the target printer is an Internet Printing Protocol(Ipp) Printer,
  // and returns IppPrinterDevice if the target is an Ipp Printer.
  //
  {$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IPrintDocumentPackageTarget2);'}
  {$EXTERNALSYM IPrintDocumentPackageTarget2}
  IPrintDocumentPackageTarget2 = interface(IUnknown)
  ['{c560298a-535c-48f9-866a-632540660cb4}']

    // This method returns True if the printer is an IppPrinter.
    function GetIsTargetIppPrinter(out isIppPrinter: BOOL): HResult; stdcall;

    // This method returns IppPrinterDevice for the target printer.
    function GetTargetIppPrintDevice(const riid: REFIID;
                                     out ppvTarget: Pointer): HResult; stdcall;

  end;
  IID_IPrintDocumentPackageTarget2 = IPrintDocumentPackageTarget2;
  {$EXTERNALSYM IID_IPrintDocumentPackageTarget2}




const

  ID_DOCUMENTPACKAGETARGET_MSXPS   : TGUID = '{9cae40a8-ded1-41c9-a9fd-d735ef33aeda}';
  {$EXTERNALSYM ID_DOCUMENTPACKAGETARGET_MSXPS}
  ID_DOCUMENTPACKAGETARGET_OPENXPS : TGUID = '{0056bb72-8c9c-4612-bd0f-93012a87099d}';
  {$EXTERNALSYM ID_DOCUMENTPACKAGETARGET_OPENXPS}

//#endif // (NTDDI_VERSION >= NTDDI_WIN7)


//#if (NTDDI_VERSION >= NTDDI_WINBLUE)

  ID_DOCUMENTPACKAGETARGET_OPENXPS_WITH_3D : TGUID = '{63dbd720-8b14-4577-b074-7bb11b596d28}';
  {$EXTERNALSYM ID_DOCUMENTPACKAGETARGET_OPENXPS_WITH_3D}

//#endif // (NTDDI_VERSION >= NTDDI_WINBLUE)




  // Additional Prototypes for ALL interfaces

  // End of Additional Prototypes

implementation

  // Implement Additional functions here.

end.
