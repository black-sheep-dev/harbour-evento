TRANSLATIONS += \
    translations/harbour-evento.ts \
    translations/harbour-evento-de.ts \
    translations/harbour-evento-fr.ts \
    translations/harbour-evento-ru.ts


qm.input    = TRANSLATIONS
qm.output   = translations/${QMAKE_FILE_BASE}.qm
qm.commands = @echo "compiling ${QMAKE_FILE_NAME}"; \
                lrelease -idbased -silent ${QMAKE_FILE_NAME} -qm ${QMAKE_FILE_OUT}
qm.CONFIG   = target_predeps no_link

QMAKE_EXTRA_COMPILERS += qm

translations.files = $$OUT_PWD/translations
translations.path  = $$PREFIX/share/$$TARGET

INSTALLS += translations

