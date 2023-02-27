package main

// #include <unistd.h>
// #include <string.h>
// #include <stdlib.h>
// #include <fcntl.h>
//
// void putIntoArray(char **arr, size_t index, char *val) {
//	arr[index] = val;
// }
import "C"
import (
	"log"
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
	log.SetPrefix("wpkg-init: ")
	log.SetFlags(0)

	if os.Getpid() != 1 {
		os.Exit(1)
	}

	pid, err := C.fork()

	if pid == -1 {
		log.Fatal(err)
	} else if pid == 0 {
		for _, err := os.Stat("/dev/null"); os.IsNotExist(err); {
		}

		C.close(0)
		C.close(1)
		C.close(2)
		file, err := os.OpenFile(os.DevNull, os.O_WRONLY|os.O_APPEND, 0666)
		if err == nil {
			fd := file.Fd()
			if fd == 0 {
				C.dup(C.int(fd))
				C.dup(C.int(fd))
			}
		}

		cstr := C.CString("/lib/wpkg-init/wpkg")

		ret, err := C.execvp(cstr, nil)
		defer C.free(unsafe.Pointer(cstr))

		if ret == -1 {
			log.SetPrefix("wpkg-script: ")
			log.Fatal(err)
		}
	} else {
		cstr := C.CString("/lib/wpkg-init/init")

		var args **C.char
		args = (**C.char)(C.malloc((C.ulong)(2 * unsafe.Sizeof(args))))
		C.putIntoArray(args, 0, cstr)
		C.putIntoArray(args, 1, nil)

		ret, err := C.execvp(cstr, args)
		defer C.free(unsafe.Pointer(cstr))

		if ret == -1 {
			log.SetPrefix("wpkg-init-launcher: ")
			log.Fatal(err)
		}
	}
}
