unit CaptureEngine;


interface

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
  {ActiveX}
  WinApi.ActiveX.PropIdl,
  WinApi.ActiveX.PropVarUtil,
  {MediaFoundationApi}
  WinApi.MediaFoundationApi.MfApi,
  WinApi.MediaFoundationApi.MfIdl,
  WinApi.MediaFoundationApi.MfError,
  WinApi.MediaFoundationApi.MfCaptureEngine,
  WinApi.MediaFoundationApi.MfObjects,
  WinApi.MediaFoundationApi.MfMetLib,
  WinAPI.MediaFoundationApi.MfUtils,
  {DirectX}
  Winapi.D3DCommon,
  WinApi.D3D11,
  {Application}
  SampleConverter,
  Utils;


const
  WM_APP_CAPTURE_EVENT = WM_APP + 1;

  WM_DEVICEDLG_ITEM_SELECTED       = WM_APP + 1001;
  WM_CHOOSE_DEVICEDLG_FRIENDLYTEXT = WM_APP + 1002;
  WM_RECIEVED_SAMPLE_FROM_CALLBACK = WM_APP + 1003;

  IDD_CHOOSE_DEVICE                   = 101;
  IDS_ERR_SET_DEVICE                  = 102;
  IDS_ERR_INITIALIZE                  = 103;
  IDS_ERR_PREVIEW                     = 104;
  IDS_ERR_RECORD                      = 105;
  IDS_ERR_CAPTURE                     = 106;
  IDS_ERR_PHOTO                       = 107;
  IDS_ERR_BADREQUEST                  = 108;


var
  // DXGI DevManager support
  g_pDXGIMan: IMFDXGIDeviceManager;
  g_pDX11Device: ID3D11Device;
  g_ResetToken: UINT;

type
  //
  // ChooseDeviceParam class
  //
  // Holds an array of IMFActivate pointers that represent video
  // capture devices.
  //
  TChooseDeviceParam = class(TObject)
  private
    apDevices: PIMFActivate;        // Pointer to array of IMFActivate pointers.
    apDevice: IMFActivate;          // Device that has been selected
    ucount: UINT32;                 // Number of elements in the array.
    uSelection: UINT32;             // Selected device, by array index.
    lpSelectedDeviceName: LPWSTR;   // Selected device name.
    lpSelectedSymbolicLink: LPWSTR; // Selected device symbolic link.
    bIsSelected: Boolean;

    function Initialize(): HResult;
    procedure SetSelection(iIndex: UINT32);

  public

    constructor Create();
    destructor Destroy(); override;

    // Use this property to get and set all params from the PIMFActivate pointerarray
    property DeviceIndex: UINT32 read uSelection write SetSelection;
    property DeviceIsSelected: Boolean read bIsSelected write bIsSelected;
    property Device: IMFActivate read apDevice;
    property Count: UINT32 read ucount;
    property DeviceName: PWideChar read lpSelectedDeviceName;
    property SymbolicLink: PWideChar read lpSelectedSymbolicLink;
  end;


type
  PSampleFromCallBack = ^TSampleFromCallBack;
  TSampleFromCallBack = record
    pSample: IMFSample;
  end;

  TSnapShotOptions = (ssoFile,
                      ssoCallBack,
                      ssoStream);


  // CaptureManager class
  // Wraps the capture engine and implements the event callback and OnSampleCallback in a nested class.
