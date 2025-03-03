// FactoryX
//
// Copyright: � FactoryX. All rights reserved.
//
// Project: MfPack - Shared
// Project location: https://sourceforge.net/projects/MFPack
//                   https://github.com/FactoryXCode/MfPack
// Module: WinApi.MMiscApi2.pas
// Kind: Pascal / Delphi unit
// Release date: 11-07-2012
// Language: ENU
//
// Revision Version: 3.1.7
// Description: ApiSet Contract for api-ms-win-mm-misc-l2-1-0
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
// Source: mmiscapi2.h
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
unit WinApi.WinMM.MMiscApi2;


  {$MINENUMSIZE 4}

  {$IFDEF WIN32}
    {$ALIGN 1}
  {$ELSE}
    {$ALIGN 8} // Win64
  {$ENDIF}

interface

  (*$HPPEMIT '' *)
  (*$HPPEMIT '#include <mmiscapi2.h>' *)
  (*$HPPEMIT '' *)

uses
  {WinApi}
  WinApi.WinApiTypes,
  {WinMM}
  WinApi.WinMM.MMSysCom;


type

  LPTIMECALLBACK = ^TIMECALLBACK;
  {$EXTERNALSYM LPTIMECALLBACK}
  TIMECALLBACK = procedure(uTimerID: UINT;
                           uMsg: UINT;
                           dwUser: DWORD_PTR;
                           dw1: DWORD_PTR;
                           dw2: DWORD_PTR);
  {$EXTERNALSYM TIMECALLBACK}



  { flags for fuEvent parameter of timeSetEvent() function }

const

  TIME_ONESHOT                        = $0000;  { program timer for single event }
  {$EXTERNALSYM TIME_ONESHOT}
  TIME_PERIODIC                       = $0001;  { program for continuous periodic event }
  {$EXTERNALSYM TIME_PERIODIC}

  TIME_CALLBACK_FUNCTION              = $0000;  { callback is function }
  {$EXTERNALSYM TIME_CALLBACK_FUNCTION}
  TIME_CALLBACK_EVENT_SET             = $0010;  { callback is event - use SetEvent }
  {$EXTERNALSYM TIME_CALLBACK_EVENT_SET}
  TIME_CALLBACK_EVENT_PULSE           = $0020;  { callback is event - use PulseEvent }
  {$EXTERNALSYM TIME_CALLBACK_EVENT_PULSE}

  TIME_KILL_SYNCHRONOUS               = $0100;  { This flag prevents the event from occurring }
                                                { after the user calls timeKillEvent() to }
                                                { destroy it. }
  {$EXTERNALSYM TIME_KILL_SYNCHRONOUS}


  function timeSetEvent(uDelay: UINT;
                        uResolution: UINT;
                        fptc: LPTIMECALLBACK;
                        dwUser: DWORD_PTR;
                        fuEvent: UINT): MMRESULT; stdcall;
  {$EXTERNALSYM timeSetEvent}


  function timeKillEvent(uTimerID: UINT): MMRESULT; stdcall;
  {$EXTERNALSYM timeKillEvent}


  // Additional Prototypes for ALL interfaces

  // End of Additional Prototypes

implementation

const
  MMiscApi2Lib = 'Winmm.dll';

{$WARN SYMBOL_PLATFORM OFF}
  function timeSetEvent; external MMiscApi2Lib name 'timeSetEvent' {$IF COMPILERVERSION > 20.0} delayed {$ENDIF};
  function timeKillEvent; external MMiscApi2Lib name 'timeKillEvent' {$IF COMPILERVERSION > 20.0} delayed {$ENDIF};
{$WARN SYMBOL_PLATFORM ON}

  // Implement Additional Prototypes here.

end.
