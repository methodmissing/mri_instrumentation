struct st_table_entry {
    unsigned int hash;
    st_data_t key;
    st_data_t record;
    st_table_entry *next;
};

typedef struct st_table_entry{
    int hash;
    long key;
    long record;
    caddr_t next;
};

typedef struct st_hash_type{
    int compare;
    int hash;
};

typedef struct st_hash_type{
    int compare;
    int hash;
};


struct st_table {
    struct st_hash_type *type;
    int num_bins;
    int num_entries;
    struct st_table_entry **bins;
};