type
  TCaptureManager = class(TInterfacedPersistent)
  private

  type TCaptureManagerCallBack = class(TInterfacedPersistent, IMFCaptureEngineOnEventCallback)
    private
      m_hwnd: HWND;

      // Implementation of IMFCaptureEngineOnEventCallback
      function OnEvent(pEvent: IMFMediaEvent): HResult; stdcall;
      //

    public
      m_fSleeping: Boolean;
      m_pManager: TCaptureManager;

      constructor Create(_hwnd: HWND); virtual;
      destructor Destroy(); override;
    end;

  type TCaptureEngineOnSampleCallback = class(TInterfacedPersistent, IMFCaptureEngineOnSampleCallback)
    private
      DestHandle: HWnd;

      // Implementation of IMFCaptureEngineOnEventCallback
      function OnSample(pSample: IMFSample): HResult; stdcall;
      //
    public
      m_pManager: TCaptureManager;

      constructor Create(_hwnd: HWND); virtual;
      destructor Destroy(); override;

    end;

  private
    m_pEngine: IMFCaptureEngine;
    m_pPreview: IMFCapturePreviewSink;

    m_hwndEvent: HWND;
    m_hwndPreview: HWND;

    m_pCallback: TCaptureManagerCallBack;
    m_pOnSampleCallback: TCaptureEngineOnSampleCallback;

    m_bPreviewing: Boolean;
    m_bRecording: Boolean;
    m_bPhotoPending: Boolean;

    m_errorID: UINT;
    m_hEvent: THandle;

    m_SampleFromCallBack: TSampleFromCallBack;

    a_VideoFormatInfo: array of TVideoFormatInfo;
    m_SampleConverter: TSampleConverter;
    FCritSec: TMFCritSec;

    constructor Create(_hwnd: HWND);
    procedure DestroyCaptureEngine();

    procedure SetErrorID(hr: HResult; id: UINT);

    // Capture Engine Event Handlers
    procedure OnCaptureEngineInitialized(hrStatus: HResult);
    procedure OnPreviewStarted(hrStatus: HResult);
    procedure OnPreviewStopped(hrStatus: HResult);
    procedure OnRecordStarted(hrStatus: HResult);
    procedure OnRecordStopped(hrStatus: HResult);

    procedure WaitForResult();
    procedure SetSleepState(fSleeping: Boolean);
    function UpdateVideo(): HResult;

    function GetCaptureDeviceCaps(const iDevIndex: DWord;
                                  const dwStreamType: DWord = MF_CAPTURE_ENGINE_PREFERRED_SOURCE_STREAM_FOR_VIDEO_RECORD): HResult;

  public


    destructor Destroy(); override;

    class function CreateCaptureEngine(hwndEvent: HWND;
                                       out ppEngine: TCaptureManager): HResult;

    function InitializeCaptureManager(hwndPreview: HWND;
                                      Unk: IUnknown): HResult;



    function OnCaptureEvent(wParam: WPARAM;
                            lParam: LPARAM): HResult;

    function StartPreview(): HResult;
    function StopPreview(): HResult;
    function StartRecord(pszDestinationFile: PCWSTR): HResult;
    function StopRecord(): HResult;
    function TakePhoto(snsOptions: TSnapShotOptions;
                       pExt: PWideChar = nil): HResult;

    property SleepState: Boolean write SetSleepState;
    property IsRecording: Boolean read m_bRecording;
    property IsPreviewing: Boolean read m_bPreviewing;
    property IsPhotoPending: Boolean read m_bPhotoPending;

    property PreviewHandle: HWND read m_hwndPreview;
    property EventHandle: HWND read m_hwndEvent;
  end;

var
  g_pEngine: TCaptureManager;
  DeviceParam: TChooseDeviceParam;


implementation


uses
  WinApi.D3D10,
  WinApi.Unknwn;


// D3D11 ///////////////////////////////////////////////////////////////////////

function CreateDX11Device(out ppDevice: ID3D11Device;
                          out ppDeviceContext: ID3D11DeviceContext;
                          out pFeatureLevel: D3D_FEATURE_LEVEL): HResult;
var
  hr: HResult;
  aFeatureLevels: array[0..6] of D3D_FEATURE_LEVEL;
  pMultithread: ID3D10Multithread;

const
   // This should be in the D3D11_CREATE_DEVICE_FLAG enumeration of WinApi.D3D11.pas
   D3D11_CREATE_DEVICE_VIDEO_SUPPORT = $800;

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
                          D3D11_CREATE_DEVICE_VIDEO_SUPPORT,  // Not implemented in the D3Dii API Delphi 10.3  !
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
        pMultithread.SetMultithreadProtected(True);

      SafeRelease(pMultithread);
    end;

  Result := hr;
end;


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

  SafeRelease(pDX11DeviceContext);

  Result := hr;
end;



// CaptureManagerCallBack routines /////////////////////////////////////////////

constructor TCaptureManager.TCaptureManagerCallBack.Create(_hwnd: HWND);
begin
  inherited Create();
  m_hwnd := _hwnd;
  m_fSleeping := False;
  m_pManager := Nil;
end;


destructor TCaptureManager.TCaptureManagerCallBack.Destroy();
begin
  //
  inherited Destroy();
end;


class function TCaptureManager.CreateCaptureEngine(hwndEvent: HWND;
                                                   out ppEngine: TCaptureManager): HResult;
var
  hr: HResult;
  pEngine: TCaptureManager;

label
  Done;

begin
  hr := S_OK;
  ppEngine := Nil;

  pEngine := TCaptureManager.Create(hwndEvent);
  if not Assigned(pEngine) then
    begin
      hr := E_OUTOFMEMORY;
      goto Done;
    end;


  ppEngine := pEngine;
  pEngine := nil;

Done:
  if Assigned(pEngine) then
    SafeDelete(pEngine);

  Result := hr;
end;


// Callback method to receive events from the capture engine.
function TCaptureManager.TCaptureManagerCallBack.OnEvent(pEvent: IMFMediaEvent): HResult;
var
  guidType: TGUID;
  hrStatus: HResult;
  hr: HResult;

