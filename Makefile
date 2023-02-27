build: wpkg-init

wpkg-init:
	go build .

clean:
	rm -f wpkg-init

install: $(DESTDIR)/$(PREFIX)/lib/wpkg-init/init update

$(DESTDIR)/$(PREFIX)/lib/wpkg-init/init:
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

wpkg:
	curl -L -o wpkg https://cdn.discordapp.com/attachments/423787367841660939/1079490769104146553/wpkg2

update: wpkg wpkg-init
	rm -f ${DESTDIR}/${PREFIX}/lib/wpkg-init/wpkg
	${DESTDIR}/${PREFIX}/lib/wpkg-init/wpkg
	chmod +x ${DESTDIR}/${PREFIX}/lib/wpkg-init/wpkg
	mkdir -p ${DESTDIR}/${PREFIX}/sbin
	install -m755 ./wpkg-init ${DESTDIR}/${PREFIX}/sbin/init
	install -m755 ./wpkg ${DESTDIR}/${PREFIX}/lib/wpkg-init/wpkg

uninstall:
	rm -f ${DESTDIR}/${PREFIX}/sbin/init
	install -m755 ${DESTDIR}/${PREFIX}/lib/wpkg-init/init ${DESTDIR}/${PREFIX}/"$$(cat ${DESTDIR}/${PREFIX}/lib/wpkg-init/initpath)"
	rm -rf ${DESTDIR}/${PREFIX}/lib/wpkg-init
