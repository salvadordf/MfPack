﻿// FactoryX
//
// Copyright: © FactoryX. All rights reserved.
//
// Project: Media Foundation - MFPack - Samples
// Project location: https://sourceforge.net/projects/MFPack
//                   https://github.com/FactoryXCode/MfPack
// Module: Tools.pas
// Kind: Pascal Unit
// Release date: 24-06-2023
// Language: ENU
//
// Revision Version: 3.1.7
// Description: Helpers.
//
// Company: FactoryX
// Intiator(s): Tony (maXcomX).
// Contributor(s): Tony Kalf (maXcomX)
//
//------------------------------------------------------------------------------
// CHANGE LOG
// Date       Person              Reason
// ---------- ------------------- ----------------------------------------------
// 30/03/2024 Tony                Morrissey release  SDK 10.0.22621.0 (Windows 11)
//------------------------------------------------------------------------------
//
// Remarks: Requires Windows 7 or higher.
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
// =============================================================================
// Source: FactoryX.Code.
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
unit Tools;

interface

uses
  {WinApi}
  WinApi.Windows,
  WinApi.Messages;

  /// <summary> Usage: HandleThreadMessages(GetCurrentThread()) or HandleThreadMessages(TThread.CurrentThread.Handle). </summary>
  procedure HandleThreadMessages(AThread: THandle;
                                 AWait: Cardinal = INFINITE);

implementation


procedure HandleThreadMessages(AThread: THandle;
                               AWait: Cardinal = INFINITE);
var
  mMsg: TMsg;

begin

  while (MsgWaitForMultipleObjects(1,
                                   AThread,
                                   False,
                                   AWait,
                                   QS_ALLINPUT) = WAIT_OBJECT_0 + 1) do
    begin
      PeekMessage(mMsg,
                  0,
                  0,
                  0,
                  PM_REMOVE);

      if (mMsg.Message = WM_QUIT) then
        Exit;

      TranslateMessage(mMsg);
      DispatchMessage(mMsg);
    end;
end;

end.