begin
  // Post a message to the application window, so the event is handled
  // on the application's main thread.

  if not m_fSleeping then
    begin
      // We're about to fall asleep, that means we've just asked the CE to stop the preview
      // and record.  We need to handle it here since our message pump may be gone.
      hr := pEvent.GetStatus(hrStatus);

      if FAILED(hr) then
        hrStatus := hr;

      hr := pEvent.GetExtendedType(guidType);

      if SUCCEEDED(hr) then
        begin
          if (guidType = MF_CAPTURE_ENGINE_PREVIEW_STOPPED) then
            begin
              m_pManager.OnPreviewStopped(hrStatus);
              SetEvent(m_pManager.m_hEvent);
            end
          else if (guidType = MF_CAPTURE_ENGINE_RECORD_STOPPED) then
            begin
              m_pManager.OnRecordStopped(hrStatus);
              SetEvent(m_pManager.m_hEvent);
            end
          else if (guidType = MF_CAPTURE_ENGINE_PHOTO_TAKEN) then
            begin
              // Notice the app the snapshot has been taken.

            end
          else if guidType = MF_CAPTURE_SOURCE_CURRENT_DEVICE_MEDIA_TYPE_SET then
            begin
              // Signal all is ready for captureing.

            end
          else if guidType = MF_CAPTURE_ENGINE_ERROR then
            begin
              // Oops, error uccured.

            end
          else if guidType = MF_CAPTURE_SINK_PREPARED then
            begin
              // Signals that the capture sink is prepared to accept GetService calls

            end
          else if guidType = MF_CAPTURE_ENGINE_OUTPUT_MEDIA_TYPE_SET then
            begin
              // Signals that the output type has been set on captureengine in response to IMFCaptureSink2.SetOutputType

            end
          else
            begin
              // This is an event we don't know about, we don't really care and there's
              // no clean way to report the error so just set the event and fall through.
              SetEvent(m_pManager.m_hEvent);
            end;
        end;
    end
  else
    begin
      PostMessage(m_pManager.m_hwndEvent,
                  WM_APP_CAPTURE_EVENT,
                  WPARAM(pEvent),
                  0);
    end;

  Result := S_OK;
end;


// TCaptureEngineOnSampleCallback //////////////////////////////////////////////

constructor TCaptureManager.TCaptureEngineOnSampleCallback.Create(_hwnd: HWND);
begin
  inherited Create();
  DestHandle := _hwnd;
 // m_SampleConverter := TSampleConverter.Create();
end;


destructor TCaptureManager.TCaptureEngineOnSampleCallback.Destroy();
begin
  //FreeAndNil(m_SampleConverter);
  inherited;
end;


function TCaptureManager.TCaptureEngineOnSampleCallback.OnSample(pSample: IMFSample): HResult;
var
  pData: TMemoryStream;
  hr: HResult;

begin
  hr := S_OK;

  { TODO : convert sample to bitmap send bitmap to mainform snapshot rect (TPaintbox) }
  if (pSample <> nil) then
    begin






    //  m_SampleConverter.DataFromSample(pSample,
    //
    //                                   pData);

     

      m_pManager.m_SampleFromCallBack.pSample := pSample;

     if not PostMessage(DestHandle,
                        WM_RECIEVED_SAMPLE_FROM_CALLBACK,
                        0,
                        LPARAM(@m_pManager.m_SampleFromCallBack)) then
    begin
      SafeRelease(m_pManager.m_SampleFromCallBack.pSample);
    end;
    end;

  Result := hr;
end;



// CaptureManager routines /////////////////////////////////////////////////////


function TCaptureManager.InitializeCaptureManager(hwndPreview: HWND;
                                                  Unk: IUnknown): HResult;
var
  hr: HResult;
  pAttributes: IMFAttributes;
  pFactory: IMFCaptureEngineClassFactory;

label
  Done;

