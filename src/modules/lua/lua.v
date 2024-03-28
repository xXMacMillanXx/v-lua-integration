module lua

#flag -I/usr/include -L/lib64
#flag -llua

#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

pub type CFunction = fn(&C.lua_State) int
pub type KFunction = fn(&C.lua_State, int, &C.lua_KContext) int

struct C.lua_State {}
struct C.lua_KContext {}

fn C.lua_close(&C.lua_State)
fn C.lua_getglobal(&C.lua_State, &char) int
fn C.lua_isboolean(&C.lua_State, int) int
fn C.lua_iscfunction(&C.lua_State, int) int
fn C.lua_isfunction(&C.lua_State, int) int
fn C.lua_isinteger(&C.lua_State, int) int
fn C.lua_islightuserdata(&C.lua_State, int) int
fn C.lua_isnil(&C.lua_State, int) int
fn C.lua_isnone(&C.lua_State, int) int
fn C.lua_isnoneornil(&C.lua_State, int) int
fn C.lua_isnumber(&C.lua_State, int) int
fn C.lua_isstring(&C.lua_State, int) int
fn C.lua_istable(&C.lua_State, int) int
fn C.lua_isthread(&C.lua_State, int) int
fn C.lua_isuserdata(&C.lua_State, int) int
fn C.lua_isyieldable(&C.lua_State) int
fn C.lua_pcall(&C.lua_State, int, int, int) int
fn C.lua_pop(&C.lua_State, int)
fn C.lua_pushnumber(&C.lua_State, f64)
fn C.lua_register(&C.lua_State, &char, voidptr)
fn C.lua_toboolean(&C.lua_State, int) int
fn C.lua_tocfunction(&C.lua_State, int) CFunction
fn C.lua_toclose(&C.lua_State, int)
fn C.lua_tointeger(&C.lua_State, int) int
fn C.lua_tointegerx(&C.lua_State, int, &int) int
fn C.lua_tolstring(&C.lua_State, int, &usize) &char
fn C.lua_tonumber(&C.lua_State, int) f64
fn C.lua_tonumberx(&C.lua_State, int, &int) f64
fn C.lua_topointer(&C.lua_State, int) voidptr
fn C.lua_tostring(&C.lua_State, int) &char
fn C.lua_tothread(&C.lua_State, int) &C.lua_State
fn C.lua_touserdata(&C.lua_State, int) voidptr

fn C.luaL_checkstring(&C.lua_State, int) &char
fn C.luaL_dofile(&C.lua_State, &char) int
fn C.luaL_newstate() &C.lua_State
fn C.luaL_openlibs(&C.lua_State)

pub enum Status {
    ok = C.LUA_OK
    yield = C.LUA_YIELD
    err_run = C.LUA_ERRRUN
    err_syntax = C.LUA_ERRSYNTAX
    err_mem = C.LUA_ERRMEM
    err_err = C.LUA_ERRERR
    err_file = C.LUA_ERRFILE
}

pub struct State {
    pub: ref &C.lua_State
}

pub fn State.new() State {
    return State{ C.luaL_newstate() }
}

pub fn (s State) open_libs() {
    C.luaL_openlibs(s.ref)
}

pub fn (s State) check_string(index int) string {
    return unsafe { cstring_to_vstring(C.luaL_checkstring(s.ref, index)) }
}

pub fn (s State) do_file(file string) bool {
    return C.luaL_dofile(s.ref, file.str) == 0
}



pub fn (s State) register(name string, func voidptr) {
    C.lua_register(s.ref, name.str, func)
}

pub fn (s State) get_global(name string) int {
    return C.lua_getglobal(s.ref, name.str)
}

pub fn (s State) push_number(n f64) {
    C.lua_pushnumber(s.ref, n)
}

pub fn (s State) p_call(nargs int, nresults int, msgh int) Status {
    return unsafe { Status(C.lua_pcall(s.ref, nargs, nresults, msgh)) }
}

pub fn (s State) is_boolean(index int) bool {
    return C.lua_isboolean(s.ref, index) == 1
}

pub fn (s State) is_c_function(index int) bool {
    return C.lua_iscfunction(s.ref, index) == 1
}

pub fn (s State) is_function(index int) bool {
    return C.lua_isfunction(s.ref, index) == 1
}

pub fn (s State) is_integer(index int) bool {
    return C.lua_isinteger(s.ref, index) == 1
}

pub fn (s State) is_light_userdata(index int) bool {
    return C.lua_islightuserdata(s.ref, index) == 1
}

pub fn (s State) is_nil(index int) bool {
    return C.lua_isnil(s.ref, index) == 1
}

pub fn (s State) is_none(index int) bool {
    return C.lua_isnone(s.ref, index) == 1
}

pub fn (s State) is_none_or_nil(index int) bool {
    return C.lua_isnoneornil(s.ref, index) == 1
}

pub fn (s State) is_number(index int) bool {
    return C.lua_isnumber(s.ref, index) == 1
}

pub fn (s State) is_string(index int) bool {
    return C.lua_isstring(s.ref, index) == 1
}

pub fn (s State) is_table(index int) bool {
    return C.lua_istable(s.ref, index) == 1
}

pub fn (s State) is_thread(index int) bool {
    return C.lua_isthread(s.ref, index) == 1
}

pub fn (s State) is_userdata(index int) bool {
    return C.lua_isuserdata(s.ref, index) == 1
}

pub fn (s State) is_yieldable() bool {
    return C.lua_isyieldable(s.ref) == 1
}

pub fn (s State) to_boolean(index int) bool {
    return C.lua_toboolean(s.ref, index) == 1
}

pub fn (s State) to_c_function(index int) CFunction {
    return C.lua_tocfunction(s.ref, index)
}

pub fn (s State) to_close(index int) {
    C.lua_toclose(s.ref, index)
}

pub fn (s State) to_integer(index int) int {
    return C.lua_tointeger(s.ref, index)
}

pub fn (s State) to_integerx(index int) ?int {
    mut is_num := 0
    ret := C.lua_tointegerx(s.ref, index, is_num)
    if is_num == 1 {
        return ret
    }
    return none
}

pub fn (s State) to_l_string(index int) ?string {
    mut len := usize(0)
    ret := C.lua_tolstring(s.ref, index, len)
    if len > 0 {
        return unsafe { cstring_to_vstring(ret) }
    }
    return none
}

pub fn (s State) to_number(index int) f64 {
    return C.lua_tonumber(s.ref, index)
}

pub fn (s State) to_numberx(index int) ?f64 {
    mut is_num := 0
    ret := C.lua_tonumberx(s.ref, index, is_num)
    if is_num == 1 {
        return ret
    }
    return none
}

pub fn (s State) to_pointer(index int) ?voidptr {
    ret := C.lua_topointer(s.ref, index)
    if ret != unsafe { nil } {
        return ret
    }
    return none
}

pub fn (s State) to_string(index int) string {
    return unsafe { cstring_to_vstring(C.lua_tostring(s.ref, index)) }
}

pub fn (s State) to_thread(index int) ?State {
    ret := C.lua_tothread(s.ref, index)
    if ret != unsafe { nil } {
        return State { ret }
    }
    return none
}

pub fn (s State) to_userdata(index int) ?voidptr {
    ret := C.lua_touserdata(s.ref, index)
    if ret != unsafe { nil } {
        return ret
    }
    return none
}

pub fn (s State) pop(n int) {
    C.lua_pop(s.ref, n)
}

pub fn (s State) close() {
    C.lua_close(s.ref)
}
