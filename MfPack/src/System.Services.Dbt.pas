// FactoryX
//
// Copyright: � FactoryX. All rights reserved.
//
// Project: MfPack - Shared
// Project location: https://sourceforge.net/projects/MFPack
//                   https://github.com/FactoryXCode/MfPack
// Module: System.Services.Dbt.pas
// Kind: Pascal / Delphi unit
// Release date: 18-06-2016
// Language: ENU
//
// Revision Version: 3.1.7
// Description: Equates for WM_DEVICECHANGE and BroadcastSystemMessage
//              This header is part of the System Services API.
//              For more information, see: https://docs.microsoft.com/en-us/windows/win32/api/_base/
//
// Organisation: FactoryX
// Initiator(s): Tony (maXcomX), Peter (OzShips)
// Contributor(s): Tony Kalf (maXcomX), Peter Larson (ozships), Jasper S
//
//------------------------------------------------------------------------------
// CHANGE LOG
// Date       Person              Reason
// ---------- ------------------- ----------------------------------------------
// 30/06/2024 All                 RammStein release  SDK 10.0.26100.0 (Windows 11)
//------------------------------------------------------------------------------
//
// Remarks: Requires Windows 10 or later.
// 
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
// Source: Dbt.h  Version:    4.00
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
unit System.Services.Dbt;

  {$HPPEMIT '#include "Dbt.h"'}

interface

uses

  {Winapi}
  Winapi.Windows,
  WinApi.WinApiTypes;

  {$MINENUMSIZE 4}

  {$IFDEF WIN32}
    {$ALIGN 1}
  {$ELSE}
    {$ALIGN 8} // Win64
  {$ENDIF}


