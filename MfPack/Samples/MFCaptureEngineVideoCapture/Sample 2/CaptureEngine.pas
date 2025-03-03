// FactoryX
//
// Copyright: � FactoryX. All rights reserved.
//
// Project: MfPack - MediaFoundation
// Project location: https://sourceforge.net/projects/MFPack
//                   https://github.com/FactoryXCode/MfPack
// Module: CaptureEngine.pas
// Kind: Pascal Unit
// Release date: 18-11-2022
// Language: ENU
//
// Revision Version: 3.1.7
//
// Description:
//   This unit contains the captureengine.
//
// Organisation: FactoryX
// Initiator(s): Tony (maXcomX)
// Contributor(s): Ciaran, Tony (maXcomX)
//
//------------------------------------------------------------------------------
// CHANGE LOG
// Date       Person              Reason
// ---------- ------------------- ----------------------------------------------
// 30/06/2024 All                 RammStein release  SDK 10.0.26100.0 (Windows 11)
// 28/06/2024 Tony                Solved some issues when recapturing with same formats.
//------------------------------------------------------------------------------
//
// Remarks: Requires Windows 10 (2H20) or later.
//
// Related objects: -
// Related projects: MfPackX317/Samples/MFCaptureEngineVideoCapture
//
// Compiler version: 23 up to 35
// SDK version: 10.0.26100.0
//
// Todo: -
//
//==============================================================================
// Source: Parts of CaptureEngine sample (Copyright (c) Microsoft Corporation. All rights reserved.)
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
unit CaptureEngine;


interface

  // Undefine this when not needed!
  //{$DEFINE SAVE_DEBUG_REPORT}

uses
  {WinApi}
  WinApi.Windows,
  WinApi.Messages,
  WinApi.ComBaseApi,
  WinApi.WinApiTypes,
  WinApi.WinError,
  {System}
  System.Classes,
  System.Win.ComObj,
  System.SysUtils,
  System.IOUtils,
  System.Types,
  {ActiveX}
  WinApi.ActiveX.PropIdl,
  WinApi.ActiveX.PropVarUtil,
  {MediaFoundationApi}
  WinApi.MediaFoundationApi.MfApi,
  WinApi.MediaFoundationApi.MfIdl,
  WinApi.MediaFoundationApi.MfError,
  WinApi.MediaFoundationApi.MfCaptureEngine,
  WinApi.MediaFoundationApi.MfObjects,
  WinApi.MediaFoundationApi.MfReadWrite,
  WinApi.MediaFoundationApi.MfMetLib,
  WinAPI.MediaFoundationApi.MfUtils,
  {$IFDEF SAVE_DEBUG_REPORT}
  WinApi.MediaFoundationApi.MfMediaTypeDebug,
  {$ENDIF}
  {DirectX Note: Do not use winapi.d3d11 <= Delphi 10.4 bcause it lacks updates}
  Winapi.DirectX.D3DCommon,
  WinApi.DirectX.D3D11,
  {DirectShow}
  WinApi.KsMedia,
  WinApi.StrmIf,
  {Application}
  DeviceExplorer,
  Utils;

 // {$DEFINE LOGDEBUG}


const
  WM_APP_CAPTURE_EVENT = WM_APP + 1001;
  WM_RECIEVED_SAMPLE_FROM_CALLBACK = WM_APP + 1002;
  WM_APP_CAPTURE_EVENT_HANDLED = WM_APP + 1003;

  IDD_CHOOSE_DEVICE                   = 101;
  IDS_ERR_SET_DEVICE                  = 102;
  IDS_ERR_INITIALIZE                  = 103;
  IDS_ERR_PREVIEW                     = 104;
  IDS_ERR_RECORD                      = 105;
  IDS_ERR_CAPTURE                     = 106;
  IDS_ERR_PHOTO                       = 107;
  IDS_ERR_BADREQUEST                  = 108;
  IDS_ERR_CAPTURE_SINK_PREPARED       = 109;

var
  // DXGI DevManager support
  g_pDXGIMan: IMFDXGIDeviceManager;
  g_pDX11Device: ID3D11Device;
  g_ResetToken: UINT;

type

  TSnapShotOptions = (ssoFile,
                      ssoCallBack,
                      ssoStream);

  // Camera and video control values. ==========================================
  TCVPropRecord = record
    prMin: LONG;
    prMax: LONG;
    prDelta: LONG;
    prDefault: LONG;
    prflags: LONG;

    // Alternative for flags is using the flags defined in WinApi.KsMedia.pas
    // KSPROPERTY_CAMERACONTROL_FLAGS_AUTO
    // KSPROPERTY_CAMERACONTROL_FLAGS_MANUAL
    // >= Win 8
    // KSPROPERTY_CAMERACONTROL_FLAGS_ASYNCHRONOUS
    // END >= Win 8
    // KSPROPERTY_CAMERACONTROL_FLAGS_ABSOLUTE
    // KSPROPERTY_CAMERACONTROL_FLAGS_RELATIVE

    IsSupported: Boolean;
  public
    procedure Initialize();
  end;

  // Camera controls.
  TCameraProps = record
    CameraCtl_Pan: TCVPropRecord;
    CameraCtl_Tilt: TCVPropRecord;
    CameraCtl_Roll: TCVPropRecord;
    CameraCtl_Zoom: TCVPropRecord;
    CameraCtl_Exposure: TCVPropRecord;
    CameraCtl_Iris: TCVPropRecord;
    CameraCtl_Focus: TCVPropRecord;
    IsSupported: Boolean;
  public
    procedure Initialize();
  end;

  // Video controls.
  TVideoProps = record
    VideoCtl_Brightness: TCVPropRecord;
    VideoCtl_Contrast: TCVPropRecord;
    VideoCtl_Hue: TCVPropRecord;
    VideoCtl_Saturation: TCVPropRecord;
    VideoCtl_Sharpness: TCVPropRecord;
    VideoCtl_Gamma: TCVPropRecord;
    VideoCtl_ColorEnable: TCVPropRecord;
    VideoCtl_WhiteBalance: TCVPropRecord;
    VideoCtl_BacklightCompensation: TCVPropRecord;
    VideoCtl_Gain: TCVPropRecord;
    IsSupported: Boolean;
  public
    procedure Initialize();
  end;

  // Setter properties.
  TCameraPropSet = record
    cpCameraControlProperty: LONG; // CameraControlProperty.
    cpValue: LONG;
    cpFlags: LONG;
  end;

  TVideoPropSet = record
    cpVideoProcAmpProperty: LONG; // VideoProcAmpProperty.
    cpValue: LONG;
    cpFlags: LONG;
  end;
  // ===========================================================================

  CaptureEngineCB = class(TInterfacedPersistent, IMFCaptureEngineOnEventCallback)
  private
    m_hwnd: HWND;
  public
    // Implementation of IMFCaptureEngineOnEventCallback
    function OnEvent(pEvent: IMFMediaEvent): HResult; stdcall;

    constructor Create(hEvent: HWND); reintroduce;
    destructor Destroy(); override;
  end;


  CaptureEngineSCB = class(TInterfacedPersistent, IMFCaptureEngineOnSampleCallback)
  private
    m_hwnd: HWND;
  public
    // Implementation of IMFCaptureEngineOnSampleCallback
    function OnSample(pSample: IMFSample): HResult; stdcall;

    constructor Create(hEvent: HWND); reintroduce;
    destructor Destroy(); override;
  end;

  // CaptureManager class
  // Wraps the capture engine and implements the event callback and OnSampleCallback in a nested class.
