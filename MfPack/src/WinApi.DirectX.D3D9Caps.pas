// FactoryX
//
// Copyright: � FactoryX. All rights reserved.
//
// Project: WinApi.DirectX - DirectX
// Project location: https://sourceforge.net/projects/MFPack
//                   https://github.com/FactoryXCode/MfPack
// Module: WinApi.DirectX.D3d9Caps.pas
// Kind: Pascal / Delphi unit
// Release date: 15-01-2018
// Language: ENU
//
// Revision Version: 3.1.3
// Description: Direct3D capabilities include file
//
// Organisation: FactoryX
// Initiator(s): Tony (maXcomX), Peter (OzShips)
// Contributor(s): Tony Kalf (maXcomX), Peter Larson (ozships)
//
//------------------------------------------------------------------------------
// CHANGE LOG
// Date       Person              Reason
// ---------- ------------------- ----------------------------------------------
// 28/08/2022 All                 Mercury release  SDK 10.0.22621.0 (Windows 11)
//------------------------------------------------------------------------------
//
// Remarks: Requires Windows Vista or later.
//          New apps should use the latest Direct3D API
//
// Related objects: -
// Related projects: MfPackX313
// Known Issues: -
//
// Compiler version: 23 up to 35
// SDK version: 10.0.22621.0
//
// Todo: -
//
//==============================================================================
// Source: d3d9caps.h
//
// Copyright (c) Microsoft Corporation. All rights reserved.
//==============================================================================
//
// LICENSE
// 
//  The contents of this file are subject to the
//  GNU General Public License v3.0 (the "License");
//  you may not use this file except in
//  compliance with the License. You may obtain a copy of the License at
//  https://www.gnu.org/licenses/gpl-3.0.html
//
// Software distributed under the License is distributed on an "AS IS"
// basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
// License for the specific language governing rights and limitations
// under the License.
// 
// Users may distribute this source code provided that this header is included
// in full at the top of the file.
// 
//==============================================================================
unit WinApi.DirectX.D3D9Caps;

  {$HPPEMIT '#include "d3d9caps.h"'}

interface

uses

  {WinApi}
  WinApi.Windows,
  {MfPack}
  WinApi.DirectX.D3D9Types;

  {$WEAKPACKAGEUNIT ON}
  {$MINENUMSIZE 4}

  {$IFDEF WIN32}
    {$ALIGN 1}
  {$ELSE}
    {$ALIGN 8} // Win64
  {$ENDIF}

  {$I 'WinApiTypes.inc'}

{$IFNDEF DIRECT3D_VERSION}
const
  DIRECT3D_VERSION                    = $0900;
  {$EXTERNALSYM DIRECT3D_VERSION}
{$ENDIF}  //DIRECT3D_VERSION

type

  PD3DVSHADERCAPS2_0 = ^D3DVSHADERCAPS2_0;
  _D3DVSHADERCAPS2_0 = record
    Caps: DWORD;
    DynamicFlowControlDepth: Integer;
    NumTemps: Integer;
    StaticFlowControlDepth: Integer;
  end;
  {$EXTERNALSYM _D3DVSHADERCAPS2_0}
  D3DVSHADERCAPS2_0 = _D3DVSHADERCAPS2_0;
  {$EXTERNALSYM D3DVSHADERCAPS2_0}


const

  D3DVS20CAPS_PREDICATION             = (1 shl 0);
  {$EXTERNALSYM D3DVS20CAPS_PREDICATION}

  D3DVS20_MAX_DYNAMICFLOWCONTROLDEPTH = 24;
  {$EXTERNALSYM D3DVS20_MAX_DYNAMICFLOWCONTROLDEPTH}
  D3DVS20_MIN_DYNAMICFLOWCONTROLDEPTH = 0;
  {$EXTERNALSYM D3DVS20_MIN_DYNAMICFLOWCONTROLDEPTH}
  D3DVS20_MAX_NUMTEMPS                = 32;
  {$EXTERNALSYM D3DVS20_MAX_NUMTEMPS}
  D3DVS20_MIN_NUMTEMPS                = 12;
  {$EXTERNALSYM D3DVS20_MIN_NUMTEMPS}
  D3DVS20_MAX_STATICFLOWCONTROLDEPTH  = 4;
  {$EXTERNALSYM D3DVS20_MAX_STATICFLOWCONTROLDEPTH}
  D3DVS20_MIN_STATICFLOWCONTROLDEPTH  = 1;
  {$EXTERNALSYM D3DVS20_MIN_STATICFLOWCONTROLDEPTH}


type

  PD3DPSHADERCAPS2_0 = ^D3DPSHADERCAPS2_0;
  _D3DPSHADERCAPS2_0 = record
    Caps: DWORD;
    DynamicFlowControlDepth: Integer;
    NumTemps: Integer;
    StaticFlowControlDepth: Integer;
    NumInstructionSlots: Integer;
  end;
  {$EXTERNALSYM _D3DPSHADERCAPS2_0}
  D3DPSHADERCAPS2_0 = _D3DPSHADERCAPS2_0;
  {$EXTERNALSYM D3DPSHADERCAPS2_0}


const

  D3DPS20CAPS_ARBITRARYSWIZZLE        = (1 shl 0);
  {$EXTERNALSYM D3DPS20CAPS_ARBITRARYSWIZZLE}
  D3DPS20CAPS_GRADIENTINSTRUCTIONS    = (1 shl 1);
  {$EXTERNALSYM D3DPS20CAPS_GRADIENTINSTRUCTIONS}
  D3DPS20CAPS_PREDICATION             = (1 shl 2);
  {$EXTERNALSYM D3DPS20CAPS_PREDICATION}
  D3DPS20CAPS_NODEPENDENTREADLIMIT    = (1 shl 3);
  {$EXTERNALSYM D3DPS20CAPS_NODEPENDENTREADLIMIT}
  D3DPS20CAPS_NOTEXINSTRUCTIONLIMIT   = (1 shl 4);
  {$EXTERNALSYM D3DPS20CAPS_NOTEXINSTRUCTIONLIMIT}

  D3DPS20_MAX_DYNAMICFLOWCONTROLDEPTH = 24;
  {$EXTERNALSYM D3DPS20_MAX_DYNAMICFLOWCONTROLDEPTH}
  D3DPS20_MIN_DYNAMICFLOWCONTROLDEPTH = 0;
  {$EXTERNALSYM D3DPS20_MIN_DYNAMICFLOWCONTROLDEPTH}
  D3DPS20_MAX_NUMTEMPS                = 32;
  {$EXTERNALSYM D3DPS20_MAX_NUMTEMPS}
  D3DPS20_MIN_NUMTEMPS                = 12;
  {$EXTERNALSYM D3DPS20_MIN_NUMTEMPS}
  D3DPS20_MAX_STATICFLOWCONTROLDEPTH  = 4;
  {$EXTERNALSYM D3DPS20_MAX_STATICFLOWCONTROLDEPTH}
  D3DPS20_MIN_STATICFLOWCONTROLDEPTH  = 0;
  {$EXTERNALSYM D3DPS20_MIN_STATICFLOWCONTROLDEPTH}
  D3DPS20_MAX_NUMINSTRUCTIONSLOTS     = 512;
  {$EXTERNALSYM D3DPS20_MAX_NUMINSTRUCTIONSLOTS}
  D3DPS20_MIN_NUMINSTRUCTIONSLOTS     = 96;
  {$EXTERNALSYM D3DPS20_MIN_NUMINSTRUCTIONSLOTS}

  D3DMIN30SHADERINSTRUCTIONS          = 512;
  {$EXTERNALSYM D3DMIN30SHADERINSTRUCTIONS}
  D3DMAX30SHADERINSTRUCTIONS          = 32768;
  {$EXTERNALSYM D3DMAX30SHADERINSTRUCTIONS}


  //* D3D9Ex only -- */
  //{$IFDEF D3D_DISABLE_9EX}
