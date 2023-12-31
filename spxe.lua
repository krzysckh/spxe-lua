local cffi

if type(jit) == 'table' then
  -- running on luajit
  cffi = require("ffi")
else
  -- running on PUC-Rio lua
  cffi = require("cffi")
end

cffi.cdef([[
  typedef struct Px {
    unsigned char r, g, b, a;
  } Px;

  int spxeRun(const Px *pixbuffer);
  int spxeEnd(Px *pixbuffer);
  Px *spxeStart(const char *title, const int winwidth, const int winheight,
                const int scrwidth, const int scrheight);

  void spxeScreenSize(int *widthptr, int *heightptr);
  void spxeWindowSize(int *widthptr, int *heightptr);

  double spxeTime(void);

  int spxeKeyDown(const int key);
  int spxeKeyPressed(const int key);
  int spxeKeyReleased(const int key);
  char spxeKeyChar(void);

  void spxeMousePos(int *xptr, int *yptr);
  int spxeMouseDown(const int button);
  int spxeMousePressed(const int button);
  int spxeMouseReleased(const int button);
  void spxeMouseVisible(const int visible);
]])

local keys = {
  key_space         = 32,
  key_apostrophe    = 39,
  key_comma         = 44,
  key_minus         = 45,
  key_period        = 46,
  key_slash         = 47,
  key_0             = 48,
  key_1             = 49,
  key_2             = 50,
  key_3             = 51,
  key_4             = 52,
  key_5             = 53,
  key_6             = 54,
  key_7             = 55,
  key_8             = 56,
  key_9             = 57,
  key_semicolon     = 59,
  key_equal         = 61,
  key_a             = 65,
  key_b             = 66,
  key_c             = 67,
  key_d             = 68,
  key_e             = 69,
  key_f             = 70,
  key_g             = 71,
  key_h             = 72,
  key_i             = 73,
  key_j             = 74,
  key_k             = 75,
  key_l             = 76,
  key_m             = 77,
  key_n             = 78,
  key_o             = 79,
  key_p             = 80,
  key_q             = 81,
  key_r             = 82,
  key_s             = 83,
  key_t             = 84,
  key_u             = 85,
  key_v             = 86,
  key_w             = 87,
  key_x             = 88,
  key_y             = 89,
  key_z             = 90,
  key_left_bracket  = 91,
  key_backslash     = 92,
  key_right_bracket = 93,
  key_grave_accent  = 96,
  key_escape        = 256,
  key_enter         = 257,
  key_tab           = 258,
  key_backspace     = 259,
  key_insert        = 260,
  key_delete        = 261,
  key_right         = 262,
  key_left          = 263,
  key_down          = 264,
  key_up            = 265,
  key_page_up       = 266,
  key_page_down     = 267,
  key_home          = 268,
  key_end           = 269,
  key_caps_lock     = 280,
  key_scroll_lock   = 281,
  key_num_lock      = 282,
  key_print_screen  = 283,
  key_pause         = 284,
  key_f1            = 290,
  key_f2            = 291,
  key_f3            = 292,
  key_f4            = 293,
  key_f5            = 294,
  key_f6            = 295,
  key_f7            = 296,
  key_f8            = 297,
  key_f9            = 298,
  key_f10           = 299,
  key_f11           = 300,
  key_f12           = 301,
  key_f13           = 302,
  key_f14           = 303,
  key_f15           = 304,
  key_f16           = 305,
  key_f17           = 306,
  key_f18           = 307,
  key_f19           = 308,
  key_f20           = 309,
  key_f21           = 310,
  key_f22           = 311,
  key_f23           = 312,
  key_f24           = 313,
  key_f25           = 314,
  key_kp_0          = 320,
  key_kp_1          = 321,
  key_kp_2          = 322,
  key_kp_3          = 323,
  key_kp_4          = 324,
  key_kp_5          = 325,
  key_kp_6          = 326,
  key_kp_7          = 327,
  key_kp_8          = 328,
  key_kp_9          = 329,
  key_kp_decimal    = 330,
  key_kp_divide     = 331,
  key_kp_multiply   = 332,
  key_kp_subtract   = 333,
  key_kp_add        = 334,
  key_kp_enter      = 335,
  key_kp_equal      = 336,
  key_left_shift    = 340,
  key_left_control  = 341,
  key_left_alt      = 342,
  key_left_super    = 343,
  key_right_shift   = 344,
  key_right_control = 345,
  key_right_alt     = 346,
  key_right_super   = 347,
  key_menu          = 348,
}

local mouse = {
  button_1      = 0,
  button_2      = 1,
  button_3      = 2,
  button_4      = 3,
  button_5      = 4,
  button_6      = 5,
  button_7      = 6,
  button_8      = 7,
  button_left   = 0,
  button_right  = 1,
  button_middle = 2,
}

local spxe = cffi.load("spxe")

return {
  run = spxe.spxeRun,
  finish = spxe.spxeEnd,
  start = spxe.spxeStart,
  screen_size = spxe.spxeScreenSize,
  window_size = spxe.spxeWindowSize,
  time = spxe.spxeTime,
  key = {
    down = function(x)
      if spxe.spxeKeyDown(x) == 0 then return false else return true end end,
    pressed = function(x)
      if spxe.spxeKeyPressed(x)  == 0 then return false else return true end end,
    released = function(x)
      if spxe.spxeKeyReleased(x) == 0 then return false else return true end end,
    char = function(x)
      if spxe.spxeKeyChar(x) == 0 then return false else return true end end,
  },
  mouse = {
    down = function(x)
      if spxe.spxeMouseDown(x) == 0 then return false else return true end end,
    pressed = function(x)
      if spxe.spxeMousePressed(x) == 0 then return false else return true end end,
    released = function(x)
      if spxe.spxeMouseReleased(x) == 0 then return false else return true end end,
    visible = spxe.spxeMouseVisible,
    pos = function()
      x = cffi.new("int[1]"); y = cffi.new("int[1]")
      spxe.spxeMousePos(x, y);

      return {
        x = x[0] < 0 and 0 or x[0],
        y = y[0] < 0 and 0 or y[0]
      }
    end,
    buttons = mouse
  },
  keys = keys,
  ffi = cffi
}