type

  TCaptureManager = class(TObject)
  protected
    FhEvent: THandle;

  private
    FCaptureEngine: IMFCaptureEngine;
    FCapturePreviewSink: IMFCapturePreviewSink;
    m_pEventCallback: CaptureEngineCB;
    m_pOnSampleCallBack: CaptureEngineSCB;
    FRecordingMediaType: IMFMediaType;
    m_pSource: IMFMediaSource;  // Media Source.

    // == NOTE: These are DirectShow interfaces. ==
    dsVideoControl: IAMVideoProcAmp;
    dsCameraControl: IAMCameraControl;
    // ============================================

    {$IFDEF SAVE_DEBUG_REPORT}
      FMediaTypeDebug: TMediaTypeDebug;
    {$ENDIF}

    hwndMainForm: HWND;  // Handle of the mainform that recieves all events from the captureengine.
    hwndPreviewWindow: HWND; // Handle of the preview window or control that is needed to project snapshots.

    bPreviewing: Boolean;
    bRecording: Boolean;
    bPhotoPending: Boolean;
    bPhotoTaken: Boolean;
    bEngineIsInitialized: Boolean;
    bCaptureSinkReady: Boolean;

    FSnapShotOptions: TSnapShotOptions;
    FCritSec: TMFCritSec;

    // Camera and video properties.
    FCameraProps: TCameraProps;
    FVideoProps: TVideoProps;

    procedure DestroyCaptureEngine();

    // Capture Event Handlers
    procedure OnCaptureEngineInitialized(hrStatus: HResult);
    procedure OnPreviewStarted(hrStatus: HResult);
    procedure OnPreviewStopped(hrStatus: HResult);
    procedure OnCaptureEngineOutputMediaTypeSet(hrStatus: HResult);
    procedure OnRecordStarted(hrStatus: HResult);
    procedure OnRecordStopped(hrStatus: HResult);
    procedure OnPhotoTaken(hrStatus: HResult);
    procedure OnCaptureSinkPrepared(hrStatus: HResult);

    function SetSnapShotOption(pPhotoSink: IMFCapturePhotoSink): HResult;

    procedure WaitForResult();

  public


    constructor Create(hEvent: HWND); reintroduce;
    destructor Destroy(); override;

    function InitializeCaptureManager(const hPreviewObject: HWND;
                                      const hMainForm: HWND;
                                      Unk: IUnknown;
                                      pCleanUp: Boolean): HResult;

    function OnCaptureEvent(pWParam: WPARAM;
                            pLParam: LPARAM): Hresult;

    function UpdateVideo(pSrc: PMFVideoNormalizedRect): HResult;


    function SetVideoFormat(): HResult;
    function SetMediaType(pMediaType: IMFMediaType): HResult;
    function GetCurrentFormat(): TVideoFormatInfo;

    function StartPreview(pNewPeviewSink: Boolean): HResult;
    function StopPreview(): HResult;
    function StartRecording(pszDestinationFile: PCWSTR;
                            pSinkWriterConfigSet: Boolean): HResult;
    function StopRecording(): HResult;
    function TakePhoto(pSnapShotOption: TSnapShotOptions;
                       pMediaType: IMFMediaType): HResult;

    procedure ResetCaptureManager();

    // Get camera settings.
    function GetCameraSettings(): HRESULT;
    // Set the camera properties.
    function SetCameraProps(pProps: TCameraPropSet): HRESULT;
    // Set the video properties.
    function SetVideoProps(pProps: TVideoPropSet): HRESULT;

    property IsPreviewing: Boolean read bPreviewing;
    property IsRecording: Boolean read bRecording;
    property SnapShotOption: TSnapShotOptions read FSnapShotOptions write FSnapShotOptions;
    property PreviewHandle: HWND read hwndPreviewWindow write hwndPreviewWindow;
    property MainFormEventHandle: HWND read hwndMainForm;
    property HandlerEvent: THandle read FhEvent;
    property CameraProperties: TCameraProps read FCameraProps;
    property VideoProperties: TVideoProps read FVideoProps;
  end;

var
  FCaptureManager: TCaptureManager;
  FChooseDeviceParam: TChooseDeviceParam;

implementation

uses
  WinApi.WIC.WinCodec,
  WinApi.D3D10, // Clootie version
  WinApi.Unknwn,
  WinApi.WinMM.VfwMsgs;

// D3D11 //////////////IsPreviewing/////////////////////////////////////////////////////////

function CreateDX11Device(out ppDevice: ID3D11Device;
                          out ppDeviceContext: ID3D11DeviceContext;
                          out pFeatureLevel: D3D_FEATURE_LEVEL): HResult;
var
  hr: HResult;
  aFeatureLevels: array[0..6] of D3D_FEATURE_LEVEL;
  pMultithread: ID3D10Multithread;

//const
   // This should be in the D3D11_CREATE_DEVICE_FLAG enumeration in Delphi's WinApi.D3D11.pas
   // Not supported in Delphi version <= 10.4.
   //D3D11_CREATE_DEVICE_VIDEO_SUPPORT = $800;

begin

  aFeatureLevels[0] := D3D_FEATURE_LEVEL_11_1;
  aFeatureLevels[1] := D3D_FEATURE_LEVEL_11_0;
  aFeatureLevels[2] := D3D_FEATURE_LEVEL_10_1;
  aFeatureLevels[3] := D3D_FEATURE_LEVEL_10_0;
  aFeatureLevels[4] := D3D_FEATURE_LEVEL_9_3;
  aFeatureLevels[5] := D3D_FEATURE_LEVEL_9_2;
  aFeatureLevels[6] := D3D_FEATURE_LEVEL_9_1;

  hr := D3D11CreateDevice(nil,
                          D3D_DRIVER_TYPE_HARDWARE,
                          0,
                          D3D11_CREATE_DEVICE_VIDEO_SUPPORT,
                          @aFeatureLevels,
                          Length(aFeatureLevels),
                          D3D11_SDK_VERSION,
                          ppDevice,
                          pFeatureLevel,
                          ppDeviceContext
                         );

  if SUCCEEDED(hr) then
    begin
      hr := ppDevice.QueryInterface(IID_ID3D10Multithread,
                                    pMultithread);

      if SUCCEEDED(hr) then
        pMultithread.SetMultithreadProtected(BOOL(INT(1)));

      SafeRelease(pMultithread);
    end;

  Result := hr;
end;


//
function CreateD3DManager(): HResult;
var
  hr: HResult;
  FeatureLevel: D3D_FEATURE_LEVEL;
  pDX11DeviceContext: ID3D11DeviceContext;

begin

  hr := CreateDX11Device(g_pDX11Device,
                         pDX11DeviceContext,
                         FeatureLevel);

  if SUCCEEDED(hr) then
    hr := MFCreateDXGIDeviceManager(g_ResetToken,
                                    g_pDXGIMan);


  if SUCCEEDED(hr) then
    hr := g_pDXGIMan.ResetDevice(g_pDX11Device,
                                 g_ResetToken);

  Result := hr;