type

  PD3DOVERLAYCAPS = ^D3DOVERLAYCAPS;
  _D3DOVERLAYCAPS = record
    Caps: UINT;
    MaxOverlayDisplayWidth: UINT;
    MaxOverlayDisplayHeight: UINT;
  end;
  {$EXTERNALSYM _D3DOVERLAYCAPS}
  D3DOVERLAYCAPS = _D3DOVERLAYCAPS;
  {$EXTERNALSYM D3DOVERLAYCAPS}

const

  D3DOVERLAYCAPS_FULLRANGERGB         = $00000001;
  {$EXTERNALSYM D3DOVERLAYCAPS_FULLRANGERGB}
  D3DOVERLAYCAPS_LIMITEDRANGERGB      = $00000002;
  {$EXTERNALSYM D3DOVERLAYCAPS_LIMITEDRANGERGB}
  D3DOVERLAYCAPS_YCbCr_BT601          = $00000004;
  {$EXTERNALSYM D3DOVERLAYCAPS_YCbCr_BT601}
  D3DOVERLAYCAPS_YCbCr_BT709          = $00000008;
  {$EXTERNALSYM D3DOVERLAYCAPS_YCbCr_BT709}
  D3DOVERLAYCAPS_YCbCr_BT601_xvYCC    = $00000010;
  {$EXTERNALSYM D3DOVERLAYCAPS_YCbCr_BT601_xvYCC}
  D3DOVERLAYCAPS_YCbCr_BT709_xvYCC    = $00000020;
  {$EXTERNALSYM D3DOVERLAYCAPS_YCbCr_BT709_xvYCC}
  D3DOVERLAYCAPS_STRETCHX             = $00000040;
  {$EXTERNALSYM D3DOVERLAYCAPS_STRETCHX}
  D3DOVERLAYCAPS_STRETCHY             = $00000080;
  {$EXTERNALSYM D3DOVERLAYCAPS_STRETCHY}

type

  PD3DCONTENTPROTECTIONCAPS = ^D3DCONTENTPROTECTIONCAPS;
  _D3DCONTENTPROTECTIONCAPS = record
    Caps: DWORD;
    KeyExchangeType: TGUID;
    BufferAlignmentStart: UINT;
    BlockAlignmentSize: UINT;
    ProtectedMemorySize: ULONGLONG;
  end;
  {$EXTERNALSYM _D3DCONTENTPROTECTIONCAPS}
  D3DCONTENTPROTECTIONCAPS = _D3DCONTENTPROTECTIONCAPS;
  {$EXTERNALSYM D3DCONTENTPROTECTIONCAPS}

const

  D3DCPCAPS_SOFTWARE                  = $00000001;
  {$EXTERNALSYM D3DCPCAPS_SOFTWARE}
  D3DCPCAPS_HARDWARE                  = $00000002;
  {$EXTERNALSYM D3DCPCAPS_HARDWARE}
  D3DCPCAPS_PROTECTIONALWAYSON        = $00000004;
  {$EXTERNALSYM D3DCPCAPS_PROTECTIONALWAYSON}
  D3DCPCAPS_PARTIALDECRYPTION         = $00000008;
  {$EXTERNALSYM D3DCPCAPS_PARTIALDECRYPTION}
  D3DCPCAPS_CONTENTKEY                = $00000010;
  {$EXTERNALSYM D3DCPCAPS_CONTENTKEY}
  D3DCPCAPS_FRESHENSESSIONKEY         = $00000020;
  {$EXTERNALSYM D3DCPCAPS_FRESHENSESSIONKEY}
  D3DCPCAPS_ENCRYPTEDREADBACK         = $00000040;
  {$EXTERNALSYM D3DCPCAPS_ENCRYPTEDREADBACK}
  D3DCPCAPS_ENCRYPTEDREADBACKKEY      = $00000080;
  {$EXTERNALSYM D3DCPCAPS_ENCRYPTEDREADBACKKEY}
  D3DCPCAPS_SEQUENTIAL_CTR_IV         = $00000100;
  {$EXTERNALSYM D3DCPCAPS_SEQUENTIAL_CTR_IV}
  D3DCPCAPS_ENCRYPTSLICEDATAONLY      = $00000200;
  {$EXTERNALSYM D3DCPCAPS_ENCRYPTSLICEDATAONLY}

  D3DCRYPTOTYPE_AES128_CTR : TGUID = (D1: $9b6bd711;
                                      D2: $4f74;
                                      D3: $41c9;
                                      D4: ($9e, $7b, $0b, $e2, $d7, $d9, $3b, $4f));
  {$EXTERNALSYM D3DCRYPTOTYPE_AES128_CTR}

  D3DCRYPTOTYPE_PROPRIETARY : TGUID = (D1: $ab4e9afd;
                                       D2: $1d1c;
                                       D3: $46e6;
                                       D4: ($a7, $2f, $08, $69, $91, $7b, $0d, $e8));
  {$EXTERNALSYM D3DCRYPTOTYPE_PROPRIETARY}

  D3DKEYEXCHANGE_RSAES_OAEP : TGUID = (D1: $c1949895;
                                       D2: $d72a;
                                       D3: $4a1d;
                                       D4: ($8e, $5d, $ed, $85, $7d, $17, $15, $20));
   {$EXTERNALSYM D3DKEYEXCHANGE_RSAES_OAEP}

  D3DKEYEXCHANGE_DXVA : TGUID = (D1: $43d3775c;
                                 D2: $38e5;
                                 D3: $4924;
                                 D4: ($8d, $86, $d3, $fc, $cf, $15, $3e, $9b));
  {$EXTERNALSYM D3DKEYEXCHANGE_DXVA}

  //{$ENDIF} // !D3D_DISABLE_9EX
  //* -- D3D9Ex only */

