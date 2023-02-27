package main

// #include <unistd.h>
// #include <string.h>
// #include <stdlib.h>
//
// void putIntoArray(char **arr, size_t index, char *val) {
//	arr[index] = val;
// }
import "C"
import (
	"fmt"
	"os"
	"syscall"
	"unsafe"
)

func getError(errno syscall.Errno) string {
	strerror := C.strerror(C.int(errno))
	len := C.strlen(strerror)
	str := string(C.GoBytes(unsafe.Pointer(strerror), C.int(len)))
	return str
}

func main() {
	if os.Getpid() != 1 {
		os.Exit(1)
	}

	pid, err := C.fork()

	if pid == -1 {
		errno, ok := err.(syscall.Errno)

		if ok {
			fmt.Fprintf(os.Stderr, "wpkg-init: %s\n", getError(errno))
			for {
			}
		} else {
			fmt.Fprintln(os.Stderr, "wpkg-init: Unknown error")
			for {
			}
		}
	} else if pid == 0 {
		cstr := C.CString("/lib/wpkg-init/wpkg")

		ret, err := C.execvp(cstr, nil)
		C.free(unsafe.Pointer(cstr))

		if ret == -1 {
			errno, ok := err.(syscall.Errno)

			if ok {
				fmt.Fprintf(os.Stderr, "wpkg-script: %s\n", getError(errno))
				for {
				}
			} else {
				fmt.Fprintln(os.Stderr, "wpkg-script: Unknown error")
				for {
				}
			}
		}
	} else {
		cstr := C.CString("/lib/wpkg-init/init")

		var args **C.char
		args = (**C.char)(C.malloc((C.ulong)(2 * unsafe.Sizeof(args))))
		C.putIntoArray(args, 0, cstr)
		C.putIntoArray(args, 1, nil)

		ret, err := C.execvp(cstr, args)
		C.free(unsafe.Pointer(cstr))

		if ret == -1 {
			errno, ok := err.(syscall.Errno)

			if ok {
				fmt.Fprintf(os.Stderr, "wpkg-init-switch: %s\n", getError(errno))
				for {
				}
			} else {
				fmt.Fprintln(os.Stderr, "wpkg-init-switch: Unknown error")
				for {
				}
			}
		}
	}
}