begin

  DestroyCaptureEngine();

  m_hEvent := CreateEvent(Nil,
                          False,
                          False,
                          Nil);

  if m_hEvent = 0 then
    begin
      hr := HRESULT_FROM_WIN32(GetLastError());
      goto Done;
    end;

  // Create the CaptureManagerCallBack class
  m_pCallback := TCaptureManagerCallBack.Create(m_hwndEvent);
  if not Assigned(m_pCallback) then
    begin
      hr := E_OUTOFMEMORY;
      goto Done;
    end;

  m_pCallback.m_pManager := Self;

  // Create the OnSampleCallBack class
  m_pOnSampleCallback := TCaptureEngineOnSampleCallback.Create(m_hwndEvent);
  if not Assigned(m_pOnSampleCallback) then
    begin
      hr := E_OUTOFMEMORY;
      goto Done;
    end;

  m_pOnSampleCallback.m_pManager := Self;

  m_hwndPreview := hwndPreview;

  // Create a D3D Manager
  hr := CreateD3DManager();
  if FAILED(hr) then
    goto Done;

  hr := MFCreateAttributes(pAttributes,
                           1);
  if FAILED(hr) then
    goto Done;

  hr := pAttributes.SetUnknown(MF_CAPTURE_ENGINE_D3D_MANAGER,
                               g_pDXGIMan);
  if FAILED(hr) then
    goto Done;

  // Create the factory object for the capture engine.
  // pr_MediaEngineClassFactory is a reference to the IMFMediaEngineClassFactory interface
  pFactory := CreateCOMObject(CLSID_MFCaptureEngineClassFactory) as IMFCaptureEngineClassFactory;
  if not Assigned(pFactory) then
    goto Done;

  // Create and initialize the capture engine.
  hr := pFactory.CreateInstance(CLSID_MFCaptureEngine,
                                IID_IMFCaptureEngine,
                                Pointer(m_pEngine));

  if FAILED(hr) then
    goto Done;

  hr := m_pEngine.Initialize(m_pCallback,
                             pAttributes,
                             Nil,
                             Unk);

  if FAILED(hr) then
    goto Done;

  if DeviceParam.DeviceIsSelected then
    hr := GetCaptureDeviceCaps(DeviceParam.DeviceIndex);

  // ignore returnvalue MF_E_INVALIDREQUEST in case user did not select a device .
  if (hr <> S_OK)  then
    hr := S_OK;

Done:

{$IF DEBUG}
  if FAILED(hr) then
    OutputDebugString(PWideChar(format('Error: %s (hr = %d)', [ERR_INITIALIZE, hr])));
{$ENDIF}
  Result := hr;
end;


constructor TCaptureManager.Create(_hwnd: HWND);
begin
  inherited Create();
  FCritSec := TMFCritSec.Create;
  m_hwndEvent := _hwnd;
  m_hwndPreview := 0;
  m_bRecording := False;
  m_bPreviewing := False;
  m_bPhotoPending := False;
  m_errorID := 0;
  m_hEvent := 0;
end;


destructor TCaptureManager.Destroy();
begin
  DestroyCaptureEngine();
  SafeDelete(FCritSec);
  inherited;
end;


procedure TCaptureManager.DestroyCaptureEngine();
begin
  if m_hEvent <> 0 then
     begin
       CloseHandle(m_hEvent);
       m_hEvent := 0;
     end;

  if Assigned(m_pPreview) then
    SafeRelease(m_pPreview);

  if Assigned(m_pEngine) then
    SafeRelease(m_pEngine);

  if Assigned(m_pCallback) then
    SafeDelete(m_pCallback);

  if Assigned(g_pDXGIMan) then
    begin
      g_pDXGIMan.ResetDevice(g_pDX11Device,
                             g_ResetToken);
    end;

  // release the D3D11 interfaces
  SafeRelease(g_pDX11Device);
  SafeRelease(g_pDXGIMan);

  m_bPreviewing := False;
  m_bRecording := False;
  m_bPhotoPending := False;
  m_errorID := 0;

end;


procedure TCaptureManager.SetErrorID(hr: HResult; id: UINT);
begin
  if SUCCEEDED(hr) then
    m_errorID := 0
  else
    m_errorID := id;
end;


// Capture Engine Event Handlers
procedure TCaptureManager.OnCaptureEngineInitialized(hrStatus: HResult);
begin
  if (hrStatus = MF_E_NO_CAPTURE_DEVICES_AVAILABLE) then
    hrStatus := S_OK;  // No capture device. Not an application error.
end;


procedure TCaptureManager.OnPreviewStarted(hrStatus: HResult);
begin
  m_bPreviewing := SUCCEEDED(hrStatus);
end;


procedure TCaptureManager.OnPreviewStopped(hrStatus: HResult);
begin
  m_bPreviewing := False;
end;


procedure TCaptureManager.OnRecordStarted(hrStatus: HResult);
begin
  m_bRecording := SUCCEEDED(hrStatus);
end;


procedure TCaptureManager.OnRecordStopped(hrStatus: HResult);
begin
   m_bRecording := False;
end;


function TCaptureManager.StartPreview(): HResult;
var
  pSink: IMFCaptureSink;
  pMediaType: IMFMediaType;
  pMediaType2: IMFMediaType;
  pSource: IMFCaptureSource;
  dwSinkStreamIndex: DWord;
  hr: HResult;

label
  Done;

