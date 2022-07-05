/* Recommended project settings */


/* Project output */
.\$(Platform)\$(Config)

/* Unit output */
.\$(Platform)\$(Config)



/* MfPack description */

Media Foundation
================
Microsoft Media Foundation is part of the brand new platforms to play, 
record, stream etc. multimedia of any kind.

MfPack
====== 
What it is MFPack is using the name Media Foundation, to cover all platforms related to 
Multimedia for the Windows Operating System (OS) starting from Windows Vista.

This is what MfPack covers
==========================
Microsoft Media Foundation: An end-to-end media pipeline, which supports playback, 
audio/video capture, and encoding (successor to DirectShow).

Windows Media Library Sharing Services
====================================== 
Enables applications to discover media devices on the home network, 
and share media libraries on the home network and the Internet.

Core Audio APIs
===============
A low-level API for audio capture and audio rendering, 
which can be used to achieve minimum latency or to implement features that 
might not be entirely supported by higher-level media APIs.

Multimedia Device (MMDevice) API.
================================= 
Clients use this API to enumerate the audio endpoint devices in the system.

Windows Audio Session API (WASAPI). 
===================================
Clients use this API to create and manage audio streams to and from audio endpoint devices.

DeviceTopology API. 
===================
Clients use this API to directly access the topological features 
(for example, volume controls and multiplexers) that lie along the data paths 
inside hardware devices in audio adapters.

EndpointVolume API. 
===================
Clients use this API to directly access the volume controls on audio endpoint devices. 
This API is primarily used by applications that manage exclusive-mode audio streams.

DirectX 
=======
The folllowing API's are included, to support Media Foundation.

 - D2D1 API
 - DirectComposition API
 - DirectWrite API
 - DXGI API
 - XAudio2 API

Notes
===== 
DirectShow and Clootie DirectX platforms are not included with MfPack. 
DirectShow and Clootie DirectX are not necessarily needed for MfPack, 
except for some interfaces that are not yet translated to the latest API's or a sample like DuckingMediaPlayer.

Until Windows 10, both platforms will be operational within the Windows family (that is what MS says). 
If you're not intended to develop applications that rely on Media Foundation or you are a happy owner of a 
Delphi version that does not includes the translations of DirectShow, 
DirectSound and DirectX, then we advise you to get the latest DirectShow, DirectSound and DirectX versions:
Clootie (http://www.clootie.ru/delphi/index.html) and 
DSPack 2.3.1 on SourceForce (https://sourceforge.net/projects/dspack/) 
or for a maintained version up to Delphi XE8 DSPack 2.3.3  on Github (https://github.com/micha137/dspack-continued-mirror-for-delphinus).


<EOF>