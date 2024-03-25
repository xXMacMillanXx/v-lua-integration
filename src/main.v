module main

import lua

fn v_hello(l lua.State) int {
	name := l.checkstring(1)
	println('Hello ${name}, this is V!')
	return 0
}

fn register_lua(l lua.State) {
	l.register('v_hello', v_hello)
}

fn main() {
	l := lua.State.new()
	l.openlibs()

	register_lua(l)

	if l.dofile('src/script.lua') != lua.lua_ok {
		error_msg := l.tostring(-1)
		println('Error running Lua script: ${error_msg}')
		l.pop(1)
	}

	l.close()
}
