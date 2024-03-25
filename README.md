# Using Lua with V

This is a basic example of how to use Lua with V. It includes a simple Lua script that prints a text to the console.

## Running the example

To run this project, you will need to have V installed. You can find instructions for installing V in the [Vlang Github readme](https://github.com/vlang/v?tab=readme-ov-file#installing-v-from-source).

Also, you will need to install Lua. You can find instructions for installing Lua on the [Lua Download page](https://www.lua.org/download.html).
If you are using Linux, you can install Lua with your distributions package manager.

```bash
# Ubuntu / Debian
sudo apt install lua

# Arch
sudo pacman -S lua

# Fedora
sudo dnf install lua
```

Once you have V and Lua installed, you can try out the project by running the following command in the project directory:

```bash
./run.sh
```

This will run the `main.v` file, which will execute the Lua script `script.lua`, which executes the function from `main.v`.