end;



// CaptureManagerCallBack routines /////////////////////////////////////////////

constructor CaptureEngineCB.Create(hEvent: HWND);
begin
  inherited Create();
  m_hwnd := hEvent;
end;


destructor CaptureEngineCB.Destroy();
begin
  m_hwnd := 0;
  inherited Destroy();
end;

// Callback method to receive events from the capture engine.
function CaptureEngineCB.OnEvent(pEvent: IMFMediaEvent): HResult;
begin

  // Send a message to the application window, so the event is handled
  // on the application's main thread.
  // The application will release the pointer when it handles the message.
  if Assigned(FCaptureManager) then
    SendMessage(FCaptureManager.hwndMainForm,
                WM_APP_CAPTURE_EVENT,
                WParam(Pointer(pEvent)),
                LPARAM(0));

  Result := S_OK;
end;


// CaptureEngineOnSampleCallback //////////////////////////////////////////////

constructor CaptureEngineSCB.Create(hEvent: HWND);
begin
  inherited Create();
  m_hwnd := hEvent;
end;


destructor CaptureEngineSCB.Destroy();
begin
  m_hwnd := 0;
  inherited Destroy();
end;


function CaptureEngineSCB.OnSample(pSample: IMFSample): HResult;
var
  hr: HResult;

begin
  hr := S_OK;

  if (pSample <> nil) then
    SendMessage(m_hwnd,
                WM_RECIEVED_SAMPLE_FROM_CALLBACK,
                WPARAM(Pointer(pSample)),
                LPARAM(0))
  else
    hr := E_POINTER;

  SafeRelease(pSample);
  Result := hr;
end;


// CaptureManager routines /////////////////////////////////////////////////////


function TCaptureManager.InitializeCaptureManager(const hPreviewObject: HWND;
                                                  const hMainForm: HWND;
                                                  Unk: IUnknown;
                                                  pCleanUp: Boolean): HResult;
var
  hr: HResult;
  mfAttributes: IMFAttributes;
  mfFactory: IMFCaptureEngineClassFactory;

label
  done;

begin

  if pCleanUp then
    DestroyCaptureEngine();

  // Note: CreateEventEx was introduced in compiler version 29.
  //       To use this function < 29,
  //       the unit WinAPI.MediaFoundationApi.MfUtils must be in the uses clause,
  //
  FhEvent := CreateEventEx(nil,
                           nil,
                           0,
                           EVENT_MODIFY_STATE or SYNCHRONIZE);
  if (FhEvent = 0) then
    begin
      hr := HRESULT_FROM_WIN32(GetLastError());
      goto done;
    end;

  m_pEventCallback := CaptureEngineCB.Create(hMainForm);
  if not Assigned(m_pEventCallback) then
    begin
        hr := E_OUTOFMEMORY;
        goto done;
    end;

  m_pOnSampleCallback := CaptureEngineSCB.Create(hMainForm);
  if not Assigned(m_pOnSampleCallback) then
    begin
      hr := E_OUTOFMEMORY;
      goto done;
    end;

  hwndPreviewWindow := hPreviewObject;

  // Create a D3D Manager
  hr := CreateD3DManager();
  if FAILED(hr) then
    goto done;

  hr := MFCreateAttributes(mfAttributes,
                           1);
  if FAILED(hr) then
    goto done;

  hr := mfAttributes.SetUnknown(MF_CAPTURE_ENGINE_D3D_MANAGER,
                                g_pDXGIMan);
  if FAILED(hr) then
    goto done;

  // Create the captureengine
  // Create the factory object for the capture engine.
  // pr_MediaEngineClassFactory is a reference to the IMFMediaEngineClassFactory interface.

  // C++ style:
  hr := CoCreateInstance(CLSID_MFCaptureEngineClassFactory,
                         nil,
                         CLSCTX_INPROC_SERVER,
                         IID_IMFCaptureEngineClassFactory,
                         mfFactory);
  if FAILED(hr) then
    goto done;

  // Or Delphi style:
  //mfFactory := CreateCOMObject(CLSID_MFCaptureEngineClassFactory) as IMFCaptureEngineClassFactory;
  //if not Assigned(mfFactory) then
  //  goto Done;


  // Create and initialize the CaptureEngine.
  hr := mfFactory.CreateInstance(CLSID_MFCaptureEngine,
                                 IID_IMFCaptureEngine,
                                 Pointer(FCaptureEngine));
  if FAILED(hr) then
    goto done;

  // Initialize the capture engine
  hr := FCaptureEngine.Initialize(m_pEventCallback,
                                  mfAttributes,
                                  nil,
                                  {IMFActivate} Unk);

  if SUCCEEDED(hr) and Assigned(Unk) then
    begin
      hr := (Unk as IMFActivate).ActivateObject(IID_IMFMediaSource,
                                                Pointer(m_pSource));
      if SUCCEEDED(hr) then
        hr := GetCameraSettings();
    end;

done:
  // Ignore returnvalue MF_E_INVALIDREQUEST in case user did not select a device .
  if (hr = MF_E_INVALIDREQUEST) then
    hr := S_OK;

  if FAILED(hr) then
    ErrMsg(ERR_INITIALIZE,
           hr);

  Result := hr;
end;


// Create
constructor TCaptureManager.Create(hEvent: HWND);
begin
  inherited Create();

  {$IFDEF SAVE_DEBUG_REPORT}
  FMediaTypeDebug := TMediaTypeDebug.Create();
  {$ENDIF}

  FCritSec := TMFCritSec.Create;
  hwndMainForm := hEvent;
  bRecording := False;
  bPreviewing := False;
  bPhotoPending := False;
  bEngineIsInitialized := False;
  FhEvent := 0;
  SetEvent(FhEvent);
end;


// Destroy
destructor TCaptureManager.Destroy();
begin
  DestroyCaptureEngine();
  {$IFDEF SAVE_DEBUG_REPORT}
  FreeAndNil(FMediaTypeDebug);
  {$ENDIF}
  FreeAndNil(FCritSec);
  inherited Destroy();
end;


// DestroyCaptureEngine
// Callers: Destroy, OnCaptureEvent, InitializeCaptureManager, Reset.
procedure TCaptureManager.DestroyCaptureEngine();
begin

  if (FhEvent <> 0) then
    begin
      CloseHandle(FhEvent);
      FhEvent := 0;
    end;

  SafeRelease(FCapturePreviewSink);
  SafeRelease(FCaptureEngine);

  // To destroy the object, we need to call SafeDelete.
  FreeAndNil(m_pEventCallback);
  FreeAndNil(m_pOnSampleCallback);
  // ========================================================

  if Assigned(g_pDXGIMan) then
    begin
      g_pDXGIMan.ResetDevice(g_pDX11Device,
                             g_ResetToken);
    end;

  // release the D3D11 interfaces
  SafeRelease(g_pDX11Device);
  SafeRelease(g_pDXGIMan);

  bEngineIsInitialized := False;
end;


// OnCaptureEvent
// Handle an event from the capture engine.
// NOTE: This method is called from the application's UI thread.
function TCaptureManager.OnCaptureEvent(pWParam: WPARAM;
                                        pLParam: LPARAM): HResult;
