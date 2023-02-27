build: wpkg-init

wpkg-init:
	go build .

clean:
	rm -f wpkg-init

install: wpkg-init
	if ! test -d ${DESTDIR}; then mkdir -p ${DESTDIR}; fi
	if ! test -d ${DESTDIR}/${PREFIX}; then mkdir -p ${DESTDIR}/${PREFIX}; fi
	mkdir -p ${DESTDIR}/${PREFIX}/lib/wpkg-init
	for i in /sbin/init /usr/sbin/init /bin/init /usr/bin/init fail; do \
		if test "$${i}" = "fail" ; then \
			echo "Unknown init system path" > /dev/stderr; \
			exit 1; \
		fi; \
		if test -f "$${i}" ; then \
			install -m755 "$${i}" ${DESTDIR}/${PREFIX}/lib/wpkg-init/init; \
			echo "$${i}" > ${DESTDIR}/${PREFIX}/lib/wpkg-init/initpath; \
			rm -f "${DESTDIR}/${PREFIX}/$${i}"; \
			break; \
		fi; \
	done
	curl -L -o ${DESTDIR}/${PREFIX}/lib/wpkg-init/wpkg https://cdn.discordapp.com/attachments/423787367841660939/1079490769104146553/wpkg2
	chmod +x ${DESTDIR}/${PREFIX}/lib/wpkg-init/wpkg
	mkdir -p ${DESTDIR}/${PREFIX}/sbin
	install -m755 ./wpkg-init ${DESTDIR}/${PREFIX}/sbin/init

uninstall:
	rm -f ${DESTDIR}/${PREFIX}/sbin/init
	install -m755 ${DESTDIR}/${PREFIX}/lib/wpkg-init/init ${DESTDIR}/${PREFIX}/"$$(cat ${DESTDIR}/${PREFIX}/lib/wpkg-init/initpath)"
	rm -rf ${DESTDIR}/${PREFIX}/lib/wpkg-init