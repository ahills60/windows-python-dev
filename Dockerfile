# Microsoft Windows Container with Anaconda Python

FROM microsoft/windowsservercore:1809-amd64 AS base

WORKDIR /tmp

RUN powershell (New-Object System.Net.WebClient).DownloadFile('https://repo.anaconda.com/archive/Anaconda3-2018.12-Windows-x86_64.exe', 'anaconda3.exe')

RUN powershell Unblock-File anaconda3.exe

RUN anaconda3.exe /InstallationType=AllUsers /RegisterPython=1 /S /D=C:\anaconda3

RUN del anaconda3.exe

WORKDIR /

RUN mkdir mingw

COPY apps/mingw64/ mingw/mingw64/

# Note the below echo[ will print an empty line
RUN (echo [build] & echo compiler = mingw32 & echo[ & echo [build_ext] & echo compiler = mingw32) > C:\anaconda3\Lib\distutils\distutils.cfg

COPY apps/git/ git/
COPY apps/git-lfs/ git/git-lfs/

# Set paths for future use
RUN setx /M PATH "%PATH%;C:\anaconda3;C:\anaconda3\Scripts;C:\anaconda3\Library\bin;C:\mingw\mingw64\bin;C:\git\cmd;C:\git\git-lfs"
RUN setx /M GITDIR "c:\git"

# For now, use these paths
RUN set PATH=%PATH%;C:\anaconda3;C:\anaconda3\Scripts;C:\anaconda3\Library\bin;C:\mingw\mingw64\bin;C:\git\cmd;C:\git\git-lfs
RUN set GITDIR=c:\git

WORKDIR /git/git-lfs

RUN git lfs install

WORKDIR /

CMD ["cmd"]