const

  //
  // BroadcastSpecialMessage constants.
  //
  WM_DEVICECHANGE                     = $0219;
  {$EXTERNALSYM WM_DEVICECHANGE}


  // Broadcast message and receipient flags.
  //
  // Note that there is a third "flag". If the wParam has:
  //
  // bit 15 on:   lparam is a pointer and bit 14 is meaningfull.
  // bit 15 off:  lparam is just a UNLONG data type.
  //
  // bit 14 on:   lparam is a pointer to an ASCIIZ string.
  // bit 14 off:  lparam is a pointer to a binary struture starting with
  //              a dword describing the length of the structure.


  BSF_QUERY                           = $00000001;
  {$EXTERNALSYM BSF_QUERY}
  BSF_IGNORECURRENTTASK               = $00000002;  // Meaningless for VxDs
  {$EXTERNALSYM BSF_IGNORECURRENTTASK}
  BSF_FLUSHDISK                       = $00000004;  // Shouldn't be used by VxDs
  {$EXTERNALSYM BSF_FLUSHDISK}
  BSF_NOHANG                          = $00000008;
  {$EXTERNALSYM BSF_NOHANG}
  BSF_POSTMESSAGE                     = $00000010;
  {$EXTERNALSYM BSF_POSTMESSAGE}
  BSF_FORCEIFHUNG                     = $00000020;
  {$EXTERNALSYM BSF_FORCEIFHUNG}
  BSF_NOTIMEOUTIFNOTHUNG              = $00000040;
  {$EXTERNALSYM BSF_NOTIMEOUTIFNOTHUNG}
  BSF_MSGSRV32ISOK                    = $80000000;  // Called synchronously from PM API
  {$EXTERNALSYM BSF_MSGSRV32ISOK}
  BSF_MSGSRV32ISOK_BIT                = 31;         // Called synchronously from PM API
  {$EXTERNALSYM BSF_MSGSRV32ISOK_BIT}

  BSM_ALLCOMPONENTS                   = $00000000;
  {$EXTERNALSYM BSM_ALLCOMPONENTS}
  BSM_VXDS                            = $00000001;
  {$EXTERNALSYM BSM_VXDS}
  BSM_NETDRIVER                       = $00000002;
  {$EXTERNALSYM BSM_NETDRIVER}
  BSM_INSTALLABLEDRIVERS              = $00000004;
  {$EXTERNALSYM BSM_INSTALLABLEDRIVERS}
  BSM_APPLICATIONS                    = $00000008;
  {$EXTERNALSYM BSM_APPLICATIONS}


  // Message = WM_DEVICECHANGE
  // wParam  = DBT_APPYBEGIN
  // lParam  = (not used)
  //
  //      'Appy-time is now available.  This message is itself sent
  //      at 'Appy-time.
  //
  // Message = WM_DEVICECHANGE
  // wParam  = DBT_APPYEND
  // lParam  = (not used)
  //
  //      'Appy-time is no longer available.  This message is //NOT// sent
  //      at 'Appy-time.  (It cannot be, because 'Appy-time is gone.)
  //
  // NOTE!  It is possible for DBT_APPYBEGIN and DBT_APPYEND to be sent
  // multiple times during a single Windows session.  Each appearance of
  // 'Appy-time is bracketed by these two messages, but 'Appy-time may
  // momentarily become unavailable during otherwise normal Windows
  // processing.  The current status of 'Appy-time availability can always
  // be obtained from a call to _SHELL_QueryAppyTimeAvailable.

  DBT_APPYBEGIN                       = $0000;
  {$EXTERNALSYM DBT_APPYBEGIN}
  DBT_APPYEND                         = $0001;
  {$EXTERNALSYM DBT_APPYEND}


  // Message = WM_DEVICECHANGE
  // wParam  = DBT_DEVNODES_CHANGED
  // lParam  = 0
  //
  //      send when configmg finished a process tree batch. Some devnodes
  //      may have been added or removed. This is used by ring3 people which
  //      need to be refreshed whenever any devnode changed occur (like
  //      device manager). People specific to certain devices should use
  //      DBT_DEVICE// instead.

  DBT_DEVNODES_CHANGED                = $0007;
  {$EXTERNALSYM DBT_DEVNODES_CHANGED}


  // Message = WM_DEVICECHANGE
  // wParam  = DBT_QUERYCHANGECONFIG
  // lParam  = 0
  //
  //    sent to ask if a config change is allowed

  DBT_QUERYCHANGECONFIG               = $0017;
  {$EXTERNALSYM DBT_QUERYCHANGECONFIG}


 // Message = WM_DEVICECHANGE
 //wParam  = DBT_CONFIGCHANGED
 // lParam  = 0
 //
 //      sent when a config has changed

  DBT_CONFIGCHANGED                   = $0018;
  {$EXTERNALSYM DBT_CONFIGCHANGED}


 // Message = WM_DEVICECHANGE
 // wParam  = DBT_CONFIGCHANGECANCELED
 // lParam  = 0
 //
 //     someone cancelled the config change

  DBT_CONFIGCHANGECANCELED            = $0019;
  {$EXTERNALSYM DBT_CONFIGCHANGECANCELED}


 // Message = WM_DEVICECHANGE
 // wParam  = DBT_MONITORCHANGE
 // lParam  = new resolution to use (LOWORD=x, HIWORD=y)
 //           if 0, use the default res for current config
 //
 //      this message is sent when the display monitor has changed
 //      and the system should change the display mode to match it.

  DBT_MONITORCHANGE                   = $001B;
  {$EXTERNALSYM DBT_MONITORCHANGE}


 // Message = WM_DEVICECHANGE
 // wParam  = DBT_SHELLLOGGEDON
 // lParam  = 0
 //
 //      The shell has finished login on: VxD can now do Shell_EXEC.


  DBT_SHELLLOGGEDON                   = $0020;
  {$EXTERNALSYM DBT_SHELLLOGGEDON}


 // Message = WM_DEVICECHANGE
 // wParam  = DBT_CONFIGMGAPI
 // lParam  = CONFIGMG API Packet
 //
 //      CONFIGMG ring 3 call.

  DBT_CONFIGMGAPI32                   = $0022;
  {$EXTERNALSYM DBT_CONFIGMGAPI32}


 // Message = WM_DEVICECHANGE
 // wParam  = DBT_VXDINITCOMPLETE
 // lParam  = 0
 //
 //      CONFIGMG ring 3 call.

  DBT_VXDINITCOMPLETE                 = $0023;
  {$EXTERNALSYM DBT_VXDINITCOMPLETE}


 // Message = WM_DEVICECHANGE
 // wParam  = DBT_VOLLOCK*
 // lParam  = pointer to VolLockBroadcast structure described below
 //
 //      Messages issued by IFSMGR for volume locking purposes on WM_DEVICECHANGE.
 //      All these messages pass a pointer to a struct which has no pointers.

  DBT_VOLLOCKQUERYLOCK                = $8041;
  {$EXTERNALSYM DBT_VOLLOCKQUERYLOCK}
  DBT_VOLLOCKLOCKTAKEN                = $8042;
  {$EXTERNALSYM DBT_VOLLOCKLOCKTAKEN}
  DBT_VOLLOCKLOCKFAILED               = $8043;
  {$EXTERNALSYM DBT_VOLLOCKLOCKFAILED}
  DBT_VOLLOCKQUERYUNLOCK              = $8044;
  {$EXTERNALSYM DBT_VOLLOCKQUERYUNLOCK}
  DBT_VOLLOCKLOCKRELEASED             = $8045;
  {$EXTERNALSYM DBT_VOLLOCKLOCKRELEASED}
  DBT_VOLLOCKUNLOCKFAILED             = $8046;
  {$EXTERNALSYM DBT_VOLLOCKUNLOCKFAILED}


  // Device broadcast header