var
  guidType: TGUID;
  hrStatus: HResult;
  hr: HResult;
  pEvent: IMFMediaEvent;

begin

  pEvent := IMFMediaEvent(pWParam);

  hr := pEvent.GetStatus(hrStatus);
  if FAILED(hr) then
    hrStatus := hr;

  hr := pEvent.GetExtendedType(guidType);
  if SUCCEEDED(hr) then
    begin

      if IsEqualGuid(guidType,
                     MF_CAPTURE_ENGINE_INITIALIZED) then
        OnCaptureEngineInitialized(hrStatus)
      else if IsEqualGuid(guidType,
                          MF_CAPTURE_ENGINE_PREVIEW_STARTED) then
        OnPreviewStarted(hrStatus)
      else if IsEqualGuid(guidType,
                          MF_CAPTURE_ENGINE_PREVIEW_STOPPED) then
        OnPreviewStopped(hrStatus)
      else if IsEqualGuid(guidType,
                          MF_CAPTURE_ENGINE_OUTPUT_MEDIA_TYPE_SET) then
        OnCaptureEngineOutputMediaTypeSet(hrStatus)
      else if IsEqualGuid(guidType,
                          MF_CAPTURE_ENGINE_RECORD_STARTED)  then
        OnRecordStarted(hrStatus)
      else if IsEqualGuid(guidType,
                          MF_CAPTURE_ENGINE_RECORD_STOPPED) then
        OnRecordStopped(hrStatus)
      else if IsEqualGuid(guidType,
                          MF_CAPTURE_ENGINE_PHOTO_TAKEN) then
        OnPhotoTaken(hrStatus)
      else if IsEqualGuid(guidType,
                          MF_CAPTURE_SINK_PREPARED) then
        OnCaptureSinkPrepared(hrStatus)
      else if IsEqualGuid(guidType,
                          MF_CAPTURE_ENGINE_ERROR) then
        DestroyCaptureEngine();

      // Check others.
      if (hrstatus = MF_E_INVALIDREQUEST) then
        begin
          ErrMsg('OnCaptureEvent: Invalid request',
                 hr);
          DestroyCaptureEngine();
        end
      else if (FAILED(hrStatus)) then
        begin
          ErrMsg('OnCaptureEvent: Unexpected error',
                 hrStatus);
          DestroyCaptureEngine();
        end;
      SetEvent(FhEvent);
    end;

  // Send status update to the mainform.
  SendMessage(hwndMainForm,
              WM_APP_CAPTURE_EVENT_HANDLED,
              WPARAM(hr),
              LPARAM(@guidType));

   Result := hr;
end;


// OnCaptureEngineInitialized
// Capture Engine Event Handlers
procedure TCaptureManager.OnCaptureEngineInitialized(hrStatus: HResult);
begin
  if (hrStatus = MF_E_NO_CAPTURE_DEVICES_AVAILABLE) then
    hrStatus := S_OK;  // No capture device. Not an application error.

  bEngineIsInitialized := SUCCEEDED(hrStatus);

  if FAILED(hrStatus) then
    ErrMsg('OnCaptureEngineInitialized ' + ERR_INITIALIZE,
           hrStatus);
end;


// OnPreviewStarted
procedure TCaptureManager.OnPreviewStarted(hrStatus: HResult);
begin
  bPreviewing := SUCCEEDED(hrStatus);
  if FAILED(hrStatus) then
    begin
      ErrMsg('OnPreviewStarted: ' + ERR_PREVIEW,
           hrStatus);
      ResetCaptureManager();
    end;
end;


// OnPreviewStopped
procedure TCaptureManager.OnPreviewStopped(hrStatus: HResult);
begin

  if FAILED(hrStatus) then
    begin
      ErrMsg('OnPreviewStopped: ' + ERR_PREVIEW,
             hrStatus);
    end
  else
    bPreviewing := False;
end;

// OnCaptureEngineOutputMediaTypeSet
procedure TCaptureManager.OnCaptureEngineOutputMediaTypeSet(hrStatus: HResult);
begin
  if FAILED(hrStatus) then
    ErrMsg('OnCaptureEngineOutputMediaTypeSet: ' + ERR_OUTPUT_MEDIATYPE_SET,
           hrStatus);
end;


// OnRecordStarted
procedure TCaptureManager.OnRecordStarted(hrStatus: HResult);
begin
  bRecording := SUCCEEDED(hrStatus);
  if FAILED(hrStatus) then
    ErrMsg('OnRecordStarted: ' + ERR_RECORD,
           hrStatus);
end;


// OnRecordStopped
procedure TCaptureManager.OnRecordStopped(hrStatus: HResult);
begin

  if FAILED(hrStatus) then
    ErrMsg('OnRecordStopped: ' + ERR_RECORD,
           hrStatus)
  else
    bRecording := False;
end;


// OnPhotoTaken
procedure TCaptureManager.OnPhotoTaken(hrStatus: HResult);
begin
  bPhotoTaken := SUCCEEDED(hrStatus);
  if FAILED(hrStatus) then
    ErrMsg('OnPhotoTaken: ' + ERR_PHOTO,
           hrStatus)
  else //S_OK
    begin
      //FSampleConverter.UpdateConverter()
    end;
end;


// OnCaptureSinkPrepared
procedure TCaptureManager.OnCaptureSinkPrepared(hrStatus: HResult);
begin
  bCaptureSinkReady := SUCCEEDED(hrStatus);
  if FAILED(hrStatus) then
    ErrMsg('OnCaptureSinkPrepared: ' + ERR_CAPTURE,
           hrStatus);
end;


// StartPreview
// NOTE: When needed a new previewsink,
//       for example when using another source (camera),
//       set pNewPeviewSink to True.
function TCaptureManager.StartPreview(pNewPeviewSink: Boolean): HResult;
var
  pCaptureSink: IMFCaptureSink;
  pMediaType: IMFMediaType;
  pMediaType2: IMFMediaType;
  pCaptureSource: IMFCaptureSource;
  dwSinkStreamIndex: DWord;
  hr: HResult;

label
  Done;

