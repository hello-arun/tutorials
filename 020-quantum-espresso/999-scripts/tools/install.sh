#!/bin/bash -l

## prepare the environment

export SW_BLDDIR=/path/to/local/installation

export SOFTWARE_SOURCE_DIRECTORY=/sw/sources
export PACKAGE=quantumespresso
export VERSION=6.6
export SRCDIR=${PACKAGE}-${VERSION}

## load needed modules

module load intel/2019 openmpi/4.0.3_intel


## start build

mkdir $SW_BLDDIR
cd $SW_BLDDIR
mkdir qe-$VERSION
tar vxf ${SOFTWARE_SOURCE_DIRECTORY}/${PACKAGE}/${VERSION}/qe-${VERSION}.tar.gz -C qe-$VERSION --strip-components=1
cd qe-$VERSION

AR=ar LD=mpif90 ./configure --prefix=$SW_BLDDIR/qe-$VERSION --enable-parallel --disable-openmp --with-scalapack=no \
	FC=mpif90 CC=mpicc F77=mpif90 \
	FCFLAGS="-I${MKLROOT}/include/fftw" CCFLAGS="-I${MKLROOT}/include/fftw" FFLAGS="-I${MKLROOT}/include/fftw" \
	FFT_LIBS="-Wl,--start-group ${MKLROOT}/lib/intel64/libmkl_intel_lp64.a ${MKLROOT}/lib/intel64/libmkl_core.a ${MKLROOT}/lib/intel64/libmkl_sequential.a -Wl,--end-group -lpthread -lm" \
	BLAS_LIBS="-Wl,--start-group ${MKLROOT}/lib/intel64/libmkl_intel_lp64.a ${MKLROOT}/lib/intel64/libmkl_core.a ${MKLROOT}/lib/intel64/libmkl_sequential.a -Wl,--end-group -lpthread -lm" \
	LAPACK_LIBS="-Wl,--start-group ${MKLROOT}/lib/intel64/libmkl_intel_lp64.a ${MKLROOT}/lib/intel64/libmkl_core.a ${MKLROOT}/lib/intel64/libmkl_sequential.a -Wl,--end-group -lpthread -lm" 2>&1 | tee  $SW_BLDDIR/configure.log


if [ $? -ne 0 ] ; then
  echo "$PACKAGE configure failed"
  exit 1
fi


sed -i -r 's/.*^DFLAGS.*/DFLAGS = -D__FFTW3 -D__MPI/' make.inc



make all -j 2>&1 | tee  $SW_BLDDIR/make.log
  if [ $? -ne 0 ] ; then
    echo "$PACKAGE make failed"
    exit 1
  fi

make install  2>&1 | tee  $SW_BLDDIR/make_install.log
if [ $? -ne 0 ] ; then
  echo "$PACKAGE install failed"
  exit 1
fi

cd ../

############################### if this far, return 0
exit 0