type

  PDEV_BROADCAST_HDR = ^DEV_BROADCAST_HDR;
  _DEV_BROADCAST_HDR = record
    dbch_size: DWORD;
    dbch_devicetype: DWORD;
    dbch_reserved: DWORD;
  end;
  {$EXTERNALSYM _DEV_BROADCAST_HDR}
  DEV_BROADCAST_HDR = _DEV_BROADCAST_HDR;
  {$EXTERNALSYM DEV_BROADCAST_HDR}


  // Structure for volume lock broadcast

  PVolLockBroadcast = ^VolLockBroadcast;
  VolLockBroadcast = record
    vlb_dbh: _DEV_BROADCAST_HDR;
    vlb_owner: DWORD;              // thread on which lock request is being issued
    vlb_perms: Byte;               // lock permission flags defined below
    vlb_lockType: Byte;            // type of lock
    vlb_drive: Byte;               // drive on which lock is issued
    vlb_flags: Byte;               // miscellaneous flags
  end;
  {$EXTERNALSYM VolLockBroadcast}

  // Values for vlb_perms

const

  LOCKP_ALLOW_WRITES                  = $01;  // Bit 0 set - allow writes
  {$EXTERNALSYM LOCKP_ALLOW_WRITES}
  LOCKP_FAIL_WRITES                   = $00;  // Bit 0 clear - fail writes
  {$EXTERNALSYM LOCKP_FAIL_WRITES}
  LOCKP_FAIL_MEM_MAPPING              = $02;  // Bit 1 set - fail memory mappings
  {$EXTERNALSYM LOCKP_FAIL_MEM_MAPPING}
  LOCKP_ALLOW_MEM_MAPPING             = $00;  // Bit 1 clear - allow memory mappings
  {$EXTERNALSYM LOCKP_ALLOW_MEM_MAPPING}
  LOCKP_USER_MASK                     = $03;  // Mask for user lock flags
  {$EXTERNALSYM LOCKP_USER_MASK}
  LOCKP_LOCK_FOR_FORMAT               = $04;  // Level 0 lock for format
  {$EXTERNALSYM LOCKP_LOCK_FOR_FORMAT}


  // Values for vlb_flags

  LOCKF_LOGICAL_LOCK                  = $00;  // Bit 0 clear - logical lock
  {$EXTERNALSYM LOCKF_LOGICAL_LOCK}
  LOCKF_PHYSICAL_LOCK                 = $01;  // Bit 0 set - physical lock
  {$EXTERNALSYM LOCKF_PHYSICAL_LOCK}


  // Message = WM_DEVICECHANGE
  // wParam  = DBT_NODISKSPACE
  // lParam  = drive number of drive that is out of disk space (1-based)
  //
  // Message issued by IFS manager when it detects that a drive is run out of
  // free space.

  DBT_NO_DISK_SPACE                   = $0047;
  {$EXTERNALSYM DBT_NO_DISK_SPACE}


  // Message = WM_DEVICECHANGE
  // wParam  = DBT_LOW_DISK_SPACE
  // lParam  = drive number of drive that is low on disk space (1-based)
  //
  // Message issued by VFAT when it detects that a drive it has mounted
  // has the remaning free space below a threshold specified by the
  // registry or by a disk space management application.
  // The broadcast is issued by VFAT ONLY when space is either allocated
  // or freed by VFAT.

  DBT_LOW_DISK_SPACE                  = $0048;
  {$EXTERNALSYM DBT_LOW_DISK_SPACE}

  DBT_CONFIGMGPRIVATE                 = $7FFF;
  {$EXTERNALSYM DBT_CONFIGMGPRIVATE}


  // The following messages are for WM_DEVICECHANGE. The immediate list
  // is for the wParam. ALL THESE MESSAGES PASS A POINTER TO A STRUCT
  // STARTING WITH A DWORD SIZE AND HAVING NO POINTER IN THE STRUCT.

  DBT_DEVICEARRIVAL                   = $8000;  // system detected a new device
  {$EXTERNALSYM DBT_DEVICEARRIVAL}
  DBT_DEVICEQUERYREMOVE               = $8001;  // wants to remove, may fail
  {$EXTERNALSYM DBT_DEVICEQUERYREMOVE}
  DBT_DEVICEQUERYREMOVEFAILED         = $8002;  // removal aborted
  {$EXTERNALSYM DBT_DEVICEQUERYREMOVEFAILED}
  DBT_DEVICEREMOVEPENDING             = $8003;  // about to remove, still avail.
  {$EXTERNALSYM DBT_DEVICEREMOVEPENDING}
  DBT_DEVICEREMOVECOMPLETE            = $8004;  // device is gone
  {$EXTERNALSYM DBT_DEVICEREMOVECOMPLETE}
  DBT_DEVICETYPESPECIFIC              = $8005;  // type specific event
  {$EXTERNALSYM DBT_DEVICETYPESPECIFIC}