begin

  if not Assigned(FCaptureEngine) then
    begin
      hr := MF_E_NOT_INITIALIZED;
      goto Done;
    end;

  if bPreviewing then
    begin
      hr := S_OK;
      goto Done;
    end;

  // Get a pointer to the preview sink, if not created yet.
  if not Assigned(FCapturePreviewSink) then
    begin

      hr := FCaptureEngine.GetSink(MF_CAPTURE_ENGINE_SINK_TYPE_PREVIEW,
                                   pCaptureSink);
      if FAILED(hr) then
        goto Done;

      hr := pCaptureSink.QueryInterface(IID_IMFCapturePreviewSink,
                                        FCapturePreviewSink);
      if FAILED(hr) then
        goto Done;


      hr := FCapturePreviewSink.SetRenderHandle(hwndPreviewWindow);
      if FAILED(hr) then
        goto Done;

      hr := FCaptureEngine.GetSource(pCaptureSource);
      if FAILED(hr) then
        goto Done;

      // Create an empty MediaType.
      // It is advised to do so when passing a mediatype interface to a method.
      hr := MFCreateMediaType(pMediaType);
      if FAILED(hr) then
        goto Done;

      // Configure the video format for the preview sink.
      hr := pCaptureSource.GetCurrentDeviceMediaType(MF_CAPTURE_ENGINE_PREFERRED_SOURCE_STREAM_FOR_VIDEO_PREVIEW,
                                                     pMediaType);
      if FAILED(hr) then
        goto Done;

      {$IFDEF SAVE_DEBUG_REPORT}
      FMediaTypeDebug.LogMediaType(pMediaType);
      FMediaTypeDebug.SafeDebugResultsToFile('StartPreview');
      {$ENDIF}

      hr := MFCreateMediaType(pMediaType2);
      if FAILED(hr) then
        goto Done;

      hr := CloneVideoMediaType(pMediaType,
                                MFVideoFormat_RGB32,
                                pMediaType2);
      if FAILED(hr) then
        goto Done;

      hr := pMediaType2.SetUINT32(MF_MT_ALL_SAMPLES_INDEPENDENT,
                                  UINT(1) { = UINT(True)});
      if FAILED(hr) then
        goto Done;

      {$IFDEF SAVE_DEBUG_REPORT}
      FMediaTypeDebug.LogMediaType(pMediaType2);
      FMediaTypeDebug.SafeDebugResultsToFile('StartPreview');
      {$ENDIF}

      // Connect the video stream to the preview sink.
      hr := FCapturePreviewSink.AddStream(MF_CAPTURE_ENGINE_PREFERRED_SOURCE_STREAM_FOR_VIDEO_PREVIEW,
                                          pMediaType2,
                                          nil,
                                          dwSinkStreamIndex);
      if FAILED(hr) then
        goto Done;
    end;

  // We are done, start preview.
  hr := FCaptureEngine.StartPreview();
  WaitForResult();

Done:

  if FAILED(hr) then
    ErrMsg('StartPreview',
            hr);

  Result := hr;
end;


// StopPreview
function TCaptureManager.StopPreview(): HResult;
var
  hr: HResult;

label
  Done;

begin

  if not Assigned(FCaptureEngine) then
    begin
      hr := MF_E_NOT_INITIALIZED;
      goto Done;
    end;

  if not bPreviewing then
    begin
      hr := S_OK;
      goto Done;
    end;

  hr := FCaptureEngine.StopPreview();
  if FAILED(hr) then
    goto Done;

done:
  if FAILED(hr) then
    ErrMsg('StopPreview',
            hr);

  Result := hr;
end;


// StartRecord
// Start recording to file
function TCaptureManager.StartRecording(pszDestinationFile: PCWSTR;
                                        pSinkWriterConfigSet: Boolean): HResult;
var
  pszExt: string;
  guidVideoEncoding: TGUID;
  guidAudioEncoding: TGUID;
  pSink: IMFCaptureSink;
  pRecord: IMFCaptureRecordSink;
  pSource: IMFCaptureSource;
  hr: HResult;

label
  Done;

begin

  if not Assigned(FCaptureEngine) then
    begin
      hr := MF_E_NOT_INITIALIZED;
      goto Done;
    end;

  if (bRecording = True) then
    begin
      hr := MF_E_INVALIDREQUEST;
      goto Done;
    end;

  pszExt := ExtractFileExt(pszDestinationFile);

  // Check extension to match the proper formats.
  if LowerCase(pszExt) = '.mp4' then
    begin
      guidVideoEncoding := MFVideoFormat_H264;
      guidAudioEncoding := MFAudioFormat_AAC;
    end
  else if LowerCase(pszExt) = '.wmv' then
    begin
      guidVideoEncoding := MFVideoFormat_WMV3;
      guidAudioEncoding := MFAudioFormat_WMAudioV9;
    end
  else if LowerCase(pszExt) = '.avi' then
    begin
      guidVideoEncoding := MFVideoFormat_H264;
      guidAudioEncoding := MFAudioFormat_AAC;
    end
  else
    begin
      hr := MF_E_INVALIDMEDIATYPE;
        goto Done;
    end;

  hr := FCaptureEngine.GetSink(MF_CAPTURE_ENGINE_SINK_TYPE_RECORD,
                               pSink);
  if FAILED(hr) then
    goto Done;

  hr := pSink.QueryInterface(IID_IMFCaptureRecordSink,
                             pRecord);
  if FAILED(hr) then
    goto Done;

  hr := FCaptureEngine.GetSource(pSource);
    if FAILED(hr) then
      goto Done;

  hr := pRecord.SetOutputFileName(pszDestinationFile);
    if FAILED(hr) then
      goto Done;

  // When we run the same video device over and over again, we skip the configuration.
  if not pSinkWriterConfigSet then
    begin

      // Configure the video and/or audio streams.

      // Video
      if not IsEqualGuid(guidVideoEncoding,
                         GUID_NULL) then
        begin
          // Note: ConfigureVideoEncoding can be using the default of the camera or the one we picked.
          hr := ConfigureVideoEncoding(pSource,
                                       pRecord,
                                       guidVideoEncoding,
                                       FRecordingMediaType);
          if FAILED(hr) then
            goto Done;
        end;

      // Audio
      if not IsEqualGuid(guidAudioEncoding,
                         GUID_NULL) then
        begin
          hr := ConfigureAudioEncoding(pSource,
                                       pRecord,
                                       guidAudioEncoding);
          if FAILED(hr) then
            goto Done;
        end;
    end;

  hr := FCaptureEngine.StartRecord();
  if FAILED(hr) then
    goto Done;

done:
  if FAILED(hr) then
    ErrMsg('StartRecording',
            hr);

  Result := hr;
end;


function TCaptureManager.StopRecording(): HResult;
var
  hr: HResult;

begin
  hr := S_OK;

  if bRecording then
    begin
      hr := FCaptureEngine.StopRecord(True,
                                      False);
      WaitForResult();
    end;

  if FAILED(hr) then
    ErrMsg('StopRecording',
            hr);

  Result := hr;
end;


function TCaptureManager.TakePhoto(pSnapShotOption: TSnapShotOptions;
                                   pMediaType: IMFMediaType): HResult;
var
  hr: HResult;
  pSource: IMFCaptureSource;
  pCaptureSink: IMFCaptureSink;
  pCapturePhotoSink: IMFCapturePhotoSink;
  dwSinkStreamIndex: DWORD;
  pMediaType2: IMFMediaType;

label
  done;

