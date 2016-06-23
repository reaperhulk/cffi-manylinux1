#!/bin/bash
set -x -e

for PYBIN in /opt/python/*/bin; do
    ${PYBIN}/pip install pycparser
    ${PYBIN}/pip wheel --no-deps cffi -w wheelhouse/
done

for whl in wheelhouse/cffi*.whl; do
    auditwheel repair $whl -w /build/wheelhouse/
done

for PYBIN in /opt/python/*/bin/; do
    ${PYBIN}/pip install cffi --no-index -f /build/wheelhouse
    ${PYBIN}/python -c "import cffi;ffi = cffi.FFI();lib = ffi.dlopen(None)"
done