//#if(WINVER >= 0x40A)
  DBT_CUSTOMEVENT                     = $8006;  // user-defined event
  {$EXTERNALSYM DBT_CUSTOMEVENT}
//#endif {* WINVER >= 0x040A *}


  DBT_DEVTYP_OEM                      = $00000000;  // oem-defined device type
  {$EXTERNALSYM DBT_DEVTYP_OEM}
  DBT_DEVTYP_DEVNODE                  = $00000001;  // devnode number
  {$EXTERNALSYM DBT_DEVTYP_DEVNODE}
  DBT_DEVTYP_VOLUME                   = $00000002;  // logical volume
  {$EXTERNALSYM DBT_DEVTYP_VOLUME}
  DBT_DEVTYP_PORT                     = $00000003;  // serial, parallel
  {$EXTERNALSYM DBT_DEVTYP_PORT}
  DBT_DEVTYP_NET                      = $00000004;  // network resource
  {$EXTERNALSYM DBT_DEVTYP_NET}

//#if(WINVER >= 0x040A)
  DBT_DEVTYP_DEVICEINTERFACE          = $00000005;  // device interface class
  {$EXTERNALSYM DBT_DEVTYP_DEVICEINTERFACE}
  DBT_DEVTYP_HANDLE                   = $00000006;  // file system handle
  {$EXTERNALSYM DBT_DEVTYP_HANDLE}
//#endif {* WINVER >= 0x040A *}