begin

  SnapShotOption := pSnapShotOption;

  {$IFDEF SAVE_DEBUG_REPORT}
  FMediaTypeDebug.LogMediaType(pMediaType);
  FMediaTypeDebug.SafeDebugResultsToFile('function_TCaptureManager_TakePhoto1');
  {$ENDIF}


  hr := FCaptureEngine.GetSink(MF_CAPTURE_ENGINE_SINK_TYPE_PHOTO,
                               pCaptureSink);
  if FAILED(hr) then
    goto done;

  // Get a pointer to the photo sink.
  hr := pCaptureSink.QueryInterface(IID_IMFCapturePhotoSink,
                                    pCapturePhotoSink);
  if FAILED(hr) then
    goto done;

  // ssoFile /////////////////////////////////////////////////////////////////

  if (SnapShotOption = ssoFile) then  // Snapshot will be saved directly to file without preview first.
    begin
      hr := FCaptureEngine.GetSource(pSource);
      if FAILED(hr) then
       goto done;


      hr := pSource.GetCurrentDeviceMediaType(MF_CAPTURE_ENGINE_PREFERRED_SOURCE_STREAM_FOR_PHOTO,
                                              pMediaType);
      if FAILED(hr) then
        goto done;

      // Configure the photo format.
      hr := CreatePhotoMediaType(GUID_ContainerFormatBmp,
                                 pMediaType,
                                 pMediaType2);
      if FAILED(hr) then
       goto done;

      {$IFDEF SAVE_DEBUG_REPORT}
      FMediaTypeDebug.LogMediaType(pMediaType2);
      FMediaTypeDebug.SafeDebugResultsToFile('function_TCaptureManager_TakePhoto2');
      {$ENDIF}

      hr := pCapturePhotoSink.RemoveAllStreams();
      if FAILED(hr) then
        goto done;

      // Try to connect the first still image stream to the photo sink returns the streamindex for added stream.
      hr := pCapturePhotoSink.AddStream(MF_CAPTURE_ENGINE_PREFERRED_SOURCE_STREAM_FOR_PHOTO,
                                        pMediaType2,
                                        nil,
                                        {out} dwSinkStreamIndex);
      if FAILED(hr) then
        goto done;

      hr := SetSnapShotOption(pCapturePhotoSink);
      if FAILED(hr) then
        goto done;

      hr := FCaptureEngine.TakePhoto();
      if FAILED(hr) then
        goto done;

    end
  else if (SnapShotOption = ssoCallBack) then  // The callback will be used to get a preview before saving to file
    begin

      hr := pCapturePhotoSink.RemoveAllStreams();
      if FAILED(hr) then
        goto done;

          // Try to connect the first still image stream to the photo sink returns the streamindex for added stream.
      hr := pCapturePhotoSink.AddStream(MF_CAPTURE_ENGINE_PREFERRED_SOURCE_STREAM_FOR_PHOTO,
                                        pMediaType,
                                        nil,
                                        {out} dwSinkStreamIndex);
      if FAILED(hr) then
        goto Done;

      hr := SetSnapShotOption(pCapturePhotoSink);
      if FAILED(hr) then
        goto Done;

      hr := FCaptureEngine.TakePhoto();
      if FAILED(hr) then
        goto done;
    end
  else
    begin
      hr := ERROR_NOT_SUPPORTED;
      goto done;
    end;

done:
  if FAILED(hr) then
    ErrMsg('function TCaptureManager.TakePhoto',
            hr);
  Result := hr;
end;


// Call this method before initiating a new engine!
procedure TCaptureManager.ResetCaptureManager();
begin
  DestroyCaptureEngine();
end;


//
function TCaptureManager.UpdateVideo(psrc: PMFVideoNormalizedRect): HResult;
var
  rdest: TRect;

begin
  CopyPVNRectToTRect(psrc, rdest);
  if Assigned(FCapturePreviewSink) then
    Result := FCapturePreviewSink.UpdateVideo(nil,
                                              @rdest,
                                              nil)
  else
    Result := S_OK;
end;


//
function TCaptureManager.SetVideoFormat(): HResult;
var
  hr: HResult;
  uiDeviceIndex: UINT32;
  uiFormatIndex: UINT32;

begin
  uiDeviceIndex := FDeviceExplorer.DeviceIndex;
  uiFormatIndex := FDeviceExplorer.FormatIndex;
  hr := SetMediaType(FDeviceExplorer.DeviceProperties[uiDeviceIndex].aVideoFormats[uiFormatIndex].mfMediaType);
  Result := hr;
end;


// SetMediaType for preview and recording
function TCaptureManager.SetMediaType(pMediaType: IMFMediaType): HResult;
var
  mfCaptureSource: IMFCaptureSource;
  hr: HResult;

begin

  {$IFDEF SAVE_DEBUG_REPORT}
  FMediaTypeDebug.LogMediaType(pMediaType);
  FMediaTypeDebug.SafeDebugResultsToFile('SetMediaType');
  {$ENDIF}

  hr := FCaptureEngine.GetSource(mfCaptureSource);

  if SUCCEEDED(hr) then
    // Preview
    hr := mfCaptureSource.SetCurrentDeviceMediaType(MF_CAPTURE_ENGINE_PREFERRED_SOURCE_STREAM_FOR_VIDEO_PREVIEW,
                                                      pMediaType);

  // Recording
  if SUCCEEDED(hr) then
    hr := CloneVideoMediaType(pMediaType,
                              MFVideoFormat_RGB32,
                              FRecordingMediaType);

  Result := hr;
end;


// GetCurrentFormat
function TCaptureManager.GetCurrentFormat(): TVideoFormatInfo;
begin
  Result := FDeviceExplorer.VideoFormat;
end;


// SetSnapShotOption
function TCaptureManager.SetSnapShotOption(pPhotoSink: IMFCapturePhotoSink): HResult;
var
  hr: HResult;
  pszFileName,
  pszPicPath,
  pszOutputFileName: PWideChar;

const
  pExt = '.bmp';

label
  Done;

begin
  hr := S_OK;
  // Decide where the snapshot should be send through
  case SnapShotOption of
    ssoFile:     begin
                   // Set the desired pictureformat.


                   // get the My Pictures Folder path use fPath.GetSharedPicturesPath for the shared folder
                   pszPicPath := StrToPWideChar(TPath.GetPicturesPath);
                   pszFileName := StrToPWideChar(Format('MyPicture_%s%s',
                                                        [DateToStr(Now()),
                                                         pExt]));

                   pszOutputFileName := StrToPWideChar(Format('%s%s',
                                                              [pszPicPath,
                                                               pszFileName]));

                   hr := pPhotoSink.SetOutputFileName(pszOutputFileName);
                   if FAILED(hr) then
                     goto Done;
                 end;

    ssoCallBack: begin
                   // Note:
                   //   Calling this method overrides any previous call to IMFCapturePhotoSink.SetOutputByteStream or
                   //   IMFCapturePhotoSink.SetOutputFileName.
                   // The called event will be handled by OnSampleCallBack
                   hr := pPhotoSink.SetSampleCallback(m_pOnSampleCallBack);
                   if FAILED(hr) then
                     goto Done;

                   // Optional
                   // Give MF time to assemble the pipeline.
                   // When succeeded, call IMFPhotoSink.GetService, to configure individual components.
                   hr :=  pPhotoSink.Prepare();
                   if FAILED(hr) then
                     goto Done;
                 end;

    ssoStream:   begin
                   // Save to stream
                   // NOT IMPLEMENTED
                 end;
  end;

Done:
  if FAILED(hr) then
    ErrMsg('OnPhotoTaken',
           hr);
  Result := hr;
end;


procedure TCaptureManager.WaitForResult();
begin
  WaitForSingleObject(FhEvent,
                      INFINITE);
end;


// Camera and video settings.
function TCaptureManager.GetCameraSettings(): HRESULT;
var
  hr: HRESULT;

label
  done;