type

  PD3DCAPS9 = ^D3DCAPS9;
  _D3DCAPS9 = record
                                             //* Device Info */
    DeviceType: D3DDEVTYPE;
    AdapterOrdinal: UINT;
                                             //* Caps from DX7 Draw */
    Caps: DWORD;
    Caps2: DWORD;
    Caps3: DWORD;
    PresentationIntervals: DWORD;
                                             //* Cursor Caps */
    CursorCaps: DWORD;
                                             //* 3D Device Caps */
    DevCaps: DWORD;
    PrimitiveMiscCaps: DWORD;
    RasterCaps: DWORD;
    ZCmpCaps: DWORD;
    SrcBlendCaps: DWORD;
    DestBlendCaps: DWORD;
    AlphaCmpCaps: DWORD;
    ShadeCaps: DWORD;
    TextureCaps: DWORD;
    TextureFilterCaps: DWORD;                // D3DPTFILTERCAPS for IDirect3DTexture9's
    CubeTextureFilterCaps: DWORD;            // D3DPTFILTERCAPS for IDirect3DCubeTexture9's
    VolumeTextureFilterCaps: DWORD;          // D3DPTFILTERCAPS for IDirect3DVolumeTexture9's
    TextureAddressCaps: DWORD;               // D3DPTADDRESSCAPS for IDirect3DTexture9's
    VolumeTextureAddressCaps: DWORD;         // D3DPTADDRESSCAPS for IDirect3DVolumeTexture9's
    LineCaps: DWORD;                         // D3DLINECAPS
    MaxTextureWidth: DWORD;
    MaxTextureHeight: DWORD;
    MaxVolumeExtent: DWORD;
    MaxTextureRepeat: DWORD;
    MaxTextureAspectRatio: DWORD;
    MaxAnisotropy: DWORD;
    MaxVertexW: Single;
    GuardBandLeft: Single;
    GuardBandTop: Single;
    GuardBandRight: Single;
    GuardBandBottom: Single;
    ExtentsAdjust: Single;
    StencilCaps: DWORD;
    FVFCaps: DWORD;
    TextureOpCaps: DWORD;
    MaxTextureBlendStages: DWORD;
    MaxSimultaneousTextures: DWORD;
    VertexProcessingCaps: DWORD;
    MaxActiveLights: DWORD;
    MaxUserClipPlanes: DWORD;
    MaxVertexBlendMatrices: DWORD;
    MaxVertexBlendMatrixIndex: DWORD;
    MaxPointSize: Single;
    MaxPrimitiveCount: DWORD;                // max number of primitives per DrawPrimitive call
    MaxVertexIndex: DWORD;
    MaxStreams: DWORD;
    MaxStreamStride: DWORD;                  // max stride for SetStreamSource
    VertexShaderVersion: DWORD;
    MaxVertexShaderConst: DWORD;             // number of vertex shader constant registers
    PixelShaderVersion: DWORD;
    PixelShader1xMaxValue: Single;           // max value storable in registers of ps.1.x shaders
                                             // Here are the DX9 specific ones
    DevCaps2: DWORD;
    MaxNpatchTessellationLevel: Single;
    Reserved5: DWORD;
    MasterAdapterOrdinal: UINT;              // ordinal of master adaptor for adapter group
    AdapterOrdinalInGroup: UINT;             // ordinal inside the adapter group
    NumberOfAdaptersInGroup: UINT;           // number of adapters in this adapter group (only if master)
    DeclTypes: DWORD;                        // Data types, supported in vertex declarations
    NumSimultaneousRTs: DWORD;               // Will be at least 1
    StretchRectFilterCaps: DWORD;            // Filter caps supported by StretchRect
    VS20Caps: D3DVSHADERCAPS2_0;
    PS20Caps: D3DPSHADERCAPS2_0;
    VertexTextureFilterCaps: DWORD;          // D3DPTFILTERCAPS for IDirect3DTexture9's for texture, used in vertex shaders
    MaxVShaderInstructionsExecuted: DWORD;   // maximum number of vertex shader instructions that can be executed
    MaxPShaderInstructionsExecuted: DWORD;   // maximum number of pixel shader instructions that can be executed
    MaxVertexShader30InstructionSlots: DWORD;
    MaxPixelShader30InstructionSlots: DWORD;
  end;
  {$EXTERNALSYM _D3DCAPS9}
  D3DCAPS9 = _D3DCAPS9;
  {$EXTERNALSYM D3DCAPS9}


  //
  // BIT DEFINES FOR D3DCAPS9 DWORD MEMBERS
  //

