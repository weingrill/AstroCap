unit Videohdr;


interface

uses windows;

type
PVIDEOHDR = ^TVIDEOHDR;
TVIDEOHDR = record
    lpData:pByte;                 // pointer to locked data buffer
    dwBufferLength:DWORD;         // Length of data buffer
    dwBytesUsed:DWORD;            // Bytes actually used
    dwTimeCaptured:DWORD;         // Milliseconds from start of stream
    dwUser:DWORD;                 // for client's use
    dwFlags:DWORD;                // assorted flags (see defines)
    dwReserved: array [0..4] of DWORD;    // reserved for driver
end;

const
  VHDR_KEYFRAME=   $00000008;  // Key Frame

implementation

end.
 