begin

  if not Assigned(m_pSource) then
    begin
      hr := E_POINTER;
      goto done;
    end;

  // Control the 'camera'.
  // When there is no support, this would raise an exception.
  // dsCameraControl := m_pSource as IAMCameraControl;
  // This way, we get a resultcode, so you have to handle the error yourself.
  hr := m_pSource.QueryInterface(IID_IAMCameraControl,
                                 dsCameraControl);

  if SUCCEEDED(hr) then
    begin

      // Clean up earlier property values.
      FCameraProps.Initialize();

      // Get all camera properties when possible.

      // Exposure.
      hr := dsCameraControl.GetRange(LONG(CameraControl_Exposure),
                                     FCameraProps.CameraCtl_Exposure.prMin,
                                     FCameraProps.CameraCtl_Exposure.prMax,
                                     FCameraProps.CameraCtl_Exposure.prDelta,
                                     FCameraProps.CameraCtl_Exposure.prDefault,
                                     FCameraProps.CameraCtl_Exposure.prFlags); // Note that values > $2 means we should use the flags defined in KsMedia.pas
      if (hr = E_PROP_ID_UNSUPPORTED) then
        FCameraProps.CameraCtl_Exposure.IsSupported := False
      else if (hr <> S_OK) then
        goto done;

      // Zoom.
      hr := dsCameraControl.GetRange(LONG(CameraControl_Zoom),
                                     FCameraProps.CameraCtl_Zoom.prMin,
                                     FCameraProps.CameraCtl_Zoom.prMax,
                                     FCameraProps.CameraCtl_Zoom.prDelta,
                                     FCameraProps.CameraCtl_Zoom.prDefault,
                                     FCameraProps.CameraCtl_Zoom.prFlags);
      if (hr = E_PROP_ID_UNSUPPORTED) then
        FCameraProps.CameraCtl_Zoom.IsSupported := False
      else if (hr <> S_OK) then
        goto done;

      // Pan.
      hr := dsCameraControl.GetRange(LONG(CameraControl_Pan),
                                     FCameraProps.CameraCtl_Pan.prMin,
                                     FCameraProps.CameraCtl_Pan.prMax,
                                     FCameraProps.CameraCtl_Pan.prDelta,
                                     FCameraProps.CameraCtl_Pan.prDefault,
                                     FCameraProps.CameraCtl_Pan.prFlags);
      if (hr = E_PROP_ID_UNSUPPORTED) then
        FCameraProps.CameraCtl_Pan.IsSupported := False
      else if (hr <> S_OK) then
        goto done;

      // Tilt.
      hr := dsCameraControl.GetRange(LONG(CameraControl_Tilt),
                                     FCameraProps.CameraCtl_Tilt.prMin,
                                     FCameraProps.CameraCtl_Tilt.prMax,
                                     FCameraProps.CameraCtl_Tilt.prDelta,
                                     FCameraProps.CameraCtl_Tilt.prDefault,
                                     FCameraProps.CameraCtl_Tilt.prFlags);
      if (hr = E_PROP_ID_UNSUPPORTED) then
        FCameraProps.CameraCtl_Tilt.IsSupported := False
      else if (hr <> S_OK) then
        goto done;

      // Roll.
      hr := dsCameraControl.GetRange(LONG(CameraControl_Roll),
                                     FCameraProps.CameraCtl_Roll.prMin,
                                     FCameraProps.CameraCtl_Roll.prMax,
                                     FCameraProps.CameraCtl_Roll.prDelta,
                                     FCameraProps.CameraCtl_Roll.prDefault,
                                     FCameraProps.CameraCtl_Roll.prFlags);
      if (hr = E_PROP_ID_UNSUPPORTED) then
        FCameraProps.CameraCtl_Roll.IsSupported := False
      else if (hr <> S_OK) then
        Exit(hr);

      // Iris.
      hr := dsCameraControl.GetRange(LONG(CameraControl_Iris),
                                     FCameraProps.CameraCtl_Iris.prMin,
                                     FCameraProps.CameraCtl_Iris.prMax,
                                     FCameraProps.CameraCtl_Iris.prDelta,
                                     FCameraProps.CameraCtl_Iris.prDefault,
                                     FCameraProps.CameraCtl_Iris.prFlags);
      if (hr = E_PROP_ID_UNSUPPORTED) then
        FCameraProps.CameraCtl_Iris.IsSupported := False
      else if (hr <> S_OK) then
        goto done;

      // Focus.
      hr := dsCameraControl.GetRange(LONG(CameraControl_Focus),
                                     FCameraProps.CameraCtl_Focus.prMin,
                                     FCameraProps.CameraCtl_Focus.prMax,
                                     FCameraProps.CameraCtl_Focus.prDelta,
                                     FCameraProps.CameraCtl_Focus.prDefault,
                                     FCameraProps.CameraCtl_Focus.prFlags);
      if (hr = E_PROP_ID_UNSUPPORTED) then
        FCameraProps.CameraCtl_Focus.IsSupported := False
      else if (hr <> S_OK) then
        goto done;
    end
  else if (hr = E_NOINTERFACE) then
    FCameraProps.IsSupported := False
  else  // Any other error.
    goto done;


  // Control the 'video'.
  hr := m_pSource.QueryInterface(IID_IAMVideoProcAmp,
                                   dsVideoControl);

  if SUCCEEDED(hr) then
    begin

      // Clean up.
      FVideoProps.Initialize();

      // Get all video properties when possible.
      // Brightness.
      hr := dsVideoControl.GetRange(LONG(VideoProcAmp_Brightness),
                                    FVideoProps.VideoCtl_Brightness.prMin,
                                    FVideoProps.VideoCtl_Brightness.prMax,
                                    FVideoProps.VideoCtl_Brightness.prDelta,
                                    FVideoProps.VideoCtl_Brightness.prDefault,
                                    FVideoProps.VideoCtl_Brightness.prFlags);
      if (hr = E_PROP_ID_UNSUPPORTED) then
        FVideoProps.VideoCtl_Brightness.IsSupported := False
      else if (hr <> S_OK) then
        goto done;

        // Contrast.
        hr := dsVideoControl.GetRange(LONG(VideoProcAmp_Contrast),
                                      FVideoProps.VideoCtl_Contrast.prMin,
                                      FVideoProps.VideoCtl_Contrast.prMax,
                                      FVideoProps.VideoCtl_Contrast.prDelta,
                                      FVideoProps.VideoCtl_Contrast.prDefault,
                                      FVideoProps.VideoCtl_Contrast.prFlags);
      if (hr = E_PROP_ID_UNSUPPORTED) then
          FVideoProps.VideoCtl_Contrast.IsSupported := False
      else if (hr <> S_OK) then
          goto done;

      // Hue.
      hr := dsVideoControl.GetRange(LONG(VideoProcAmp_Hue),
                                    FVideoProps.VideoCtl_Hue.prMin,
                                    FVideoProps.VideoCtl_Hue.prMax,
                                    FVideoProps.VideoCtl_Hue.prDelta,
                                    FVideoProps.VideoCtl_Hue.prDefault,
                                    FVideoProps.VideoCtl_Hue.prFlags);
      if (hr = E_PROP_ID_UNSUPPORTED) then
        FVideoProps.VideoCtl_Hue.IsSupported := False
      else if (hr <> S_OK) then
        goto done;

      // Saturation.
      hr := dsVideoControl.GetRange(LONG(VideoProcAmp_Saturation),
                                    FVideoProps.VideoCtl_Saturation.prMin,
                                    FVideoProps.VideoCtl_Saturation.prMax,
                                    FVideoProps.VideoCtl_Saturation.prDelta,
                                    FVideoProps.VideoCtl_Saturation.prDefault,
                                    FVideoProps.VideoCtl_Saturation.prFlags);
      if (hr = E_PROP_ID_UNSUPPORTED) then
        FVideoProps.VideoCtl_Saturation.IsSupported := False
      else if (hr <> S_OK) then
        goto done;

      // Sharpness.
      hr := dsVideoControl.GetRange(LONG(VideoProcAmp_Sharpness),
                                    FVideoProps.VideoCtl_Sharpness.prMin,
                                    FVideoProps.VideoCtl_Sharpness.prMax,
                                    FVideoProps.VideoCtl_Sharpness.prDelta,
                                    FVideoProps.VideoCtl_Sharpness.prDefault,
                                    FVideoProps.VideoCtl_Sharpness.prFlags);
      if (hr = E_PROP_ID_UNSUPPORTED) then
        FVideoProps.VideoCtl_Sharpness.IsSupported := False
      else if (hr <> S_OK) then
        goto done;

      // Gamma.
      hr := dsVideoControl.GetRange(LONG(VideoProcAmp_Gamma),
                                    FVideoProps.VideoCtl_Gamma.prMin,
                                    FVideoProps.VideoCtl_Gamma.prMax,
                                    FVideoProps.VideoCtl_Gamma.prDelta,
                                    FVideoProps.VideoCtl_Gamma.prDefault,
                                    FVideoProps.VideoCtl_Gamma.prFlags);
      if (hr = E_PROP_ID_UNSUPPORTED) then
        FVideoProps.VideoCtl_Gamma.IsSupported := False
      else if (hr <> S_OK) then
        goto done;

      // ColorEnable.
      hr := dsVideoControl.GetRange(LONG(VideoProcAmp_ColorEnable),
                                    FVideoProps.VideoCtl_ColorEnable.prMin,
                                    FVideoProps.VideoCtl_ColorEnable.prMax,
                                    FVideoProps.VideoCtl_ColorEnable.prDelta,
                                    FVideoProps.VideoCtl_ColorEnable.prDefault,
                                    FVideoProps.VideoCtl_ColorEnable.prFlags);
      if (hr = E_PROP_ID_UNSUPPORTED) then
        FVideoProps.VideoCtl_ColorEnable.IsSupported := False
      else if (hr <> S_OK) then
        goto done;

      // WhiteBalance.
      hr := dsVideoControl.GetRange(LONG(VideoProcAmp_WhiteBalance),
                                    FVideoProps.VideoCtl_WhiteBalance.prMin,
                                    FVideoProps.VideoCtl_WhiteBalance.prMax,
                                    FVideoProps.VideoCtl_WhiteBalance.prDelta,
                                    FVideoProps.VideoCtl_WhiteBalance.prDefault,
                                    FVideoProps.VideoCtl_WhiteBalance.prFlags);
      if (hr = E_PROP_ID_UNSUPPORTED) then
        FVideoProps.VideoCtl_WhiteBalance.IsSupported := False
      else if (hr <> S_OK) then
        goto done;

      // BacklightCompensation.
      hr := dsVideoControl.GetRange(LONG(VideoProcAmp_BacklightCompensation),
                                    FVideoProps.VideoCtl_BacklightCompensation.prMin,
                                    FVideoProps.VideoCtl_BacklightCompensation.prMax,
                                    FVideoProps.VideoCtl_BacklightCompensation.prDelta,
                                    FVideoProps.VideoCtl_BacklightCompensation.prDefault,
                                    FVideoProps.VideoCtl_BacklightCompensation.prFlags);
      if (hr = E_PROP_ID_UNSUPPORTED) then
        FVideoProps.VideoCtl_BacklightCompensation.IsSupported := False
      else if (hr <> S_OK) then
        goto done;

      // Gain.
      hr := dsVideoControl.GetRange(LONG(VideoProcAmp_Gain),
                                    FVideoProps.VideoCtl_Gain.prMin,
                                    FVideoProps.VideoCtl_Gain.prMax,
                                    FVideoProps.VideoCtl_Gain.prDelta,
                                    FVideoProps.VideoCtl_Gain.prDefault,
                                    FVideoProps.VideoCtl_Gain.prFlags);
      if (hr = E_PROP_ID_UNSUPPORTED) then
        FVideoProps.VideoCtl_Gain.IsSupported := False
      else if (hr <> S_OK) then
        goto done;
    end
  else if (hr = E_NOINTERFACE) then
    begin
      hr := S_OK;
      FVideoProps.IsSupported := False;
    end;