const
  //
  // Caps
  //
  D3DCAPS_OVERLAY                     = $00000800;
  {$EXTERNALSYM D3DCAPS_OVERLAY}
  D3DCAPS_READ_SCANLINE               = $00020000;
  {$EXTERNALSYM D3DCAPS_READ_SCANLINE}

  //
  // Caps2
  //
  D3DCAPS2_FULLSCREENGAMMA            = $00020000;
  {$EXTERNALSYM D3DCAPS2_FULLSCREENGAMMA}
  D3DCAPS2_CANCALIBRATEGAMMA          = $00100000;
  {$EXTERNALSYM D3DCAPS2_CANCALIBRATEGAMMA}
  D3DCAPS2_RESERVED                   = $02000000;
  {$EXTERNALSYM D3DCAPS2_RESERVED}
  D3DCAPS2_CANMANAGERESOURCE          = $10000000;
  {$EXTERNALSYM D3DCAPS2_CANMANAGERESOURCE}
  D3DCAPS2_DYNAMICTEXTURES            = $20000000;
  {$EXTERNALSYM D3DCAPS2_DYNAMICTEXTURES}
  D3DCAPS2_CANAUTOGENMIPMAP           = $40000000;
  {$EXTERNALSYM D3DCAPS2_CANAUTOGENMIPMAP}

  //* D3D9Ex only -- */
  //{$IFDEF D3D_DISABLE_9EX}
  D3DCAPS2_CANSHARERESOURCE           = $80000000;
  {$EXTERNALSYM D3DCAPS2_CANSHARERESOURCE}
  //{$ENDIF} // !D3D_DISABLE_9EX
  //* -- D3D9Ex only */

  //
  // Caps3
  //
  D3DCAPS3_RESERVED                   = $8000001F;
  {$EXTERNALSYM D3DCAPS3_RESERVED}

  // Indicates that the device can respect the ALPHABLENDENABLE render state
  // when fullscreen while using the FLIP or DISCARD swap effect.
  // COPY and COPYVSYNC swap effects work whether or not this flag is set.
  D3DCAPS3_ALPHA_FULLSCREEN_FLIP_OR_DISCARD= $00000020;
  {$EXTERNALSYM D3DCAPS3_ALPHA_FULLSCREEN_FLIP_OR_DISCARD}

  // Indicates that the device can perform a gamma correction from
  // a windowed back buffer containing linear content to the sRGB desktop.
  D3DCAPS3_LINEAR_TO_SRGB_PRESENTATION= $00000080;
  {$EXTERNALSYM D3DCAPS3_LINEAR_TO_SRGB_PRESENTATION}

  D3DCAPS3_COPY_TO_VIDMEM             = $00000100;  { Device can acclerate copies from sysmem to local vidmem }
  {$EXTERNALSYM D3DCAPS3_COPY_TO_VIDMEM}
  D3DCAPS3_COPY_TO_SYSTEMMEM          = $00000200;  { Device can acclerate copies from local vidmem to sysmem }
  {$EXTERNALSYM D3DCAPS3_COPY_TO_SYSTEMMEM}
  D3DCAPS3_DXVAHD                     = $00000400;
  {$EXTERNALSYM D3DCAPS3_DXVAHD}
  D3DCAPS3_DXVAHD_LIMITED             = $00000800;
  {$EXTERNALSYM D3DCAPS3_DXVAHD_LIMITED}


  //
  // PresentationIntervals
  //
  D3DPRESENT_INTERVAL_DEFAULT         = $00000000;
  {$EXTERNALSYM D3DPRESENT_INTERVAL_DEFAULT}
  D3DPRESENT_INTERVAL_ONE             = $00000001;
  {$EXTERNALSYM D3DPRESENT_INTERVAL_ONE}
  D3DPRESENT_INTERVAL_TWO             = $00000002;
  {$EXTERNALSYM D3DPRESENT_INTERVAL_TWO}
  D3DPRESENT_INTERVAL_THREE           = $00000004;
  {$EXTERNALSYM D3DPRESENT_INTERVAL_THREE}
  D3DPRESENT_INTERVAL_FOUR            = $00000008;
  {$EXTERNALSYM D3DPRESENT_INTERVAL_FOUR}
  D3DPRESENT_INTERVAL_IMMEDIATE       = $80000000;
  {$EXTERNALSYM D3DPRESENT_INTERVAL_IMMEDIATE}

  //
  // CursorCaps
  //
  // Driver supports HW color cursor in at least hi-res modes(height >=400)
  D3DCURSORCAPS_COLOR                 = $00000001;
  {$EXTERNALSYM D3DCURSORCAPS_COLOR}
  // Driver supports HW cursor also in low-res modes(height < 400)
  D3DCURSORCAPS_LOWRES                = $00000002;
  {$EXTERNALSYM D3DCURSORCAPS_LOWRES}

  //
  // DevCaps
  //
  D3DDEVCAPS_EXECUTESYSTEMMEMORY      = $00000010;  { Device can use execute buffers from system memory }
  {$EXTERNALSYM D3DDEVCAPS_EXECUTESYSTEMMEMORY}
  D3DDEVCAPS_EXECUTEVIDEOMEMORY       = $00000020;  { Device can use execute buffers from video memory }
  {$EXTERNALSYM D3DDEVCAPS_EXECUTEVIDEOMEMORY}
  D3DDEVCAPS_TLVERTEXSYSTEMMEMORY     = $00000040;  { Device can use TL buffers from system memory }
  {$EXTERNALSYM D3DDEVCAPS_TLVERTEXSYSTEMMEMORY}
  D3DDEVCAPS_TLVERTEXVIDEOMEMORY      = $00000080;  { Device can use TL buffers from video memory }
  {$EXTERNALSYM D3DDEVCAPS_TLVERTEXVIDEOMEMORY}
  D3DDEVCAPS_TEXTURESYSTEMMEMORY      = $00000100;  { Device can texture from system memory }
  {$EXTERNALSYM D3DDEVCAPS_TEXTURESYSTEMMEMORY}
  D3DDEVCAPS_TEXTUREVIDEOMEMORY       = $00000200;  { Device can texture from device memory }
  {$EXTERNALSYM D3DDEVCAPS_TEXTUREVIDEOMEMORY}
  D3DDEVCAPS_DRAWPRIMTLVERTEX         = $00000400;  { Device can draw TLVERTEX primitives }
  {$EXTERNALSYM D3DDEVCAPS_DRAWPRIMTLVERTEX}
  D3DDEVCAPS_CANRENDERAFTERFLIP       = $00000800;  { Device can render without waiting for flip to complete }
  {$EXTERNALSYM D3DDEVCAPS_CANRENDERAFTERFLIP}
  D3DDEVCAPS_TEXTURENONLOCALVIDMEM    = $00001000;  { Device can texture from nonlocal video memory }
  {$EXTERNALSYM D3DDEVCAPS_TEXTURENONLOCALVIDMEM}
  D3DDEVCAPS_DRAWPRIMITIVES2          = $00002000;  { Device can support DrawPrimitives2 }
  {$EXTERNALSYM D3DDEVCAPS_DRAWPRIMITIVES2}
  D3DDEVCAPS_SEPARATETEXTUREMEMORIES  = $00004000;  { Device is texturing from separate memory pools }
  {$EXTERNALSYM D3DDEVCAPS_SEPARATETEXTUREMEMORIES}
  D3DDEVCAPS_DRAWPRIMITIVES2EX        = $00008000;  { Device can support Extended DrawPrimitives2 i.e. DX7 compliant driver}
  {$EXTERNALSYM D3DDEVCAPS_DRAWPRIMITIVES2EX}
  D3DDEVCAPS_HWTRANSFORMANDLIGHT      = $00010000;  { Device can support transformation and lighting in hardware and DRAWPRIMITIVES2EX must be also }
  {$EXTERNALSYM D3DDEVCAPS_HWTRANSFORMANDLIGHT}
  D3DDEVCAPS_CANBLTSYSTONONLOCAL      = $00020000;  { Device supports a Tex Blt from system memory to non-local vidmem }
  {$EXTERNALSYM D3DDEVCAPS_CANBLTSYSTONONLOCAL}
  D3DDEVCAPS_HWRASTERIZATION          = $00080000;  { Device has HW acceleration for rasterization }
  {$EXTERNALSYM D3DDEVCAPS_HWRASTERIZATION}
  D3DDEVCAPS_PUREDEVICE               = $00100000;  { Device supports D3DCREATE_PUREDEVICE }
  {$EXTERNALSYM D3DDEVCAPS_PUREDEVICE}
  D3DDEVCAPS_QUINTICRTPATCHES         = $00200000;  { Device supports quintic Beziers and BSplines }
  {$EXTERNALSYM D3DDEVCAPS_QUINTICRTPATCHES}
  D3DDEVCAPS_RTPATCHES                = $00400000;  { Device supports Rect and Tri patches }
  {$EXTERNALSYM D3DDEVCAPS_RTPATCHES}
  D3DDEVCAPS_RTPATCHHANDLEZERO        = $00800000;  { Indicates that RT Patches may be drawn efficiently using handle 0 }
  {$EXTERNALSYM D3DDEVCAPS_RTPATCHHANDLEZERO}
  D3DDEVCAPS_NPATCHES                 = $01000000;  { Device supports N-Patches }
  {$EXTERNALSYM D3DDEVCAPS_NPATCHES}

  //
  // PrimitiveMiscCaps
  //
  D3DPMISCCAPS_MASKZ                  = $00000002;
  {$EXTERNALSYM D3DPMISCCAPS_MASKZ}
  D3DPMISCCAPS_CULLNONE               = $00000010;
  {$EXTERNALSYM D3DPMISCCAPS_CULLNONE}
  D3DPMISCCAPS_CULLCW                 = $00000020;
  {$EXTERNALSYM D3DPMISCCAPS_CULLCW}
  D3DPMISCCAPS_CULLCCW                = $00000040;
  {$EXTERNALSYM D3DPMISCCAPS_CULLCCW}
  D3DPMISCCAPS_COLORWRITEENABLE       = $00000080;
  {$EXTERNALSYM D3DPMISCCAPS_COLORWRITEENABLE}
  D3DPMISCCAPS_CLIPPLANESCALEDPOINTS  = $00000100;  { Device correctly clips scaled points to clip planes }
  {$EXTERNALSYM D3DPMISCCAPS_CLIPPLANESCALEDPOINTS}
  D3DPMISCCAPS_CLIPTLVERTS            = $00000200;  { device will clip post-transformed vertex primitives }
  {$EXTERNALSYM D3DPMISCCAPS_CLIPTLVERTS}
  D3DPMISCCAPS_TSSARGTEMP             = $00000400;  { device supports D3DTA_TEMP for temporary register }
  {$EXTERNALSYM D3DPMISCCAPS_TSSARGTEMP}
  D3DPMISCCAPS_BLENDOP                = $00000800;  { device supports D3DRS_BLENDOP }
  {$EXTERNALSYM D3DPMISCCAPS_BLENDOP}
  D3DPMISCCAPS_NULLREFERENCE          = $00001000;  { Reference Device that doesnt render }
  {$EXTERNALSYM D3DPMISCCAPS_NULLREFERENCE}
  D3DPMISCCAPS_INDEPENDENTWRITEMASKS  = $00004000;  { Device supports independent write masks for MET or MRT }
  {$EXTERNALSYM D3DPMISCCAPS_INDEPENDENTWRITEMASKS}
  D3DPMISCCAPS_PERSTAGECONSTANT       = $00008000;  { Device supports per-stage constants }
  {$EXTERNALSYM D3DPMISCCAPS_PERSTAGECONSTANT}

  D3DPMISCCAPS_FOGANDSPECULARALPHA    = $00010000;  { Device supports separate fog and specular alpha (many devices
                                                      use the specular alpha channel to store fog factor) }
  {$EXTERNALSYM D3DPMISCCAPS_FOGANDSPECULARALPHA}


  D3DPMISCCAPS_SEPARATEALPHABLEND     = $00020000;  { Device supports separate blend settings for the alpha channel }
  {$EXTERNALSYM D3DPMISCCAPS_SEPARATEALPHABLEND}
  D3DPMISCCAPS_MRTINDEPENDENTBITDEPTHS = $00040000;  { Device supports different bit depths for MRT }
  {$EXTERNALSYM D3DPMISCCAPS_MRTINDEPENDENTBITDEPTHS}
  D3DPMISCCAPS_MRTPOSTPIXELSHADERBLENDING = $00080000;  { Device supports post-pixel shader operations for MRT }
  {$EXTERNALSYM D3DPMISCCAPS_MRTPOSTPIXELSHADERBLENDING}
  D3DPMISCCAPS_FOGVERTEXCLAMPED       = $00100000;  { Device clamps fog blend factor per vertex }
  {$EXTERNALSYM D3DPMISCCAPS_FOGVERTEXCLAMPED}

  //* D3D9Ex only -- */
  //{$IFDEF D3D_DISABLE_9EX}
  D3DPMISCCAPS_POSTBLENDSRGBCONVERT   = $00200000;  { Indicates device can perform conversion to sRGB after blending. }
  {$EXTERNALSYM D3DPMISCCAPS_POSTBLENDSRGBCONVERT}
  //{$ENDIF} // !D3D_DISABLE_9EX
  //* -- D3D9Ex only */


  //
  // LineCaps
  //
  D3DLINECAPS_TEXTURE                 = $00000001;
  {$EXTERNALSYM D3DLINECAPS_TEXTURE}
  D3DLINECAPS_ZTEST                   = $00000002;
  {$EXTERNALSYM D3DLINECAPS_ZTEST}
  D3DLINECAPS_BLEND                   = $00000004;
  {$EXTERNALSYM D3DLINECAPS_BLEND}
  D3DLINECAPS_ALPHACMP                = $00000008;
  {$EXTERNALSYM D3DLINECAPS_ALPHACMP}
  D3DLINECAPS_FOG                     = $00000010;
  {$EXTERNALSYM D3DLINECAPS_FOG}
  D3DLINECAPS_ANTIALIAS               = $00000020;
  {$EXTERNALSYM D3DLINECAPS_ANTIALIAS}

  //
  // RasterCaps
  //
  D3DPRASTERCAPS_DITHER               = $00000001;
  {$EXTERNALSYM D3DPRASTERCAPS_DITHER}
  D3DPRASTERCAPS_ZTEST                = $00000010;
  {$EXTERNALSYM D3DPRASTERCAPS_ZTEST}
  D3DPRASTERCAPS_FOGVERTEX            = $00000080;
  {$EXTERNALSYM D3DPRASTERCAPS_FOGVERTEX}
  D3DPRASTERCAPS_FOGTABLE             = $00000100;
  {$EXTERNALSYM D3DPRASTERCAPS_FOGTABLE}
  D3DPRASTERCAPS_MIPMAPLODBIAS        = $00002000;
  {$EXTERNALSYM D3DPRASTERCAPS_MIPMAPLODBIAS}
  D3DPRASTERCAPS_ZBUFFERLESSHSR       = $00008000;
  {$EXTERNALSYM D3DPRASTERCAPS_ZBUFFERLESSHSR}
  D3DPRASTERCAPS_FOGRANGE             = $00010000;
  {$EXTERNALSYM D3DPRASTERCAPS_FOGRANGE}
  D3DPRASTERCAPS_ANISOTROPY           = $00020000;
  {$EXTERNALSYM D3DPRASTERCAPS_ANISOTROPY}
  D3DPRASTERCAPS_WBUFFER              = $00040000;
  {$EXTERNALSYM D3DPRASTERCAPS_WBUFFER}
  D3DPRASTERCAPS_WFOG                 = $00100000;
  {$EXTERNALSYM D3DPRASTERCAPS_WFOG}
  D3DPRASTERCAPS_ZFOG                 = $00200000;
  {$EXTERNALSYM D3DPRASTERCAPS_ZFOG}
  D3DPRASTERCAPS_COLORPERSPECTIVE     = $00400000;  { Device iterates colors perspective correct }
  {$EXTERNALSYM D3DPRASTERCAPS_COLORPERSPECTIVE}
  D3DPRASTERCAPS_SCISSORTEST          = $01000000;
  {$EXTERNALSYM D3DPRASTERCAPS_SCISSORTEST}
  D3DPRASTERCAPS_SLOPESCALEDEPTHBIAS  = $02000000;
  {$EXTERNALSYM D3DPRASTERCAPS_SLOPESCALEDEPTHBIAS}
  D3DPRASTERCAPS_DEPTHBIAS            = $04000000;
  {$EXTERNALSYM D3DPRASTERCAPS_DEPTHBIAS}
  D3DPRASTERCAPS_MULTISAMPLE_TOGGLE   = $08000000;
  {$EXTERNALSYM D3DPRASTERCAPS_MULTISAMPLE_TOGGLE}

  //
  // ZCmpCaps, AlphaCmpCaps
  //
  D3DPCMPCAPS_NEVER                   = $00000001;
  {$EXTERNALSYM D3DPCMPCAPS_NEVER}
  D3DPCMPCAPS_LESS                    = $00000002;
  {$EXTERNALSYM D3DPCMPCAPS_LESS}
  D3DPCMPCAPS_EQUAL                   = $00000004;
  {$EXTERNALSYM D3DPCMPCAPS_EQUAL}
  D3DPCMPCAPS_LESSEQUAL               = $00000008;
  {$EXTERNALSYM D3DPCMPCAPS_LESSEQUAL}
  D3DPCMPCAPS_GREATER                 = $00000010;
  {$EXTERNALSYM D3DPCMPCAPS_GREATER}
  D3DPCMPCAPS_NOTEQUAL                = $00000020;
  {$EXTERNALSYM D3DPCMPCAPS_NOTEQUAL}
  D3DPCMPCAPS_GREATEREQUAL            = $00000040;
  {$EXTERNALSYM D3DPCMPCAPS_GREATEREQUAL}
  D3DPCMPCAPS_ALWAYS                  = $00000080;
  {$EXTERNALSYM D3DPCMPCAPS_ALWAYS}

  //
  // SourceBlendCaps, DestBlendCaps
  //
  D3DPBLENDCAPS_ZERO                  = $00000001;
  {$EXTERNALSYM D3DPBLENDCAPS_ZERO}
  D3DPBLENDCAPS_ONE                   = $00000002;
  {$EXTERNALSYM D3DPBLENDCAPS_ONE}
  D3DPBLENDCAPS_SRCCOLOR              = $00000004;
  {$EXTERNALSYM D3DPBLENDCAPS_SRCCOLOR}
  D3DPBLENDCAPS_INVSRCCOLOR           = $00000008;
  {$EXTERNALSYM D3DPBLENDCAPS_INVSRCCOLOR}
  D3DPBLENDCAPS_SRCALPHA              = $00000010;
  {$EXTERNALSYM D3DPBLENDCAPS_SRCALPHA}
  D3DPBLENDCAPS_INVSRCALPHA           = $00000020;
  {$EXTERNALSYM D3DPBLENDCAPS_INVSRCALPHA}
  D3DPBLENDCAPS_DESTALPHA             = $00000040;
  {$EXTERNALSYM D3DPBLENDCAPS_DESTALPHA}
  D3DPBLENDCAPS_INVDESTALPHA          = $00000080;
  {$EXTERNALSYM D3DPBLENDCAPS_INVDESTALPHA}
  D3DPBLENDCAPS_DESTCOLOR             = $00000100;
  {$EXTERNALSYM D3DPBLENDCAPS_DESTCOLOR}
  D3DPBLENDCAPS_INVDESTCOLOR          = $00000200;
  {$EXTERNALSYM D3DPBLENDCAPS_INVDESTCOLOR}
  D3DPBLENDCAPS_SRCALPHASAT           = $00000400;
  {$EXTERNALSYM D3DPBLENDCAPS_SRCALPHASAT}
  D3DPBLENDCAPS_BOTHSRCALPHA          = $00000800;
  {$EXTERNALSYM D3DPBLENDCAPS_BOTHSRCALPHA}
  D3DPBLENDCAPS_BOTHINVSRCALPHA       = $00001000;
  {$EXTERNALSYM D3DPBLENDCAPS_BOTHINVSRCALPHA}
  D3DPBLENDCAPS_BLENDFACTOR           = $00002000;  { Supports both D3DBLEND_BLENDFACTOR and D3DBLEND_INVBLENDFACTOR }
  {$EXTERNALSYM D3DPBLENDCAPS_BLENDFACTOR}

  //* D3D9Ex only -- */
  //{$IFDEF D3D_DISABLE_9EX}
  D3DPBLENDCAPS_SRCCOLOR2             = $00004000;
  {$EXTERNALSYM D3DPBLENDCAPS_SRCCOLOR2}
  D3DPBLENDCAPS_INVSRCCOLOR2          = $00008000;
  {$EXTERNALSYM D3DPBLENDCAPS_INVSRCCOLOR2}
  //{$ENDIF} // !D3D_DISABLE_9EX
  //* -- D3D9Ex only */


  //
  // ShadeCaps
  //
  D3DPSHADECAPS_COLORGOURAUDRGB       = $00000008;
  {$EXTERNALSYM D3DPSHADECAPS_COLORGOURAUDRGB}
  D3DPSHADECAPS_SPECULARGOURAUDRGB    = $00000200;
  {$EXTERNALSYM D3DPSHADECAPS_SPECULARGOURAUDRGB}
  D3DPSHADECAPS_ALPHAGOURAUDBLEND     = $00004000;
  {$EXTERNALSYM D3DPSHADECAPS_ALPHAGOURAUDBLEND}
  D3DPSHADECAPS_FOGGOURAUD            = $00080000;
  {$EXTERNALSYM D3DPSHADECAPS_FOGGOURAUD}

  //
  // TextureCaps
  //
  D3DPTEXTURECAPS_PERSPECTIVE         = $00000001;  { Perspective-correct texturing is supported }
  {$EXTERNALSYM D3DPTEXTURECAPS_PERSPECTIVE}
  D3DPTEXTURECAPS_POW2                = $00000002;  { Power-of-2 texture dimensions are required - applies to non-Cube/Volume textures only. }
  {$EXTERNALSYM D3DPTEXTURECAPS_POW2}
  D3DPTEXTURECAPS_ALPHA               = $00000004;  { Alpha in texture pixels is supported }
  {$EXTERNALSYM D3DPTEXTURECAPS_ALPHA}
  D3DPTEXTURECAPS_SQUAREONLY          = $00000020;  { Only square textures are supported }
  {$EXTERNALSYM D3DPTEXTURECAPS_SQUAREONLY}
  D3DPTEXTURECAPS_TEXREPEATNOTSCALEDBYSIZE= $00000040;  { Texture indices are not scaled by the texture size prior to interpolation }
  {$EXTERNALSYM D3DPTEXTURECAPS_TEXREPEATNOTSCALEDBYSIZE}
  D3DPTEXTURECAPS_ALPHAPALETTE        = $00000080;  { Device can draw alpha from texture palettes }
  {$EXTERNALSYM D3DPTEXTURECAPS_ALPHAPALETTE}
