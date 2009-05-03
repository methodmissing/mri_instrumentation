inline int FMODE_READABLE = 1;
#pragma D binding "1.0" FMODE_READABLE
inline int FMODE_WRITABLE = 2;
#pragma D binding "1.0" FMODE_WRITABLE
inline int FMODE_READWRITE = 3;
#pragma D binding "1.0" FMODE_READWRITE
inline int FMODE_APPEND = 64;
#pragma D binding "1.0" FMODE_APPEND
inline int FMODE_CREATE = 128;
#pragma D binding "1.0" FMODE_CREATE
inline int FMODE_BINMODE = 4;
#pragma D binding "1.0" FMODE_BINMODE
inline int FMODE_SYNC = 8;
#pragma D binding "1.0" FMODE_SYNC
inline int FMODE_WBUF = 16;
#pragma D binding "1.0" FMODE_WBUF
inline int FMODE_RBUF = 32;
#pragma D binding "1.0" FMODE_RBUF
inline int FMODE_WSPLIT = 32;
#pragma D binding "1.0" FMODE_WSPLIT
inline int FMODE_WSPLIT_INITIATLIZED = 32;
#pragma D binding "1.0" FMODE_WSPLIT_INITIALIZED

typedef struct open_file{
    int mode;
    int pid;
    int lineno;
    char path;
};

#pragma D binding "1.0" translator
translator open_file < struct OpenFile *OF > {
	mode = OF->mode;
	pid = OF->pid;
	lineno = OF->lineno;
	path = OF->path;
}; 