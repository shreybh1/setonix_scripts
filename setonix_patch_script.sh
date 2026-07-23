#!/usr/bin/env bash
## Bash script to add patches to run lfric core 3.1 on Setonix.
#set -euo pipefail

LFRIC_CORE=$1

if [ -z "$1" ] || [ ! -d "$1" ]; then
    echo "Usage: $0 <path-to-lfric_core>" >&2
    exit 1
fi

echo "==> Patching lfric_core at: ${LFRIC_CORE}"

COMPILE_MK="${LFRIC_CORE}/infrastructure/build/compile.mk"
CRAYFTN_MK="${LFRIC_CORE}/infrastructure/build/fortran/crayftn.mk"
LOG_MOD="${LFRIC_CORE}/infrastructure/source/utilities/log_mod.F90"

echo "--> [1/3] Blanking TIME_TOOL in ${COMPILE_MK}"
grep -n 'TIME_TOOL' "${COMPILE_MK}" || echo "    (no TIME_TOOL line found)"
sed -i '/TIME_TOOL.*\/usr\/bin\/time/c\TIME_TOOL =' "${COMPILE_MK}"
echo "    Result:"
grep -n 'TIME_TOOL' "${COMPILE_MK}"

echo "--> [2/3] Updating optimisation flags in ${CRAYFTN_MK}"
grep -n 'FFLAGS_.*OPTIMISATION' "${CRAYFTN_MK}"
sed -i -E \
    -e '/FFLAGS_(NO|SAFE)_OPTIMISATION/{/-hipa0/!s/[[:space:]]*$/ -hipa0/}' \
    -e 's/-hipa3/-hipa0/' \
    -e 's/-hipa2/-hipa0/' \
    "${CRAYFTN_MK}"
echo "    Result:"
grep -n 'FFLAGS_.*OPTIMISATION' "${CRAYFTN_MK}"

echo "--> [3/3] Removing ierror=<> from ${LOG_MOD}"
grep -n 'ierror=' "${LOG_MOD}" || echo "    (no ierror= found)"
sed -i 's/,\s*ierror=[^ )]*//' "${LOG_MOD}"
echo "    Result:"
grep -n 'ierror' "${LOG_MOD}" || echo "    (none remaining)"

echo "==> Done patching lfric_core."
