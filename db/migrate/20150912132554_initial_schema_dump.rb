class InitialSchemaDump < ActiveRecord::Migration
  def change
    create_table "pligg_additional_categories", id: false, force: :cascade do |t|
    t.integer "ac_link_id", limit: 4, null: false
    t.integer "ac_cat_id",  limit: 4, null: false
  end

  add_index "pligg_additional_categories", ["ac_link_id", "ac_cat_id"], name: "ac_link_id", unique: true, using: :btree

  create_table "pligg_categories", primary_key: "category__auto_id", force: :cascade do |t|
    t.string  "category_lang",         limit: 2,   default: "en",     null: false
    t.integer "category_id",           limit: 4,   default: 0,        null: false
    t.integer "category_parent",       limit: 4,   default: 0,        null: false
    t.string  "category_name",         limit: 64,  default: "",       null: false
    t.string  "category_safe_name",    limit: 64,  default: "",       null: false
    t.integer "rgt",                   limit: 4,   default: 0,        null: false
    t.integer "lft",                   limit: 4,   default: 0,        null: false
    t.integer "category_enabled",      limit: 4,   default: 1,        null: false
    t.integer "category_order",        limit: 4,   default: 0,        null: false
    t.string  "category_desc",         limit: 255,                    null: false
    t.string  "category_keywords",     limit: 255,                    null: false
    t.string  "category_author_level", limit: 9,   default: "normal", null: false
    t.string  "category_author_group", limit: 255, default: "",       null: false
    t.string  "category_votes",        limit: 4,   default: "",       null: false
    t.string  "category_karma",        limit: 4,   default: "",       null: false
  end

  add_index "pligg_categories", ["category_id"], name: "category_id", using: :btree
  add_index "pligg_categories", ["category_parent"], name: "category_parent", using: :btree
  add_index "pligg_categories", ["category_safe_name"], name: "category_safe_name", using: :btree

  create_table "pligg_comments", primary_key: "comment_id", force: :cascade do |t|
    t.integer  "comment_randkey", limit: 4,     default: 0,           null: false
    t.integer  "comment_parent",  limit: 4,     default: 0
    t.integer  "comment_link_id", limit: 4,     default: 0,           null: false
    t.integer  "comment_user_id", limit: 4,     default: 0,           null: false
    t.datetime "comment_date",                                        null: false
    t.integer  "comment_karma",   limit: 2,     default: 0,           null: false
    t.text     "comment_content", limit: 65535
    t.integer  "comment_votes",   limit: 4,     default: 0,           null: false
    t.string   "comment_status",  limit: 9,     default: "published", null: false
  end

  add_index "pligg_comments", ["comment_date"], name: "comment_date", using: :btree
  add_index "pligg_comments", ["comment_link_id", "comment_date"], name: "comment_link_id_2", using: :btree
  add_index "pligg_comments", ["comment_link_id", "comment_parent", "comment_date"], name: "comment_link_id", using: :btree
  add_index "pligg_comments", ["comment_parent", "comment_date"], name: "comment_parent", using: :btree
  add_index "pligg_comments", ["comment_randkey", "comment_link_id", "comment_user_id", "comment_parent"], name: "comments_randkey", unique: true, using: :btree

  create_table "pligg_config", primary_key: "var_id", force: :cascade do |t|
    t.string "var_page",         limit: 50,    null: false
    t.string "var_name",         limit: 100,   null: false
    t.string "var_value",        limit: 255,   null: false
    t.string "var_defaultvalue", limit: 50,    null: false
    t.string "var_optiontext",   limit: 200,   null: false
    t.string "var_title",        limit: 200,   null: false
    t.text   "var_desc",         limit: 65535, null: false
    t.string "var_method",       limit: 10,    null: false
    t.string "var_enclosein",    limit: 5
  end

  create_table "pligg_formulas", force: :cascade do |t|
    t.string  "type",    limit: 10,    null: false
    t.boolean "enabled",               null: false
    t.string  "title",   limit: 50,    null: false
    t.text    "formula", limit: 65535, null: false
  end

  create_table "pligg_friends", primary_key: "friend_id", force: :cascade do |t|
    t.integer "friend_from", limit: 8, default: 0, null: false
    t.integer "friend_to",   limit: 8, default: 0, null: false
  end

  add_index "pligg_friends", ["friend_from", "friend_to"], name: "friends_from_to", unique: true, using: :btree

  create_table "pligg_group_member", primary_key: "member_id", force: :cascade do |t|
    t.integer "member_user_id",  limit: 4, null: false
    t.integer "member_group_id", limit: 4, null: false
    t.string  "member_role",     limit: 9, null: false
    t.string  "member_status",   limit: 8, null: false
  end

  add_index "pligg_group_member", ["member_group_id", "member_user_id"], name: "user_group", using: :btree

  create_table "pligg_group_shared", primary_key: "share_id", force: :cascade do |t|
    t.integer "share_link_id",  limit: 4, null: false
    t.integer "share_group_id", limit: 4, null: false
    t.integer "share_user_id",  limit: 4, null: false
  end

  add_index "pligg_group_shared", ["share_group_id", "share_link_id"], name: "share_group_id", unique: true, using: :btree

  create_table "pligg_groups", primary_key: "group_id", force: :cascade do |t|
    t.integer  "group_creator",         limit: 4,     null: false
    t.string   "group_status",          limit: 7,     null: false
    t.integer  "group_members",         limit: 4,     null: false
    t.datetime "group_date",                          null: false
    t.text     "group_safename",        limit: 65535, null: false
    t.text     "group_name",            limit: 65535, null: false
    t.text     "group_description",     limit: 65535, null: false
    t.string   "group_privacy",         limit: 10,    null: false
    t.string   "group_avatar",          limit: 255,   null: false
    t.integer  "group_vote_to_publish", limit: 4,     null: false
    t.string   "group_field1",          limit: 255,   null: false
    t.string   "group_field2",          limit: 255,   null: false
    t.string   "group_field3",          limit: 255,   null: false
    t.string   "group_field4",          limit: 255,   null: false
    t.string   "group_field5",          limit: 255,   null: false
    t.string   "group_field6",          limit: 255,   null: false
    t.boolean  "group_notify_email",                  null: false
  end

  add_index "pligg_groups", ["group_creator", "group_status"], name: "group_creator", using: :btree
  add_index "pligg_groups", ["group_name"], name: "group_name", length: {"group_name"=>100}, using: :btree

  create_table "pligg_links", primary_key: "link_id", force: :cascade do |t|
    t.integer  "link_author",         limit: 4,                                 default: 0,         null: false
    t.string   "link_status",         limit: 9,                                 default: "discard"
    t.integer  "link_randkey",        limit: 4,                                 default: 0,         null: false
    t.integer  "link_votes",          limit: 4,                                 default: 0,         null: false
    t.integer  "link_reports",        limit: 4,                                 default: 0,         null: false
    t.integer  "link_comments",       limit: 4,                                 default: 0,         null: false
    t.decimal  "link_karma",                           precision: 10, scale: 2, default: 0.0,       null: false
    t.datetime "link_modified",                                                                     null: false
    t.datetime "link_date",                                                                         null: false
    t.datetime "link_published_date",                                                               null: false
    t.integer  "link_category",       limit: 4,                                 default: 0,         null: false
    t.integer  "link_lang",           limit: 4,                                 default: 1,         null: false
    t.string   "link_url",            limit: 200,                               default: "",        null: false
    t.text     "link_url_title",      limit: 65535
    t.text     "link_title",          limit: 65535,                                                 null: false
    t.string   "link_title_url",      limit: 255
    t.text     "link_content",        limit: 16777215,                                              null: false
    t.text     "link_summary",        limit: 65535
    t.text     "link_tags",           limit: 65535
    t.string   "link_field1",         limit: 255,                               default: "",        null: false
    t.string   "link_field2",         limit: 255,                               default: "",        null: false
    t.string   "link_field3",         limit: 255,                               default: "",        null: false
    t.string   "link_field4",         limit: 255,                               default: "",        null: false
    t.string   "link_field5",         limit: 255,                               default: "",        null: false
    t.string   "link_field6",         limit: 255,                               default: "",        null: false
    t.string   "link_field7",         limit: 255,                               default: "",        null: false
    t.string   "link_field8",         limit: 255,                               default: "",        null: false
    t.string   "link_field9",         limit: 255,                               default: "",        null: false
    t.string   "link_field10",        limit: 255,                               default: "",        null: false
    t.string   "link_field11",        limit: 255,                               default: "",        null: false
    t.string   "link_field12",        limit: 255,                               default: "",        null: false
    t.string   "link_field13",        limit: 255,                               default: "",        null: false
    t.string   "link_field14",        limit: 255,                               default: "",        null: false
    t.string   "link_field15",        limit: 255,                               default: "",        null: false
    t.integer  "link_group_id",       limit: 4,                                 default: 0,         null: false
    t.string   "link_group_status",   limit: 9,                                 default: "new",     null: false
    t.integer  "link_out",            limit: 4,                                 default: 0,         null: false
  end

  add_index "pligg_links", ["link_author"], name: "link_author", using: :btree
  add_index "pligg_links", ["link_date"], name: "link_date", using: :btree
  add_index "pligg_links", ["link_published_date"], name: "link_published_date", using: :btree
  add_index "pligg_links", ["link_status"], name: "link_status", using: :btree
  add_index "pligg_links", ["link_tags"], name: "link_tags", type: :fulltext
  add_index "pligg_links", ["link_title", "link_content", "link_tags"], name: "link_search", type: :fulltext
  add_index "pligg_links", ["link_title_url"], name: "link_title_url", using: :btree
  add_index "pligg_links", ["link_url", "link_url_title", "link_title", "link_content", "link_tags"], name: "link_url_2", type: :fulltext
  add_index "pligg_links", ["link_url"], name: "link_url", using: :btree

  create_table "pligg_login_attempts", primary_key: "login_id", force: :cascade do |t|
    t.string   "login_username", limit: 100
    t.datetime "login_time",                             null: false
    t.string   "login_ip",       limit: 100
    t.integer  "login_count",    limit: 4,   default: 0, null: false
  end

  add_index "pligg_login_attempts", ["login_ip", "login_username"], name: "login_username", unique: true, using: :btree

  create_table "pligg_messages", primary_key: "idMsg", force: :cascade do |t|
    t.string   "title",       limit: 255,   default: "", null: false
    t.text     "body",        limit: 65535,              null: false
    t.integer  "sender",      limit: 4,     default: 0,  null: false
    t.integer  "receiver",    limit: 4,     default: 0,  null: false
    t.integer  "senderLevel", limit: 4,     default: 0,  null: false
    t.integer  "readed",      limit: 4,     default: 0,  null: false
    t.datetime "date",                                   null: false
  end

  create_table "pligg_misc_data", primary_key: "name", force: :cascade do |t|
    t.text "data", limit: 65535, null: false
  end

  create_table "pligg_modules", force: :cascade do |t|
    t.string  "name",           limit: 50, null: false
    t.float   "version",        limit: 24, null: false
    t.float   "latest_version", limit: 24, null: false
    t.string  "folder",         limit: 50, null: false
    t.boolean "enabled",                   null: false
    t.integer "weight",         limit: 4,  null: false
  end

  create_table "pligg_old_urls", primary_key: "old_id", force: :cascade do |t|
    t.integer "old_link_id",   limit: 4,   null: false
    t.string  "old_title_url", limit: 255, null: false
  end

  add_index "pligg_old_urls", ["old_title_url"], name: "old_title_url", using: :btree

  create_table "pligg_redirects", primary_key: "redirect_id", force: :cascade do |t|
    t.string "redirect_old", limit: 255, null: false
    t.string "redirect_new", limit: 255, null: false
  end

  add_index "pligg_redirects", ["redirect_old"], name: "redirect_old", using: :btree

  create_table "pligg_saved_links", primary_key: "saved_id", force: :cascade do |t|
    t.integer "saved_user_id", limit: 4,                    null: false
    t.integer "saved_link_id", limit: 4,                    null: false
    t.string  "saved_privacy", limit: 7, default: "public", null: false
  end

  add_index "pligg_saved_links", ["saved_user_id"], name: "saved_user_id", using: :btree

  create_table "pligg_tag_cache", id: false, force: :cascade do |t|
    t.string  "tag_words", limit: 64
    t.integer "count",     limit: 4,  null: false
  end

  create_table "pligg_tags", id: false, force: :cascade do |t|
    t.integer  "tag_link_id", limit: 4,  default: 0,    null: false
    t.string   "tag_lang",    limit: 4,  default: "en", null: false
    t.datetime "tag_date",                              null: false
    t.string   "tag_words",   limit: 64, default: "",   null: false
  end

  add_index "pligg_tags", ["tag_lang", "tag_date"], name: "tag_lang", using: :btree
  add_index "pligg_tags", ["tag_link_id", "tag_lang", "tag_words"], name: "tag_link_id", unique: true, using: :btree
  add_index "pligg_tags", ["tag_words", "tag_link_id"], name: "tag_words", using: :btree

  create_table "pligg_totals", primary_key: "name", force: :cascade do |t|
    t.integer "total", limit: 4, null: false
  end

  create_table "pligg_trackbacks", primary_key: "trackback_id", force: :cascade do |t|
    t.integer  "trackback_link_id",  limit: 4,     default: 0,         null: false
    t.integer  "trackback_user_id",  limit: 4,     default: 0,         null: false
    t.string   "trackback_type",     limit: 3,     default: "in",      null: false
    t.string   "trackback_status",   limit: 7,     default: "pendent", null: false
    t.datetime "trackback_modified",                                   null: false
    t.datetime "trackback_date"
    t.string   "trackback_url",      limit: 200,   default: "",        null: false
    t.text     "trackback_title",    limit: 65535
    t.text     "trackback_content",  limit: 65535
  end

  add_index "pligg_trackbacks", ["trackback_date"], name: "trackback_date", using: :btree
  add_index "pligg_trackbacks", ["trackback_link_id", "trackback_type", "trackback_url"], name: "trackback_link_id_2", unique: true, using: :btree
  add_index "pligg_trackbacks", ["trackback_link_id"], name: "trackback_link_id", using: :btree
  add_index "pligg_trackbacks", ["trackback_url"], name: "trackback_url", using: :btree

  create_table "pligg_users", primary_key: "user_id", force: :cascade do |t|
    t.string   "user_login",         limit: 32,                           default: "",       null: false
    t.string   "user_level",         limit: 9,                            default: "normal", null: false
    t.datetime "user_modification",                                                          null: false
    t.datetime "user_date",                                                                  null: false
    t.string   "user_pass",          limit: 64,                           default: "",       null: false
    t.string   "user_email",         limit: 128,                          default: "",       null: false
    t.string   "user_names",         limit: 128,                          default: "",       null: false
    t.decimal  "user_karma",                     precision: 10, scale: 2, default: 0.0
    t.string   "user_url",           limit: 128,                          default: "",       null: false
    t.datetime "user_lastlogin",                                                             null: false
    t.string   "user_facebook",      limit: 64,                           default: "",       null: false
    t.string   "user_twitter",       limit: 64,                           default: "",       null: false
    t.string   "user_linkedin",      limit: 64,                           default: "",       null: false
    t.string   "user_googleplus",    limit: 64,                           default: "",       null: false
    t.string   "user_skype",         limit: 64,                           default: "",       null: false
    t.string   "user_pinterest",     limit: 64,                           default: "",       null: false
    t.string   "public_email",       limit: 64,                           default: "",       null: false
    t.string   "user_avatar_source", limit: 255,                          default: "",       null: false
    t.string   "user_ip",            limit: 20,                           default: "0"
    t.string   "user_lastip",        limit: 20,                           default: "0"
    t.datetime "last_reset_request",                                                         null: false
    t.string   "last_reset_code",    limit: 255
    t.string   "user_location",      limit: 255
    t.string   "user_occupation",    limit: 255
    t.string   "user_categories",    limit: 255,                          default: "",       null: false
    t.boolean  "user_enabled",                                            default: true,     null: false
    t.string   "user_language",      limit: 32
  end

  add_index "pligg_users", ["user_email"], name: "user_email", using: :btree
  add_index "pligg_users", ["user_login"], name: "user_login", unique: true, using: :btree

  create_table "pligg_votes", primary_key: "vote_id", force: :cascade do |t|
    t.string   "vote_type",    limit: 8,  default: "links", null: false
    t.datetime "vote_date",                                 null: false
    t.integer  "vote_link_id", limit: 4,  default: 0,       null: false
    t.integer  "vote_user_id", limit: 4,  default: 0,       null: false
    t.integer  "vote_value",   limit: 2,  default: 1,       null: false
    t.integer  "vote_karma",   limit: 4,  default: 0
    t.string   "vote_ip",      limit: 64
  end

  add_index "pligg_votes", ["vote_link_id"], name: "link_id", using: :btree
  add_index "pligg_votes", ["vote_type", "vote_link_id", "vote_user_id", "vote_ip"], name: "vote_type", using: :btree
  add_index "pligg_votes", ["vote_user_id"], name: "user_id", using: :btree

  create_table "pligg_widgets", force: :cascade do |t|
    t.string  "name",           limit: 50
    t.float   "version",        limit: 24, null: false
    t.float   "latest_version", limit: 24, null: false
    t.string  "folder",         limit: 50
    t.boolean "enabled",                   null: false
    t.string  "column",         limit: 5,  null: false
    t.integer "position",       limit: 4,  null: false
    t.string  "display",        limit: 5,  null: false
  end

  add_index "pligg_widgets", ["folder"], name: "folder", unique: true, using: :btree

  end
end