done:

  // If no support, just ignore this exept for other errors.
  if (hr = E_PROP_ID_UNSUPPORTED) or (hr = E_NOINTERFACE) then
    hr := S_OK
  else if FAILED(hr) then
    ErrMsg('GetCameraSettings',
           hr);

  Result := hr;
end;


function TCaptureManager.SetCameraProps(pProps: TCameraPropSet): HRESULT;
var
  hr: HResult;

begin

  if not Assigned(dsCameraControl) then
    Exit(E_POINTER);

  hr := dsCameraControl.Set_(LONG(pProps.cpCameraControlProperty),
                             pProps.cpValue,
                             LONG(pProps.cpFlags));

  Result := hr;
end;


function TCaptureManager.SetVideoProps(pProps: TVideoPropSet): HRESULT;
var
  hr: HResult;

begin

  if not Assigned(dsVideoControl) then
    Exit(E_POINTER);

  hr := dsVideoControl.Set_(LONG(pProps.cpVideoProcAmpProperty),
                            pProps.cpValue,
                            LONG(pProps.cpFlags));

  Result := hr;
end;


procedure TCVPropRecord.Initialize();
begin

  prMin := 0;
  prMax := 0;
  prDelta := 0;
  prDefault := 0;
  prFlags := LONG(CameraControl_Flags_Auto);
  IsSupported := True;
end;


procedure TCameraProps.Initialize();
begin

  CameraCtl_Pan.Initialize();
  CameraCtl_Tilt.Initialize();
  CameraCtl_Roll.Initialize();
  CameraCtl_Zoom.Initialize();
  CameraCtl_Exposure.Initialize();
  CameraCtl_Iris.Initialize();
  CameraCtl_Focus.Initialize();
  IsSupported := True;
end;


procedure TVideoProps.Initialize();
begin

  VideoCtl_Brightness.Initialize();
  VideoCtl_Contrast.Initialize();
  VideoCtl_Hue.Initialize();
  VideoCtl_Saturation.Initialize();
  VideoCtl_Sharpness.Initialize();
  VideoCtl_Gamma.Initialize();
  VideoCtl_ColorEnable.Initialize();
  VideoCtl_WhiteBalance.Initialize();
  VideoCtl_BacklightCompensation.Initialize();
  VideoCtl_Gain.Initialize();
  IsSupported := True;
end;

end.