type

  PDEV_BROADCAST_HEADER = ^_DEV_BROADCAST_HEADER;
  _DEV_BROADCAST_HEADER = record
    dbcd_size       : DWORD;
    dbcd_devicetype : DWORD;
    dbcd_reserved   : DWORD;
  end;
  {$EXTERNALSYM _DEV_BROADCAST_HEADER}
  DEV_BROADCAST_HEADER = _DEV_BROADCAST_HEADER;
  {$EXTERNALSYM DEV_BROADCAST_HEADER}


  PDEV_BROADCAST_OEM = ^DEV_BROADCAST_OEM;
  _DEV_BROADCAST_OEM = record
    dbco_size       : DWORD;
    dbco_devicetype : DWORD;
    dbco_reserved   : DWORD;
    dbco_identifier : DWORD;
    dbco_suppfunc   : DWORD;
  end;
  {$EXTERNALSYM _DEV_BROADCAST_OEM}
  DEV_BROADCAST_OEM = _DEV_BROADCAST_OEM;
  {$EXTERNALSYM DEV_BROADCAST_OEM}


  PDEV_BROADCAST_DEVNODE = ^DEV_BROADCAST_DEVNODE;
  _DEV_BROADCAST_DEVNODE = record
    dbcd_size       : DWORD;
    dbcd_devicetype : DWORD;
    dbcd_reserved   : DWORD;
    dbcd_devnode    : DWORD;
  end;
  {$EXTERNALSYM _DEV_BROADCAST_DEVNODE}
  DEV_BROADCAST_DEVNODE = _DEV_BROADCAST_DEVNODE;
  {$EXTERNALSYM DEV_BROADCAST_DEVNODE}


  PDEV_BROADCAST_VOLUME = ^DEV_BROADCAST_VOLUME;
  _DEV_BROADCAST_VOLUME = record
    dbcv_size       : DWORD;
    dbcv_devicetype : DWORD;
    dbcv_reserved   : DWORD;
    dbcv_unitmask   : DWORD;
    dbcv_flags      : WORD;
  end;
  {$EXTERNALSYM _DEV_BROADCAST_VOLUME}
  DEV_BROADCAST_VOLUME = _DEV_BROADCAST_VOLUME;
  {$EXTERNALSYM DEV_BROADCAST_VOLUME}



const

  DBTF_MEDIA                          = $0001;  // media comings and goings
  {$EXTERNALSYM DBTF_MEDIA}
  DBTF_NET                            = $0002;  // network volume
  {$EXTERNALSYM DBTF_NET}


type

  PDEV_BROADCAST_PORT_A = ^_DEV_BROADCAST_PORT_A;
  _DEV_BROADCAST_PORT_A = record
    dbcp_size       : DWORD;  // length of dbcp_name including #0 terminator
    dbcp_devicetype : DWORD;
    dbcp_reserved   : DWORD;
    dbcp_name       : array [0..0] of AnsiChar;
  end;
  {$EXTERNALSYM _DEV_BROADCAST_PORT_A}
  DEV_BROADCAST_PORT_A = _DEV_BROADCAST_PORT_A;
  {$EXTERNALSYM DEV_BROADCAST_PORT_A}


  PDEV_BROADCAST_PORT_W = ^DEV_BROADCAST_PORT_W;
  _DEV_BROADCAST_PORT_W = record
    dbcp_size       : DWORD;
    dbcp_devicetype : DWORD;
    dbcp_reserved   : DWORD;
    dbcp_name       : array [0..0] of WideChar;
  end;
  {$EXTERNALSYM _DEV_BROADCAST_PORT_W}
  DEV_BROADCAST_PORT_W = _DEV_BROADCAST_PORT_W;
  {$EXTERNALSYM DEV_BROADCAST_PORT_W}


{$IFDEF DEFINE_UNICODE}
  PDEV_BROADCAST_PORT = PDEV_BROADCAST_PORT_W;
  DEV_BROADCAST_PORT = DEV_BROADCAST_PORT_W;
  {$EXTERNALSYM DEV_BROADCAST_PORT}
{$ELSE}
  PDEV_BROADCAST_PORT = PDEV_BROADCAST_PORT_A;
  DEV_BROADCAST_PORT = DEV_BROADCAST_PORT_A;
  {$EXTERNALSYM DEV_BROADCAST_PORT}
{$ENDIF}


  PDEV_BROADCAST_NET = ^DEV_BROADCAST_NET;
  _DEV_BROADCAST_NET = record
    dbcn_size       : DWORD;
    dbcn_devicetype : DWORD;
    dbcn_reserved   : DWORD;
    dbcn_resource   : DWORD;
    dbcn_flags      : DWORD;
  end;
  {$EXTERNALSYM _DEV_BROADCAST_NET}
  DEV_BROADCAST_NET = _DEV_BROADCAST_NET;
  {$EXTERNALSYM DEV_BROADCAST_NET}