// Device can use non-POW2 textures if:
//  1) D3DTEXTURE_ADDRESS is set to CLAMP for this texture's stage
//  2) D3DRS_WRAP(N) is zero for this texture's coordinates
//  3) mip mapping is not enabled (use magnification filter only)
  D3DPTEXTURECAPS_NONPOW2CONDITIONAL  = $00000100;
  {$EXTERNALSYM D3DPTEXTURECAPS_NONPOW2CONDITIONAL}
  D3DPTEXTURECAPS_PROJECTED           = $00000400;  { Device can do D3DTTFF_PROJECTED }
  {$EXTERNALSYM D3DPTEXTURECAPS_PROJECTED}
  D3DPTEXTURECAPS_CUBEMAP             = $00000800;  { Device can do cubemap textures }
  {$EXTERNALSYM D3DPTEXTURECAPS_CUBEMAP}
  D3DPTEXTURECAPS_VOLUMEMAP           = $00002000;  { Device can do volume textures }
  {$EXTERNALSYM D3DPTEXTURECAPS_VOLUMEMAP}
  D3DPTEXTURECAPS_MIPMAP              = $00004000;  { Device can do mipmapped textures }
  {$EXTERNALSYM D3DPTEXTURECAPS_MIPMAP}
  D3DPTEXTURECAPS_MIPVOLUMEMAP        = $00008000;  { Device can do mipmapped volume textures }
  {$EXTERNALSYM D3DPTEXTURECAPS_MIPVOLUMEMAP}
  D3DPTEXTURECAPS_MIPCUBEMAP          = $00010000;  { Device can do mipmapped cube maps }
  {$EXTERNALSYM D3DPTEXTURECAPS_MIPCUBEMAP}
  D3DPTEXTURECAPS_CUBEMAP_POW2        = $00020000;  { Device requires that cubemaps be power-of-2 dimension }
  {$EXTERNALSYM D3DPTEXTURECAPS_CUBEMAP_POW2}
  D3DPTEXTURECAPS_VOLUMEMAP_POW2      = $00040000;  { Device requires that volume maps be power-of-2 dimension }
  {$EXTERNALSYM D3DPTEXTURECAPS_VOLUMEMAP_POW2}
  D3DPTEXTURECAPS_NOPROJECTEDBUMPENV  = $00200000;  { Device does not support projected bump env lookup operation
                                                      in programmable and fixed function pixel shaders }
  {$EXTERNALSYM D3DPTEXTURECAPS_NOPROJECTEDBUMPENV}


  //
  // TextureFilterCaps, StretchRectFilterCaps
  //
  D3DPTFILTERCAPS_MINFPOINT           = $00000100;  { Min Filter }
  {$EXTERNALSYM D3DPTFILTERCAPS_MINFPOINT}
  D3DPTFILTERCAPS_MINFLINEAR          = $00000200;
  {$EXTERNALSYM D3DPTFILTERCAPS_MINFLINEAR}
  D3DPTFILTERCAPS_MINFANISOTROPIC     = $00000400;
  {$EXTERNALSYM D3DPTFILTERCAPS_MINFANISOTROPIC}
  D3DPTFILTERCAPS_MINFPYRAMIDALQUAD   = $00000800;
  {$EXTERNALSYM D3DPTFILTERCAPS_MINFPYRAMIDALQUAD}
  D3DPTFILTERCAPS_MINFGAUSSIANQUAD    = $00001000;
  {$EXTERNALSYM D3DPTFILTERCAPS_MINFGAUSSIANQUAD}
  D3DPTFILTERCAPS_MIPFPOINT           = $00010000;  { Mip Filter }
  {$EXTERNALSYM D3DPTFILTERCAPS_MIPFPOINT}
  D3DPTFILTERCAPS_MIPFLINEAR          = $00020000;
  {$EXTERNALSYM D3DPTFILTERCAPS_MIPFLINEAR}

  //* D3D9Ex only -- */
  //{$IFDEF D3D_DISABLE_9EX}
  D3DPTFILTERCAPS_CONVOLUTIONMONO     = $00040000;  { Min and Mag for the convolution mono filter }
  {$EXTERNALSYM D3DPTFILTERCAPS_CONVOLUTIONMONO}
  //{$ENDIF} // !D3D_DISABLE_9EX
  //* -- D3D9Ex only */

  D3DPTFILTERCAPS_MAGFPOINT           = $01000000;  { Mag Filter }
  {$EXTERNALSYM D3DPTFILTERCAPS_MAGFPOINT}
  D3DPTFILTERCAPS_MAGFLINEAR          = $02000000;
  {$EXTERNALSYM D3DPTFILTERCAPS_MAGFLINEAR}
  D3DPTFILTERCAPS_MAGFANISOTROPIC     = $04000000;
  {$EXTERNALSYM D3DPTFILTERCAPS_MAGFANISOTROPIC}
  D3DPTFILTERCAPS_MAGFPYRAMIDALQUAD   = $08000000;
  {$EXTERNALSYM D3DPTFILTERCAPS_MAGFPYRAMIDALQUAD}
  D3DPTFILTERCAPS_MAGFGAUSSIANQUAD    = $10000000;
  {$EXTERNALSYM D3DPTFILTERCAPS_MAGFGAUSSIANQUAD}

  //
  // TextureAddressCaps
  //
  D3DPTADDRESSCAPS_WRAP               = $00000001;
  {$EXTERNALSYM D3DPTADDRESSCAPS_WRAP}
  D3DPTADDRESSCAPS_MIRROR             = $00000002;
  {$EXTERNALSYM D3DPTADDRESSCAPS_MIRROR}
  D3DPTADDRESSCAPS_CLAMP              = $00000004;
  {$EXTERNALSYM D3DPTADDRESSCAPS_CLAMP}
  D3DPTADDRESSCAPS_BORDER             = $00000008;
  {$EXTERNALSYM D3DPTADDRESSCAPS_BORDER}
  D3DPTADDRESSCAPS_INDEPENDENTUV      = $00000010;
  {$EXTERNALSYM D3DPTADDRESSCAPS_INDEPENDENTUV}
  D3DPTADDRESSCAPS_MIRRORONCE         = $00000020;
  {$EXTERNALSYM D3DPTADDRESSCAPS_MIRRORONCE}

  //
  // StencilCaps
  //
  D3DSTENCILCAPS_KEEP                 = $00000001;
  {$EXTERNALSYM D3DSTENCILCAPS_KEEP}
  D3DSTENCILCAPS_ZERO                 = $00000002;
  {$EXTERNALSYM D3DSTENCILCAPS_ZERO}
  D3DSTENCILCAPS_REPLACE              = $00000004;
  {$EXTERNALSYM D3DSTENCILCAPS_REPLACE}
  D3DSTENCILCAPS_INCRSAT              = $00000008;
  {$EXTERNALSYM D3DSTENCILCAPS_INCRSAT}
  D3DSTENCILCAPS_DECRSAT              = $00000010;
  {$EXTERNALSYM D3DSTENCILCAPS_DECRSAT}
  D3DSTENCILCAPS_INVERT               = $00000020;
  {$EXTERNALSYM D3DSTENCILCAPS_INVERT}
  D3DSTENCILCAPS_INCR                 = $00000040;
  {$EXTERNALSYM D3DSTENCILCAPS_INCR}
  D3DSTENCILCAPS_DECR                 = $00000080;
  {$EXTERNALSYM D3DSTENCILCAPS_DECR}
  D3DSTENCILCAPS_TWOSIDED             = $00000100;
  {$EXTERNALSYM D3DSTENCILCAPS_TWOSIDED}

  //
  // TextureOpCaps
  //
  D3DTEXOPCAPS_DISABLE                = $00000001;
  {$EXTERNALSYM D3DTEXOPCAPS_DISABLE}
  D3DTEXOPCAPS_SELECTARG1             = $00000002;
  {$EXTERNALSYM D3DTEXOPCAPS_SELECTARG1}
  D3DTEXOPCAPS_SELECTARG2             = $00000004;
  {$EXTERNALSYM D3DTEXOPCAPS_SELECTARG2}
  D3DTEXOPCAPS_MODULATE               = $00000008;
  {$EXTERNALSYM D3DTEXOPCAPS_MODULATE}
  D3DTEXOPCAPS_MODULATE2X             = $00000010;
  {$EXTERNALSYM D3DTEXOPCAPS_MODULATE2X}
  D3DTEXOPCAPS_MODULATE4X             = $00000020;
  {$EXTERNALSYM D3DTEXOPCAPS_MODULATE4X}
  D3DTEXOPCAPS_ADD                    = $00000040;
  {$EXTERNALSYM D3DTEXOPCAPS_ADD}
  D3DTEXOPCAPS_ADDSIGNED              = $00000080;
  {$EXTERNALSYM D3DTEXOPCAPS_ADDSIGNED}
  D3DTEXOPCAPS_ADDSIGNED2X            = $00000100;
  {$EXTERNALSYM D3DTEXOPCAPS_ADDSIGNED2X}
  D3DTEXOPCAPS_SUBTRACT               = $00000200;
  {$EXTERNALSYM D3DTEXOPCAPS_SUBTRACT}
  D3DTEXOPCAPS_ADDSMOOTH              = $00000400;
  {$EXTERNALSYM D3DTEXOPCAPS_ADDSMOOTH}
  D3DTEXOPCAPS_BLENDDIFFUSEALPHA      = $00000800;
  {$EXTERNALSYM D3DTEXOPCAPS_BLENDDIFFUSEALPHA}
  D3DTEXOPCAPS_BLENDTEXTUREALPHA      = $00001000;
  {$EXTERNALSYM D3DTEXOPCAPS_BLENDTEXTUREALPHA}
  D3DTEXOPCAPS_BLENDFACTORALPHA       = $00002000;
  {$EXTERNALSYM D3DTEXOPCAPS_BLENDFACTORALPHA}
  D3DTEXOPCAPS_BLENDTEXTUREALPHAPM    = $00004000;
  {$EXTERNALSYM D3DTEXOPCAPS_BLENDTEXTUREALPHAPM}
  D3DTEXOPCAPS_BLENDCURRENTALPHA      = $00008000;
  {$EXTERNALSYM D3DTEXOPCAPS_BLENDCURRENTALPHA}
  D3DTEXOPCAPS_PREMODULATE            = $00010000;
  {$EXTERNALSYM D3DTEXOPCAPS_PREMODULATE}
  D3DTEXOPCAPS_MODULATEALPHA_ADDCOLOR = $00020000;
  {$EXTERNALSYM D3DTEXOPCAPS_MODULATEALPHA_ADDCOLOR}
  D3DTEXOPCAPS_MODULATECOLOR_ADDALPHA = $00040000;
  {$EXTERNALSYM D3DTEXOPCAPS_MODULATECOLOR_ADDALPHA}
  D3DTEXOPCAPS_MODULATEINVALPHA_ADDCOLOR= $00080000;
  {$EXTERNALSYM D3DTEXOPCAPS_MODULATEINVALPHA_ADDCOLOR}
  D3DTEXOPCAPS_MODULATEINVCOLOR_ADDALPHA= $00100000;
  {$EXTERNALSYM D3DTEXOPCAPS_MODULATEINVCOLOR_ADDALPHA}
  D3DTEXOPCAPS_BUMPENVMAP             = $00200000;
  {$EXTERNALSYM D3DTEXOPCAPS_BUMPENVMAP}
  D3DTEXOPCAPS_BUMPENVMAPLUMINANCE    = $00400000;
  {$EXTERNALSYM D3DTEXOPCAPS_BUMPENVMAPLUMINANCE}
  D3DTEXOPCAPS_DOTPRODUCT3            = $00800000;
  {$EXTERNALSYM D3DTEXOPCAPS_DOTPRODUCT3}
  D3DTEXOPCAPS_MULTIPLYADD            = $01000000;
  {$EXTERNALSYM D3DTEXOPCAPS_MULTIPLYADD}
  D3DTEXOPCAPS_LERP                   = $02000000;
  {$EXTERNALSYM D3DTEXOPCAPS_LERP}

  //
  // FVFCaps
  //
  D3DFVFCAPS_TEXCOORDCOUNTMASK        = $0000FFFF;  { mask for texture coordinate count field }
  {$EXTERNALSYM D3DFVFCAPS_TEXCOORDCOUNTMASK}
  D3DFVFCAPS_DONOTSTRIPELEMENTS       = $00080000;  { Device prefers that vertex elements not be stripped }
  {$EXTERNALSYM D3DFVFCAPS_DONOTSTRIPELEMENTS}
  D3DFVFCAPS_PSIZE                    = $00100000;  { Device can receive point size }
  {$EXTERNALSYM D3DFVFCAPS_PSIZE}

  //
  // VertexProcessingCaps
  //
  D3DVTXPCAPS_TEXGEN                  = $00000001;  { device can do texgen }
  {$EXTERNALSYM D3DVTXPCAPS_TEXGEN}
  D3DVTXPCAPS_MATERIALSOURCE7         = $00000002;  { device can do DX7-level colormaterialsource ops }
  {$EXTERNALSYM D3DVTXPCAPS_MATERIALSOURCE7}
  D3DVTXPCAPS_DIRECTIONALLIGHTS       = $00000008;  { device can do directional lights }
  {$EXTERNALSYM D3DVTXPCAPS_DIRECTIONALLIGHTS}
  D3DVTXPCAPS_POSITIONALLIGHTS        = $00000010;  { device can do positional lights (includes point and spot) }
  {$EXTERNALSYM D3DVTXPCAPS_POSITIONALLIGHTS}
  D3DVTXPCAPS_LOCALVIEWER             = $00000020;  { device can do local viewer }
  {$EXTERNALSYM D3DVTXPCAPS_LOCALVIEWER}
  D3DVTXPCAPS_TWEENING                = $00000040;  { device can do vertex tweening }
  {$EXTERNALSYM D3DVTXPCAPS_TWEENING}
  D3DVTXPCAPS_TEXGEN_SPHEREMAP        = $00000100;  { device supports D3DTSS_TCI_SPHEREMAP }
  {$EXTERNALSYM D3DVTXPCAPS_TEXGEN_SPHEREMAP}
  D3DVTXPCAPS_NO_TEXGEN_NONLOCALVIEWER= $00000200;  { device does not support TexGen in non-local
                                                            viewer mode }
  {$EXTERNALSYM D3DVTXPCAPS_NO_TEXGEN_NONLOCALVIEWER}

  //
  // DevCaps2
  //
  D3DDEVCAPS2_STREAMOFFSET            = $00000001;  { Device supports offsets in streams. Must be set by DX9 drivers }
  {$EXTERNALSYM D3DDEVCAPS2_STREAMOFFSET}
  D3DDEVCAPS2_DMAPNPATCH              = $00000002;  { Device supports displacement maps for N-Patches}
  {$EXTERNALSYM D3DDEVCAPS2_DMAPNPATCH}
  D3DDEVCAPS2_ADAPTIVETESSRTPATCH     = $00000004;  { Device supports adaptive tesselation of RT-patches}
  {$EXTERNALSYM D3DDEVCAPS2_ADAPTIVETESSRTPATCH}
  D3DDEVCAPS2_ADAPTIVETESSNPATCH      = $00000008;  { Device supports adaptive tesselation of N-patches}
  {$EXTERNALSYM D3DDEVCAPS2_ADAPTIVETESSNPATCH}
  D3DDEVCAPS2_CAN_STRETCHRECT_FROM_TEXTURES= $00000010;  { Device supports StretchRect calls with a texture as the source}
  {$EXTERNALSYM D3DDEVCAPS2_CAN_STRETCHRECT_FROM_TEXTURES}
  D3DDEVCAPS2_PRESAMPLEDDMAPNPATCH    = $00000020;  { Device supports presampled displacement maps for N-Patches }
  {$EXTERNALSYM D3DDEVCAPS2_PRESAMPLEDDMAPNPATCH}
  D3DDEVCAPS2_VERTEXELEMENTSCANSHARESTREAMOFFSET= $00000040;  { Vertex elements in a vertex declaration can share the same stream offset }
  {$EXTERNALSYM D3DDEVCAPS2_VERTEXELEMENTSCANSHARESTREAMOFFSET}

  //
  // DeclTypes
  //
  D3DDTCAPS_UBYTE4                    = $00000001;
  {$EXTERNALSYM D3DDTCAPS_UBYTE4}
  D3DDTCAPS_UBYTE4N                   = $00000002;
  {$EXTERNALSYM D3DDTCAPS_UBYTE4N}
  D3DDTCAPS_SHORT2N                   = $00000004;
  {$EXTERNALSYM D3DDTCAPS_SHORT2N}
  D3DDTCAPS_SHORT4N                   = $00000008;
  {$EXTERNALSYM D3DDTCAPS_SHORT4N}
  D3DDTCAPS_USHORT2N                  = $00000010;
  {$EXTERNALSYM D3DDTCAPS_USHORT2N}
  D3DDTCAPS_USHORT4N                  = $00000020;
  {$EXTERNALSYM D3DDTCAPS_USHORT4N}
  D3DDTCAPS_UDEC3                     = $00000040;
  {$EXTERNALSYM D3DDTCAPS_UDEC3}
  D3DDTCAPS_DEC3N                     = $00000080;
  {$EXTERNALSYM D3DDTCAPS_DEC3N}
  D3DDTCAPS_FLOAT16_2                 = $00000100;
  {$EXTERNALSYM D3DDTCAPS_FLOAT16_2}
  D3DDTCAPS_FLOAT16_4                 = $00000200;
  {$EXTERNALSYM D3DDTCAPS_FLOAT16_4}


  // Additional Prototypes for ALL interfaces

  // End of Additional Prototypes

implementation

  // Implement Additional functions here.

end.
