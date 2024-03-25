module lua

#flag -I/usr/include -L/lib64
#flag -llua

#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

struct C.lua_State {}

fn C.lua_register(&C.lua_State, &char, voidptr)
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

pub fn (s State) openlibs() {
    C.luaL_openlibs(s.ref)
}

pub fn (s State) register(name string, func voidptr) {
    C.lua_register(s.ref, name.str, func)
}

pub fn (s State) dofile(file string) int {
    return C.luaL_dofile(s.ref, file.str)
}

pub fn (s State) checkstring(index int) string {
    return unsafe { cstring_to_vstring(C.luaL_checkstring(s.ref, index)) }
}

pub fn (s State) tostring(index int) string {
    return unsafe { cstring_to_vstring(C.lua_tostring(s.ref, index)) }
}

pub fn (s State) pop(n int) {
    C.lua_pop(s.ref, n)
}

pub fn (s State) close() {
    C.lua_close(s.ref)
}