//#if(WINVER >= $040A)

  PDEV_BROADCAST_DEVICEINTERFACE_A = ^_DEV_BROADCAST_DEVICEINTERFACE_A;
  _DEV_BROADCAST_DEVICEINTERFACE_A = record
    dbcc_size       : DWORD;  // size of dbcc_name including terminating #0
    dbcc_devicetype : DWORD;  // = DBT_DEVTYP_DEVICEINTERFACE
    dbcc_reserved   : DWORD;
    dbcc_classguid  : TGUID;
    dbcc_name       : array [0..0] of AnsiChar;  // char
  end;
  {$EXTERNALSYM _DEV_BROADCAST_DEVICEINTERFACE_A}
  DEV_BROADCAST_DEVICEINTERFACE_A = _DEV_BROADCAST_DEVICEINTERFACE_A;
  {$EXTERNALSYM DEV_BROADCAST_DEVICEINTERFACE_A}

  PDEV_BROADCAST_DEVICEINTERFACE_W = ^_DEV_BROADCAST_DEVICEINTERFACE_W;
  _DEV_BROADCAST_DEVICEINTERFACE_W = record
    dbcc_size       : DWORD;  // size of dbcc_name including terminating #0
    dbcc_devicetype : DWORD;  // = DBT_DEVTYP_DEVICEINTERFACE
    dbcc_reserved   : DWORD;
    dbcc_classguid  : TGUID;
    dbcc_name       : array [0..0] of WideChar;
  end;
  {$EXTERNALSYM _DEV_BROADCAST_DEVICEINTERFACE_W}
  DEV_BROADCAST_DEVICEINTERFACE_W = _DEV_BROADCAST_DEVICEINTERFACE_W;
  {$EXTERNALSYM DEV_BROADCAST_DEVICEINTERFACE_W}


{$IFDEF UNICODE}
  PDEV_BROADCAST_DEVICEINTERFACE = PDEV_BROADCAST_DEVICEINTERFACE_W;
  DEV_BROADCAST_DEVICEINTERFACE = DEV_BROADCAST_DEVICEINTERFACE_W;
  {$EXTERNALSYM DEV_BROADCAST_DEVICEINTERFACE}
{$ELSE}
  PDEV_BROADCAST_DEVICEINTERFACE = PDEV_BROADCAST_DEVICEINTERFACE_A;
  DEV_BROADCAST_DEVICEINTERFACE = DEV_BROADCAST_DEVICEINTERFACE_A;
  {$EXTERNALSYM DEV_BROADCAST_DEVICEINTERFACE}
{$ENDIF}

  PDEV_BROADCAST_HANDLE = ^_DEV_BROADCAST_HANDLE;
  _DEV_BROADCAST_HANDLE = record
    dbch_size       : DWORD;
    dbch_devicetype : DWORD;
    dbch_reserved   : DWORD;
    dbch_handle     : THandle;        // file handle used in call to RegisterDeviceNotification
    dbch_hdevnotify : HDEVNOTIFY;     // returned from RegisterDeviceNotification
    //
    // The following 3 fields are only valid if wParam is DBT_CUSTOMEVENT.
    //
    dbch_eventguid  : TGUID;
    dbch_nameoffset : LONG;                  // offset (bytes) of variable-length string buffer (-1 if none)
    dbch_data       : array [0..0] of Byte;  // variable-sized buffer, potentially containing binary and/or text data
  end;
  {$EXTERNALSYM _DEV_BROADCAST_HANDLE}
  DEV_BROADCAST_HANDLE = _DEV_BROADCAST_HANDLE;
  {$EXTERNALSYM DEV_BROADCAST_HANDLE}

//#if(WINVER >= 0x0501)


  // Define 32-bit and 64-bit versions of the DEV_BROADCAST_HANDLE structure
  // for WOW64.  These must be kept in sync with the above structure.
  //==================================================================

  PDEV_BROADCAST_HANDLE32 = ^_DEV_BROADCAST_HANDLE32;
  _DEV_BROADCAST_HANDLE32 = record
    dbch_size       : DWORD;
    dbch_devicetype : DWORD;
    dbch_reserved   : DWORD;
    dbch_handle     : ULONG32;
    dbch_hdevnotify : ULONG32;
    dbch_eventguid  : TGUID;
    dbch_nameoffset : LONG;
    dbch_data       : array [0..0] of Byte;
  end;
  {$EXTERNALSYM _DEV_BROADCAST_HANDLE32}
  DEV_BROADCAST_HANDLE32 = _DEV_BROADCAST_HANDLE32;
  {$EXTERNALSYM DEV_BROADCAST_HANDLE32}

  PDEV_BROADCAST_HANDLE64 = ^_DEV_BROADCAST_HANDLE64;
  _DEV_BROADCAST_HANDLE64 = record
    dbch_size       : DWORD;
    dbch_devicetype : DWORD;
    dbch_reserved   : DWORD;
    dbch_handle     : ULONG64;
    dbch_hdevnotify : ULONG64;
    dbch_eventguid  : TGUID;
    dbch_nameoffset : LONG;
    dbch_data       : array [0..0] of Byte;
  end;
  {$EXTERNALSYM _DEV_BROADCAST_HANDLE64}
  DEV_BROADCAST_HANDLE64 = _DEV_BROADCAST_HANDLE64;
  {$EXTERNALSYM DEV_BROADCAST_HANDLE64}


