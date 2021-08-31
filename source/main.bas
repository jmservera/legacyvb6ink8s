Attribute VB_Name = "MainModule"
' check https://www.tek-tips.com/faqs.cfm?fid=5647 to know how to link a
' console application in VB6. You can use the flags
' LINK /EDIT /SUBSYSTEM:CONSOLE {your exe's filename}
'
' This code requires a reference to Microsoft Scripting Runtime
' used for console output
Private sout As Scripting.TextStream

Option Explicit

Private Declare Sub GetLocalTime Lib "kernel32" (lpSystemTime As SYSTEMTIME)
Private Type SYSTEMTIME
    wYear As Integer
    wMonth As Integer
    wDayOfWeek As Integer
    wDay As Integer
    wHour As Integer
    wMinute As Integer
    wSecond As Integer
    wMilliseconds As Integer
End Type

Sub Main()
   On Error GoTo ProcError
   Dim server1 As New Server
      
   Dim FSO As New Scripting.FileSystemObject
   Set sout = FSO.GetStandardStream(StdOut)
       
   LogMessage "server_start", CStr(Now)
   Load server1
   

ProcExit:
   LogMessage "server_exit", CStr(Now)
   Set sout = Nothing
  Exit Sub

ProcError:
  LogError Err.Number, Err.Source, Err.Description
  Resume ProcExit
End Sub

' SYSLOGTIMESTAMP LOGLEVEL NAME VALUE
' SYSLOGTIMESTAMP LOGLEVEL:ERROR Number Source Description

Private Sub Log(value As String)
    Dim logmsg As String

    logmsg = GetIsoTimestamp() & " " & value

    On Error Resume Next
    sout.WriteLine (logmsg)
    On Error GoTo 0

    Open "C:\temp\myapp.log" For Append As #1
    Print #1, logmsg & " " & vbLf;
    Close #1
    
End Sub

Private Function GetIsoTimestamp() As String
    Dim st As SYSTEMTIME

    ' Get the local date and time.
    GetLocalTime st

    ' Format the result.
    GetIsoTimestamp = _
        Format$(st.wYear, "0000") & "-" & _
        Format$(st.wMonth, "00") & "-" & _
        Format$(st.wDay, "00") & "T" & _
        Format$(st.wHour, "00") & ":" & _
        Format$(st.wMinute, "00") & ":" & _
        Format$(st.wSecond, "00") & "." & _
        Right$("000" & Format$(st.wMilliseconds), 3)
End Function

Public Sub LogError(errno As Integer, errsrc As String, desc As String)
    Dim value As String

    value = "ERROR " & CStr(errno) & " '" & errsrc & "' '" & desc & "'"
        
    Log (value)
    
End Sub

Public Sub LogMessage(name As String, value As String)
    Log ("INFO " & name & ": " & "'" & value & "'")
End Sub

Public Sub LogTrace(name As String, value As String)
    Log ("TRACE " & name & ": " & "'" & value & "'")
End Sub


