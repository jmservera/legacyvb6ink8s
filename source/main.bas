Attribute VB_Name = "Module1"
' check https://www.tek-tips.com/faqs.cfm?fid=5647 to know how to link it
' LINK /EDIT /SUBSYSTEM:CONSOLE {your exe's filename}
'Requires a reference to Microsoft Scripting Runtime.
Option Explicit
Sub Main()
   On Error GoTo ProcError
   Dim sArgs As String
   sArgs = Command
   
   Dim FSO As New Scripting.FileSystemObject
   Dim sin As Scripting.TextStream
   Dim sout As Scripting.TextStream
   Dim strWord As String
   Dim iloop As Integer
      
   'Set sin = FSO.GetStandardStream(StdIn)
   Set sout = FSO.GetStandardStream(StdOut)
   sout.WriteLine "Hello!"
   sout.WriteLine sArgs
      
'   sout.WriteLine "What's the word?"
   'strWord = sin.ReadLine()
   sout.WriteLine "So, the word is " & strWord
   Set sout = Nothing
   Set sin = Nothing
ProcExit:
  Exit Sub

ProcError:
  MsgBox Err.Description
  Resume ProcExit
End Sub