//#endif {* WINVER >= 0x0501 *}

//#endif {* WINVER >= 0x040A *}

const

  DBTF_RESOURCE                       = $00000001;  // network resource
  {$EXTERNALSYM DBTF_RESOURCE}
  DBTF_XPORT                          = $00000002;  // new transport coming or going
  {$EXTERNALSYM DBTF_XPORT}
  DBTF_SLOWNET                        = $00000004;  // new incoming transport is slow
  {$EXTERNALSYM DBTF_SLOWNET}                       // (dbcn_resource undefined for now)
  DBT_VPOWERDAPI                      = $8100;      // VPOWERD API for Win95
  {$EXTERNALSYM DBT_VPOWERDAPI}


  //  User-defined message types all use wParam = $FFFF with the
  //  lParam a pointer to the structure below.
  //
  //  dbud_dbh - DEV_BROADCAST_HEADER must be filled in as usual.
  //
  //  dbud_szName contains a case-sensitive ASCIIZ name which names the
  //  message.  The message name consists of the vendor name, a backslash,
  //  then arbitrary user-defined ASCIIZ text.  For example:
  //
  //      "WidgetWare\QueryScannerShutdown"
  //      "WidgetWare\Video Q39S\AdapterReady"
  //
  //  After the ASCIIZ name, arbitrary information may be provided.
  //  Make sure that dbud_dbh.dbch_size is big enough to encompass
  //  all the data.  And remember that nothing in the structure may
  //  contain pointers.

  DBT_USERDEFINED                     = $FFFF;
  {$EXTERNALSYM DBT_USERDEFINED}

type

  PDEV_BROADCAST_USERDEFINED = ^DEV_BROADCAST_USERDEFINED;
  _DEV_BROADCAST_USERDEFINED = record
    dbud_dbh    : _DEV_BROADCAST_HDR ;
    dbud_szName : array [0..0] of AnsiChar;  {* ASCIIZ name *}
    {/*  BYTE        dbud_rgbUserDefined[];*/ /* User-defined contents */}
  end;
  {$EXTERNALSYM _DEV_BROADCAST_USERDEFINED}
  DEV_BROADCAST_USERDEFINED = _DEV_BROADCAST_USERDEFINED;
  {$EXTERNALSYM DEV_BROADCAST_USERDEFINED}




  // Additional Prototypes for ALL interfaces


  // Remarks
  //   Because this structure contains variable length fields, use it as a template for creating a pointer to a user-defined structure.
  //   Note that the structure must not contain pointers.
  //   The following example shows such a user-defined structure.
  //
  // const
  //
  //  NAME_LENGTH                         = 32;
  //  USER_LENGTH                         = 50;
  //
  //type
  //
  //  PWIDGET_WARE_DEV_BROADCAST_USERDEFINED = ^tagWIDGET_WARE_DEV_BROADCAST_USERDEFINED;
  //  tagWIDGET_WARE_DEV_BROADCAST_USERDEFINED = record
  //    DBHeader: _DEV_BROADCAST_HDR;
  //    szName: array[0..NAME_LENGTH - 1] of AnsiChar;
  //    UserDefined: array[0..USER_LENGTH - 1] of Byte;
  //  end;
  //  WIDGET_WARE_DEV_BROADCAST_USERDEFINED = tagWIDGET_WARE_DEV_BROADCAST_USERDEFINED;


  // End of Additional Prototypes

implementation

  // Implement Additional functions here.

end.
