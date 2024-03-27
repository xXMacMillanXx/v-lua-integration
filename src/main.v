module main

import lua

fn v_hello(l lua.State) int {
	name := l.check_string(1)
	println('Hello ${name}, this is V!')
	return 0
}

fn f(l lua.State, x f64, y f64) !f64 {
	mut ret := f64(0)

	l.get_global('f')
	l.push_number(x)
	l.push_number(y)

	if l.p_call(2, 1, 0) != lua.lua_ok {
		return error('Error running Lua function: ${l.to_string(-1)}')
	}
	if !l.is_number(-1) {
		return error('Error: Lua function must return a number')
	}

	ret = f64(l.to_number(-1))
	l.pop(1)

	return ret
}

fn register_lua(l lua.State) {
	l.register('v_hello', v_hello)
}

fn main() {
	l := lua.State.new()
	l.open_libs()
	defer {
		l.close()
	}

	register_lua(l)

	if l.do_file('src/script.lua') != lua.lua_ok {
		error_msg := l.to_string(-1)
		println('Error running Lua script: ${error_msg}')
		l.pop(1)
	}

	res := f(l, 2.5, 5.0) or {
		println(err)
		return
	}
	println('V got ${res} from Lua')
}
