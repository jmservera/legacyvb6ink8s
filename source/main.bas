Attribute VB_Name = "MainModule"
' check https://www.tek-tips.com/faqs.cfm?fid=5647 to know how to link a
' console application in VB6. You can use the flags
' LINK /EDIT /SUBSYSTEM:CONSOLE {your exe's filename}
'
' This code requires a reference to Microsoft Scripting Runtime
' used for console output
Private sout As Scripting.TextStream

Option Explicit

Sub Main()
   On Error GoTo ProcError
   Dim server1 As New Server
      
   Dim FSO As New Scripting.FileSystemObject
   Set sout = FSO.GetStandardStream(StdOut)

   Log ("Starting Server")
   Load server1

ProcExit:
   Set sout = Nothing
  Exit Sub

ProcError:
  Log (Err.Description)
  Resume ProcExit
End Sub

Public Sub Log(value As String)
    On Error Resume Next
    sout.WriteLine (value)
End Sub

