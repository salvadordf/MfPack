// FactoryX
//
// Copyright � by FactoryX. All rights reserved.
//
// Project: MFPack - XAudio2
// Project location: https://sourceforge.net/projects/MFPack
//                   https://github.com/FactoryXCode/MfPack
// Module: XAudio2.inc
// Kind: Delphi include file
// Release date: 07-07-2018
// Language: ENU
//
// Revision Version: 3.1.7
// Description: Version control unit for XAudio2
//              Requires Windows 8, XAudio2.8 or later
//
// Initiator(s): Tony (maXcomX), Peter (OzShips)
//
//------------------------------------------------------------------------------
// CHANGE LOG
// Date       Person              Reason
// ---------- ------------------- ----------------------------------------------
// 30/06/2024 All                 RammStein release  SDK 10.0.26100.0 (Windows 11)
//------------------------------------------------------------------------------
// Remarks: Delphi specific include file, to determine which DLL's are needed to load.
//          XAudio2 version 2.9 ships as part of Windows 10, XAUDIO2_9.DLL,
//          alongside XAudio2.8 to support older applications, and does not require redistribution.
//
// Related objects: -
// Related projects: MfPackX317
// Known Issues: -
// Compiler version: 23 up to 35
// SDK version: 10.0.22000.0
// Todo: -
// =============================================================================
// Source: xaudio2fx.h / xaudio2.h
// XAudio
//
// Copyright (c) Microsoft Corporation. All rights reserved
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


// By default compile for windows 10 32bit
{$IFDEF WIN32}

  {$DEFINE _WIN32_WINNT_WIN10}  // <<< Comment this directive if you compile for Windows 8 32bit
  {$DEFINE _WINNT_WIN10}

  {$IFNDEF _WIN32_WINNT_WIN10}
    {$UNDEFINE _WINNT_WIN10}
    {$DEFINE _WIN32_WINNT_WIN8}
    {$DEFINE _WINNT_WIN8}
  {$ENDIF}

{$ENDIF}



{$IFDEF WIN64}  // 64bit

  {$DEFINE _WIN64_WINNT_WIN10}  // <<< Comment out this directive if you compile for Windows 8 64bit
  {$DEFINE _WINNT_WIN10}

  {$IFNDEF _WIN64_WINNT_WIN10}
    {$UNDEFINE _WINNT_WIN10}
    {$DEFINE _WIN64_WINNT_WIN8}
    {$DEFINE _WINNT_WIN8}
  {$ENDIF}

{$ENDIF}



const

// Current name of the DLL shipped in the same SDK as this header.
// The name reflects the current version
{$IFDEF _WIN32_WINNT_WIN10}
  XAUDIO2_DLL_A                      = 'xaudio2_9.dll';
  XAUDIO2_DLL_W                      = 'xaudio2_9.dll';
  X3DAUDIO_DLL                       = 'x3daudio1_0.dll';
{$ENDIF}

{$IFDEF _WIN64_WINNT_WIN10}
  XAUDIO2_DLL_A                      = 'xaudio2_9d.dll';
  XAUDIO2_DLL_W                      = 'xaudio2_9d.dll';
  X3DAUDIO_DLL                       = 'x3daudio1_0.dll';
{$ENDIF}

{$IFDEF _WIN32_WINNT_WIN8}  //Windows 8 32bit
  XAUDIO2_DLL_A                      = 'xaudio2_8.dll';
  XAUDIO2_DLL_W                      = 'xaudio2_8.dll';
  X3DAUDIO_DLL                       = 'x3daudio.dll';
{$ENDIF}

{$IFDEF _WIN64_WINNT_WIN8}  //Windows 8 64bit
  XAUDIO2_DLL_A                      = 'xaudio2_8.dll';
  XAUDIO2_DLL_W                      = 'xaudio2_8.dll';
  X3DAUDIO_DLL                       = 'x3daudio.dll';
{$ENDIF}

{$IFDEF UNICODE}
  XAUDIO2_DLL                        = XAUDIO2_DLL_W;
{$ELSE}
  XAUDIO2_DLL                        = XAUDIO2_DLL_A;
{$ENDIF}

// XAPOFx
  XAPOFxLib = 'Windows.Media.Audio.dll';   // See:
                                           // Note: This dll is not the one XAPOFx uses.


//<eof>