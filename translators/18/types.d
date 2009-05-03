typedef struct r_basic{
    long flags;
    long klass;
};

translator r_basic < struct RBasic *RB > {
	flags = RB->flags;
	klass = RB->klass;
};

struct RObject {
    struct RBasic basic;
    struct st_table *iv_tbl;
};

struct RClass {
    struct RBasic basic;
    struct st_table *iv_tbl;
    struct st_table *m_tbl;
    VALUE super;
};

struct RFloat {
    struct RBasic basic;
    double value;
};

struct RString {
    struct RBasic basic;
    long len;
    char *ptr;
    union {
	long capa;
	VALUE shared;
    } aux;
};

struct RArray {
    struct RBasic basic;
    long len;
    union {
	long capa;
	VALUE shared;
    } aux;
    VALUE *ptr;
};

struct RRegexp {
    struct RBasic basic;
    struct re_pattern_buffer *ptr;
    long len;
    char *str;
};

struct RHash {
    struct RBasic basic;
    struct st_table *tbl;
    int iter_lev;
    VALUE ifnone;
};

struct RFile {
    struct RBasic basic;
    struct OpenFile *fptr;
};

struct RData {
    struct RBasic basic;
    void (*dmark) _((void*));
    void (*dfree) _((void*));
    void *data;
};

struct RStruct {
    struct RBasic basic;
    long len;
    VALUE *ptr;
};

struct RBignum {
    struct RBasic basic;
    char sign;
    long len;
    void *digits;
};
