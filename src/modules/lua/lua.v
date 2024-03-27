module lua

#flag -I/usr/include -L/lib64
#flag -llua

#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

struct C.lua_State {}

fn C.lua_register(&C.lua_State, &char, voidptr)
fn C.lua_getglobal(&C.lua_State, &char) int
fn C.lua_pushnumber(&C.lua_State, f64)
fn C.lua_pcall(&C.lua_State, int, int, int) int
fn C.lua_isnumber(&C.lua_State, int) int
fn C.lua_tonumber(&C.lua_State, int) f64
fn C.lua_tostring(&C.lua_State, int) &char
fn C.lua_pop(&C.lua_State, int)
fn C.lua_close(&C.lua_State)

fn C.luaL_checkstring(&C.lua_State, int) &char
fn C.luaL_newstate() &C.lua_State
fn C.luaL_openlibs(&C.lua_State)
fn C.luaL_dofile(&C.lua_State, &char) int

pub const(
	lua_ok = C.LUA_OK
	lua_yield = C.LUA_YIELD
	lua_err_run = C.LUA_ERRRUN
	lua_err_syntax = C.LUA_ERRSYNTAX
	lua_err_mem = C.LUA_ERRMEM
	lua_err_err = C.LUA_ERRERR
)

pub struct State {
    pub: ref &C.lua_State
}

pub fn State.new() State {
    return State{ C.luaL_newstate() }
}

pub fn (s State) open_libs() {
    C.luaL_openlibs(s.ref)
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

pub fn (s State) p_call(nargs int, nresults int, msgh int) int {
    return C.lua_pcall(s.ref, nargs, nresults, msgh)
}

pub fn (s State) is_number(index int) bool {
    return C.lua_isnumber(s.ref, index) == 1
}

pub fn (s State) do_file(file string) int {
    return C.luaL_dofile(s.ref, file.str)
}

pub fn (s State) check_string(index int) string {
    return unsafe { cstring_to_vstring(C.luaL_checkstring(s.ref, index)) }
}

pub fn (s State) to_number(index int) f64 {
    return C.lua_tonumber(s.ref, index)
}

pub fn (s State) to_string(index int) string {
    return unsafe { cstring_to_vstring(C.lua_tostring(s.ref, index)) }
}

pub fn (s State) pop(n int) {
    C.lua_pop(s.ref, n)
}

pub fn (s State) close() {
    C.lua_close(s.ref)
}
