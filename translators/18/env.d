extern struct FRAME {
    VALUE self;
    int argc;
    ID last_func;
    ID orig_func;
    VALUE last_class;
    struct FRAME *prev;
    struct FRAME *tmp;
    struct RNode *node;
    int iter;
    int flags;
    unsigned long uniq;
} *ruby_frame;

extern struct SCOPE {
    struct RBasic super;
    ID *local_tbl;
    VALUE *local_vars;
    int flags;
} *ruby_scope;

struct RVarmap {
    struct RBasic super;
    ID id;
    VALUE val;
    struct RVarmap *next;
};
