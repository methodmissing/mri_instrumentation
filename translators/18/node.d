typedef struct RNode {
    unsigned long flags;
    char *nd_file;
    union {
	struct RNode *node;
	ID id;
	VALUE value;
	VALUE (*cfunc)(ANYARGS);
	ID *tbl;
    } u1;
    union {
	struct RNode *node;
	ID id;
	long argc;
	VALUE value;
    } u2;
    union {
	struct RNode *node;
	ID id;
	long state;
	struct global_entry *entry;
	long cnt;
	VALUE value;
    } u3;
} NODE;

struct rb_thread {
    rb_thread_t next, prev;
    rb_jmpbuf_t context;
#if (defined _WIN32 && !defined _WIN32_WCE) || defined __CYGWIN__
    unsigned long win32_exception_list;
#endif

    VALUE result;

    size_t stk_len;
    size_t stk_max;
    VALUE *stk_ptr;
    VALUE *stk_pos;
#ifdef __ia64
    size_t bstr_len;
    size_t bstr_max;
    VALUE *bstr_ptr;
    VALUE *bstr_pos;
#endif

    struct FRAME *frame;
    struct SCOPE *scope;
    struct RVarmap *dyna_vars;
    struct BLOCK *block;
    struct iter *iter;
    struct tag *tag;
    VALUE klass;
    VALUE wrapper;
    NODE *cref;

    int flags;		/* misc. states (vmode/rb_trap_immediate/raised) */

    NODE *node;

    int tracing;
    VALUE errinfo;
    VALUE last_status;
    VALUE last_line;
    VALUE last_match;

    int safe;

    enum rb_thread_status status;
    int wait_for;
    int fd;
    fd_set readfds;
    fd_set writefds;
    fd_set exceptfds;
    int select_value;
    double delay;
    rb_thread_t join;

    int abort;
    int priority;
    VALUE thgroup;

    struct st_table *locals;

    VALUE thread;

    VALUE sandbox;
};