begin

  if Not Assigned(m_pEngine) then
    begin
      hr := MF_E_NOT_INITIALIZED;
      goto Done;
    end;

  if m_bPreviewing then
    begin
      hr := S_OK;
      goto Done;
    end;

  // Get a pointer to the preview sink.
  if Not Assigned(m_pPreview) then
    begin
      hr := m_pEngine.GetSink(MF_CAPTURE_ENGINE_SINK_TYPE_PREVIEW,
                              pSink);
      if FAILED(hr) then
        goto Done;


      hr := pSink.QueryInterface(IID_IMFCapturePreviewSink,
                                 m_pPreview);
      if FAILED(hr) then
        goto Done;

      hr := m_pPreview.SetRenderHandle(m_hwndPreview);

      if FAILED(hr) then
        goto Done;

      hr := m_pEngine.GetSource(pSource);

      if FAILED(hr) then
        goto Done;

      // Configure the video format for the preview sink.
      hr := pSource.GetCurrentDeviceMediaType(DWord(MF_CAPTURE_ENGINE_PREFERRED_SOURCE_STREAM_FOR_VIDEO_PREVIEW),
                                              pMediaType);
      if FAILED(hr) then
        goto Done;

      hr := CloneVideoMediaType(pMediaType,
                                MFVideoFormat_RGB32,
                                pMediaType2);
      if FAILED(hr) then
        goto Done;

      hr := pMediaType2.SetUINT32(MF_MT_ALL_SAMPLES_INDEPENDENT,
                                  UINT(True));
      if FAILED(hr) then
        goto Done;

      // Connect the video stream to the preview sink.
      hr := m_pPreview.AddStream(DWORD(MF_CAPTURE_ENGINE_PREFERRED_SOURCE_STREAM_FOR_VIDEO_PREVIEW),
                                 pMediaType2,
                                 Nil,
                                 dwSinkStreamIndex);

      if FAILED(hr) then
        goto Done;
    end;


  hr := m_pEngine.StartPreview();

Done:
  Result := hr;
end;


function TCaptureManager.StopPreview(): HResult;
var
  hr: HResult;

label
  Done;

begin

  if Not Assigned(m_pEngine) then
    begin
      hr := MF_E_NOT_INITIALIZED;
      goto Done;
    end;

  if m_bPreviewing then
    begin
      hr := S_OK;
      goto Done;
    end;

  hr := m_pEngine.StopPreview();

  if FAILED(hr) then
    goto Done;

  WaitForResult();

done:
  Result := hr;
end;


// Handle an event from the capture engine.
// NOTE: This method is called from the application's UI thread.
function TCaptureManager.OnCaptureEvent(wParam: WPARAM;
                                        lParam: LPARAM): HResult;
var
  guidType: TGUID;
  hrStatus: HResult;
  hr: HResult;
  pEvent: IMFMediaEvent;

begin

  pEvent := IMFMediaEvent(wParam);

  hr := pEvent.GetStatus(hrStatus);
  if FAILED(hr) then
    hrStatus := hr;


  hr := pEvent.GetExtendedType(guidType);
  if SUCCEEDED(hr) then
    begin

{$IF DEBUG}
      if SUCCEEDED(StringFromCLSID(guidType,
                                   str)) then
        begin
          OutputDebugString(format('MF_CAPTURE_ENGINE_EVENT: %s (hr = %d)', [str, hrStatus]));
          CoTaskMemFree(str);
        end;
{$ENDIF}

        if (guidType = MF_CAPTURE_ENGINE_INITIALIZED) then
          begin
            OnCaptureEngineInitialized(hrStatus);
            SetErrorID(hrStatus,
                       IDS_ERR_INITIALIZE);
          end
        else if (guidType = MF_CAPTURE_ENGINE_PREVIEW_STARTED) then
          begin
            OnPreviewStarted(hrStatus);
            SetErrorID(hrStatus,
                       IDS_ERR_PREVIEW);
          end
        else if (guidType = MF_CAPTURE_ENGINE_PREVIEW_STOPPED) then
          begin
            OnPreviewStopped(hrStatus);
            SetErrorID(hrStatus, IDS_ERR_PREVIEW);
          end
        else if (guidType = MF_CAPTURE_ENGINE_RECORD_STARTED)  then
          begin
            OnRecordStarted(hrStatus);
            SetErrorID(hrStatus, IDS_ERR_RECORD);
          end
        else if (guidType = MF_CAPTURE_ENGINE_RECORD_STOPPED) then
          begin
            OnRecordStopped(hrStatus);
            SetErrorID(hrStatus, IDS_ERR_RECORD);
          end
        else if (guidType = MF_CAPTURE_ENGINE_PHOTO_TAKEN) then
          begin
            m_bPhotoPending := false;
            SetErrorID(hrStatus, IDS_ERR_PHOTO);
          end
        else if (guidType = MF_CAPTURE_ENGINE_ERROR) then
          begin
            DestroyCaptureEngine();
            SetErrorID(hrStatus, IDS_ERR_CAPTURE);
          end
        else if (hrstatus = MF_E_INVALIDREQUEST) then
          begin
            SetErrorID(hrStatus, IDS_ERR_CAPTURE);
          end
        else if (FAILED(hrStatus)) then
         begin
            SetErrorID(hrStatus, IDS_ERR_CAPTURE);
         end
    end;

   SetEvent(m_hEvent);
   Result := hrStatus;
