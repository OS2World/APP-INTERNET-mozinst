/* REXX install script */
/* supports Rich Walsh's run!.exe: specify any parameters on the install commandline.                           */
/* Example: to set LIBPATHSTRICT, to display icon hatched until program end, to pipe stdout/stderr to log file: */
/* install.cmd lkg                                                                                              */
/* Make sure that the options appear in the order as you have renamed the run!.exe executable                   */


rc = stream('application.ini','C','OPEN READ')
if rc = 'READY:' then do
   if RxFuncAdd('SysLoadFuncs','REXXUTIL','SysLoadFuncs') then do
      rc = SysLoadFuncs()
   end
   runopts = arg(1)
   if (runopts <> '') then do
      runopts = '!'runopts
   end
   appname = ''
   version = ''
   do while lines('application.ini') = 1
      line = linein('application.ini')
      if appname = '' then parse var line 'Name='appname 
      if version = '' then parse var line 'Version='version
   end
   rc = stream('application.ini','C','CLOSE')
   if (appname <> '') & (version <> '') then do
      curdir = directory()
      fullname = curdir'\'appname||runopts'.exe'
      title    = appname' 'version
      appuppercase = translate(appname)
      if appuppercase = 'SEAMONKEY' | appuppercase = 'FIREFOX' then do
         rc = SysCreateObject('WPProgram',title,'<WP_DESKTOP>','EXENAME='fullname';STARTUPDIR='curdir';PARAMETERS=-browser;','R')
      end
      if appuppercase = 'SEAMONKEY' then do
         rc = SysCreateObject('WPProgram',title' Composer','<WP_DESKTOP>','EXENAME='fullname';STARTUPDIR='curdir';PARAMETERS=-edit;','R')
      end
      if appuppercase = 'SEAMONKEY' | appuppercase = 'THUNDERBIRD' then do
         rc = SysCreateObject('WPProgram',title' Mail','<WP_DESKTOP>','EXENAME='fullname';STARTUPDIR='curdir';PARAMETERS=-mail;','R')
      end
      rc = SysCreateObject('WPProgram',title' Profile Manager','<WP_DESKTOP>','EXENAME='fullname';STARTUPDIR='curdir';PARAMETERS=-ProfileManager;','R')
      say 'Removing Innotek Font Engine support for this application'
      say 'It is no longer needed and removing prevents application traps'
      say 'You can reactivate Innotek Font Engine support at any time'
      say 'Run fechg.exe for help'
      '@fechg.exe -d 'appname
      ret = 0
   end
   else do
      say 'Could not query application name/version info from application.ini'
      ret = 1
   end
end
else do
   say 'File application.ini could not be found'
   say 'Make sure that you copy install.cmd and fechg.exe'
   say 'to the root path of Firefox/Thunderbird/Seamonkey'
   say 'and that file application.ini does exist in this directory'
   ret = 1
end

return ret
