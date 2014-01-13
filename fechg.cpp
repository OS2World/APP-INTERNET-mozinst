#pragma strings(writeable)

#include <string.h>
#include <stdio.h>
#include <os2win.h>

int main(int argc,char *argv[])
{
   /*
      for whatever reason, this OPEN32 application has to be marked
      as a PM application and we HAVE to call below function
      to start the actual application
   */
   return WinCallWinMain(argc,argv, WinMain, SW_SHOWNORMAL);
}

int WINAPI WinMain(HINSTANCE hInst,HINSTANCE hPreInst,LPSTR lpszCmdLine,int nCmdShow)
{
   int rc=0;
   LONG res=0;
   HKEY key=0,key2=0;
   CHAR arg1[256],arg2[256];
   BOOL fToDelete=FALSE;

   if (sscanf(lpszCmdLine,"%s%s",arg1,arg2) != 2)
   {
      rc = MessageBox(0,"Invocation: fechg.exe [-i|-d] application name\n"
                        "\t-i: install font engine support\n"
                        "\t-d: remove font engine support\n"
                        "Example: fechg.exe -d firefox",NULL ,MB_OK);
      return 1;
   }

   if (strcmpi(arg1,"-d") == 0)
   {
      fToDelete = TRUE;
   }
   else if (strcmpi(arg1,"-i") == 0)
   {
      fToDelete = FALSE;
   }
   else
   {
      return 1;
   }

   strcat(arg2,".exe");

   if (fToDelete)
   {
      res = RegOpenKey(HKEY_LOCAL_MACHINE,"SOFTWARE\\InnoTek\\InnoTek Font Engine\\Applications",&key);
      res = RegDeleteKey(key,arg2);
      res = RegCloseKey(key);
      res = RegOpenKey(HKEY_CURRENT_USER,"SOFTWARE\\InnoTek\\InnoTek Font Engine\\Applications",&key);
      res = RegDeleteKey(key,arg2);
      res = RegCloseKey(key);
   }
   else
   {
      DWORD Val;
      res = RegOpenKey(HKEY_LOCAL_MACHINE,"SOFTWARE\\InnoTek\\InnoTek Font Engine\\Applications",&key);
      res = RegCreateKey(key,arg2,&key2);
      Val = 1U;
      res = RegSetValueEx(key2,"Enabled",0,REG_DWORD,(const BYTE *)&Val,sizeof(Val));
      res = RegCloseKey(key2);
      res = RegCloseKey(key);
      res = RegOpenKey(HKEY_CURRENT_USER,"SOFTWARE\\InnoTek\\InnoTek Font Engine\\Applications",&key);
      res = RegCreateKey(key,arg2,&key2);
      Val = 1U;
      res = RegSetValueEx(key2,"Enabled",0,REG_DWORD,(const BYTE *)&Val,sizeof(Val));
      res = RegCloseKey(key2);
      res = RegCloseKey(key);
   }
   return 0;
}