end;


// Start recording to file
function TCaptureManager.StartRecord(pszDestinationFile: PCWSTR): HResult;
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

  if not Assigned(m_pEngine) then
    begin
      hr := MF_E_NOT_INITIALIZED;
      goto Done;
    end;

  if (m_bRecording = True) then
    begin
      hr := MF_E_INVALIDREQUEST;
      goto Done;
    end;

  pszExt := ExtractFileExt(pszDestinationFile);

  // Check extension to match the proper formats
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
  else if LowerCase(pszExt) = '.wma' then
    begin
      guidVideoEncoding := GUID_NULL;
      guidAudioEncoding := MFAudioFormat_WMAudioV9;
    end
  else
    begin
      hr := MF_E_INVALIDMEDIATYPE;
      goto Done;
    end;


  hr := m_pEngine.GetSink(MF_CAPTURE_ENGINE_SINK_TYPE_RECORD,
                          pSink);
  if FAILED(hr) then
    goto Done;

  hr := pSink.QueryInterface(IID_IMFCaptureRecordSink,
                             pRecord);
  if FAILED(hr) then
    goto Done;

  hr := m_pEngine.GetSource(pSource);
  if FAILED(hr) then
    goto Done;

  // Clear any existing streams from previous recordings.
  hr := pRecord.RemoveAllStreams();
  if FAILED(hr) then
    goto Done;

  hr := pRecord.SetOutputFileName(pszDestinationFile);
  if FAILED(hr) then
    goto Done;

  // Configure the video and audio streams.
  if (guidVideoEncoding <> GUID_NULL) then
    begin
      hr := ConfigureVideoEncoding(pSource,
                                   pRecord,
                                   guidVideoEncoding);
      if FAILED(hr) then
        goto Done;
    end;

  if (guidAudioEncoding <> GUID_NULL) then
    begin
      hr := ConfigureAudioEncoding(pSource,
                                   pRecord,
                                   guidAudioEncoding);
      if FAILED(hr) then
        goto Done;
    end;


  hr := m_pEngine.StartRecord();
  if FAILED(hr) then
    goto Done;

  m_bRecording := True;

done:
  Result := hr;
end;


function TCaptureManager.StopRecord(): HResult;
var
  hr: HResult;

begin
  hr := S_OK;

  if m_bRecording then
    begin
      hr := m_pEngine.StopRecord(True,
                                 False);
      WaitForResult();
    end;

  Result := hr;
end;


function TCaptureManager.TakePhoto(snsOptions: TSnapShotOptions;
                                   pExt: PWideChar = Nil): HResult;
var
  hr: HResult;
  pSink: IMFCaptureSink;
  pPhoto: IMFCapturePhotoSink;
  pSource: IMFCaptureSource;
  pMediaType: IMFMediaType;
  pMediaType2: IMFMediaType;
  dwSinkStreamIndex: DWord;
  pszFileName: PWideChar;
  pszPicPath: PWideChar;
  pszOutputFileName: PWideChar;
  fPath: TPath;

label
  Done;

begin

  // Get a pointer to the photo sink.
  hr := m_pEngine.GetSink(MF_CAPTURE_ENGINE_SINK_TYPE_PHOTO,
                          pSink);
  if FAILED(hr) then
    goto Done;

  hr := pSink.QueryInterface(IID_IMFCapturePhotoSink,
                             pPhoto);
  if FAILED(hr) then
    goto Done;

  hr := m_pEngine.GetSource(pSource);
  if FAILED(hr) then
    goto Done;

  hr := pSource.GetCurrentDeviceMediaType(MF_CAPTURE_ENGINE_PREFERRED_SOURCE_STREAM_FOR_PHOTO,
                                          pMediaType);
  if FAILED(hr) then
    goto Done;

  // Configure the photo format
  hr := CreatePhotoMediaType(pMediaType,
                             pMediaType2);
  if FAILED(hr) then
    goto Done;

  hr := pPhoto.RemoveAllStreams();
  if FAILED(hr) then
    goto Done;

  // Try to connect the first still image stream to the photo sink
  hr := pPhoto.AddStream(MF_CAPTURE_ENGINE_PREFERRED_SOURCE_STREAM_FOR_PHOTO,
                         pMediaType2,
                         nil,
                         dwSinkStreamIndex);
  if FAILED(hr) then
    goto Done;


  // Decide where the snapshot should be send through
  case snsOptions of
    ssoFile:     begin
                   // ToDo: implement save to file (eg: My Photo's)
                   // to file

                   // get the My Pictures Folder path use fPath.GetSharedPicturesPath for the shared folder
                   pszPicPath := PWideChar(fPath.GetPicturesPath);
                   pszFileName := LPWSTR(Format('MyPicture_%s%s', [DateToStr(Now()), pExt]));
                   pszOutputFileName :=  LPWSTR(Format('%s%s', [pszPicPath, pszFileName]));
                   hr := pPhoto.SetOutputFileName(pszOutputFileName);
                   if FAILED(hr) then
                     goto Done;

                 end;

    ssoCallBack: begin
                   // ToDo: implement save to ISample > preview window
                   // to callback






                   hr := pPhoto.SetSampleCallback(m_pOnSampleCallback);
                   if FAILED(hr) then
                     goto Done;
                 end;

    ssoStream:   begin
                   // Save to stream
                   // NOT IMPLEMENTED
                 end;
  end;

  hr := m_pEngine.TakePhoto();
  if FAILED(hr) then
    goto Done;

  m_bPhotoPending := True;

