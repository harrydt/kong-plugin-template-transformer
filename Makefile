DEV_ROCKS = "https://raw.githubusercontent.com/openresty/lua-cjson/2.1.0.8/lua-cjson-2.1.0.6-1.rockspec" "kong 2.6.0" "luacov 0.12.0" "busted 2.0.0-1" "luacov-cobertura 0.2-1" "luacheck 0.20.0" "lua-resty-template 1.9-1" "--server=http://luarocks.org/dev luaffi scm-1"
PROJECT_FOLDER = template-transformer
LUA_PROJECT = kong-plugin-template-transformer

setup:
	@for rock in $(DEV_ROCKS) ; do \
		if luarocks list --porcelain $$rock | grep -q "installed" ; then \
			echo $$rock already installed, skipping ; \
		else \
			echo $$rock not found, installing via luarocks... ; \
			luarocks install $$rock; \
		fi \
	done;

check:
	cd $(PROJECT_FOLDER)
	@for rock in $(DEV_ROCKS) ; do \
		if luarocks list --porcelain $$rock | grep -q "installed" ; then \
			echo $$rock is installed ; \
		else \
			echo $$rock is not installed ; \
		fi \
	done;

install:
	-@luarocks remove $(LUA_PROJECT)
	luarocks make

test:
	cd $(PROJECT_FOLDER) && busted spec/ ${ARGS}

coverage:
	cd $(PROJECT_FOLDER) && busted spec/ -c ${ARGS} && luacov && luacov-cobertura -o cobertura.xml

package:
	luarocks make --pack-binary-rock

lint:
	cd $(PROJECT_FOLDER) && luacheck -q .
