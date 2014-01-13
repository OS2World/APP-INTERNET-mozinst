.SUFFIXES:
.SUFFIXES: .cpp .obj

.cpp.obj:
       icc.exe /Q /Ge /Gm /Gd /G5 /C $<

fechg.exe: fechg.obj {$(LIB)}pmwinx.lib
#OPEN32 applications have to be marked as PM applications !
       ilink.exe /NOL /EXE /E:2 /ST:0x10000 /BAS:0x10000 /PM:PM /M /O:$@ $**
       dllrname.exe /N /Q $@ CPPOM30=OS2OM30