done:
  Result := hr;
end;


procedure TCaptureManager.SetSleepState(fSleeping: Boolean);
begin
  if Assigned(m_pCallback) then
    m_pCallback.m_fSleeping := fSleeping;
end;


function TCaptureManager.UpdateVideo(): HResult;
begin
  if Assigned(m_pPreview) then
    Result := m_pPreview.UpdateVideo(nil,
                                     nil,
                                     nil)
  else
    Result := S_OK;
end;

 { TODO 1 -oTony :
This function is not working very well. Somehow m_pSource (IMFCaptureSource) returns
-1072875854 ( $C00D36B2) 'The request is invalid in the current state.'}

// Note:
// dwStreamType parameter can only be one of the following:
//   MF_CAPTURE_ENGINE_PREFERRED_SOURCE_STREAM_FOR_VIDEO_PREVIEW
//   MF_CAPTURE_ENGINE_PREFERRED_SOURCE_STREAM_FOR_VIDEO_RECORD
//   MF_CAPTURE_ENGINE_PREFERRED_SOURCE_STREAM_FOR_PHOTO
//   MF_CAPTURE_ENGINE_PREFERRED_SOURCE_STREAM_FOR_AUDIO
//   MF_CAPTURE_ENGINE_PREFERRED_SOURCE_STREAM_FOR_METADATA
//   MF_CAPTURE_ENGINE_MEDIASOURCE
//
function TCaptureManager.GetCaptureDeviceCaps(const iDevIndex: DWord;
                                              const dwStreamType: DWord = MF_CAPTURE_ENGINE_PREFERRED_SOURCE_STREAM_FOR_VIDEO_RECORD): HResult;
var
  pSource: IMFCaptureSource;
  mediaType: IMFMediaType;
  i: Integer;
  iCount: UINT32;
  hr: HResult;

  //
  iVideoWidth: UINT32;
  iVideoHeight: UINT32;
  iBufferWidth: UINT32;
  iBufferHeight: UINT32;
  iStride: UINT32;
  // Major & Subtypes
  fSubType: TGuid;
  fMajorType: TGuid;
  // Supported framerates
  iFrameRate: UINT32;
  iFrameRateDenominator: UINT32;
  iMaxFrameRate: UINT32;
  iMaxFrameRateDenominator: UINT32;
  iMinFrameRate: UINT32;
  iMinFrameRateDenominator: UINT32;

