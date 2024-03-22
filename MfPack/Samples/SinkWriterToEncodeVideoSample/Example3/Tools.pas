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
// Revision Version: 3.1.6
// Description: Helpers.
//
// Company: FactoryX
// Intiator(s): Renate Schaaf, Tony (maXcomX).
// Contributor(s): Renate Schaaf, Tony Kalf (maXcomX)
//
//------------------------------------------------------------------------------
// CHANGE LOG
// Date       Person              Reason
// ---------- ------------------- ----------------------------------------------
// 30/01/2024 All                 Morrissey release  SDK 10.0.22621.0 (Windows 11)
//------------------------------------------------------------------------------
//
// Remarks: Requires Windows 7 or higher.
//
// Related objects: -
// Related projects: MfPackX316
// Known Issues: -
//
// Compiler version: 23 up to 35
// SDK version: 10.0.22621.0
//
// Todo: -
//
// =============================================================================
// Source: FactoryX.Code Sinkwriter and Transcode Examples.
//         Bitmaps2Video for Media Foundation.
//         https://github.com/rmesch/Bitmaps2Video-for-Media-Foundation
//
// Copyright © 2003-2024 Renate Schaaf
// Requires MFPack at https://github.com/FactoryXCode/MfPack
// Download the repository and add the folder "src" to your library path.
//
// The sinkwriter sample in this repository got me started on this project.
// Thanks for the great work!
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
  WinApi.Wincodec,
  {$IF COMPILERVERSION >= 29.0}
  Winapi.ShLwApi,
  {$ENDIF}
  {VCL}
  VCL.Graphics,
  {System}
  System.Classes,
  {MediaFoundationApi}
  WinApi.MediaFoundationApi.MfUtils;

/// <summary> Assigns a TWICImage to a TBitmap without setting its alphaformat to afDefined.
/// A TWICImage can be used for fast decoding of image formats .jpg, .bmp, .png, .ico, .tif. </summary>
procedure WICToBmp(const aWic: TWICImage;
                   const bmp: TBitmap);

function LogicalCompare(List: TStringlist;
                        Index1: Integer;
                        Index2: Integer): Integer;


implementation


procedure WICToBmp(const aWic: TWICImage; const bmp: TBitmap);
var
  LWicBitmap: IWICBitmapSource;
  Stride: Integer;
  Buffer: array of Byte;
  BitmapInfo: TBitmapInfo;
  w: Integer;
  h: Integer;

begin
  w := aWic.Width;
  h := aWic.Height;
  Stride := w * 4;
  SetLength(Buffer,
            Stride * h);

  WICConvertBitmapSource(GUID_WICPixelFormat32bppBGRA,
                         aWic.Handle,
                         LWicBitmap);

  LWicBitmap.CopyPixels(nil,
                        Stride,
                        Length(Buffer),
                        @Buffer[0]);

  FillChar(BitmapInfo,
           SizeOf(BitmapInfo),
           0);

  BitmapInfo.bmiHeader.biSize := SizeOf(BitmapInfo);
  BitmapInfo.bmiHeader.biWidth := w;
  BitmapInfo.bmiHeader.biHeight := -h;
  BitmapInfo.bmiHeader.biPlanes := 1;
  BitmapInfo.bmiHeader.biBitCount := 32;

  bmp.SetSize(0,
              0); // Erase pixels.

  bmp.PixelFormat := pf32bit;

  // If the alphaformat was afDefined before, this is a good spot
  // for VCL.Graphics to do un-multiplication.
  bmp.AlphaFormat := afIgnored;

  bmp.SetSize(w,
              h);

  SetDIBits(0,
            bmp.Handle,
            0,
            h,
            @Buffer[0],
            BitmapInfo,
            DIB_RGB_COLORS);
end;


function LogicalCompare(List: TStringlist;
                        Index1: Integer;
                        Index2: Integer): Integer;
begin
  Result := StrCmpLogicalW(PWideChar(List[Index1]),
                           PWideChar(List[Index2]));
end;

end.