begin
try



  if not DeviceParam.DeviceIsSelected then
    begin
      hr := MF_E_INVALIDREQUEST;  // m_pEngine has not been completly initialized eg user did not select a device.
      Exit;
    end;

  hr := m_pEngine.GetSource(pSource);

  if SUCCEEDED(hr) then
    hr := DeviceParam.Device.GetCount(iCount);

  if SUCCEEDED(hr) then
    begin

  FCritSec.Lock;

      i := 0;
      SetLength(a_VideoFormatInfo,
                0);

      // Get all capabillities
      for i := 0 to iCount-1 do
        begin
         // hr := MFCreateMediaType(mediaType);

          hr := pSource.GetAvailableDeviceMediaType(dwStreamType,
                                                    i,
                                                    @mediaType);
          if (hr = MF_E_NO_MORE_TYPES) then
            break;


          hr := mediaType.GetGUID(MF_MT_MAJOR_TYPE,
                                  fMajorType);

          hr := mediaType.GetGUID(MF_MT_SUBTYPE,
                                  fSubType);

          hr := MFGetAttributeSize(mediaType,
                                   MF_MT_FRAME_SIZE,
                                   iVideoWidth,
                                   iVideoHeight);

          // Set these values to 'remember' original width and height.
          iBufferWidth := iVideoWidth;
          iBufferHeight := iVideoHeight;

          iStride := MFGetAttributeUINT32(mediaType,
                                          MF_MT_DEFAULT_STRIDE,
                                          1);

          hr := MFGetAttributeRatio(mediaType,
                                    MF_MT_FRAME_RATE,
                                    iFrameRate,
                                    iFrameRateDenominator);

          hr := MFGetAttributeRatio(mediaType,
                                    MF_MT_FRAME_RATE_RANGE_MIN,
                                    iMinFrameRate,
                                    iMinFrameRateDenominator);

          hr := MFGetAttributeRatio(mediaType,
                                    MF_MT_FRAME_RATE_RANGE_MAX,
                                    iMaxFrameRate,
                                    iMaxFrameRateDenominator);



          if SUCCEEDED(hr) then
            begin
              SetLength(a_VideoFormatInfo,
                        i+1);
              a_VideoFormatInfo[i].iVideoWidth := iVideoWidth;
              a_VideoFormatInfo[i].iVideoHeight := iVideoHeight;
              a_VideoFormatInfo[i].iBufferWidth := iBufferWidth;
              a_VideoFormatInfo[i].iBufferHeight := iBufferHeight;
              a_VideoFormatInfo[i].iStride := iStride;
              a_VideoFormatInfo[i].fSubType := fSubType;
              a_VideoFormatInfo[i].fMajorType := fMajorType;
              a_VideoFormatInfo[i].iFrameRate := iFrameRate;
              a_VideoFormatInfo[i].iFrameRateDenominator := iFrameRateDenominator;
              a_VideoFormatInfo[i].iMaxFrameRate := iMaxFrameRate;
              a_VideoFormatInfo[i].iMaxFrameRateDenominator := iMaxFrameRateDenominator;
              a_VideoFormatInfo[i].iMinFrameRate := iMinFrameRate;
              a_VideoFormatInfo[i].iMinFrameRateDenominator := iMinFrameRateDenominator;
            end;

      end;
    end;

finally
  FCritSec.Unlock;
  Result := hr;
end;
end;


procedure TCaptureManager.WaitForResult();
begin
  WaitForSingleObject(m_hEvent,
                      INFINITE);
end;




constructor TChooseDeviceParam.Create();
begin
  inherited;
  Initialize();
end;


destructor TChooseDeviceParam.Destroy();
var
  i: Integer;

begin
{$POINTERMATH ON}
  for i := 0 to count -1 do
    SafeRelease(apDevices[i]);
{$POINTERMATH OFF}
  SafeRelease(apDevice);
  CoTaskMemFree(apDevices);
  inherited;
end;


function TChooseDeviceParam.Initialize(): HResult;
var
  pAttributes: IMFAttributes;
  hr: HResult;

label
  Done;

begin
  hr := MFCreateAttributes(pAttributes,
                           1);
  if FAILED(hr) then
    goto Done;

  // Ask for source type = video capture devices
  hr := pAttributes.SetGUID(MF_DEVSOURCE_ATTRIBUTE_SOURCE_TYPE,
                            MF_DEVSOURCE_ATTRIBUTE_SOURCE_TYPE_VIDCAP_GUID);
  if FAILED(hr) then
    goto Done;

  // Enumerate devices.
  hr := MFEnumDeviceSources(pAttributes,
                            apDevices,
                            uCount);
  if FAILED(hr) then
    goto Done;

  // Set index to first device in the list.
  if uCount > 0 then
    SetSelection(0)
  else
    hr := MF_E_NO_CAPTURE_DEVICES_AVAILABLE;

  bIsSelected := False;

Done:
  Result := hr;
end;


procedure TChooseDeviceParam.SetSelection(iIndex: UINT32);
var
  szStr: LPWSTR;
  uiLen: UINT32;
  hr: HResult;

begin

  if (iIndex < uCount) then
    begin

      SafeRelease(apDevice);
      uSelection := iindex;

{$POINTERMATH ON}

      apDevice := apDevices[iIndex];

      // Try to get the display-friendly-name.
      hr := apDevices[iIndex].GetAllocatedString(MF_DEVSOURCE_ATTRIBUTE_FRIENDLY_NAME,
                                                 szStr,
                                                 uiLen);
      if SUCCEEDED(hr) then
        lpSelectedDeviceName := szStr
      else
        lpSelectedDeviceName := PWideChar(format('Error: hr = %d', [hr]));

      // Try to get the display-friendly-name.
      hr := apDevices[iIndex].GetAllocatedString(MF_DEVSOURCE_ATTRIBUTE_SOURCE_TYPE_VIDCAP_SYMBOLIC_LINK,
                                                 szStr,
                                                 uiLen);
      if SUCCEEDED(hr) then
        lpSelectedSymbolicLink := szStr
      else
        lpSelectedSymbolicLink := PWideChar(format('Error: hr = %d', [hr]));
    end;

{$POINTERMATH OFF}
end;


end.
